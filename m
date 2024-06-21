Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1449383A2;
	Fri, 21 Jun 2024 14:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718981653; cv=none; b=V5lCGpmZ2rj50qPKxPepTGGDqCT0psu/nsEIY5FVD3o87Ym9qyp4hJU+u04PdQTOjEflDMZLX9qn4Oc+Uxf/WPKmW27SSxluaBuAnkz+zZqDPUSv8ZcoRjydll685vppTBJCAhc7BNFf4BtGHGsHScps+3kDfSBE+e8qrtacQuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718981653; c=relaxed/simple;
	bh=9fGiVhIGKu4NQKJdAeG7n0j9T/2YWEcWWCSmYg2oLKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XnXTYUdvEXl+PMiMMqj9gHLGQWYih2RF7mzTEQpa+oahfLnbctfabJZbOcvh/RMEcjTSbkmXLOPnOMnimUzGWfffQUvHCeCgXS+o9cK5q4Xzv8WyTyIAzJJmWu0oncI5LLZrMB50r+mBKmRGoumMLh13ltWOW68wnWlzcnqIUc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7ec00e71a57so79421439f.3;
        Fri, 21 Jun 2024 07:54:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718981645; x=1719586445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J/NNzS6WAE1jFUsn8rK9By+4Dsv7Fm3OvCmxKnmIsak=;
        b=eNnKwY0+d6dkeBm8d98FTgobqVZNkO0oSRSC1uBv77Z0TnU+A5VWlCmdN+vLl+VZw6
         0kzc4uyHZld7ClkR0qIacjMjunA5PClJtgmiQ+I0UinUfE2+i9U/o3BDEWiwd/ghWHOg
         vEBPLIcWsmTd8ZQ+wMl7YF384oEsrAFaV23TiSYwb8YfpTiXSZihJcxsEGRjG/VwRwg9
         05qtiSlF94A5NhndzT8u72SCLvG8MJmntZCgbDaqYjdV3kjGPCKeC6e9eo2nRPygaKqc
         3kUwFu0xLRwRktagluvnf6uRlibddxLzGLRusLKsj8UUy+fyZmJ2wgPELOaO69WIGSyR
         M5Rg==
X-Forwarded-Encrypted: i=1; AJvYcCWYKTge5dbdm8r5z9m8ks+A5Oi6jzL9bHsmh2ufyeBbgBScgHPpkY0wYpYUIItusXgP6YZWZP1by2ylxYg4ZML5aJ7vGMz2qBobQm888tVcaI49FpEBXBniSHnPrqdM4j26UeEaXbXL3Q==
X-Gm-Message-State: AOJu0YwZM4aj/juDhAOxBXaBOIOH8yvOJtFZDEo7/bVnSBNFhF4LTwuq
	UBfVc1BKwbizSFIrx900R2a3o3NnT1DFdn2gLQQ6JB7OsElhdhqLcMhSuhuj9kky8Q==
X-Google-Smtp-Source: AGHT+IFcRzV6dJNS5jfG2v6r9279SJkSIlyV7C8keMTvkV5Ha9cngM6oAIKho3O1NjoDeFF3mFFBDg==
X-Received: by 2002:a05:6602:3429:b0:7eb:caf2:98d5 with SMTP id ca18e2360f4ac-7f13edaf7bemr1020316339f.1.1718981644685;
        Fri, 21 Jun 2024 07:54:04 -0700 (PDT)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com. [209.85.166.44])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b9d1110286sm391040173.63.2024.06.21.07.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jun 2024 07:54:04 -0700 (PDT)
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7ebe508fa34so106316739f.2;
        Fri, 21 Jun 2024 07:54:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUBp749T3AnQl2PIdPG64vT3Tvwp3Z9LQ7CuGy1icoOUNxDfKEBTkDk1UMNixK80NvXubpeJoPP/QVn2epyIdM38TbULrcqsuw8krKvH2MXUYbQ1oJXe/1MPxV/m/JAo2n7qxbdNffBgA==
X-Received: by 2002:a05:6602:60ce:b0:7eb:898f:1c66 with SMTP id
 ca18e2360f4ac-7f13ee0a0fcmr992286339f.11.1718981644259; Fri, 21 Jun 2024
 07:54:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240616220719.26641-1-andre.przywara@arm.com> <20240616220719.26641-3-andre.przywara@arm.com>
In-Reply-To: <20240616220719.26641-3-andre.przywara@arm.com>
Reply-To: wens@csie.org
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 21 Jun 2024 22:53:47 +0800
X-Gmail-Original-Message-ID: <CAGb2v6724rJ19-LEQHuMvfU5SsrECKYwUxRyE7vQTdnb39Ubjw@mail.gmail.com>
Message-ID: <CAGb2v6724rJ19-LEQHuMvfU5SsrECKYwUxRyE7vQTdnb39Ubjw@mail.gmail.com>
Subject: Re: [PATCH 2/4] crypto: sun8i-ce - wrap accesses to descriptor
 address fields
To: Andre Przywara <andre.przywara@arm.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
	Samuel Holland <samuel@sholland.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev, 
	devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2024 at 6:08=E2=80=AFAM Andre Przywara <andre.przywara@arm.=
com> wrote:
>
> The Allwinner H616 (and later) SoCs support more than 32 bits worth of
> physical addresses. To accommodate the larger address space, the CE task
> descriptor fields holding addresses are now encoded as "word addresses",
> so take the actual address divided by four.
> This is true for the fields within the descriptor, but also for the
> descriptor base address, in the CE_TDA register.
>
> Wrap all accesses to those fields in a function, which will do the
> required division if needed. For now this in unused, so there should be
> no change in behaviour.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>

though you need to fix up the reported sparse warning in sun8i_ce_run_task(=
).

> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c |  8 ++++----
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   |  3 ++-
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   |  6 +++---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c   |  6 +++---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c   |  2 +-
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h        | 10 ++++++++++
>  6 files changed, 23 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/driver=
s/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> index de50c00ba218f..3a5674b1bd3c0 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> @@ -190,7 +190,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engi=
ne *engine, void *async_req
>                 err =3D -EFAULT;
>                 goto theend;
>         }
> -       cet->t_key =3D cpu_to_le32(rctx->addr_key);
> +       cet->t_key =3D sun8i_ce_desc_addr(ce, rctx->addr_key);
>
>         ivsize =3D crypto_skcipher_ivsize(tfm);
>         if (areq->iv && crypto_skcipher_ivsize(tfm) > 0) {
> @@ -208,7 +208,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engi=
ne *engine, void *async_req
>                         err =3D -ENOMEM;
>                         goto theend_iv;
>                 }
> -               cet->t_iv =3D cpu_to_le32(rctx->addr_iv);
> +               cet->t_iv =3D sun8i_ce_desc_addr(ce, rctx->addr_iv);
>         }
>
>         if (areq->src =3D=3D areq->dst) {
> @@ -236,7 +236,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engi=
ne *engine, void *async_req
>
>         len =3D areq->cryptlen;
>         for_each_sg(areq->src, sg, nr_sgs, i) {
> -               cet->t_src[i].addr =3D cpu_to_le32(sg_dma_address(sg));
> +               cet->t_src[i].addr =3D sun8i_ce_desc_addr(ce, sg_dma_addr=
ess(sg));
>                 todo =3D min(len, sg_dma_len(sg));
>                 cet->t_src[i].len =3D cpu_to_le32(todo / 4);
>                 dev_dbg(ce->dev, "%s total=3D%u SG(%d %u off=3D%d) todo=
=3D%u\n", __func__,
> @@ -251,7 +251,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engi=
ne *engine, void *async_req
>
>         len =3D areq->cryptlen;
>         for_each_sg(areq->dst, sg, nr_sgd, i) {
> -               cet->t_dst[i].addr =3D cpu_to_le32(sg_dma_address(sg));
> +               cet->t_dst[i].addr =3D sun8i_ce_desc_addr(ce, sg_dma_addr=
ess(sg));
>                 todo =3D min(len, sg_dma_len(sg));
>                 cet->t_dst[i].len =3D cpu_to_le32(todo / 4);
>                 dev_dbg(ce->dev, "%s total=3D%u SG(%d %u off=3D%d) todo=
=3D%u\n", __func__,
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/=
crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> index 0408b2d5d533b..89ab3e08f0697 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> @@ -172,7 +172,8 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int fl=
ow, const char *name)
>         writel(v, ce->base + CE_ICR);
>
>         reinit_completion(&ce->chanlist[flow].complete);
> -       writel(ce->chanlist[flow].t_phy, ce->base + CE_TDQ);
> +       writel(sun8i_ce_desc_addr(ce, ce->chanlist[flow].t_phy),
> +              ce->base + CE_TDQ);
>
>         ce->chanlist[flow].status =3D 0;
>         /* Be sure all data is written before enabling the task */
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/=
crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> index ee2a28c906ede..a710ec9aa96f1 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> @@ -403,7 +403,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, v=
oid *breq)
>
>         len =3D areq->nbytes;
>         for_each_sg(areq->src, sg, nr_sgs, i) {
> -               cet->t_src[i].addr =3D cpu_to_le32(sg_dma_address(sg));
> +               cet->t_src[i].addr =3D sun8i_ce_desc_addr(ce, sg_dma_addr=
ess(sg));
>                 todo =3D min(len, sg_dma_len(sg));
>                 cet->t_src[i].len =3D cpu_to_le32(todo / 4);
>                 len -=3D todo;
> @@ -414,7 +414,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, v=
oid *breq)
>                 goto theend;
>         }
>         addr_res =3D dma_map_single(ce->dev, result, digestsize, DMA_FROM=
_DEVICE);
> -       cet->t_dst[0].addr =3D cpu_to_le32(addr_res);
> +       cet->t_dst[0].addr =3D sun8i_ce_desc_addr(ce, addr_res);
>         cet->t_dst[0].len =3D cpu_to_le32(digestsize / 4);
>         if (dma_mapping_error(ce->dev, addr_res)) {
>                 dev_err(ce->dev, "DMA map dest\n");
> @@ -445,7 +445,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, v=
oid *breq)
>         }
>
>         addr_pad =3D dma_map_single(ce->dev, buf, j * 4, DMA_TO_DEVICE);
> -       cet->t_src[i].addr =3D cpu_to_le32(addr_pad);
> +       cet->t_src[i].addr =3D sun8i_ce_desc_addr(ce, addr_pad);
>         cet->t_src[i].len =3D cpu_to_le32(j);
>         if (dma_mapping_error(ce->dev, addr_pad)) {
>                 dev_err(ce->dev, "DMA error on padding SG\n");
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c b/drivers/=
crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> index 80815379f6fc5..f030167f95945 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> @@ -132,10 +132,10 @@ int sun8i_ce_prng_generate(struct crypto_rng *tfm, =
const u8 *src,
>         cet->t_sym_ctl =3D cpu_to_le32(sym);
>         cet->t_asym_ctl =3D 0;
>
> -       cet->t_key =3D cpu_to_le32(dma_iv);
> -       cet->t_iv =3D cpu_to_le32(dma_iv);
> +       cet->t_key =3D sun8i_ce_desc_addr(ce, dma_iv);
> +       cet->t_iv =3D sun8i_ce_desc_addr(ce, dma_iv);
>
> -       cet->t_dst[0].addr =3D cpu_to_le32(dma_dst);
> +       cet->t_dst[0].addr =3D sun8i_ce_desc_addr(ce, dma_dst);
>         cet->t_dst[0].len =3D cpu_to_le32(todo / 4);
>         ce->chanlist[flow].timeout =3D 2000;
>
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c b/drivers/=
crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
> index 9c35f2a83eda8..465c1c512eb85 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
> @@ -77,7 +77,7 @@ static int sun8i_ce_trng_read(struct hwrng *rng, void *=
data, size_t max, bool wa
>         cet->t_sym_ctl =3D 0;
>         cet->t_asym_ctl =3D 0;
>
> -       cet->t_dst[0].addr =3D cpu_to_le32(dma_dst);
> +       cet->t_dst[0].addr =3D sun8i_ce_desc_addr(ce, dma_dst);
>         cet->t_dst[0].len =3D cpu_to_le32(todo / 4);
>         ce->chanlist[flow].timeout =3D todo;
>
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypt=
o/allwinner/sun8i-ce/sun8i-ce.h
> index 93d4985def87a..8fa58f3bb7f86 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
> @@ -149,6 +149,7 @@ struct ce_variant {
>         bool hash_t_dlen_in_bits;
>         bool prng_t_dlen_in_bytes;
>         bool trng_t_dlen_in_bytes;
> +       bool needs_word_addresses;
>         struct ce_clock ce_clks[CE_MAX_CLOCKS];
>         int esr;
>         unsigned char prng;
> @@ -241,6 +242,15 @@ struct sun8i_ce_dev {
>  #endif
>  };
>
> +static inline __le32 sun8i_ce_desc_addr(struct sun8i_ce_dev *dev,
> +                                       dma_addr_t addr)
> +{
> +       if (dev->variant->needs_word_addresses)
> +               return cpu_to_le32(addr / 4);
> +
> +       return cpu_to_le32(addr);
> +}
> +
>  /*
>   * struct sun8i_cipher_req_ctx - context for a skcipher request
>   * @op_dir:            direction (encrypt vs decrypt) for this request
> --
> 2.39.4
>
