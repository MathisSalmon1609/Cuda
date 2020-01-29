#include<iostream>

__global__ void fill(int * v, std::size_t size)
{
  auto id = blockIdx.x * blockDim.x + threadIdx.x;
  
  if( id < size)
  {
      v [ id ] = id;
  }

}

int main() {

  std::size_t size = 2048;
  int * v_h = nullptr;
  int * v_d = nullptr;

   cudaMallocHost( &v_h, size * sizeof(int));
	//ou :  v_h = (int * )malloc(size* sizeof(int));
	//ou : v_h = new int [size];

  cudaMallocHost( &v_d, size * sizeof(int));
  dim3 block = 1024;
  dim3 grid = (size -1) / block.x +1;
  fill<<< grid , block >>>( v_d, size );

  cudaMemcpy( v_h, v_d, size * sizeof(int), cudaMemcpyDeviceToHost);
  
  for ( std::size_t i = 0 ; i < size ; ++i ) {
    std::cout << v_h[i] << std::endl;
  }

  return 0;
}
