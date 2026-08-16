#import "Tweak.h"

__attribute__((constructor)) static void init() {
    [Tweak setup];
}
