Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF8934388E
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 22:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079479; cv=pass; b=FJAn2oH4OhQHR5P3q+unfalxtfNZUmi0nzDO+YBok3rQG8FrnR9/Ip9BMV3MCCveCbBz/t4q7mRwOeSjF0MB6fyW5hyrgT77AWPukw2jblwJMXs5ph1dJTx3JseGVdukH/npNpcTRRRmhuqJkzfPKeF5lGOqWJR9elSnU8DZVaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079479; c=relaxed/simple;
	bh=mqkdWXOaH7nmkon+ND3yeEXHqdrXFJ4EUiqvK2I9fBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uygLl9Yotmoa7cN6h+SjHm91Yd3iLGTYz8OF33LJB5EGm7M3f8+2dbXRzVpB75U7lV0I9ldDN6DkXhDoLF332nY8c3xHkO6xQ/kiNHi6frgJZz4CXdUcbLiNkhOmuAP4UNG4woy3iQcCI9A8TUHi6Al2y2Nh9BUhdhjoJzv5SQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=RPshzASx; arc=pass smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="RPshzASx"
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALVBkH3848706
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 15:31:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=Xyns3w1s5BnPWLiZe/VHaLNYj68K+2MXvTrvc
	ya5Tcs=; b=RPshzASxcfHSqEkDfY2qvyQ9KR11JtMXcK7g8OZY2oqZbw/2cz/Qj
	yv/kFiCFZTJDoilGMoDqeMiqMhDefhjzp8Sg7i5GvuAA7gMC8S2CLvT9zW6eYi/c
	n7WC9dptKGY2NamqnmsTjzu30Tfuh0mpIHQIP2UHMJ7tD/9VeUUqTB4HmQza2Njq
	0oTIwPr8oSKFSF9Fa5McA1kgFtzy/5Q6K9pdHyYg3bxO6cXd/hMU/Vlkh/pfvP6p
	XxRo1hC4mMRhJRaHYWzNp0wOuMpc2VkJpn07itXEejPKVfl5XWq2Wa71oZFHrdpe
	JeeuQ0H0F66PoQt0UJ51mLUh3fYdOIoag==
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gkcyet85s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 15:31:14 -0700 (PDT)
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49d0ae342b9so2217115e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 15:31:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789079473; cv=none;
        d=google.com; s=arc-20260327;
        b=jtFHrajvCoWVPIK4MjSj8LxvRANjFey1JvnGUvfq6WLVpauOsq3b+lSdpXiHnEGtNt
         oqI9Akn9bOToifmYv9Itmb8noieYxlCpFi6waga2CXEKgoZukup2VdLeyaJtArCRDxlB
         sblToYz6K1qEBzJ2lPoVm5Ac/2ks65v+yB1/ahhxTSbfXWISudSZ94szJHXBjGHKcaoy
         ymtiDjFyZ094l9CqJEI7MrPJJVYQU60+C3Vb9wG9NGikULrJk3G+vzkOyKIsHN8pC0bE
         HY2/EVwgaYciS1GKrP7Kj0Szk7MR44SXxu9EprgsCjXHQzRr84fPOBc1z5QwokWPEvNc
         xNog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=Xyns3w1s5BnPWLiZe/VHaLNYj68K+2MXvTrvcya5Tcs=;
        fh=oqTerlA2ojIqtLR4fVn+cAMzBMvHT3ZYVCumPirHjDw=;
        b=XNbkcylORoybRb0XfgE3NzKj7V7enYZNcJZUmsHTQKGqnHLdnP1+11cIeAWEg555+p
         ztqvRz7qj1Wtzda/ooeBvs7c/pxe5ps8oY2IALL59Jl1J0VoBWEeKGXsghqgVElEwdTz
         vNBtJOXyN9JsYnifcm3HzVq/0re9AVIFUKvyjw7UnlHI2p7UTedh7boU3jLC6caS6pNG
         eO0iNxYN5JTt6k2cyjtHSULtAdhrvJgL1S25NIcXTymI5qlwxQCBr83fw0/kOCV2imlN
         J+kLYnh5rcDL7V6NFZoYq4UESIwZXjs9Lweg/5JqshkSZdLMPL1ngjQk4+v/8QRlFBAi
         TsRQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789079473; x=1789684273;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xyns3w1s5BnPWLiZe/VHaLNYj68K+2MXvTrvcya5Tcs=;
        b=sRGJPbc2uPaML080uZ65zWUopPV0dQOeqWs4DKNDLtFjxB8cTuK0JtjiYfwVmJeJRy
         LPRuv072VyQkdAu0nn6mmlOkSSWiTJzcK/Dhh2FT4zA0okmTMBgFENZZvpxdgwPOnqve
         fKt8aFMGyLZ5MG22mOWeCm0/AMZTA+7c+CVUol7nWNl+hfhJEqI/9gGfNegacQHrMYHp
         BGTG32IiTBQQdnDDaPVz0pxCZo7STfqugZ62Mcx/9MGOw8RK2CiN2JajIV95CLQVezoq
         K2dWiZfWftpVGCVlX3gN+nhisiWIxPRRBG8tAEACoCt+rSsEUeZDjSg08MEAET080X5s
         Ai9A==
X-Forwarded-Encrypted: i=1; AKwUvBz46ol8bmygj6lUKjVfvqH3Hlrk7F+HXwVnP67JCbvGh1HKXYTcjxSQzDhfZQyw6wAyo6v8T/VtACA1vrs=@vger.kernel.org
X-Gm-Message-State: AFuF++lI6E7pIQ5opLK1n3DwTMdVEOGj3NH234Hsm9HSF+4oI+nVUP/f
	tjtVGuLoMQusNxxacuY+dS9v7AJV15n8losd+g6MUS/czsJxcpjuGnJiOESC/mh2AUKyTMbotv+
	FSfCEkn9cPoRRR02yO2EQq4247J12rsASEpTQzRqkPhRFHb1GXVsm2kZgh3KHOc3+xXucqj/Bq+
	yFCZKLgyeUu55swG/IT77KvD9ApzcTAodhP+frxbQ=
X-Gm-Gg: AYBFou0Bo9NTy+9ekO/f6jMAbn1fjRPqB1B9KxgA+FssBsLW4MoscLzcugDR/QGVera
	TP2xsVP/LMr44+sK+LlHQ+nTyIB3U3FHY4pU4s05jwwxxAuQxgh3Gw2dpGXWWG5dslJ0Z1UjHI+
	WCair42NOrae2PAi0a/WxNY9dlzr7o0u8ZR3efrwyRj8i8fq3o350X4ErWHA==
X-Received: by 2002:a05:600c:3513:b0:49c:fc6e:a3d2 with SMTP id 5b1f17b1804b1-49e619bfdc8mr12376105e9.17.1789079472869;
        Thu, 10 Sep 2026 15:31:12 -0700 (PDT)
X-Received: by 2002:a05:600c:3513:b0:49c:fc6e:a3d2 with SMTP id
 5b1f17b1804b1-49e619bfdc8mr12375835e9.17.1789079472575; Thu, 10 Sep 2026
 15:31:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260825220616.3842633-1-usama.arif@linux.dev> <20260908153715.3063790-1-usama.arif@linux.dev>
In-Reply-To: <20260908153715.3063790-1-usama.arif@linux.dev>
From: Nick Terrell <terrelln@meta.com>
Date: Thu, 10 Sep 2026 18:30:59 -0400
X-Gm-Features: AcwNN1Xvy4hCdQWDoJBuTqwETdZ28QWr_8dT9gnVleiBuTga15NCigx00hGAtSc
Message-ID: <CA+BOzqre9-EjDZcMEa0m64p6dNks0_FO4u5Z6bHpUovkT9U92Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] crypto: zstd - avoid initializing the workspace twice
To: Usama Arif <usama.arif@linux.dev>
Cc: davem@davemloft.net, dsterba@suse.com,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, terrelln@fb.com, cyan@meta.com,
        hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
        chengming.zhou@linux.dev, shakeel.butt@linux.dev, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: -sK6xP8AsSGpjGqvEjlFN1CdY6xNmpT0
X-Proofpoint-ORIG-GUID: -sK6xP8AsSGpjGqvEjlFN1CdY6xNmpT0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDI4MyBTYWx0ZWRfX/BpHYvqnrdJd
 PpZTQ+F9Lxzb5YGSrQ58X+2z0Djeds17E0oYJrlIY/lRBKfutiEXwAcW0Kkxxnms/O0xCmnoTNY
 EwYMmyb3fPZOCZ0ETrOQMvpp3BWIB0dCnPg/zIalsZR+H/KwTXM8Q2A8+MqHCmUF9UXrR7o+4Yg
 pTGZQO2bmY8Xaud1/Q/z7UYR+aVD154rz2IjY73pqtFo7sBqb5R0SEcenHuY7GDUarYBevtU7Ph
 W+XmLytQwIT0jJNiwh8XmhusZGuSH7FnQwQpChxvYxFL7z9S6EHPGb3pmedsDO7Q6GlbxT36Nmm
 wK61xBUvugmRkColKxMzOEifQ8V3Gqy7dlVqFDcjWJilL20o/5B+7+pAWK8fPbbSD8D4KMqSZAN
 oFcVpXpc+De02R1WnellyL+6x6snXesSEU4MMBH6jlQoGk1gE4FryTyArxy9krAQFtfyzcwdsFN
 DGbjvppomlNXtpROjSg==
X-Authority-Analysis: v=2.4 cv=B+0sQ+tM c=1 sm=1 tr=0 ts=6aa32fb2 cx=c_pps
 a=Q4jRaax7EcWM5fECTC1wcQ==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=jCddH8ec0KUNCymVuxII:22
 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=FAvacPIE_xOtX3pQF60A:9 a=QEXdDO2ut3YA:10
 a=nJq5_VNI1X7IEIKzvdHs:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDI4MyBTYWx0ZWRfX/AWSBJEE1khY
 bOSOGcp72j07FugeQ+jVXg2AhoDnkeuv0bC43lmMNHkXIlSxd7h3kdfb/nylT39RBmnU/dcUiKi
 LjEDVoPdN29LMMVZaiLHKj7zfn4LB3g=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01

On Tue, Sep 8, 2026 at 11:39=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
> On Tue, 25 Aug 2026 15:06:00 -0700 Usama Arif <usama.arif@linux.dev> wrot=
e:
>
> > Both zstd_compress() and zstd_decompress() set up the shared per-CPU
> > workspace as a C/DStream before walking the request, and then, when the
> > first source and destination fragments each span the whole request, han=
d
> > off to zstd_compress_one()/zstd_decompress_one(), which immediately
> > overwrite that same ctx->wksp with a CCtx/DCtx. The stream setup is
> > discarded without a byte having been processed.
> >
> > That one-shot path is not a corner case: zswap always takes it when
> > storing, and takes it for a load whenever the stored object lies within=
 a
> > single zsmalloc page.
> >
> > These two patches defer the stream initialization to the first walk
> > iteration that actually streams, guarded by a flag because that iterati=
on
> > can be reached more than once.
> >
> > A 4 KiB crypto_acomp benchmark [1], twelve runs of nine 30,000-operatio=
n
> > rounds. Bare metal is an Intel Xeon Platinum 8321HC, turbo off,
> > performance governor, pinned to one core; the VM is a one-vCPU KVM gues=
t
> > on a faster host.
> >
> >                   baseline    patched     delta
> >   bare metal
> >     compress      52,283 ns   51,038 ns   1,245 ns   2.4%
> >     decompress     2,317 ns    1,998 ns     319 ns  13.8%
> >   one-vCPU KVM
> >     compress      16,675 ns   15,050 ns   1,625 ns   9.8%
> >     decompress     3,516 ns    2,265 ns   1,251 ns  35.6%
> >
> > The guest numbers are larger because the two CPUID instructions in
> > ZSTD_cpuid() become unconditional VM exits there.
> >
> > [1] https://gist.github.com/uarif1/5cf02f0e22c23f0d1b3d84348f12914c
>
> Hi,
>
> Just wanted to check if there was any feedback or review of the series.
>
> I think its a nice optimization and even with the CPUID instructions
> getting cached [1], this is still needed. The improvement in baremetal
> is not coming (just) from CPUID instructions.

Agreed, this optimization makes sense to me as well.

> [1] https://lore.kernel.org/all/20260901110850.1805747-1-usama.arif@linux=
.dev/
>
> Thanks,
> Usama
