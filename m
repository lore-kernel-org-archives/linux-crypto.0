Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBA318872A
	for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 01:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781400481; cv=pass; b=aqXUn4CzvbH6iQxTH4RdSz5v8Ng74j2xEfLG9s3aFwwyOO9Qz0GBKZKwr4sMIUH4cM9ZXBrHhtz0QYK2FPeuMyfH4xbVglg7FH+l0dNymZYnA2Mu9Jmhqnkl/WhKNHYnEuU41SkwRHu5SFsBIhKOjP14Hs+by7yYHbkFRwhgdTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781400481; c=relaxed/simple;
	bh=yl4s+tPGFoOT7z7AfBBTUvQULRtt7fX6k6jyT9pAyGE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C5bEYJ1r5yDznxkZ5PyvL89SIxqPL6E6558wFnbMMqcj2mv37W/KXckb+DHVeVtomER2hWFTbaJw7HOea1bwhQp2vCaNnCfRIEugrwzKP+xm260DxSyluZr4SuPhnxDmGT2i/9JzJ8XexxFkvxAawiq6WrBfpqatgtflHndvRk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6yn58NA; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6yn58NA"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bef1e6423e7so227902166b.1
        for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 18:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781400478; cv=none;
        d=google.com; s=arc-20240605;
        b=Rbb5v3bwl+xxuZ9VksNBwKHytBKFRQw8x2jVtQBMV2jGA4XXRzq5wyFtAIvK5WLGSU
         QBeQjgKkEmn9oiC9a6X2oOAHOFig20Qc7EVITaSnLmZjZt5B0fRbz8Iwxol6ZkIhGmeL
         OWFH7J28pgWEi5JmrtH64ozPqx1KaXd0lEv4G02LrFpWtQU4WHQAUAmjxyx9NCHTunw5
         J9wrLgJIFs8gy1pCR62JFOsC3AJFg15WTUpwiRFe3DOLwwTkFj0YN9sX/E+zUvVRtupO
         J/fEaHhTE5PtjqBNUVGCNMPORs+u0Rd6m6ID9x//3he3p1gf8MtKC+Jq1hmGMGVM9qe0
         zLOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jFIKs8j64KxCitzcKGd4Fty6LNszXbLrdt5aKTUJMaU=;
        fh=cFrSywvrO56GI0X7qV4M9Bi0Spv/g0V39ESd3dkxWuY=;
        b=Mhwk4TzhLbW3KRYdjB78O98gZ9M+Gqyr0EpFi0v3bextIJ4uk6ow9WfHc0vVKo3K5J
         Aw3lgSrHGWEZYm7qFK9Pc/8AwRw7+jHkoP0Gh9XjlW8ajfHcHw4BbcaJ7UuCm3xU7J8E
         1l5H22uzu62qd11/OcVkVqok6MOUOa+jxniRbZh7izNVU7LKFrOSZ+8J/Dpa7vJsrXVu
         U2txI7ItLYQQ57oesHqokEN3gmIMcLJFRzPL/WHFhyobu4UokZHhaezy4lW4O25vsEM9
         bKXzay/LW9ziXViWMvSLWRyrjQPm3p2TXXdIXNOvegcA/Cy6woXP6xfIaSEwEBZ3iTVA
         aB6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781400478; x=1782005278; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFIKs8j64KxCitzcKGd4Fty6LNszXbLrdt5aKTUJMaU=;
        b=L6yn58NAouqq0TSx7UJwh1tI4aD7+c/d9XArKiPPGHeDTXm/s7d/LFB5/1sFhiFyDX
         1S7XfumFSNLGjxFM3l0jxKSWUKxSHmP4wVgLvaD0uo5nC6snRzsbFt7Cqmv/WjS3eOaj
         CsvWKbmS66VJA3+9NNLSngb7cJAEAbHUA1o0s5lXJthP65YWTeWZVJ05iOeyaV5B8Kbo
         hpsIjzzl0aQusuttl+k3xUx4UeahnFZ4mCWSLwsJSc5xAgyHIUeH7yMMvI/JC2iqKAou
         BoAaWAXvwhr1hEHpL2kZLQgt2f/WLb4x172ZLXa7dfO6yahh1E0BrdQsQZRoN8ag4Cik
         1MEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781400478; x=1782005278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jFIKs8j64KxCitzcKGd4Fty6LNszXbLrdt5aKTUJMaU=;
        b=VSh8UfwbkMbTBm1g8s+ifW83G5A6bapDRUgCYSGluZEOTo8IEcHCEL0a2U1XXx2rOj
         oaUsb1Yflm86Mocle5/ujKo/bT00v6VI+pZzYR3Sf14fj76Z3b3Y9s1rs9blIREJKJQg
         eTkj6mT/VUpVAWH/XlvRuhJGAQ9Soww2nR+ll43cHAQNZkyZAmOthA2geZ/Zj2ddhvuK
         UiiPSCeKHv79hypF5dHBklHJkXz1e/d5VKmtBq8pS7eZ03mBaYRavHOLvMvvOP2CnwvF
         exVdpBHaUj7dtBGsxxHU4A8/kxo9vDmL5Uv3fDgm71kkY52ifzmaijO6/YSypK8aBJtY
         2dBw==
X-Gm-Message-State: AOJu0YwMHTNT5XvLk6wRT5WRv1lmJ74XnxmK5ZX6WTYKQYMvlPejzGHR
	LhEXvX0JGM9QRCvFK+m2Ea12KAuQxOVxTx+NIYuO1QncOhClUbvcVnhCowp6M5r8ekunfYdiKbT
	kgtE+t6Uv8NUcuHYNBuQ9MAPHUCegPLu4lQ==
X-Gm-Gg: Acq92OFJhQ0PRaGkl8k4eMtgLiRMUCnb8ZS/ub9ortIoWZseoyWFG4CWWzub3bbouKN
	uaMkKPDQVB8GghwmbICzphAt530mm9FYzUiIBkOBc+uf2+7bAAeXdUZu7KYLnWwewBNPuOD1BRZ
	VU3/dl4r5sOagxCBXGXE5FnKq9Q4fYJC8mqHO0YJuvKeK9Krp+feSlspSyyceDODFZAhRR+PHN6
	837bKE70h4OxJOv4df62KX/2StFkNYSPMRBChsnHNA9X/rpMcECDBtqSebXGf4ugH2RT2qqPvl8
	/E82aQco7aK/zPx0Uutpycb/NONpHdYQX4sJL/iwr6emhmphAb9ZY3rBs8JDUfBnowcsddvGHjK
	cspcLUvQTbYPXlh8m7h+OTRNksmxjco9D9dAl6fpfh+5OyD8Acez9aU4Zzw==
X-Received: by 2002:a17:906:847c:b0:bf0:1c43:bd22 with SMTP id
 a640c23a62f3a-bfe28e11607mr227070566b.19.1781400477978; Sat, 13 Jun 2026
 18:27:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260613234559.20934-1-rosenp@gmail.com>
In-Reply-To: <20260613234559.20934-1-rosenp@gmail.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Sat, 13 Jun 2026 18:27:46 -0700
X-Gm-Features: AVVi8Cfbl9zX-yBGxMemU9Axm1uuSXDuu1kxye3-S7veDj4mgGYIQSHxJs1eZKs
Message-ID: <CAKxU2N-e+rBjKKfko5UR2icG0w2wVigUXcxyGN1a3xRqzTdjxA@mail.gmail.com>
Subject: Re: [PATCH] crypto: amcc - embed pdr_uinfo as flexible array in crypto4xx_device
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 13, 2026 at 4:46=E2=80=AFPM Rosen Penev <rosenp@gmail.com> wrot=
e:
>
> No need to allocate and free separately.
On further review, it makes more sense to change to a static array.
>
> This keeps crypto4xx_destroy_pdr dedicated to dma freeing only.
>
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c | 12 +-----------
>  drivers/crypto/amcc/crypto4xx_core.h |  3 ++-
>  2 files changed, 3 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/c=
rypto4xx_core.c
> index 001da785af07..ea1e40b3184b 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.c
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -171,14 +171,6 @@ static u32 crypto4xx_build_pdr(struct crypto4xx_devi=
ce *dev)
>         if (!dev->pdr)
>                 return -ENOMEM;
>
> -       dev->pdr_uinfo =3D kzalloc_objs(struct pd_uinfo, PPC4XX_NUM_PD);
> -       if (!dev->pdr_uinfo) {
> -               dma_free_coherent(dev->core_dev->device,
> -                                 sizeof(struct ce_pd) * PPC4XX_NUM_PD,
> -                                 dev->pdr,
> -                                 dev->pdr_pa);
> -               return -ENOMEM;
> -       }
>         dev->shadow_sa_pool =3D dma_alloc_coherent(dev->core_dev->device,
>                                    sizeof(union shadow_sa_buf) * PPC4XX_N=
UM_PD,
>                                    &dev->shadow_sa_pool_pa,
> @@ -226,8 +218,6 @@ static void crypto4xx_destroy_pdr(struct crypto4xx_de=
vice *dev)
>                 dma_free_coherent(dev->core_dev->device,
>                         sizeof(struct sa_state_record) * PPC4XX_NUM_PD,
>                         dev->shadow_sr_pool, dev->shadow_sr_pool_pa);
> -
> -       kfree(dev->pdr_uinfo);
>  }
>
>  static u32 crypto4xx_get_pd_from_pdr_nolock(struct crypto4xx_device *dev=
)
> @@ -1247,7 +1237,7 @@ static int crypto4xx_probe(struct platform_device *=
ofdev)
>         dev_set_drvdata(dev, core_dev);
>         core_dev->ofdev =3D ofdev;
>         core_dev->dev =3D devm_kzalloc(
> -               &ofdev->dev, sizeof(struct crypto4xx_device), GFP_KERNEL)=
;
> +               &ofdev->dev, struct_size(core_dev->dev, pdr_uinfo, PPC4XX=
_NUM_PD), GFP_KERNEL);
>         if (!core_dev->dev)
>                 return -ENOMEM;
>
> diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/c=
rypto4xx_core.h
> index 66a95733c86d..bd4a286514a4 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.h
> +++ b/drivers/crypto/amcc/crypto4xx_core.h
> @@ -93,11 +93,12 @@ struct crypto4xx_device {
>         u32 gdr_head;
>         u32 sdr_tail;
>         u32 sdr_head;
> -       struct pd_uinfo *pdr_uinfo;
>         struct list_head alg_list;      /* List of algorithm supported
>                                         by this device */
>         struct ratelimit_state aead_ratelimit;
>         bool is_revb;
> +
> +       struct pd_uinfo pdr_uinfo[];
>  };
>
>  struct crypto4xx_core_device {
> --
> 2.54.0
>
