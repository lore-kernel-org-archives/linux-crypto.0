Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA2279CF;
	Wed, 21 May 2025 05:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747805877; cv=none; b=gfqx+0HDfGR/Msi43F7RLaGce4F6W43jY+l11ujSxMznya60BnlzhKsJkF6RpdWa9OGku+TXrmjDQvPZP9ecuTBEMOj392gf3lG65RYMPXtNCsD7nbV1Vl2qDEqyWdbwhYRvs13zmbkeXq2p18GR7GlGnvC+0WsPq+BKqYT2rO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747805877; c=relaxed/simple;
	bh=3lw/6ZmeRXC/eWpLMtwZ364acTLZd+iqqodrLc9oIss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XBc3rxIIHSD1D/xXHqV3fwCGMEVzrmCJFYkyvUiR9+5JtSEPQf1K05q1c1SNMkmj18aRRSpjfbcYuovuZVBmUbkyEZN6YZEyuodn0+D+MEH9+kHJl75i6WVTfENU1XqZHwHV2t0k8xw3wM8YP2QLO7kGfSRnZC8hQiavFGZfW1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VcENZlUn; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VcENZlUn"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e7d5ca0b71fso277900276.1;
        Tue, 20 May 2025 22:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747805875; x=1748410675; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wJi8Uhh+lzqIKZME4Ze4Y4J96yIckW6rCj2gYlAVdq8=;
        b=VcENZlUnY7LepxYG9b+VOSLwqJxC1US1Kf0Nq/7WxY6r6tBS6/sPAUYjSxzb0JgCRC
         Ba8N33Oa/+YM91ST9iUEq34IcqHEnXlJEFJ1aUMEPjnCBz85gd8rMq4XssHWlHZLeL1B
         jUiVUgumBVs+Fm8b3U+lCP+BTaGYzEpVjMuI9jqO9HJ/YjMMIyJXb9Hx78jEBLEm6Tt6
         rjf6PZd7MvvjVCpp8sOwXvqU/Lqli3csCRLkh6GNcn1se4NQOdLojgyMVgPqNXyuwknt
         abZKysXegmBAsW17hk8QzI/HGwITEZkPoBxe+bVIk6mEkRqbBuDvyxA/I5omYLUwnqmU
         Rzvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747805875; x=1748410675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wJi8Uhh+lzqIKZME4Ze4Y4J96yIckW6rCj2gYlAVdq8=;
        b=N8YrQqykmz5/eKNdYzM7sIeLeUdXHCszEK52fq9blnvOjwFCssZ1mLa8dnmflWJoi8
         yxdM6JIhJeZ5bezoox1yfGLsofcTYmSEaur4XybqgQEomvdv1mAG+etpM1PU/yKQlQC+
         TS5z49R0cg+rzbLZVtZzeA+cLyMVDtkDm4Uh3z6GgcTFCXg4F/ajy7boTCjX3dweC1sa
         V1C4nOOoSH5Az5sLP67j9TFr++6aBnc5D83gmVCz8mk0ZIGX6BU/4ttPf4uWxRyPsbJR
         hEEWhIBTBqD8BxPgazjSTckLoAoXkBquZerm5iwXAJ8dxY+6MhyZ7Ue/VUppoA3ZOmOj
         VdMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPE2r5Kasp0UjgTVxd7T8aB+MTzkGL1Q0R6/4XhooQR4s9msktQGwfC1J8wEVUYPdZk7dkZ4KAM6ZUaPI=@vger.kernel.org, AJvYcCWGSDdUgsTXugNlSu72ZDgCpRivKh1Gqgiq8ekOSKTfdLeX5cg/gW7zmrbc6yFNtQrhalTayAEsHfl2E1Nx@vger.kernel.org, AJvYcCXRCHv593sEPq2TyysdrCvq75zLQq/JyM3Glr4pfVAM4rO41EXX99S9oBtyundxd2obs7E3fE2U@vger.kernel.org
X-Gm-Message-State: AOJu0YxeJNs+hflOJRidRAA7wSb2PUIQ3Oi15+A6YZw6d8Ke9D4OTXXd
	x6PRD3WUobSdjBZFknuU9ge0pFzSCgtOxfDnRVgSyaVOX7mZpnolDNOy1UcxIJA5gaXqtD8pvT0
	4FxMb81oLaKWr1TDFi7U8MDHtZyxZBXE=
X-Gm-Gg: ASbGncvOQJaLzUrvq+LQcoPmrkNO2IKUSVREB71w8IRTcpoSQC9uHHMKl9bKpl68odc
	VgElD8EE2CSo07edlAl6NpPB6HBZYyZjNT3jkgUXJJBQSPmG+DPMWWq1VKoTf/bq8CS1a6dodGB
	cVVDIqGC/FNKQWIk6tM7ED5a4vbdhpRlU=
X-Google-Smtp-Source: AGHT+IHG8nFmbbF5KqGD4r2dcJJXRBEpvP+aXS118vaPP+FX3tYHjvwmTsTPVWi+b7ZaeTKA9e4NtgZeCQBpPrtRMfE=
X-Received: by 2002:a05:6902:120b:b0:e7b:8256:ec80 with SMTP id
 3f1490d57ef6-e7b8256ed38mr21558528276.20.1747805875077; Tue, 20 May 2025
 22:37:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250520130737.4181994-1-bbhushan2@marvell.com>
 <20250520130737.4181994-3-bbhushan2@marvell.com> <aC0J8g6UYxSw_7zZ@gondor.apana.org.au>
In-Reply-To: <aC0J8g6UYxSw_7zZ@gondor.apana.org.au>
From: Bharat Bhushan <bharatb.linux@gmail.com>
Date: Wed, 21 May 2025 11:07:43 +0530
X-Gm-Features: AX0GCFvMCLodwcWAvmyb1AykHvfajITUZiZwSFFDvaTBZi1hS56YuDL_ebWQ5pg
Message-ID: <CAAeCc_nj1Sk_dAkasYNvwtJtUc1et3cveoTETh25RSojStqNDQ@mail.gmail.com>
Subject: Re: [PATCH 2/4 v2] crypto: octeontx2: Fix address alignment issue on
 ucode loading
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bharat Bhushan <bbhushan2@marvell.com>, bbrezillon@kernel.org, schalla@marvell.com, 
	davem@davemloft.net, giovanni.cabiddu@intel.com, linux@treblig.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2025 at 4:32=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Tue, May 20, 2025 at 06:37:35PM +0530, Bharat Bhushan wrote:
> >
> > @@ -1519,22 +1520,27 @@ int otx2_cpt_discover_eng_capabilities(struct o=
tx2_cptpf_dev *cptpf)
> >       if (ret)
> >               goto delete_grps;
> >
> > -     compl_rlen =3D ALIGN(sizeof(union otx2_cpt_res_s), OTX2_CPT_DMA_M=
INALIGN);
> > -     len =3D compl_rlen + LOADFVC_RLEN;
> > +     len =3D LOADFVC_RLEN + sizeof(union otx2_cpt_res_s) +
> > +            OTX2_CPT_RES_ADDR_ALIGN;
> >
> > -     result =3D kzalloc(len, GFP_KERNEL);
> > -     if (!result) {
> > +     rptr =3D kzalloc(len, GFP_KERNEL);
> > +     if (!rptr) {
> >               ret =3D -ENOMEM;
> >               goto lf_cleanup;
> >       }
> > -     rptr_baddr =3D dma_map_single(&pdev->dev, (void *)result, len,
> > +
> > +     rptr_baddr =3D dma_map_single(&pdev->dev, rptr, len,
> >                                   DMA_BIDIRECTIONAL);
>
> After this change rptr is still unaligned.  However, you appear
> to be doing bidirectional DMA to rptr, so it should be aligned
> to ARCH_DMA_MINALIGN or you risk corrupting the surrounding
> memory.

Yes, rptr was not aligned as ARCH_KMALLOC_MINALIGN and rptr alignment are s=
ame.
But as per the second part of the comment, rptr must be aligned to
ARCH_DMA_MINALIGN.
So will change total memory allocation and rptr and result_address
alignment accordingly.

Thanks
-Bharat
>
> Only TO_DEVICE DMA addresses can be unaligned.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
