From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: IXP4xx: Fix ixp4xx_crypto sparse warnings.
Date: Sun, 10 Jan 2010 18:32:14 +0100
Message-ID: <m3r5px3ly9.fsf@intrepid.localdomain>
References: <m34omu3rf7.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christian Hohnstaedt <chohnstaedt@innominate.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:37740 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab0AJRcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Jan 2010 12:32:16 -0500
In-Reply-To: <m34omu3rf7.fsf@intrepid.localdomain> (Krzysztof Halasa's message
	of "Sun, 10 Jan 2010 16:35:38 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Krzysztof Ha=C5=82asa <khc@pm.waw.pl>

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_cry=
pto.c
index cac026a..99f06e1 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -402,7 +402,7 @@ static void one_packet(dma_addr_t phys)
 		break;
 	case CTL_FLAG_GEN_REVAES:
 		ctx =3D crypto_tfm_ctx(crypt->data.tfm);
-		*(u32*)ctx->decrypt.npe_ctx &=3D cpu_to_be32(~CIPH_ENCR);
+		*(__be32 *)ctx->decrypt.npe_ctx &=3D cpu_to_be32(~CIPH_ENCR);
 		if (atomic_dec_and_test(&ctx->configuring))
 			complete(&ctx->completion);
 		break;
@@ -641,7 +641,7 @@ static int register_chain_var(struct crypto_tfm *tf=
m, u8 xpad, u32 target,
 	crypt->init_len =3D init_len;
 	crypt->ctl_flags |=3D CTL_FLAG_GEN_ICV;
=20
-	buf->next =3D 0;
+	buf->next =3D NULL;
 	buf->buf_len =3D HMAC_PAD_BLOCKLEN;
 	buf->pkt_len =3D 0;
 	buf->phys_addr =3D pad_phys;
@@ -672,7 +672,7 @@ static int setup_auth(struct crypto_tfm *tfm, int e=
ncrypt, unsigned authsize,
 #ifndef __ARMEB__
 	cfgword ^=3D 0xAA000000; /* change the "byte swap" flags */
 #endif
-	*(u32*)cinfo =3D cpu_to_be32(cfgword);
+	*(__be32 *)cinfo =3D cpu_to_be32(cfgword);
 	cinfo +=3D sizeof(cfgword);
=20
 	/* write ICV to cryptinfo */
@@ -709,7 +709,7 @@ static int gen_rev_aes_key(struct crypto_tfm *tfm)
 	if (!crypt) {
 		return -EAGAIN;
 	}
-	*(u32*)dir->npe_ctx |=3D cpu_to_be32(CIPH_ENCR);
+	*(__be32 *)dir->npe_ctx |=3D cpu_to_be32(CIPH_ENCR);
=20
 	crypt->data.tfm =3D tfm;
 	crypt->crypt_offs =3D 0;
@@ -771,7 +771,7 @@ static int setup_cipher(struct crypto_tfm *tfm, int=
 encrypt,
 		}
 	}
 	/* write cfg word to cryptinfo */
-	*(u32*)cinfo =3D cpu_to_be32(cipher_cfg);
+	*(__be32 *)cinfo =3D cpu_to_be32(cipher_cfg);
 	cinfo +=3D sizeof(cipher_cfg);
=20
 	/* write cipher key to cryptinfo */
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
