Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074DA1D90C8;
	Tue, 20 May 2025 04:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747715676; cv=none; b=A6lR05RWfBB9N7qF4CQiiuTqz83oLt8CgavrjV5z8T6Re6xGx7NzQsU1qS2zw2fwvMBXhvoAAmAAGReNPEOp2DvFje0IGB3mN2nMZXpnh0pIUehs4ss0r1APQvlIQcWPTl4JS2XTwSGRQqk/JtNuH8fOBYgU+E7e3Ezw0mtDd4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747715676; c=relaxed/simple;
	bh=yeGc+XD0k3LZ9UJmhqDSts9L4n+Fozk4dj67vHp5imw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AIf3G8WhWmaOD5TO6rqZb/z/19uAkYCRgrInI1fFoaLeANVnY1YhkoCF3vmS8CPRhDHs4FAhGaQXR4xF3XnY92f1hNlwaFNfmW8233vBSB+IklbhgM/GW3UpRtLeX0Cp6WpH6E+pgoBHl7WaH3bVAymNzWxHmH3Iz/uuBKOdJRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GAfjpNUA; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GAfjpNUA"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e75668006b9so5370830276.3;
        Mon, 19 May 2025 21:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747715673; x=1748320473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KLdIEO3JhzFK3+pAV0v9OMiBG9saZVl50Zc3M7eZWJs=;
        b=GAfjpNUA4VlvtaABDYx7D+bhiFosaXy3CWuMtv1O3coE2UNNb2ik74OIj0fN8+HngO
         DgmjS36LwO/Cv+urjx8djQWuiOHa/Cd3NA8COyTaih62C9X0TEE7YxueThzLnOqAhEsv
         XuPEttmuwsL6tKr8MCXSPpHkrirQtD40GGZy3SHYJSAly1nyBDQjaDFrhiqM/OtfWLDl
         oXuFDkQ2o3j5e5q0hg2o2HLDjuPJe7Hco8OWOIHnf5/uowbEPTs6OqNOBXchXbxrMwNA
         asrDAqaj18LeS5r29dfF5Baxu/1d4JETszqixOY2t+9FBMCXUXBA0gbL1UwuDc1xQ9iJ
         ZVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747715673; x=1748320473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KLdIEO3JhzFK3+pAV0v9OMiBG9saZVl50Zc3M7eZWJs=;
        b=ra6Hdx2zqxLz4XULf1xjNlXFbeDcg7sBa99bDUkf7139SCD0IMvi4hVqKgqnFkD+s3
         0aXgQ8M1brR7SKZavh6WORzT1QmNl5hsm+fsi10lNkwXCz/9gQCXlwyThMJg0h3YuDl2
         bC/20Q/+73MUT88/b+FAPOszOgSBKs+5wYQZ9Vju4AMG8UIlxyUp3Vd56/QHPhw+ur1f
         zkB17xrsfFS25jd/bo6fA6CdXH4SBAJLPARO+GG19ThH8YpuLnYvbCUjszXbwyxcU6El
         82La4iRR1QJ7FqN4ZH9MAjmZtOfqJbHQHHPdKdG3Pgb6XTzTQHu9n2bxiyTVm8pM98a8
         Gb+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTPOn772RCoABF4LURdhswz7PoUbpQVqs0ASuQHe507S/17jCNlhIPy9R1bPsNjPyRLX94jwKUPsmFR34M@vger.kernel.org, AJvYcCWTr2Zn5EoyCRNq1CbCklaS3Ye8VfD3uq9397wnhFwItmAT79/O+7U66nNhgaUVFmG+OqZXYrGVcjd3D/w=@vger.kernel.org, AJvYcCXY0dvTSo/ZgjvDCi5PdGjMHc2/3WqTFbqHac9UqAlnU1jJhz9fR2SSzeNQA/NzBHVHSV+WRVaB@vger.kernel.org
X-Gm-Message-State: AOJu0YxQpLnzvK/dzEvzhc4J5qOXHBnE9XN1e8oywqw5zkoA3hYXiJyN
	iXHwaAwBfpKYrW7+Z+WJ7cdDQ7RUtTtr1N3oviP75WrSv/ZOoAv0NTIhQWa/HH0H6VAFAXtWP6d
	mA6MfX/8BYn+E7MCtgRqO0TQIoxzGBzYLEA==
X-Gm-Gg: ASbGncvmY79vqogWbNcJvKsHQvRX5C53NeNahKSJ7pRZj4R/Z8pxIkbQP5RBVLqQXlf
	AVDtwK6yc0K/9ifnZTBYa3V7gYhDzpYtVHgeCjpjS3R0wi6u8mseJnL9/wUTretM07QjKHEwJF3
	U28FAKo5R2+1PlkE0WtnrbOgqg6+W8ecgX
X-Google-Smtp-Source: AGHT+IEx2HdcWVTUVwOuMeLPDKj8IZNpw5yYGNZx9DYx4yEeiOH/kPUiA83A02WG77XaxTg5xkdkMHTDx7HxMU2ZtyE=
X-Received: by 2002:a05:6902:478e:b0:e7b:8add:805d with SMTP id
 3f1490d57ef6-e7b8add8192mr13175077276.46.1747715672859; Mon, 19 May 2025
 21:34:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250514051043.3178659-1-bbhushan2@marvell.com>
 <20250514051043.3178659-4-bbhushan2@marvell.com> <aCqzAQH06FAoYpYO@gondor.apana.org.au>
 <CAAeCc_=QShbySa8x9zU+QnDqn1SLK3JLXMD8RYNoax+gh3NVEQ@mail.gmail.com> <aCrfNdnRzlQSr6sy@gondor.apana.org.au>
In-Reply-To: <aCrfNdnRzlQSr6sy@gondor.apana.org.au>
From: Bharat Bhushan <bharatb.linux@gmail.com>
Date: Tue, 20 May 2025 10:04:21 +0530
X-Gm-Features: AX0GCFs8BgWCUV4foeRy_615K0bqYt6Ee4N9DJIR-VtGMkL2q1NFBzBtrDbDkDI
Message-ID: <CAAeCc_mKDq2jSM+yZ816nx_BPsFSWiCjEswfuu9HBzXrv+V+WQ@mail.gmail.com>
Subject: Re: [PATCH 3/4 RESEND] crypto: octeontx2: Fix address alignment on
 CN10K A0/A1 and OcteonTX2
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bharat Bhushan <bbhushan2@marvell.com>, bbrezillon@kernel.org, arno@natisbad.org, 
	schalla@marvell.com, davem@davemloft.net, giovanni.cabiddu@intel.com, 
	linux@treblig.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2025 at 1:05=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Mon, May 19, 2025 at 11:47:18AM +0530, Bharat Bhushan wrote:
> >
> > > > +     /* Allocate extra memory for SG and response address alignmen=
t */
> > > > +     total_mem_len =3D ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN) +=
 dlen;
> >
> > This add extra memory for 8-byte (OTX2_CPT_DPTR_RPTR_ALIGN) alignment
> >
> > > > +     total_mem_len =3D ALIGN(total_mem_len, OTX2_CPT_RES_ADDR_ALIG=
N) +
> > > > +                      sizeof(union otx2_cpt_res_s);
> >
> > This add extra memory for 32-byte (OTX2_CPT_RES_ADDR_ALIGN))
> > In case not observed,  OTX2_CPT_RES_ADDR_ALIGN is not the same as
> > OTX2_CPT_DPTR_RPTR_ALIGN.
>
> But it doesn't do that.  Look, assume that total_mem_len is 64,
> then ALIGN(64, 32) will still be 64.  You're not adding any extra
> space for the alignment padding.
>
> OTOH, kmalloc can return something that has a page offset of 8,
> and you will need 24 extra bytes in your structure to make it
> align at 32.
>
> Now of course if you're very lucky, and total_mem_len starts out
> at 8, then it would work but that's purely by chance.

Thanks for explaining, will change in the next version.

Thanks
-Bharat

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
