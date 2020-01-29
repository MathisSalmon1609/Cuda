#include<iostream>

__global__ void fill(int * m, std::size_t w ,  std::size_t h)
{
    auto idx = blockIdx.x * blockDim.x + threadIdx.x;
    auto idy = blockIdx.y * blockDim.y + threadIdx.y;


    if( idx < w && idy <h )
    {
        m [ idy * w + idx ] = idy * w + idx;
    }

}

int main() {

   std::size_t w =10;
   std::size_t h =10;
   std::size_t size =w*h;

   int * m_h = nullptr;
   int * m_d = nullptr;
    cudaMallocHost(&m_h, size * sizeof(int));
    cudaMalloc( &m_d, size * sizeof(int));
    dim3 block (32 , 32);
    dim3 grid ((w-1) / block.x +1, (h-1)/block.y +1);
    fill<<<grid, block >>>(m_d, w , h );
    cudaMemcpy ( m_h , m_d, size * sizeof (int) , cudaMemcpyDeviceToHost);

    for (std::size_t j = 0; j < h ;++j )
    {
        for (std::size_t i =0 ; i<w ; ++i)
        {
         std::cout << m_h[j*w +i]<< ' ';
        }
        std::cout << std:: endl;
    }

    cudaFree(m_d);
    cudaFreeHost(m_h);


    return 0;
}
