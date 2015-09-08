From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: testmgr: test IV value after a cipher operation
Date: Tue, 08 Sep 2015 05:23:59 +0200
Message-ID: <43689867.jVbFUkvrcd@tauon.atsec.com>
References: <1434448007-9537-1-git-send-email-boris.brezillon@free-electrons.com> <1434448007-9537-2-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33803 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbbIHDYF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Sep 2015 23:24:05 -0400
In-Reply-To: <1434448007-9537-2-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 16. Juni 2015, 11:46:46 schrieb Boris Brezillon:

Hi Herbert,

>The crypto drivers are supposed to update the IV passed to the crypto
>request before calling the completion callback.
>Test for the IV value before considering the test as successful.

May I ask whether there is anything wrong with this patch?

I am asking because the keywrapping template I would like to release would 
need the test manager to check the generated IV.

Thanks a lot.

>
>Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>---
> crypto/testmgr.c | 12 +++++++++++-
> crypto/testmgr.h |  1 +
> 2 files changed, 12 insertions(+), 1 deletion(-)
>
>diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>index f9bce3d..e6b5f24 100644
>--- a/crypto/testmgr.c
>+++ b/crypto/testmgr.c
>@@ -1013,12 +1013,22 @@ static int __test_skcipher(struct crypto_ablkcipher
>*tfm, int enc,
>
> 		q = data;
> 		if (memcmp(q, template[i].result, template[i].rlen)) {
>-			pr_err("alg: skcipher%s: Test %d failed on %s for 
%s\n",
>+			pr_err("alg: skcipher%s: Test %d failed (invalid 
result) on %s for %s\n",
>d, j, e, algo);
> 			hexdump(q, template[i].rlen);
> 			ret = -EINVAL;
> 			goto out;
> 		}
>+
>+		if (template[i].iv_out &&
>+		    memcmp(iv, template[i].iv_out,
>+			   crypto_ablkcipher_ivsize(tfm))) {
>+			pr_err("alg: skcipher%s: Test %d failed (invalid 
output IV) on %s for
>%s\n", +			       d, j, e, algo);
>+			hexdump(iv, crypto_ablkcipher_ivsize(tfm));
>+			ret = -EINVAL;
>+			goto out;
>+		}
> 	}
>
> 	j = 0;
>diff --git a/crypto/testmgr.h b/crypto/testmgr.h
>index 62e2485..03320f9 100644
>--- a/crypto/testmgr.h
>+++ b/crypto/testmgr.h
>@@ -49,6 +49,7 @@ struct hash_testvec {
> struct cipher_testvec {
> 	char *key;
> 	char *iv;
>+	char *iv_out;
> 	char *input;
> 	char *result;
> 	unsigned short tap[MAX_TAP];


Ciao
Stephan
