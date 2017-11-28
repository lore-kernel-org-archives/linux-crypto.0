From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: use-after-free Read in aead_recvmsg
Date: Mon, 27 Nov 2017 23:29:44 -0800
Message-ID: <20171128072944.GA23565@zzz.localdomain>
References: <001a113ebb5ece8a7a055efb7676@google.com>
 <2409323.isfI9bk5QC@positron.chronox.de>
 <20171127224308.GB8426@gmail.com>
 <5111191.QYDWLsXdp1@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzbot
        <bot+6fbc13c3b1ed2105e7a2e516be43d6a0624a59c0@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5111191.QYDWLsXdp1@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 28, 2017 at 07:30:46AM +0100, Stephan Mueller wrote:
> Am Montag, 27. November 2017, 23:43:08 CET schrieb Eric Biggers:
> 
> Hi Eric,
> 
> > No, that doesn't help.  I tested v4.15-rc1 with all the extra commits from
> > crypto-2.6.git/master applied:
> > 
> > 	crypto: algif_aead - skip SGL entries with NULL page
> > 	crypto: af_alg - remove locking in async callback
> > 	crypto: skcipher - Fix skcipher_walk_aead_common
> > 
> > Did you use the .config the bot provided?  It's possible the bug is only
> > noticable with KASAN enabled.
> 
> Not so far, but the bug seemed to be there without my patch and then gone 
> after testing it with my patch. It seems not.
> 
> I will use your config then.
> 

Sometimes you have to reboot to get the reproducer to work, because the bug has
to do with referencing counting of the "null skcipher" which is a global
resource.  Here's a patch that fixes it, it seems:

---8<---

>From 453b54793e843c0d5b8fd2d5e33fcc5427ec038e Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Mon, 27 Nov 2017 23:23:05 -0800
Subject: [PATCH] crypto: algif_aead - fix reference counting of null skcipher

In the AEAD interface for AF_ALG, the reference to the "null skcipher"
held by each tfm was being dropped in the wrong place -- when each
af_alg_ctx was freed instead of when the aead_tfm was freed.  As
discovered by syzkaller, a specially crafted program could use this to
cause the null skcipher to be freed while it is still in use.

Fix it by dropping the reference in the right place.

Fixes: 72548b093ee3 ("crypto: algif_aead - copy AAD from src to dst")
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algif_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 805f485ddf1b..48b34e9c6834 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -503,6 +503,7 @@ static void aead_release(void *private)
 	struct aead_tfm *tfm = private;
 
 	crypto_free_aead(tfm->aead);
+	crypto_put_default_null_skcipher2();
 	kfree(tfm);
 }
 
@@ -535,7 +536,6 @@ static void aead_sock_destruct(struct sock *sk)
 	unsigned int ivlen = crypto_aead_ivsize(tfm);
 
 	af_alg_pull_tsgl(sk, ctx->used, NULL, 0);
-	crypto_put_default_null_skcipher2();
 	sock_kzfree_s(sk, ctx->iv, ivlen);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
-- 
2.15.0
