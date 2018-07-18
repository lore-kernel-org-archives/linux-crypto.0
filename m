From: Joe Perches <joe@perches.com>
Subject: make sure swap arguments are the same type? (was: Re: [PATCH]
 crypto: rmd320 - use swap macro in rmd320_transform)
Date: Wed, 18 Jul 2018 11:31:13 -0700
Message-ID: <4dbef38e6020d6cb78e860a9f01fcd1de9f0fb52.camel@perches.com>
References: <20180718171908.GA22962@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718171908.GA22962@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2018-07-18 at 12:19 -0500, Gustavo A. R. Silva wrote:
> swap

Perhaps the swap macro should verify that the
swap(a, b) arguments are the same type.

Something like the patch below, but this patch
causes a compilation failure on at least a couple
cases that aren't obviously correct in

net/netfilter/ipset/ip_set_bitmap_port.c
	where a u16 is swapped with a u32.

and

net/netfilter/ipset/ip_set_hash_netport.c
	where a single bit bitfield is swapped with a u8
---
 include/linux/kernel.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d6aac75b51ba..506b59e0da24 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -969,14 +969,19 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
  */
 #define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
-
 /**
  * swap - swap values of @a and @b
  * @a: first value
  * @b: second value
+ * @a and @b must be the same type
  */
-#define swap(a, b) \
-	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
+#define swap(a, b)							\
+do {									\
+	typeof(a) __tmp = (a);						\
+	BUILD_BUG_ON(!__same_type(typeof(a), typeof(b)));		\
+	(a) = (b);							\
+	(b) = __tmp;							\
+} while (0)
 
 /* This counts to 12. Any more, it will return 13th argument. */
 #define __COUNT_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _n, X...) _n
