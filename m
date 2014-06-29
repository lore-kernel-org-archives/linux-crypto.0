From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 3/4] DRBG: Fix format string for debugging statements
Date: Sat, 28 Jun 2014 20:53:19 -0700
Message-ID: <1404013999.9064.50.camel@joe-AO725>
References: <4927386.WYHrRe3NJm@myon.chronox.de>
	 <10901956.0EDQunEZJL@myon.chronox.de>
	 <20140629122402.0fd014d8@canb.auug.org.au>
	 <4311965.FMe9YfRAnU@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <4311965.FMe9YfRAnU@myon.chronox.de>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, 2014-06-29 at 05:46 +0200, Stephan Mueller wrote:
> Am Sonntag, 29. Juni 2014, 12:24:02 schrieb Stephen Rothwell:
> 
> Hi Stephen,
> 
> > Hi Stephan,
> > 
> > On Sat, 28 Jun 2014 22:01:46 +0200 Stephan Mueller <smueller@chronox.de> 
> wrote:
> > > @@ -1987,8 +1987,9 @@ static int __init drbg_init(void)
> > > 
> > >  	if (ARRAY_SIZE(drbg_cores) * 2 > ARRAY_SIZE(drbg_algs)) {
> > >  	
> > >  		pr_info("DRBG: Cannot register all DRBG types"
> > > 
> > > -			"(slots needed: %lu, slots available: %lu)\n",
> > > -			ARRAY_SIZE(drbg_cores) * 2, ARRAY_SIZE(drbg_algs));
> > > +			"(slots needed: %u, slots available: %u)\n",
> > > +			(unsigned int)ARRAY_SIZE(drbg_cores) * 2,
> > > +			(unsigned int)ARRAY_SIZE(drbg_algs));
> > 
> > Doesn't ARRAY_SIZE() always return a size_t?  In which case surely we
> > need no casts, but need to us %zu in the format string.
> 
> Unfortunately not at all. On my x86_64, I get the compiler warning that 
> ARRAY_SIZE is a long unsigned int without the cast.

This should fix that.
---
 include/linux/kernel.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 6e3d497..58bc57d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -51,7 +51,8 @@
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
 
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#define ARRAY_SIZE(arr)						\
+	(sizeof(arr) / sizeof((arr)[0]) + (size_t)__must_be_array(arr))
 
 /*
  * This looks more complex than it should be. But we need to
