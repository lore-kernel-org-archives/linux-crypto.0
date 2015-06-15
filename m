From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/8] crypto: caam - Convert GCM to new AEAD interface
Date: Mon, 15 Jun 2015 22:05:25 +0800
Message-ID: <20150615140525.GA6028@gondor.apana.org.au>
References: <20150615080716.GA30753@gondor.apana.org.au>
 <E1Z4PSj-00084W-6B@gondolin.me.apana.org.au>
 <557EC610.9070309@freescale.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:36830 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbbFOOF3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 10:05:29 -0400
Content-Disposition: inline
In-Reply-To: <557EC610.9070309@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 03:33:20PM +0300, Horia Geant=C4=83 wrote:
>=20
> caam_jr ffe301000.jr: 40000e10: DECO: desc idx 14: Invalid Sequence
> Command. A SEQ IN PTR OR SEQ OUT PTR Command is invalid or a SEQ KEY,
> SEQ LOAD, SEQ FIFO LOAD, or SEQ FIFO STORE decremented the input or
> output sequence length below 0. This error may result if a built-in
> PROTOCOL Command has encountered a malformed PDU.
> alg: aead: encryption failed on test 1 for rfc4543-gcm-aes-caam:
> ret=3D-1073745424

OK I see what's going on.  I trashed MATH3 which then gets used
as the length by the seq load.  This incremental patch should fix
rfc4543.

Thanks,

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamal=
g.c
index 066a488..c7cccd0 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1138,7 +1138,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead=
 *aead)
 			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
=20
 	/* assoclen + cryptlen =3D seqinlen */
-	append_math_add(desc, REG3, SEQINLEN, REG0, CAAM_CMD_SZ);
+	append_math_sub(desc, REG3, SEQINLEN, REG0, CAAM_CMD_SZ);
=20
 	/*
 	 * MOVE_LEN opcode is not available in all SEC HW revisions,
@@ -1151,10 +1151,10 @@ static int rfc4543_set_sh_desc(struct crypto_ae=
ad *aead)
 				     (0x8 << MOVE_LEN_SHIFT));
=20
 	/* Will read assoclen + cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
=20
 	/* Will write assoclen + cryptlen bytes */
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
=20
 	/* Read and write assoclen + cryptlen bytes */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF);
@@ -1213,7 +1213,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead=
 *aead)
 			 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT | OP_ALG_ICV_ON);
=20
 	/* assoclen + cryptlen =3D seqoutlen */
-	append_math_add(desc, REG3, SEQOUTLEN, REG0, CAAM_CMD_SZ);
+	append_math_sub(desc, REG3, SEQOUTLEN, REG0, CAAM_CMD_SZ);
=20
 	/*
 	 * MOVE_LEN opcode is not available in all SEC HW revisions,
@@ -1226,10 +1226,10 @@ static int rfc4543_set_sh_desc(struct crypto_ae=
ad *aead)
 				     (0x8 << MOVE_LEN_SHIFT));
=20
 	/* Will read assoclen + cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQINLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
=20
 	/* Will write assoclen + cryptlen bytes */
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQOUTLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
=20
 	/* Store payload data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VL=
=46);

--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
