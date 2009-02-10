From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: LRW endian issues?
Date: Tue, 10 Feb 2009 23:02:19 +1100
Message-ID: <20090210120218.GA23234@gondor.apana.org.au>
References: <20090206040124.GA4299@gondor.apana.org.au> <alpine.LRH.2.00.0902061117570.26894@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: rsnel@cube.dyndns.org, linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54562 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754402AbZBJMC3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Feb 2009 07:02:29 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902061117570.26894@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 06, 2009 at 11:18:46AM +0100, Geert Uytterhoeven wrote:
>
> Here's a backtrace from the RCU stall detector on PS3:
> 
> | INFO: RCU detected CPU 1 stall (t=4294906597/2500 jiffies)
> | Call Trace:
> | [c00000000c186fc0] [c00000000000f850] .show_stack+0x6c/0x16c (unreliable)
> | [c00000000c187070] [c000000000098a04] .__rcu_pending+0x94/0x2c0
> | [c00000000c187110] [c000000000098c7c] .rcu_pending+0x4c/0xa4
> | [c00000000c1871b0] [c00000000005fa04] .update_process_times+0x40/0x94
> | [c00000000c187240] [c00000000007b25c] .tick_sched_timer+0x154/0x1ac
> | [c00000000c187300] [c000000000070df4] .__run_hrtimer+0x8c/0xfc
> | [c00000000c1873a0] [c000000000071e6c] .hrtimer_interrupt+0x144/0x1e8
> | [c00000000c187490] [c00000000001d46c] .timer_interrupt+0xb0/0xe4
> | [c00000000c187520] [c00000000000360c] decrementer_common+0x10c/0x180
> | --- Exception: 901 at .crypto_alg_mod_lookup+0x4/0xa8
> |     LR = .crypto_lookup_skcipher+0x38/0x2b8
> | [c00000000c187810] [c0000000001bf790] .crypto_lookup_skcipher+0x284/0x2b8 (unreliable)

Thanks, could you try this patch?

diff --git a/crypto/api.c b/crypto/api.c
index 9975a7b..d80e548 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -205,6 +205,26 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alg_lookup);
 
+static struct crypto_alg *crypto_alg_lookup_untested(const char *name,
+						     u32 type, u32 mask)
+{
+	struct crypto_alg *alg;
+
+	down_read(&crypto_alg_sem);
+	alg = __crypto_alg_lookup(name, type, mask);
+	if (!alg)
+		alg = __crypto_alg_lookup(name, type,
+					  mask & ~CRYPTO_ALG_TESTED);
+	up_read(&crypto_alg_sem);
+
+	if (alg && ((alg->cra_flags ^ type) & mask & CRYPTO_ALG_TESTED)) {
+		crypto_mod_put(alg);
+		alg = ERR_PTR(-ENOENT);
+	}
+
+	return alg;
+}
+
 struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
@@ -220,6 +240,18 @@ struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 	if (alg)
 		return crypto_is_larval(alg) ? crypto_larval_wait(alg) : alg;
 
+	/*
+	 * Do not probe again if a failed algorithm already exists,
+	 * or we may loop forever while churning out an endless list
+	 * of failed algorithms.
+	 *
+	 * The user may recover from this by removing the failed
+	 * algorithm.
+	 */
+	alg = crypto_alg_lookup_untested(name, type, mask);
+	if (alg)
+		return alg;
+
 	return crypto_larval_add(name, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_larval_lookup);

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
