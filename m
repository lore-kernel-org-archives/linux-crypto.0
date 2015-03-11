From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 4/15] crypto: don't export static symbol
Date: Wed, 11 Mar 2015 17:56:26 +0100
Message-ID: <1426092997-30605-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1426092997-30605-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	daniel@iogearbox.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426092997-30605-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
type T;
identifier f;
@@

static T f (...) { ... }

@@
identifier r.f;
declarer name EXPORT_SYMBOL_GPL;
@@

-EXPORT_SYMBOL_GPL(f);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/x86/crypto/glue_helper.c |    1 -
 1 file changed, 1 deletion(-)

diff -u -p a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -232,7 +232,6 @@ static void glue_ctr_crypt_final_128bit(
 
 	le128_to_be128((be128 *)walk->iv, &ctrblk);
 }
-EXPORT_SYMBOL_GPL(glue_ctr_crypt_final_128bit);
 
 static unsigned int __glue_ctr_crypt_128bit(const struct common_glue_ctx *gctx,
 					    struct blkcipher_desc *desc,
