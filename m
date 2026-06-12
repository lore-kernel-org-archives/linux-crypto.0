Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3380C346791
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781273701; cv=pass; b=SdihgSoM2UbXUdKmxFzrJI+RcQXtkP6kLio5u8egi6in5l6BsxgSTMTMkhXbOkW8H/+91e2Hr9QxbWLze1etAp1Neo2MT69eR4UXw+hVqCbKZA7GD2E47wlVqqbYikwlcLZ/kF+Yu5qxzyEPb3/gyuFRedwFiOmkZx6ZhWlP5kk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781273701; c=relaxed/simple;
	bh=k+Npt9s9+aGG9eR21MoWbFSgCKZQrbuOiexH8GQUrc4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DXeJ2mbrSHaJKCakjOFwR/cYs850nJlgCbFQ8n4VtttGj7iJZBLlRz+3+ceJw3O/oFeKpP+YB+tJfvVTQuixNwuaaG5ngLQog5hmUJpAA/D9sbwgAp4aQlg5PmeiMHHrQgSA/ckIQThiTQ1iDo2HVA+YnT+9K6V/PmAIz71CVTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IkSE46QO; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IkSE46QO"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51778077b28so10626591cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 07:14:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781273697; cv=none;
        d=google.com; s=arc-20240605;
        b=MxzxLlXT1W0hA/qkvSTPr8JHbaPv+0f4BuxyhBNAvCvsjr2sYSlNsap0ZGyxQzHFmA
         GVVTDLTxh1ed7GxEUvSYAwSAcp9BciXXfqgFjMsh6PLE1t2gvSgbcgfRI/UEEQ0Dnryk
         6U/YwoaRTENr4RHVYFQejWRJrLVRa6m+XW3+Z74+GOeaNjyFDhmabECNHBVDI5YCeZRN
         SEEVtTZzqNKe6IBpcPr5UEYbqPYXLJBlFQrI6StEKeDpIcebqynU71YSaNQ1yOca3xZz
         bD3WLtDajcxSLAr0WUOQ4jWJy7Qu5R29qmGaWlZ+91SxssO2UHrzN9lJK5nAWDfWqO/6
         FF4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yd9kHJ67qXfiTgnEeD19c6GXo2mZOtbVeKPFm5XCTBc=;
        fh=9VW+1w7iumsEyOVLR1pal2ryBvkKrhVd0peJpwWbwfA=;
        b=Q4NQDCfZgT/xaBEjd79GoT+cwdG7KNcvsKYtdtQrDoHSbBcSrzw5seD4qbN11SgGwa
         gbEi1JfuOx7L94KDyUz0cDw4Y93PsMD2oQXNOZTN7afqrxHXUPDsR+lfYhQi45B1UKm6
         z466GUNasSuOpQFBuzcATQU9/kgziDty3vOoZ3xARc6T/uf4af5dqmOHvisDnP5HjwOi
         k4qtHY+AaTkFTf16vqBoMBrkS/24Xgi1HVzyJfkNXQ/m8tgnnvpJ0Ud1X0i36A9THC96
         YVQmdKoCTR7o8WgUu/wh0K8DEJevLhOsE9ixblj0K6GSKkKYQGRepaxMaMeofCui8Wxq
         TFhQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781273697; x=1781878497; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yd9kHJ67qXfiTgnEeD19c6GXo2mZOtbVeKPFm5XCTBc=;
        b=IkSE46QOtFWvqRu+tPjnc1uh4SH4juPi3M2lQPEm24Zv/cobJ5P3ppZEgy9PJljqnd
         AV1OIjRmEWbhrEB9QaKAzYCjU052OIcY2HGKgV8CM+vP9yeCZ8WvfyWhPT3TSTfjDY24
         NN3N8Tu/MC6uttteztooZIdvuRTyFcgvOEO3LvXS6SzmNBqD7FeHBLo9yS7/8UAysRVR
         4OZKpZedeBdWKLj8z2HE1Sdl9TaW481Y+cHUXYcUm9K7cV8NMqQGak4QkdHnmWlGNelq
         Tkoh785xY2/WJ9UrqJb0EUsVgnOjMP8njHXNBFU9KODm3M6PEjuCLQHQLHbOk5lLBWmO
         W0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781273697; x=1781878497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yd9kHJ67qXfiTgnEeD19c6GXo2mZOtbVeKPFm5XCTBc=;
        b=mcEh9QBsW2LMZl5fA1/6y0mfWKpmZe/UmQ9X39StmUJrxRJbl6daorb7BWZShoz2Rv
         yfH/dvon3iNbLSgz9FQjLMDCgvVpJrZnuU6yTWHlank3AmYtGq3QN+95KjsLMaWZTuAs
         SOLLa3BmqACfnYY1jx9zwLZGlc6/cqUMx4qpMZ1mnRpv0wBEcTarU98v5IGayKaA1QrD
         ZUwVMw8M6z5GwlUSIM8C4a4d3nbdR4Yt46Y7vpae5RPjgPOJKFfG4mDUd9DD7aAYrgyD
         uGht9+Y3sgU4iiskJKOHTTtTbQnBytnWy55b50/Y6fS8P+p3i9UMgYpkw+gVhmHp1E/d
         zW7A==
X-Gm-Message-State: AOJu0YwVhAs9th4CDRXmpufKG+iszCYSeNpCIDsuv3dmwVNjq27tXbM8
	SULsomWtuoGw9hoULFRkukkeETD3X4o5rzbPrDhmQpa9LluJN3MG4uTIMp4D4L46xNewD0yVOjD
	Uy18YRZBozmDGZs7f/6P/X13Qk43Wig0=
X-Gm-Gg: Acq92OHRDCsRkLxgb+C2ZQ/pUAG9KBlxHEG6uyqYp4hZjtt0DvsNhiAXU21OUVfcuXa
	OAeKYqmpEqb13ZazrE9YyS9bNfJhbs6RnF3jUmr3mTLZw/9oc0VRz268M/Cw7gnTWT0vKLY+Oa2
	O121e5vklBzCVVilemGgkWveyoJX/XWcrYy8TdAVmTYLF8Jszw8wwE41CyHLeiRPhTGPR6o8wMq
	lfXQxMtx7jUCMo2NJ49lBHs6caW8xXRG4d5zIaDtnouBqxTe4gIVCO+meVncG1q8IGFVch5BnW9
	9smw0g==
X-Received: by 2002:a05:622a:2e8b:b0:517:8fb6:56ba with SMTP id
 d75a77b69052e-517fe48d5d9mr31961101cf.24.1781273696515; Fri, 12 Jun 2026
 07:14:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMho2RfgwvNhWJidb_Xn3RRt71TFjQ2QBKP9Xt8ur22L-ZWP9A@mail.gmail.com>
 <20260609192542.GA3811606@google.com>
In-Reply-To: <20260609192542.GA3811606@google.com>
From: kstzavertaylo <kstzavertaylo@gmail.com>
Date: Fri, 12 Jun 2026 17:14:54 +0300
X-Gm-Features: AVVi8CemVVHFflJa6Hz3DuXXouq63JVH2gayeroj__1EQ7AIN7kpjICai6WB51s
Message-ID: <CAMho2Rem-B908oaFQzTx8Mg895LuvPcfN9+ANoHW+XfGW+wB6A@mail.gmail.com>
Subject: Re: [RFC] ML-KEM (FIPS 203) implementation with reusable
 decapsulation pool
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for the detailed reply and for pointing me to the existing
ML-KEM/X-Wing patchset. I spent some time reviewing the implementation
to better understand the design choices and how they compare to the
approach I took in my own work.

After reviewing the patchset, I can see several strengths in the
implementation. It integrates cleanly into the existing lib/crypto
infrastructure, reuses kernel cryptographic primitives, avoids large
stack allocations, and includes KUnit-based validation. The
implementation also appears intentionally compact and well aligned
with existing kernel conventions.

While reviewing the implementation, I noticed that decapsulation
allocates a temporary workspace for each operation. This is one of the
areas where my design diverged, which is what originally motivated the
reusable pool approach.

My implementation was developed with a somewhat different goal in
mind. I experimented with a reusable decapsulation workspace model
where memory is allocated during key initialization and then reused
across subsequent decapsulation operations. The main motivation was
reducing allocation frequency and minimizing both stack usage and
repeated memory management during decapsulation.

As a result, the implementation avoids allocations during
decapsulation entirely by reusing preallocated workspaces associated
with the key context. My original hypothesis was that moving memory
allocation to key initialization, thereby eliminating allocations from
the decapsulation path, could reduce allocation overhead during
repeated decapsulation operations and be beneficial in environments
where allocation activity is considered undesirable.

Another difference is the integration level. My prototype explored
direct integration through the KPP interface, whereas the patchset
focuses on providing a reusable cryptographic library component within
lib/crypto. These approaches address somewhat different layers of the
kernel crypto stack.

The primary reason I initially started working on this implementation
was to explore whether a reusable-workspace architecture could be
useful in environments where allocation frequency and memory reuse are
considered important design factors. I therefore wanted to understand
whether such an approach might offer any practical value within the
kernel context, even if the overall implementation strategy differs
from the existing patchset.

The goal is to analyze the results and understand whether the
reusable-workspace approach actually achieves its intended goals in
terms of memory usage, allocation behavior, throughput, and related
metrics. In particular, I am interested in understanding whether such
an approach may provide practical benefits in environments where stack
space is constrained or where reducing allocation activity is
desirable. To better evaluate these tradeoffs, I am currently
preparing a comparison against several established ML-KEM
implementations. If such data would be useful for the discussion, I
would be happy to share the results once they are available.

Best regards,
K. Zavertailo


On Tue, Jun 9, 2026 at 10:25=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Jun 09, 2026 at 10:45:48AM +0300, kstzavertaylo wrote:
> > Hello,
> > I have been working on an ML-KEM (FIPS 203) implementation for the
> > Linux kernel. This is an early RFC to solicit feedback on the overall
> > design and architecture before further polishing.
> >
> > The implementation consists of two closely related variants sharing
> > the same core cryptographic logic:
> >     1. A userspace implementation accompanied by a set of validation
> > programs, including NIST KAT vectors, timing-leakage testing (dudect),
> > pool stress tests, and additional functional tests.
> >     2. A Linux kernel module implementing the KPP interface and
> > reusing the same core architecture where possible.
> >
> > Key features include:
> >    1. Support for all three parameter sets: ML-KEM-512, ML-KEM-768,
> > and ML-KEM-1024.
> >    2. The implementation uses a reusable decapsulation pool consisting
> > of preallocated slots associated with a key context. The goal of this
> > design is to move memory allocation to key initialization and avoid
> > per-decapsulation allocations.
> >    3. Explicit zeroization of sensitive data and constant-time
> > operations where required.
> >    4. Portable C11 codebase with minimal differences between userspace
> > and kernel versions.
> >
> > I am aware that some aspects (local SHA3/SHAKE implementation, coding
> > style, etc.) will likely need adjustment to align with upstream
> > expectations.
> >
> > At this stage, I would like to ask for feedback on the following points=
:
> >    1. Is the general direction (KPP integration + reusable
> > decapsulation pool) acceptable?
> >    2. Are there any fundamental concerns with the pool-based architectu=
re?
> >    3. Would you prefer to reuse kernel crypto primitives for
> > SHA3/SHAKE, or is the current embedded approach acceptable at this
> > stage?
> >
> > The implementation is available at: repository - https://github.com/kst=
zv/ml-kem
> >
> > Documentation and implementation details are available in the repositor=
y.
> >
> > Any feedback, criticism or suggestions would be greatly appreciated.
>
> There's already a kernel patchset for ML-KEM and X-Wing ready to go:
> https://lore.kernel.org/linux-crypto/20260525184403.101818-1-ebiggers@ker=
nel.org/T/#u
> It's a high quality implementation that fully follows kernel conventions
> already.  There just hasn't been a reason to merge it yet, since there's
> no user yet.
>
> We could consider replacing my ML-KEM implementation (patch 1 of that
> series) with a different one.  But it would have to be a high-quality
> implementation that brings something substantially new to the table.
>
> I think only an integration of
> https://github.com/pq-code-package/mlkem-native *might* have a chance at
> passing that bar.  However, it would be way more code than my
> implementation, would have significant integration challenges, and would
> need some fixing up to work in the kernel.  The main benefit would be
> getting the assembly code, but it's not clear that will be needed.  So
> those are some of the reasons I didn't reach for that initially.
>
> I don't think integrating https://github.com/kstzv/ml-kem would be
> beneficial, for a number of reasons.
>
> Anyway, I suggest you review the pre-existing patchset
> https://lore.kernel.org/linux-crypto/20260525184403.101818-1-ebiggers@ker=
nel.org/
> and give feedback on that, if you have any.
>
> - Eric
