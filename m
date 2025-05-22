Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B242857DC;
	Thu, 22 May 2025 10:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747908502; cv=none; b=PpQEwYbUG3Wr8vdPA+3lByAwLH4ieqLt5ITRBZvp/JcMFcxqHiotT8bKnPXAc/HF8s+yFzWSsOPXebrPwIo8gg4m4pGBfytScaC1EAWYjRAjenj79YO3hR5bPk7wxPXnZfWVTpinIxvlDxQeKjTeCRWecFtTsUVZdS0aSHdHInY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747908502; c=relaxed/simple;
	bh=AsDzyl49LK629MmRklC5I4eoPWBY9T1tNQJDljXq6Tk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IpBGXDuH25VEnuPQh5onggcqCbYf+FU/zLGXa/GOJ/zuBYhO7vToafwLun5ELuy+Be/fAPhFBOrZdu9mEMAU++x96Rg1MOCvLQ8qa5krkJz4w6qdoruqJ1zQpZBeqIGE/AnLS+IFgE2j7RelacF/Q5osYwzVzLUJaPxApAtFr4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HmFGi1G/; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HmFGi1G/"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e740a09eb00so6925166276.0;
        Thu, 22 May 2025 03:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747908500; x=1748513300; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+ekVzBJjiUUVKOSvdTf3XQZFnehy6dFyVQdqspB96E=;
        b=HmFGi1G/A0GNN1x6RZrWcz9qdTew4hXZbAaj94Sbhe8Mq7wWhYjbw5lxgqGKtEP50q
         P5MBR8ZR0+kg9b28yKtfgvslHFJgGn1YsDc1Wdi0VhAlFhpV3hdxjd3l5T0CgyYvMVaL
         vy18F5M4itCP1x9KB8VXSUa3RETxMX1xcdOSurtoE5okIOIoRyz565gGxbJCAtNahoHp
         YVWEJkeEvZjKXvN5TdmSFj64irXZff9hT4VBYo5154uuAL2mVvZfEiTZRcE3917BDZ90
         I47P42Y3+VqHhgA47kxpJnWB84CM/YjszzK2xNM3W4P/9/6xIA24AUQTqbCgcqtYCtHy
         OMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747908500; x=1748513300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+ekVzBJjiUUVKOSvdTf3XQZFnehy6dFyVQdqspB96E=;
        b=lx4l8SnRVIa3PGIevlXxjgaQzErBscrDF5tV/ORs4OgCsWYG0J8t4+4JpiFUZ0wElG
         e5tDP5jVvT19Pf4gh3Ew0+ktwB0glboYR9mknQRfUtKx6/30a+NP2k6aUgZ4y9N6MyO5
         2/NoQ+iVcRjABeVTI7v1bydTFUKxeCrNFHomPhmIDNHEzHTYutUQSWHVBGepz8DiTPTD
         0A8kRsueXtnfmHCUkzsJfWOwoviXpXk4rOMxRXhKlOzPwlBnS5AtNjD4ubxHNuryayHt
         H4ed+xlVTyBEC8IUIjbLHZA9GjA3S84LdFkJcu0VUcSP2yDjMkK/5fH6ljuODXOyU1ks
         o4Aw==
X-Forwarded-Encrypted: i=1; AJvYcCUVDBTxH6blpAJ8OiaTEdPu7mzsa9Hkj+fKtIrCMbeH2n5hfPunSos/x1yJcZyDVhqkvQ8zSg+VbCSOX9k=@vger.kernel.org, AJvYcCVni8pqXZ6VtfhUvZ/jyh0kT60HPUYgMgnp01B+IH6z7V4wCk6PW6Jvg4VFicMg4aEfIZdZNzJWdch9Ssd8@vger.kernel.org, AJvYcCWbeTeMX9M7dfA3x2U6YvnR6m8eybjtYIkYLEHfQ82TAfSqNBNKPONkdfD7TvpcGvtlmbWfHWXv@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb3JFNZGPp7nuftZgEQgvfWBRkkLxhREBv8GPjr9ec+89RnLRF
	woGK0aAQzo6rS69eKwf5nHhWlTelq/bxIrU/LY6qaZbjvtqF1Sjle3RFiMioYWc2q0sPejNUlfE
	LMQxKmM+S/aAWbdh11xm8G3K5H6QLbUw=
X-Gm-Gg: ASbGnct1lsysn/4kBoKG9T0My3+Xsi0wmpLEluZg2n9wrXWe02igftyy3Ciu/xnPwXB
	uOqy8shLzxBKDwXv027yNgUxhaOm9N9zkKILXcDGGazuH9yCLH+TnTryDzYem6iA+cxgSzsqNtG
	0wFaViiT2qXejWmbymxhh2pFuFi7dhraGG
X-Google-Smtp-Source: AGHT+IFkLoMJ1W0sbpI/K9v0M/MWV+36N3rfaHzGPKsXVp/Y7TE6hM8ko1y1I3d8GfWS6EwCQP05jJt8knmWz+KK4JY=
X-Received: by 2002:a05:6902:2290:b0:e7d:600c:dd39 with SMTP id
 3f1490d57ef6-e7d600ce014mr5736241276.19.1747908499816; Thu, 22 May 2025
 03:08:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250521100447.94421-1-bbhushan2@marvell.com> <20250521100447.94421-4-bbhushan2@marvell.com>
 <aC2406qOlaI17_f3@gondor.apana.org.au>
In-Reply-To: <aC2406qOlaI17_f3@gondor.apana.org.au>
From: Bharat Bhushan <bharatb.linux@gmail.com>
Date: Thu, 22 May 2025 15:38:08 +0530
X-Gm-Features: AX0GCFssFL6oJgfjgRymvpi41c5m1fHTzYicNAQL3OlyUme3fr3SGEa8EPrH6SE
Message-ID: <CAAeCc_kxhT-JHn+U2BNeh2E+DNukMXWfypW+-D_x5f1OcZ9Hmw@mail.gmail.com>
Subject: Re: [PATCH 3/4 v3] crypto: octeontx2: Fix address alignment on CN10K
 A0/A1 and OcteonTX2
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bharat Bhushan <bbhushan2@marvell.com>, bbrezillon@kernel.org, schalla@marvell.com, 
	davem@davemloft.net, giovanni.cabiddu@intel.com, linux@treblig.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2025 at 4:58=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Wed, May 21, 2025 at 03:34:46PM +0530, Bharat Bhushan wrote:
> >
> > @@ -429,22 +431,51 @@ otx2_sg_info_create(struct pci_dev *pdev, struct =
otx2_cpt_req_info *req,
> >               return NULL;
> >       }
> >
> > -     g_sz_bytes =3D ((req->in_cnt + 3) / 4) *
> > -                   sizeof(struct otx2_cpt_sglist_component);
> > -     s_sz_bytes =3D ((req->out_cnt + 3) / 4) *
> > -                   sizeof(struct otx2_cpt_sglist_component);
> > +     /* Allocate memory to meet below alignment requirement:
> > +      *  ----------------------------------
> > +      * |    struct otx2_cpt_inst_info     |
> > +      * |    (No alignment required)       |
> > +      * |     -----------------------------|
> > +      * |    | padding for 8B alignment    |
> > +      * |----------------------------------|
>
> This should be updated to show that everything following this
> is on an 128-byte boundary.
>
> > +      * |    SG List Gather/Input memory   |
> > +      * |    Length =3D multiple of 32Bytes  |
> > +      * |    Alignment =3D 8Byte             |
> > +      * |----------------------------------|
> > +      * |    SG List Scatter/Output memory |
> > +      * |    Length =3D multiple of 32Bytes  |
> > +      * |    Alignment =3D 8Byte             |
> > +      * |    (padding for below alignment) |
> > +      * |     -----------------------------|
> > +      * |    | padding for 32B alignment   |
> > +      * |----------------------------------|
> > +      * |    Result response memory        |
> > +      *  ----------------------------------
> > +      */
> >
> > -     dlen =3D g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
> > -     align_dlen =3D ALIGN(dlen, align);
> > -     info_len =3D ALIGN(sizeof(*info), align);
> > -     total_mem_len =3D align_dlen + info_len + sizeof(union otx2_cpt_r=
es_s);
> > +     info_len =3D sizeof(*info);
> > +
> > +     g_len =3D ((req->in_cnt + 3) / 4) *
> > +              sizeof(struct otx2_cpt_sglist_component);
> > +     s_len =3D ((req->out_cnt + 3) / 4) *
> > +              sizeof(struct otx2_cpt_sglist_component);
> > +
> > +     dlen =3D g_len + s_len + SG_LIST_HDR_SIZE;
> > +
> > +     /* Allocate extra memory for SG and response address alignment */
> > +     total_mem_len =3D ALIGN(info_len, ARCH_DMA_MINALIGN) + dlen;
> > +     total_mem_len =3D ALIGN(total_mem_len, OTX2_CPT_DPTR_RPTR_ALIGN);
> > +     total_mem_len +=3D (OTX2_CPT_RES_ADDR_ALIGN - 1) &
> > +                       ~(OTX2_CPT_DPTR_RPTR_ALIGN - 1);
> > +     total_mem_len +=3D sizeof(union otx2_cpt_res_s);
>
> This calculation is wrong again.  It should be:
>
>         total_mem_len =3D ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN);
>         total_mem_len +=3D (ARCH_DMA_MINALIGN - 1) &
>                          ~(OTX2_CPT_DPTR_RPTR_ALIGN - 1);
>         total_mem_len +=3D ALIGN(dlen, OTX2_CPT_RES_ADDR_ALIGN);
>         total_mem_len +=3D sizeof(union otx2_cpt_res_s);
>
> Remember ALIGN may not actually give you extra memory.  So if you
> need to add memory for alignment padding, you will need to do it
> by hand.

Will do changes as proposed above, Thanks for reviewing.

Thanks
-Bharat

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
