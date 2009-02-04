From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: zeroing tfms in crypto_free_tfm()
Date: Wed, 4 Feb 2009 16:09:04 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902041606460.29216@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57194 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756616AbZBDPJJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Feb 2009 10:09:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A long time ago (in 2.6.9 and 2.4.28), crypto_free_tfm() started zeroin=
g
"alg->cra_ctxsize" bytes before freeing a crypto_tfm:

| commit 94ab49d18f69a816561ae199e05daab709ba912e (from full-history-li=
nux)
| Author: David S. Miller <davem@nuts.davemloft.net>
| Date:   Tue Sep 14 08:21:40 2004 -0700
|=20
|     [CRYPTO]: Zero out tfm before freeing in crypto_free_tfm().
|    =20
|     Based upon discussions with Ulrich Kuehn
|     (ukuehn@acm.org)
|    =20
|     Signed-off-by: James Morris <jmorris@redhat.com>
|     Signed-off-by: David S. Miller <davem@davemloft.net>
|=20
| diff --git a/crypto/api.c b/crypto/api.c
| index 6f0e625..394169a 100644
| --- a/crypto/api.c
| +++ b/crypto/api.c
| @@ -155,8 +155,12 @@ out:
| =20
|  void crypto_free_tfm(struct crypto_tfm *tfm)
|  {
| +	struct crypto_alg *alg =3D tfm->__crt_alg;
| +	int size =3D sizeof(*tfm) + alg->cra_ctxsize;
| +
|  	crypto_exit_ops(tfm);
| -	crypto_alg_put(tfm->__crt_alg);
| +	crypto_alg_put(alg);
| +	memset(tfm, 0, size);
|  	kfree(tfm);
|  }

However, in the mean time, the allocation mechanism for crypto_tfm obje=
cts has
been changed twice, by:
  1. commit fbdae9f3e7fb57c07cb0d973f113eb25da2e8ff2 ("[CRYPTO] Ensure =
cit_iv
     is aligned correctly"), which replaced "alg->cra_ctxsize" by
     "crypto_ctxsize(alg, flags)" in crypto_alloc_tfm(),
  2. commit 7b0bac64cd5b74d6f1147524c26216de13a501fd ("crypto: api - Re=
birth of
     crypto_alloc_tfm"), which introduced the alternative crypto_create=
_tfm(),
     where the memory requirements are based on
     "frontend->extsize(alg, frontend)" instead of "alg->cra_ctxsize".

=46ortunately (for all current transforms under crypto/), it seems that
"crypto_ctxsize(alg, flags)" and "frontend->extsize(alg, frontend)" are=
 always
at least as large as "alg->cra_ctxsize". But still,
  (a) this may leak key information in the few cases where the actual k=
ey size
      is larger than "alg->cra_ctxsize",
  (b) this may change in the future, causing memory corruption.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
