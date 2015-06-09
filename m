From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: nios2: Export get_cycles
Date: Tue, 9 Jun 2015 12:46:46 +0800
Message-ID: <20150609044646.GA6892@gondor.apana.org.au>
References: <3181127.KGS6GDHCq6@tachyon.chronox.de>
 <55766C3A.3070101@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Peter Zijlstra
	<public-peterz-wegcikhe2lqwvfeawa7xhq@plane.gmane.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
	Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55766C3A.3070101@roeck-us.net>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 08, 2015 at 09:31:54PM -0700, Guenter Roeck wrote:
> 
> nios2 still fails to build with
> 
> ERROR: "get_cycles" [crypto/jitterentropy.ko] undefined!

It's the only arch that doesn't inline get_cycles and doesn't
export it.

---8<---
nios2 is the only architecture that does not inline get_cycles
and does not export it.  This breaks crypto as it uses get_cycles
in a number of modules.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/nios2/kernel/time.c b/arch/nios2/kernel/time.c
index 7f45474..be186a7 100644
--- a/arch/nios2/kernel/time.c
+++ b/arch/nios2/kernel/time.c
@@ -8,6 +8,7 @@
  * for more details.
  */
 
+#include <linux/export.h>
 #include <linux/interrupt.h>
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
@@ -106,6 +107,7 @@ cycles_t get_cycles(void)
 {
 	return nios2_timer_read(&nios2_cs.cs);
 }
+EXPORT_SYMBOL(get_cycles);
 
 static void nios2_timer_start(struct nios2_timer *timer)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
