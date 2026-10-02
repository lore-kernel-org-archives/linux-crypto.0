Received: from mail-qv2-f41.google.com (mail-qv2-f41.google.com [74.125.230.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3112736D50D
	for <linux-crypto@vger.kernel.org>; Fri,  2 Oct 2026 05:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790917981; cv=pass; b=OQIU0IO0MinrwZQga8y1DiaM6r1E9Yhxi4UXuXrSVInMYgTR8nHbAg7CCoVkTtEwpbgYtx2r0M4NjIe2vz6lNAkTZ79XoOCG7YGJFEnoH1eYZc3nDD0gX0vo2DXaT3dA/at2avncN2IpSahJ67S9WCjTJZh8dvSErfbrG0P/u5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790917981; c=relaxed/simple;
	bh=S8Jtihtn3387XynzpWWxcaATC2/8v7ntnHCXBS2w0/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cQEngGSq+tkig/wQyxV1Nj/0RT5BHndy01sVLR0yIMZMQhd9ZCKCx8y0FO1YCJn3FGPYJ9l9CI4p/5e+vvofHwvWfSlxJKvi62DJXh5xez+l1ZHq5Xf8+B562An3sC7lOIr6rUpay7qDLrmq1RAYDeYMp23mDiwo276B0igQX94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=myosPXgN; arc=pass smtp.client-ip=74.125.230.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="myosPXgN"
Received: by mail-qv2-f41.google.com with SMTP id 6a1803df08f44-91782a91a3aso39951006d6.0
        for <linux-crypto@vger.kernel.org>; Thu, 01 Oct 2026 22:12:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790917976; cv=none;
        d=google.com; s=arc-20260327;
        b=GUWbOdS2a9PaoSpg0lySqSL2ObA01XFNfzZdTOxajsyKVkwtjHhal6DXhYFwRYiNvQ
         ATv0ZNcSZ+/2g1yumTrqZBfR3pQwngYX0YXplwi6xu2Bl55kb82MpG7fwPlMzphS83Of
         HvCQknj7yQuCzJaJKYjNzAF5wkes0Uk7u7tA7fEYLQwOmBHl1zrP71u5+CLlMx6cyEce
         PtTQ8slsE2RD3FhvQ+q4cl4rSjRTPI88sgsRt0RJr+H2EOH7L2cypDpcoAl8bAUIJjyw
         Yif6qJ9x2pFdV9zf6z4TWvmPSLZhcK1nAtEj8PmyVTg/WUVKlR2sdmO8gEeD/b33Lp01
         4+pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pNsuUSVMsMgy4F3/JOoqgtAPcs+ltR4LwZ8VqgJ/YUE=;
        fh=Z6NBMD+V18o+gASEi/ThZwAbFPU2Q2lEZgBzKuBf/8o=;
        b=hrN6K76qKon/nQnxSP1MCtWJVTNjgT+8h8E9FMqBb35ZIwGTvNVbHI5V10K07LFz6z
         PPsw0LZwS0azJcX0xMoTP5LDXQuq3cm4S9UncJBKjMWrq0pFdLzKHUlz4H3V+a+OiQoK
         i+esW4cOmsgimifm8huQR62W7iRerqYOL183w3HzIXc7jDV9oJgQDDKDG6u3/ELroFr7
         yLW9t4AjSJ7Hvr/TRU2GQ1fZeZUXKdo4z8OpJyyNofFbisiS9XKFGMciVVA94YwUDV75
         Nk9z7n3amYXY3ebdJzOsrmeiS7DTQVDT5Fff/W2zEAKY1BA0EJMAxlknf9yFZZwOBj5D
         OGiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1790917976; x=1791522776; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pNsuUSVMsMgy4F3/JOoqgtAPcs+ltR4LwZ8VqgJ/YUE=;
        b=myosPXgNiQ2EgUqdXuO+GFGGLYAJMcgo3fuME5H4yjy92LJKtfFI/XZ2p+TUsWFOZR
         lBgkc8j4YUVVSjeNDM1c0RNIDKJJ7nwmmZrdhag/XDet5Bx1sgWv/hQiBNaZ+4raPtbP
         ukvnU2guE5dyF8hKU427P271uiNd/ohRO/QQc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790917976; x=1791522776;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pNsuUSVMsMgy4F3/JOoqgtAPcs+ltR4LwZ8VqgJ/YUE=;
        b=b7xsODJKLWUaJO2DM8ySKaYyvd14RETdue+4clV+l2Sl/GnARx+6UJ/mF88wwyXg8G
         AEifexil7bO/5f87gBb7LXyzfiritowU3vejRN2fNapN/DYrtmmkftccHh/jb5WlSgNm
         L4cbZFLqzLREJEczh+cE/E2KY6bwRprmKU4uwv3wjZWfpMFNIgTXviF16u99RCIdX0Hs
         2DeKopVPxOHjk7e4PSV56oNQ257hSKID3TMBi0WgVp2ASaqyewB+EApnRIWR6AnzsaJ2
         LeV32z0QB4HYoacQA0pKoEPImD0XKRi5SqWkINNb6AUFhtfMr4xHxZJS9O2ViKCYF4Av
         8t2A==
X-Gm-Message-State: AFq9FYK5IvgvEe//1RdnbZE1p/BXyEE01HnjF+s8P8wEdnmsanqtdFkJ
	YPaPW2fzce8Rt3Tt55V6th6yJDFoN9A5v+3G/Ef6k/exgaGup0a1m5rTbL+4jJmb4eHxzCQXUx8
	khz+H0rdHjseLquMVjm56c+QB4GHiwZVXU9SOx6MLiw==
X-Gm-Gg: AYBFou0qeyoZuTVQPWPPZLC8CGaM8kI8oQuTVmj04d/keOk9A09H1b21jMIrk9qYzaB
	WsCGAK14533lmfMmaZMv7TRXn+5yDeK7L/tEusWA3bW3r1B8BXEFTmCyh1ljDaoRAGX9qX5FxBj
	ohHCObxyQYccKN58+V3b2LEi2DiCxW4Bbv/qxfFgsrZi5x7ZRCcTaaWMC7Me4qQ5IrS1iPhX54O
	TN+Es/xwW4r67a9RcfZyd9aoq6GHGc57IMWMemHS+rwWL8IOvHUInjYbBsG2vrBkwz0pnIGTeEO
	EuBjewFFmm4g5nzyqNiFHYTx9Nw346Duwfl3ZRxg1EmUpCX2ayMEITqTvH6+RFzWsRGX8uaBrff
	IebJFMrPObj/d5RPk57RjnFc63MJ8U45E6w1Jgi5fsEPD1QhaH+yZk0eLjs4PZjF3YznAUvMSV4
	7PqeG9uP7zF0tCdqEBKEzMTLvssaduHCE=
X-Received: by 2002:a05:6214:1d01:b0:912:6380:fe12 with SMTP id
 6a1803df08f44-917c0043ca8mr36615026d6.8.1790917976456; Thu, 01 Oct 2026
 22:12:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907155916.999153-1-pavitrakumarm@vayavyalabs.com>
 <20260907155916.999153-3-pavitrakumarm@vayavyalabs.com> <aqz45SDR8judkwk5@gondor.apana.org.au>
In-Reply-To: <aqz45SDR8judkwk5@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Fri, 2 Oct 2026 10:42:44 +0530
X-Gm-Features: AclHuK9z4TzNQCLimIHBRc_f1VJ8yqzmTGjdYfPGf-ABCOBscmzwdXYvuVHOzI8
Message-ID: <CALxtO0nptFbjV-h567rag=ibWTxb_2PtG4ZEKCiAufTt-g-bUg@mail.gmail.com>
Subject: Re: [PATCH v25 2/4] crypto: spacc - Add SPAcc ahash support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, robh@kernel.org, krzk@kernel.org, 
	conor+dt@kernel.org, ruud.derwig@gf.com, rbannerm@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, 
	navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com, 
	nazim.khan@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,
   My comments are embedded below.

Also while bringing up an async ahash SPAcc driver against 7.3-rc1,
cmac(aes) and xcbc(aes) fail their self-tests at tfm allocation, and
I'd like to understand whether the underlying cause is intentional
before I work around it in the driver.

All tests pass for every hash and HMAC we register, except cmac(aes)
and xcbc(aes). For cmac(aes)/xcbc(aes) it fails.

crypto_ahash_init_tfm() allocates the fallback with:

    crypto_alloc_ahash(name, CRYPTO_ALG_REQ_VIRT,
                       CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_VIRT |
                       CRYPTO_AHASH_ALG_NO_EXPORT_CORE);

On our tree no cmac(aes)/xcbc(aes) provider satisfies that: with both
CONFIG_CRYPTO_CMAC/XCBC=3Dy and CONFIG_CRYPTO_LIB_AES_CBC_MACS=3Dy,
neither the crypto/cmac.c template nor the new AES-CMAC library shash
implements export_core/import_core, so both report NO_EXPORT_CORE. The
allocation finds no candidate and returns -EINVAL.

alg: hash: failed to allocate transform for spacc-cmac(aes): -22

The library shash matches ASYNC=3D0 and REQ_VIRT but is rejected on
NO_EXPORT_CORE. No candidate remains. CONFIG_CRYPTO_SELFTESTS_FULL=3Dy,
so this is hit deterministically.

This looks like the case flagged in "crypto: sha256 - Implement
export_core() and import_core()" (Eric, Sep 2025), which notes that
since
commit 9d7a0ab1c753 export_core/import_core "effectively became
mandatory... since legacy drivers that need a fallback depend on
them."
sha256/sha512/md5/hmac gained export_core, but cmac(aes)/xcbc(aes) did not.

Is the absence of export_core/import_core on cmac(aes)/xcbc(aes)
intentional -- i.e. async offload drivers must not rely on the core
software fallback for these MACs -- or is it an oversight that should
be addressed the way sha256 was?

Warm regards,
Pavitrakumar
Vayavya Labs Pvt. Ltd.

On Fri, Sep 18, 2026 at 2:10=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Mon, Sep 07, 2026 at 09:29:14PM +0530, Pavitrakumar Managutte wrote:
> >
> > +static int spacc_hash_init(struct ahash_request *req)
> > +{
> > +     int rc;
> > +     struct crypto_ahash *tfm        =3D crypto_ahash_reqtfm(req);
> > +     struct spacc_crypto_ctx *tctx   =3D crypto_ahash_ctx(tfm);
> > +     struct spacc_crypto_reqctx *ctx =3D ahash_request_ctx(req);
> > +
> > +     memset(ctx->state_buffer, 0, sizeof(ctx->state_buffer));
> > +
> > +     if (tctx->shash_fb) {
> > +             SHASH_DESC_ON_STACK(desc, tctx->shash_fb);
> > +
> > +             desc->tfm =3D tctx->shash_fb;
> > +             rc =3D crypto_shash_init(desc);
> > +             if (!rc)
> > +                     rc =3D crypto_shash_export(desc, ctx->state_buffe=
r);
> > +             shash_desc_zero(desc);
> > +     } else {
> > +             HASH_FBREQ_ON_STACK(fbreq, req);
> > +
> > +             rc =3D crypto_ahash_init(fbreq);
> > +             if (!rc)
> > +                     rc =3D crypto_ahash_export(fbreq, ctx->state_buff=
er);
> > +             HASH_REQUEST_ZERO(fbreq);
> > +     }
>
> Why do we need two fallback paths? It would appear that you can
> just use the else clause in all cases.
PK: Will fix that. We just need the ahash else path.

>
> > +static const struct ahash_engine_alg spacc_hash_template =3D {
> > +     .base =3D {
> > +             .init     =3D spacc_hash_init,
> > +             .update   =3D spacc_hash_update,
> > +             .final    =3D spacc_hash_final,
> > +             .finup    =3D spacc_hash_finup,
> > +             .digest   =3D spacc_hash_digest,
> > +             .setkey   =3D spacc_hash_setkey,
> > +             .export   =3D spacc_hash_export,
> > +             .import   =3D spacc_hash_import,
> > +             .init_tfm =3D spacc_hash_init_tfm,
> > +             .exit_tfm =3D spacc_hash_exit_tfm,
> > +
> > +             .halg.base =3D {
> > +                     .cra_priority   =3D 300,
> > +                     .cra_module     =3D THIS_MODULE,
> > +                     .cra_ctxsize    =3D sizeof(struct spacc_crypto_ct=
x),
> > +                     .cra_reqsize    =3D sizeof(struct spacc_crypto_re=
qctx),
> > +                     .cra_destroy    =3D spacc_hash_alg_destroy,
> > +                     .cra_flags      =3D CRYPTO_ALG_TYPE_AHASH    |
> > +                                       CRYPTO_ALG_ASYNC
>
> Please use BLOCK_ONLY for all new drivers.  See aspeed for an
> example on how it works.
PK: Is this needed for SPAcc? Let me give some context here.
The SPAcc engine computes MACs in a single shot only; it cannot export
or import intermediate MAC state. So, following the current model, the
driver registers async ahash algorithms and relies on the
core-provided software fallback for the incremental
(init/update/final) path, as per your suggestion. So is the BLOCK_ONLY
flag still needed?

>
> > +     /*
> > +      * CMAC/XCBC-AES have a dedicated shash fallback (allocated in
> > +      * init_tfm).  They must not advertise CRYPTO_ALG_OPTIONAL_KEY or
> > +      * the crypto API may try to use the generic ahash fallback for t=
hem,
> > +      * which would recurse back into this driver.
> > +      */
>
> How can it recurse back into the driver? The fallback allocated
> by the API is always synchronous so unless your driver is sync
> (which it is not) it cannot recurse.
PK: Agreed, will remove that.

>
> > +             salg->alg.hash.base.halg.base.cra_flags =3D
> > +                     CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC |
> > +                     CRYPTO_ALG_NEED_FALLBACK;
>
> There is no need to set NEED_FALLBACK as the API now allocates
> fallbacks for all async drivers.
PK: Agreed, I will fix that.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
