Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088BA3D1A97
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 16:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780071904; cv=none; b=Eh7y5VeJDP1Cr+st/JQxlz5grupBQJPw4/h5CJb/iaz6nz84GVm6j+l47OjIhRv2Bzo2SN4zqNjK+0RD4LIyPPkHTZrCMp1HjD6HuI0UNDow+m8E09LtM6CZu2naLRk2H74aO/xxUYrwM3DizZW94hpgEayLk4C33/tjPI5cVZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780071904; c=relaxed/simple;
	bh=r48R7/3j0Wyq254lO5gTO2ka/52UHzJ9VOophkzDJvg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZHCGvkUCKSF/JcHbGabJXIMGePBuNnMRNgqt6QAYHOYpbkV3WJWyS7C9y1pqnQHfuZmCzHpq5aO+kQjm8qSH0yaskhPmvL2O7tgimIDmeaFPquKvvKpDbDx4rxkk9n5RrR8oc7oz9kf3G2ufc2gnN5U2E9Q9jeJXDBDN1HZ6Q18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m6jvKVoc; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m6jvKVoc"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49050ff7cbdso67169645e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 09:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780071901; x=1780676701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3UMLnH3bCJ46gdTbKIBGPYf7r6dIutjs1msirUQq3y8=;
        b=m6jvKVocYlZoRTSxrnT8/zSOF+mt+802KfDoX/wC9goEoUeY0OfzJLpGGbsrw2Mi+1
         8XFi0QfeXanFxUiqCWNEwhUbLagJUBsHZN8MAQPhdOpJYcbdyVxRmSWq8x/vdkFOjY6Z
         OXzzIvpDGtWPfZ+2AaotmH+5SnnKakivf1foSk8vGG9EBNDxcwK39aPwgcJU3ROEFOPZ
         Rz1XJBGQRw1AR1fQ84ZrGKEQPPy6QycyiclX80B4mvyiFF2j0b1jv2dUihK9++KItOWt
         y8//m7c4ffvAjtcpy+xDu+YYy24nbPiq973jXjDGaTWPDxs7N+jGCY8VJIUYZmV0zHtp
         wzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780071901; x=1780676701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3UMLnH3bCJ46gdTbKIBGPYf7r6dIutjs1msirUQq3y8=;
        b=W0+21qTORBevJrcNprJQ4A58ZA4kGdvvJgH+Lk2oc5KWTFsZkdjlPfuHuDfXxzB8Ij
         W1BCtfwruq82xlqykzj6DRNVN7YmbYLUk1mS4qct+Ead4WP8Uut39yB2131WMGx/XBeJ
         0GYSPGJiS8mkQqizi652HSux5B3wIE44xm3P/cEd/JPH8uHU7YjVINYsn7LW0adnZyhk
         erE+3fhSFRFC07XHk/7GhU3CWOUlUKWxQrr7ke3j6kmh2CDqJnfYGofLCvsrWA58uG5T
         LpvlL/EJDw30Fj4KhcVIoW1fJcu1OS1Z6MeHLVs4Gma0LHSKXkWhmgU1gXBfXdX05rkg
         /KYg==
X-Forwarded-Encrypted: i=1; AFNElJ+eFufchhXMcMBfBwCrizZBYQ/C8Vqtgsqiw2lHpFVTa8U0kplOVE+Yk7rOi91pfQTKlUL76MzxpjZY2nY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwI4rgE1xi0hOEGc7x0SOoWbIhgnftbbhZcyKDLHa/jRNMmj0RD
	mo1ttT8CCf/iUXqPITS7bR/zXWx0cOk7ZcIZCArE7i2FhUvJvApFhwvD
X-Gm-Gg: Acq92OFsr9Iv8Yxmh/XaP6GxcnX7YF69lUR5bWRRcZjfP/dfoq1EGC6tdmhEOeursx1
	qTvONGSjLcIDJMYrv1Ww2Nlt90KBJu7LG0KfEaQ5ZL03GwkMO8MdTWVbxek1kB2mMcDVnbB4ovC
	dsc1jxX1Z2SnNVPX8lkg5BjYr6umUnWcWk+aleEdIf/Sjpxymy0SPx/bm7BldDRm7BJj/fxDFLO
	QWKpS1GBQ5GVdeUp+ZwDYioXZ5VJK0/MpJqdwUe57IWoj7Qg4yCwHJD4xgPuSx3CNXf75QZ4RSR
	w2WzZf2IFPrP+MdDo0b78j0JxPGMbSZI+Q3hVxRykigCDEtm6EFUrBxr9E4m/dQr73/AWuHWT+Y
	LZtPgf/y5rCx6iH0yWykfBk3lOB83ZbIKuSQtzPe678K6wz+ciWP5kV9buCoUpRNHlYJQ2w9D14
	RVJUxv3R8Ty63swCwkX/Y4TcRK7jroNcJMYOkFhko9gSCdESsAc83+0uInWUsQfxO2boKbTHk=
X-Received: by 2002:a05:600c:4f89:b0:490:6237:5212 with SMTP id 5b1f17b1804b1-490a292eda5mr4947685e9.9.1780071901126;
        Fri, 29 May 2026 09:25:01 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c0b862dsm17340755e9.15.2026.05.29.09.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:25:00 -0700 (PDT)
Date: Fri, 29 May 2026 17:24:59 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Paul Louvel <paul.louvel@bootlin.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Herve Codina
 <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/29] crypto: talitos - Prepare crypto implementation
 file splitting
Message-ID: <20260529172459.1e99ea24@pumpkin>
In-Reply-To: <22245899-e046-41f1-8707-94f172b310e9@kernel.org>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
	<20260528-7-1-rc1_talitos_cleanup-v1-5-cb1ad6cdea49@bootlin.com>
	<22245899-e046-41f1-8707-94f172b310e9@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 29 May 2026 15:21:39 +0200
"Christophe Leroy (CS GROUP)" <chleroy@kernel.org> wrote:

> Hi Paul,
>=20
> Le 28/05/2026 =C3=A0 11:08, Paul Louvel a =C3=A9crit=C2=A0:
> > Remove the static qualifier on multiple function that will be called
> > inside each crypto implementation file.
> > Add them to the main driver header file. =20
>=20
> I didn't have time to look at the generated text yet but I'm a bit=20
> sceptic with this change, or more than the change itself, about its=20
> purpose. And even more when I see patches 24 and 25.
>=20
> Most functions here are small helpers. To be shared between several C=20
> files they deserve becoming static inlines in talitos.h, not global=20
> functions.
>=20
> Indeed, most of the time is_sec1 is known at build time because in most=20
> cases has_ftr_sec1() will constant fold into true or false during build.=
=20
> This is because it is very unlikely that someone build a kernel to run=20
> on both MPC 82xx and MPC 83xx at the same time. Therefore it is really=20
> unlikely that this in built with both CRYPTO_DEV_TALITOS1 and=20
> CRYPTO_DEV_TALITOS2 at the same time.
>=20
> I can understand for a function like talitos_submit() but not for=20
> functions like to_talitos_ptr() or to_talitos_ptr_ext_set() whose=20
> purpose is really to get inlined into the caller.

I also spotted a couple of indirect calls being added.
They will be slower than you might think.
If there are only two options it is better to use an 'if'.

-- David

>=20
> Christophe
>=20
>=20
> >=20
> > Add the common structures too.
> >=20
> > Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> > ---
> >   drivers/crypto/talitos/talitos.c | 123 ++++++++++++++----------------=
---------
> >   drivers/crypto/talitos/talitos.h |  91 +++++++++++++++++++++++++++++
> >   2 files changed, 135 insertions(+), 79 deletions(-)
> >=20
> > diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/=
talitos.c
> > index f5feff8f7d3d..3fc1069062da 100644
> > --- a/drivers/crypto/talitos/talitos.c
> > +++ b/drivers/crypto/talitos/talitos.c
> > @@ -40,8 +40,8 @@
> >  =20
> >   #include "talitos.h"
> >  =20
> > -static void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_add=
r,
> > -			   unsigned int len, bool is_sec1)
> > +void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
> > +		    unsigned int len, bool is_sec1)
> >   {
> >   	ptr->ptr =3D cpu_to_be32(lower_32_bits(dma_addr));
> >   	if (is_sec1) {
> > @@ -52,8 +52,8 @@ static void to_talitos_ptr(struct talitos_ptr *ptr, d=
ma_addr_t dma_addr,
> >   	}
> >   }
> >  =20
> > -static void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
> > -			     struct talitos_ptr *src_ptr, bool is_sec1)
> > +void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
> > +		      struct talitos_ptr *src_ptr, bool is_sec1)
> >   {
> >   	dst_ptr->ptr =3D src_ptr->ptr;
> >   	if (is_sec1) {
> > @@ -64,8 +64,8 @@ static void copy_talitos_ptr(struct talitos_ptr *dst_=
ptr,
> >   	}
> >   }
> >  =20
> > -static unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr,
> > -					   bool is_sec1)
> > +unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr,
> > +				    bool is_sec1)
> >   {
> >   	if (is_sec1)
> >   		return be16_to_cpu(ptr->len1);
> > @@ -73,14 +73,14 @@ static unsigned short from_talitos_ptr_len(struct t=
alitos_ptr *ptr,
> >   		return be16_to_cpu(ptr->len);
> >   }
> >  =20
> > -static void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val,
> > -				   bool is_sec1)
> > +void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val,
> > +			    bool is_sec1)
> >   {
> >   	if (!is_sec1)
> >   		ptr->j_extent =3D val;
> >   }
> >  =20
> > -static void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val, boo=
l is_sec1)
> > +void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val, bool is_se=
c1)
> >   {
> >   	if (!is_sec1)
> >   		ptr->j_extent |=3D val;
> > @@ -102,15 +102,15 @@ static void __map_single_talitos_ptr(struct devic=
e *dev,
> >   	to_talitos_ptr(ptr, dma_addr, len, is_sec1);
> >   }
> >  =20
> > -static void map_single_talitos_ptr(struct device *dev,
> > -				   struct talitos_ptr *ptr,
> > -				   unsigned int len, void *data,
> > -				   enum dma_data_direction dir)
> > +void map_single_talitos_ptr(struct device *dev,
> > +			    struct talitos_ptr *ptr,
> > +			    unsigned int len, void *data,
> > +			    enum dma_data_direction dir)
> >   {
> >   	__map_single_talitos_ptr(dev, ptr, len, data, dir, 0);
> >   }
> >  =20
> > -static void map_single_talitos_ptr_nosync(struct device *dev,
> > +void map_single_talitos_ptr_nosync(struct device *dev,
> >   					  struct talitos_ptr *ptr,
> >   					  unsigned int len, void *data,
> >   					  enum dma_data_direction dir)
> > @@ -122,9 +122,9 @@ static void map_single_talitos_ptr_nosync(struct de=
vice *dev,
> >   /*
> >    * unmap bus single (contiguous) h/w descriptor pointer
> >    */
> > -static void unmap_single_talitos_ptr(struct device *dev,
> > -				     struct talitos_ptr *ptr,
> > -				     enum dma_data_direction dir)
> > +void unmap_single_talitos_ptr(struct device *dev,
> > +			      struct talitos_ptr *ptr,
> > +			      enum dma_data_direction dir)
> >   {
> >   	struct talitos_private *priv =3D dev_get_drvdata(dev);
> >   	bool is_sec1 =3D has_ftr_sec1(priv);
> > @@ -303,11 +303,11 @@ static void dma_map_request(struct device *dev, s=
truct talitos_request *request,
> >    * callback must check err and feedback in descriptor header
> >    * for device processing status.
> >    */
> > -static int talitos_submit(struct device *dev, int ch, struct talitos_d=
esc *desc,
> > -			  void (*callback)(struct device *dev,
> > -					   struct talitos_desc *desc,
> > -					   void *context, int error),
> > -			  void *context)
> > +int talitos_submit(struct device *dev, int ch, struct talitos_desc *de=
sc,
> > +		   void (*callback)(struct device *dev,
> > +				    struct talitos_desc *desc,
> > +				    void *context, int error),
> > +		   void *context)
> >   {
> >   	struct talitos_private *priv =3D dev_get_drvdata(dev);
> >   	struct talitos_request *request;
> > @@ -830,24 +830,6 @@ DEF_TALITOS2_INTERRUPT(ch1_3, TALITOS2_ISR_CH_1_3_=
DONE, TALITOS2_ISR_CH_1_3_ERR,
> >    * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
> >    */
> >   #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
> > -#ifdef CONFIG_CRYPTO_DEV_TALITOS2
> > -#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
> > -#else
> > -#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)
> > -#endif
> > -#define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_B=
LOCK_SIZE */
> > -
> > -struct talitos_ctx {
> > -	struct device *dev;
> > -	int ch;
> > -	__be32 desc_hdr_template;
> > -	u8 key[TALITOS_MAX_KEY_SIZE];
> > -	u8 iv[TALITOS_MAX_IV_LENGTH];
> > -	dma_addr_t dma_key;
> > -	unsigned int keylen;
> > -	unsigned int enckeylen;
> > -	unsigned int authkeylen;
> > -};
> >  =20
> >   #define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
> >   #define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA38=
4_SHA512
> > @@ -939,7 +921,7 @@ static int aead_des3_setkey(struct crypto_aead *aut=
henc,
> >   	return err;
> >   }
> >  =20
> > -static void talitos_sg_unmap(struct device *dev,
> > +void talitos_sg_unmap(struct device *dev,
> >   			     struct talitos_edesc *edesc,
> >   			     struct scatterlist *src,
> >   			     struct scatterlist *dst,
> > @@ -1124,7 +1106,7 @@ static int sg_to_link_tbl_offset(struct scatterli=
st *sg, int sg_count,
> >   	return count;
> >   }
> >  =20
> > -static int talitos_sg_map_ext(struct device *dev, struct scatterlist *=
src,
> > +int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
> >   			      unsigned int len, struct talitos_edesc *edesc,
> >   			      struct talitos_ptr *ptr, int sg_count,
> >   			      unsigned int offset, int tbl_off, int elen,
> > @@ -1161,7 +1143,7 @@ static int talitos_sg_map_ext(struct device *dev,=
 struct scatterlist *src,
> >   	return sg_count;
> >   }
> >  =20
> > -static int talitos_sg_map(struct device *dev, struct scatterlist *src,
> > +int talitos_sg_map(struct device *dev, struct scatterlist *src,
> >   			  unsigned int len, struct talitos_edesc *edesc,
> >   			  struct talitos_ptr *ptr, int sg_count,
> >   			  unsigned int offset, int tbl_off)
> > @@ -1299,17 +1281,17 @@ static int ipsec_esp(struct talitos_edesc *edes=
c, struct aead_request *areq,
> >   /*
> >    * allocate and map the extended descriptor
> >    */
> > -static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
> > -						 struct scatterlist *src,
> > -						 struct scatterlist *dst,
> > -						 u8 *iv,
> > -						 unsigned int assoclen,
> > -						 unsigned int cryptlen,
> > -						 unsigned int authsize,
> > -						 unsigned int ivsize,
> > -						 int icv_stashing,
> > -						 u32 cryptoflags,
> > -						 bool encrypt)
> > +struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
> > +					  struct scatterlist *src,
> > +					  struct scatterlist *dst,
> > +					  u8 *iv,
> > +					  unsigned int assoclen,
> > +					  unsigned int cryptlen,
> > +					  unsigned int authsize,
> > +					  unsigned int ivsize,
> > +					  int icv_stashing,
> > +					  u32 cryptoflags,
> > +					  bool encrypt)
> >   {
> >   	struct talitos_edesc *edesc;
> >   	int src_nents, dst_nents, alloc_len, dma_len, src_len, dst_len;
> > @@ -2172,18 +2154,6 @@ static int ahash_setkey(struct crypto_ahash *tfm=
, const u8 *key,
> >   	return 0;
> >   }
> >  =20
> > -
> > -struct talitos_alg_template {
> > -	u32 type;
> > -	u32 priority;
> > -	union {
> > -		struct skcipher_alg skcipher;
> > -		struct ahash_alg hash;
> > -		struct aead_alg aead;
> > -	} alg;
> > -	__be32 desc_hdr_template;
> > -};
> > -
> >   static struct talitos_alg_template driver_algs[] =3D {
> >   	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
> >   	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
> > @@ -2998,14 +2968,8 @@ static struct talitos_alg_template driver_algs[]=
 =3D {
> >   	}
> >   };
> >  =20
> > -struct talitos_crypto_alg {
> > -	struct list_head entry;
> > -	struct device *dev;
> > -	struct talitos_alg_template algt;
> > -};
> > -
> > -static int talitos_init_common(struct talitos_ctx *ctx,
> > -			       struct talitos_crypto_alg *talitos_alg)
> > +int talitos_init_common(struct talitos_ctx *ctx,
> > +			struct talitos_crypto_alg *talitos_alg)
> >   {
> >   	struct talitos_private *priv;
> >  =20
> > @@ -3066,7 +3030,7 @@ static int talitos_cra_init_ahash(struct crypto_t=
fm *tfm)
> >   	return talitos_init_common(ctx, talitos_alg);
> >   }
> >  =20
> > -static void talitos_cra_exit(struct crypto_tfm *tfm)
> > +void talitos_cra_exit(struct crypto_tfm *tfm)
> >   {
> >   	struct talitos_ctx *ctx =3D crypto_tfm_ctx(tfm);
> >   	struct device *dev =3D ctx->dev;
> > @@ -3080,7 +3044,7 @@ static void talitos_cra_exit(struct crypto_tfm *t=
fm)
> >    * type and primary/secondary execution units required match the hw
> >    * capabilities description provided in the device tree node.
> >    */
> > -static int hw_supports(struct device *dev, __be32 desc_hdr_template)
> > +int talitos_hw_supports(struct device *dev, __be32 desc_hdr_template)
> >   {
> >   	struct talitos_private *priv =3D dev_get_drvdata(dev);
> >   	int ret;
> > @@ -3117,7 +3081,7 @@ static void talitos_remove(struct platform_device=
 *ofdev)
> >   		list_del(&t_alg->entry);
> >   	}
> >  =20
> > -	if (hw_supports(dev, DESC_HDR_SEL0_RNG))
> > +	if (talitos_hw_supports(dev, DESC_HDR_SEL0_RNG))
> >   		talitos_unregister_rng(dev);
> >  =20
> >   	for (i =3D 0; i < 2; i++)
> > @@ -3426,7 +3390,7 @@ static int talitos_probe(struct platform_device *=
ofdev)
> >   	}
> >  =20
> >   	/* register the RNG, if available */
> > -	if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
> > +	if (talitos_hw_supports(dev, DESC_HDR_SEL0_RNG)) {
> >   		err =3D talitos_register_rng(dev);
> >   		if (err) {
> >   			dev_err(dev, "failed to register hwrng: %d\n", err);
> > @@ -3437,7 +3401,8 @@ static int talitos_probe(struct platform_device *=
ofdev)
> >  =20
> >   	/* register crypto algorithms the device supports */
> >   	for (i =3D 0; i < ARRAY_SIZE(driver_algs); i++) {
> > -		if (hw_supports(dev, driver_algs[i].desc_hdr_template)) {
> > +		if (talitos_hw_supports(dev,
> > +					driver_algs[i].desc_hdr_template)) {
> >   			struct talitos_crypto_alg *t_alg;
> >   			struct crypto_alg *alg =3D NULL;
> >  =20
> > diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/=
talitos.h
> > index fa8c71b1f90f..1f81d336dae8 100644
> > --- a/drivers/crypto/talitos/talitos.h
> > +++ b/drivers/crypto/talitos/talitos.h
> > @@ -5,7 +5,13 @@
> >    * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
> >    */
> >  =20
> > +#include <crypto/aes.h>
> > +#include <crypto/internal/aead.h>
> > +#include <crypto/internal/hash.h>
> > +#include <crypto/internal/skcipher.h>
> > +#include <crypto/sha2.h>
> >   #include <linux/device.h>
> > +#include <linux/dma-mapping.h>
> >   #include <linux/hw_random.h>
> >   #include <linux/interrupt.h>
> >   #include <linux/scatterlist.h>
> > @@ -19,6 +25,13 @@
> >   #define PRIMARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 28) & 0xf)
> >   #define SECONDARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 16) & 0xf)
> >  =20
> > +#ifdef CONFIG_CRYPTO_DEV_TALITOS2
> > +#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
> > +#else
> > +#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)
> > +#endif
> > +#define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_B=
LOCK_SIZE */
> > +
> >   /* descriptor pointer entry */
> >   struct talitos_ptr {
> >   	union {
> > @@ -174,6 +187,35 @@ struct talitos_private {
> >  =20
> >   };
> >  =20
> > +struct talitos_ctx {
> > +	struct device *dev;
> > +	int ch;
> > +	__be32 desc_hdr_template;
> > +	u8 key[TALITOS_MAX_KEY_SIZE];
> > +	u8 iv[TALITOS_MAX_IV_LENGTH];
> > +	dma_addr_t dma_key;
> > +	unsigned int keylen;
> > +	unsigned int enckeylen;
> > +	unsigned int authkeylen;
> > +};
> > +
> > +struct talitos_alg_template {
> > +	u32 type;
> > +	u32 priority;
> > +	union {
> > +		struct skcipher_alg skcipher;
> > +		struct ahash_alg hash;
> > +		struct aead_alg aead;
> > +	} alg;
> > +	__be32 desc_hdr_template;
> > +};
> > +
> > +struct talitos_crypto_alg {
> > +	struct list_head entry;
> > +	struct device *dev;
> > +	struct talitos_alg_template algt;
> > +};
> > +
> >   /* .features flag */
> >   #define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
> >   #define TALITOS_FTR_HW_AUTH_CHECK 0x00000002
> > @@ -432,6 +474,55 @@ static inline bool has_ftr_sec1(struct talitos_pri=
vate *priv)
> >   #define DESC_PTR_LNKTBL_RET			0x02
> >   #define DESC_PTR_LNKTBL_NEXT			0x01
> >  =20
> > +void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
> > +		    unsigned int len, bool is_sec1);
> > +void copy_talitos_ptr(struct talitos_ptr *dst_ptr, struct talitos_ptr =
*src_ptr,
> > +		      bool is_sec1);
> > +unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr, bool is_s=
ec1);
> > +void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val, bool is_s=
ec1);
> > +void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val, bool is_se=
c1);
> > +
> > +void map_single_talitos_ptr(struct device *dev, struct talitos_ptr *pt=
r,
> > +			    unsigned int len, void *data,
> > +			    enum dma_data_direction dir);
> > +void map_single_talitos_ptr_nosync(struct device *dev, struct talitos_=
ptr *ptr,
> > +				   unsigned int len, void *data,
> > +				   enum dma_data_direction dir);
> > +void unmap_single_talitos_ptr(struct device *dev, struct talitos_ptr *=
ptr,
> > +			      enum dma_data_direction dir);
> > +
> > +int talitos_submit(struct device *dev, int ch, struct talitos_desc *de=
sc,
> > +		   void (*callback)(struct device *dev,
> > +				    struct talitos_desc *desc, void *context,
> > +				    int error),
> > +		   void *context);
> > +
> > +void talitos_sg_unmap(struct device *dev, struct talitos_edesc *edesc,
> > +		      struct scatterlist *src, struct scatterlist *dst,
> > +		      unsigned int len, unsigned int offset);
> > +int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
> > +		       unsigned int len, struct talitos_edesc *edesc,
> > +		       struct talitos_ptr *ptr, int sg_count,
> > +		       unsigned int offset, int tbl_off, int elen, bool force,
> > +		       int align);
> > +int talitos_sg_map(struct device *dev, struct scatterlist *src,
> > +		   unsigned int len, struct talitos_edesc *edesc,
> > +		   struct talitos_ptr *ptr, int sg_count, unsigned int offset,
> > +		   int tbl_off);
> > +
> > +struct talitos_edesc *
> > +talitos_edesc_alloc(struct device *dev, struct scatterlist *src,
> > +		    struct scatterlist *dst, u8 *iv, unsigned int assoclen,
> > +		    unsigned int cryptlen, unsigned int authsize,
> > +		    unsigned int ivsize, int icv_stashing, u32 cryptoflags,
> > +		    bool encrypt);
> > +
> > +int talitos_hw_supports(struct device *dev, __be32 desc_hdr_template);
> > +
> > +int talitos_init_common(struct talitos_ctx *ctx,
> > +			struct talitos_crypto_alg *talitos_alg);
> > +void talitos_cra_exit(struct crypto_tfm *tfm);
> > +
> >   /* Hardware RNG */
> >  =20
> >   int talitos_register_rng(struct device *dev);
> >  =20
>=20
>=20

