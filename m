From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/8] crypto: caam - Convert GCM to new AEAD interface
Date: Mon, 15 Jun 2015 21:59:47 +0800
Message-ID: <20150615135947.GA3363@gondor.apana.org.au>
References: <20150615080716.GA30753@gondor.apana.org.au>
 <E1Z4PSj-00084W-6B@gondolin.me.apana.org.au>
 <557EC610.9070309@freescale.com>
 <20150615125951.GA1902@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	ruchika.gupta@freescale.com, cristian.stoica@freescale.com,
	NiteshNarayanLal@freescale.com, jinyanjiang@gmail.com,
	Tudor Ambarus <tudor.ambarus@freescale.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44874 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbbFON7w (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 09:59:52 -0400
Content-Disposition: inline
In-Reply-To: <20150615125951.GA1902@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 08:59:51PM +0800, Herbert Xu wrote:
> On Mon, Jun 15, 2015 at 03:33:20PM +0300, Horia Geant=C4=83 wrote:
> >=20
> > Testing on P2041RDB I see the following failures:
> >=20
> > caam_jr ffe301000.jr: 40000f10: DECO: desc idx 15: Invalid Sequence
> > Command. A SEQ IN PTR OR SEQ OUT PTR Command is invalid or a SEQ KE=
Y,
> > SEQ LOAD, SEQ FIFO LOAD, or SEQ FIFO STORE decremented the input or
> > output sequence length below 0. This error may result if a built-in
> > PROTOCOL Command has encountered a malformed PDU.
> > alg: aead: encryption failed on test 1 for rfc4106-gcm-aes-caam:
> > ret=3D-1073745680

OK I see a bug here where I used the wrong length so it's off by
authsize and that could explain the error.

> > caam_jr ffe301000.jr: 40000e10: DECO: desc idx 14: Invalid Sequence
> > Command. A SEQ IN PTR OR SEQ OUT PTR Command is invalid or a SEQ KE=
Y,
> > SEQ LOAD, SEQ FIFO LOAD, or SEQ FIFO STORE decremented the input or
> > output sequence length below 0. This error may result if a built-in
> > PROTOCOL Command has encountered a malformed PDU.
> > alg: aead: encryption failed on test 1 for rfc4543-gcm-aes-caam:
> > ret=3D-1073745424

I still don't understand this one though.

Here's an incremental patch for rfc4106.

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamal=
g.c
index ca8948e..066a488 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -986,10 +986,10 @@ static int rfc4106_set_sh_desc(struct crypto_aead=
 *aead)
 			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
=20
 	/* cryptlen =3D seqoutlen - assoclen */
-	append_math_sub(desc, VARSEQOUTLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
=20
 	/* Will read cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
=20
 	/* Write encrypted data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VL=
=46);
@@ -1054,10 +1054,10 @@ static int rfc4106_set_sh_desc(struct crypto_ae=
ad *aead)
 			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
=20
 	/* Will write cryptlen bytes */
-	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQOUTLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
=20
 	/* Will read cryptlen bytes */
-	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQINLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
=20
 	/* Store payload data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VL=
=46);

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
