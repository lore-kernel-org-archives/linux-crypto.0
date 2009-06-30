From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v2] crypto/ansi prng: alloc cipher just in in init()
Date: Tue, 30 Jun 2009 21:55:18 +0200
Message-ID: <20090630195517.GA4659@Chamillionaire.breakpoint.cc>
References: <1246281425.3688.13.camel@queen> <20090629140704.GA25939@Chamillionaire.breakpoint.cc> <20090629152027.GA5022@hmsreliant.think-freely.org> <20090629214508.GB29616@Chamillionaire.breakpoint.cc> <20090630145150.GB13116@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	davem@davemloft.net, Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60588 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbZF3TzV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Jun 2009 15:55:21 -0400
Content-Disposition: inline
In-Reply-To: <20090630145150.GB13116@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As reported by Eric Sesterhenn the re-allocation of the cipher in reset leads
to:
|BUG: sleeping function called from invalid context at kernel/rwsem.c:21
|in_atomic(): 1, irqs_disabled(): 0, pid: 4926, name: modprobe
|INFO: lockdep is turned off.
|Pid: 4926, comm: modprobe Tainted: G   M 2.6.31-rc1-22297-g5298976 #24
|Call Trace:
| [<c011dd93>] __might_sleep+0xf9/0x101
| [<c0777aa0>] down_read+0x16/0x68
| [<c048bf04>] crypto_alg_lookup+0x16/0x34
| [<c048bf52>] crypto_larval_lookup+0x30/0xf9
| [<c048c038>] crypto_alg_mod_lookup+0x1d/0x62
| [<c048c13e>] crypto_alloc_base+0x1e/0x64
| [<c04bf991>] reset_prng_context+0xab/0x13f
| [<c04e5cfc>] ? __spin_lock_init+0x27/0x51
| [<c04bfce1>] cprng_init+0x2a/0x42
| [<c048bb4c>] __crypto_alloc_tfm+0xfa/0x128
| [<c048c153>] crypto_alloc_base+0x33/0x64
| [<c04933c9>] alg_test_cprng+0x30/0x1f4
| [<c0493329>] alg_test+0x12f/0x19f
| [<c0177f1f>] ? __alloc_pages_nodemask+0x14d/0x481
| [<d09219e2>] do_test+0xf9d/0x163f [tcrypt]
| [<d0920de6>] do_test+0x3a1/0x163f [tcrypt]
| [<d0926035>] tcrypt_mod_init+0x35/0x7c [tcrypt]
| [<c010113c>] _stext+0x54/0x12c
| [<d0926000>] ? tcrypt_mod_init+0x0/0x7c [tcrypt]
| [<c01398a3>] ? up_read+0x16/0x2b
| [<c0139fc4>] ? __blocking_notifier_call_chain+0x40/0x4c
| [<c014ee8d>] sys_init_module+0xa9/0x1bf
| [<c010292b>] sysenter_do_call+0x12/0x32

because a spin lock is held and crypto_alloc_base() may sleep.
There is no reason to re-allocate the cipher, the state is resetted in
->setkey(). This patches makes the cipher allocation a one time thing and
moves it to init.

Reported-by: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
v2: - remove crypto_free_cipher() from reset
    - don'r return 0 in error case in reset
v1: initial shot

Neil, what about that one? Setting tfm to NULL and grabbing the return
code earler would make the patch a little longer.

 crypto/ansi_cprng.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index ff00b58..5357ba7 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -283,7 +283,6 @@ static int reset_prng_context(struct prng_context *ctx,
 			      unsigned char *V, unsigned char *DT)
 {
 	int ret;
-	int rc = -EINVAL;
 	unsigned char *prng_key;
 
 	spin_lock_bh(&ctx->prng_lock);
@@ -307,34 +306,20 @@ static int reset_prng_context(struct prng_context *ctx,
 	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
 	memset(ctx->last_rand_data, 0, DEFAULT_BLK_SZ);
 
-	if (ctx->tfm)
-		crypto_free_cipher(ctx->tfm);
-
-	ctx->tfm = crypto_alloc_cipher("aes", 0, 0);
-	if (IS_ERR(ctx->tfm)) {
-		dbgprint(KERN_CRIT "Failed to alloc tfm for context %p\n",
-			ctx);
-		ctx->tfm = NULL;
-		goto out;
-	}
-
 	ctx->rand_data_valid = DEFAULT_BLK_SZ;
 
 	ret = crypto_cipher_setkey(ctx->tfm, prng_key, klen);
 	if (ret) {
 		dbgprint(KERN_CRIT "PRNG: setkey() failed flags=%x\n",
 			crypto_cipher_get_flags(ctx->tfm));
-		crypto_free_cipher(ctx->tfm);
 		goto out;
 	}
 
-	rc = 0;
+	ret = 0;
 	ctx->flags &= ~PRNG_NEED_RESET;
 out:
 	spin_unlock_bh(&ctx->prng_lock);
-
-	return rc;
