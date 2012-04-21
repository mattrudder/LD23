
#include <Talon/Talon.h>
#include <Talon/Engine.h>

using namespace Talon;

#if TALON_WINDOWS
int CALLBACK WinMain(
  __in  HINSTANCE /*hInstance*/,
  __in  HINSTANCE /*hPrevInstance*/,
  __in  LPSTR argv,
  __in  int /*nCmdShow*/
)
#else
int main(int argc, char** argv)
#endif
{
	Engine engine;
	engine.Initialize(argv);
	while(engine.IsRunning())
	{
		engine.RunFrame();
	}
	engine.Shutdown();

	return 0;
}