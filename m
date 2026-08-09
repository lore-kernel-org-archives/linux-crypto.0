Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B61149DF1
	for <linux-crypto@vger.kernel.org>; Sun,  9 Aug 2026 14:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786284985; cv=pass; b=DkqbIGlegAPv5gSV0FyFOwCf24f2ypUXy/RzCrLcRorVwhXLLDufPcvVPN4Q5Y++LoLa7Pc6mkVmuZEp1pLlJTdgYLPq/RxMjejqJkWnYCUNAyWgwcH37Xdc8OzaMhhzzfQScsCo7Mk1zNYVBGXOV0G/apFA/0eGvbzywMPcJAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786284985; c=relaxed/simple;
	bh=o1L7kWYJEumEhhsSCtRVIFmGQcq8HNyNb/TEpRDlIn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WVk5AMQjg5NT13N9Up6EppaISQHOirQbuYHk2MYWYmgssxR+08k8qDxR6BQpgZbHE5N6Cbz21WWCKnVl6Rhrb+niCTvbBbOUdAaITVCHSGKIw6cmwL3FaYSjb2c+dyo6fkbcZ0BRBAJ+TslmmHDBOu5bPLBgDfqpMLIXhcUa/s4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D0NLONJO; arc=pass smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D0NLONJO"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cb5a6aa8760so499232a12.1
        for <linux-crypto@vger.kernel.org>; Sun, 09 Aug 2026 07:16:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786284983; cv=none;
        d=google.com; s=arc-20260327;
        b=g7d1EYrKKa186KPLpf9sy1Ou1mMTrXR4tfzLHaTfR2GObz0Fm008bt7PQz/5SaUppw
         TCnt7Q1/Mn61HHjqAh/Vx5TP3Bj6MPyIa/IBgPjjijgXlBwUUQkBZj+S3Y7YG9o43Pws
         HobnG8oOmviHB1adcf6sIZkFmfzIQLH7d1slxGg6XQyMBFq+DSU8PVyYB7+bRyOUi47Q
         LNA1NJOGCnHaD2ar4hEFUM5HvO7Y/Q2+zDx4jfBqjULG5Hf8xowRRcMJk2ey8gSZz+o5
         DfYS2dICORR7FUkGkKaQnQEi+jv3og20HcouAsJ3Q5Pzll6VuRYdW6u665IJmFEQvXG5
         rWMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6+CX/kANJ/fEZ/2swijdSvi5SBT8qzSh+rrKca5Hvok=;
        fh=9VW+1w7iumsEyOVLR1pal2ryBvkKrhVd0peJpwWbwfA=;
        b=K2ndAo098JxAZ67IbUpJrAHNXZcmnqzsLxt9IYSDs8B+aOEcYv3Z396tN6KyH4QFx9
         Mvr8meLhFgzCvwTB/cxF9KdY8E14s3dsMmREonFU8jJ2u+n+3RnBG5ZsVKSM0vvdMFUB
         OfJklAU6fi7w4OmCFp7rYxURod9dqxAKga3LeAGNaNu3xjzgsfqkn3wKgaoYGoKf2dJt
         VZzv4ubavfIEAiu99rj1CxuVzci6RtpMq9bPlhIvS6Rp6q61/huko4/ZloK5SPyrPRVd
         hlxEfz9Av1++LeajTJRN6qAdjMOr/xd7x+iUqemNM+Fm70SSQ471WPU0RMSU8Z24zexq
         kC6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786284983; x=1786889783; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6+CX/kANJ/fEZ/2swijdSvi5SBT8qzSh+rrKca5Hvok=;
        b=D0NLONJOclWl0ifrcKQCgbCbcjOCu45rpKrljhKmfRBD6YNsGJLgqx/J9LKyaFdzPl
         1nRIyZQIFXtKOX0b89tg1htUrxfxAdzmvxOE38sqlak6SW+416R2QHL/d+d7yStOaHwf
         9PmdIYSzhVsndDwxAAgr5o8mZtSK1Du906wr3843RZYHVzwm1a04+cdVKQMqx9OboZ7/
         yNUHL6oDyTJVT7xCUsAKHdaEHi7KwsJSWb25aBLzuuKT9R4KFyjq6j2hXBQyfRG9o7Cv
         bOWPabr2WusIdVid9LnmRj9lKiKhLaH3Bw9akqEaO9PdthW3GdsgcKcjMNN+QuzU+mQ9
         75tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786284983; x=1786889783;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6+CX/kANJ/fEZ/2swijdSvi5SBT8qzSh+rrKca5Hvok=;
        b=hyW5PM2jFysO7S/cFSgdKZ95bPFDzXc5IS4G19bd1AjkWrsPn2YEw6FGCmMlo1unz+
         E5DcS3WvwcN92C80aQPyY9y/Oum7BzDVaTmZsk6sN5GTgbCXsijnqN53hHL12sAY1CcM
         fACLymb6uUaMCfTywHJxRpBAKhXucHtV6+QidKp8HsnonxBuKyFNzUZIiUC+dxO+aX27
         AcIuv8KXpQOHRvew7sKqw+v80DtK3li9lozuNJ7fTJ0fCRjRnp6WWajQtSDBq4f7McI6
         aYjJUmNbVC+94FN245/ZKaZdhq8KIMtlkBiBdvvScLWPIOnTNL4PjnlrTVMCjnMX1PUP
         QdWA==
X-Gm-Message-State: AOJu0YwyTOu14vB76EGKYnnQeD+K6jp44fiydw7xMcodcyc7gu4cJ5V/
	jA0R+NSzqDqeouEHXoBz+SIMC2tLEZyJch7o3KfzUVIsmqLGo23+RLe+uN92rFYoeOTL4k0tsL0
	2278lmScenK4dRKodshz/UmDuq1GS0gY=
X-Gm-Gg: AR+sD13W73hY1/tCHr/U/OY7KOwvqfg+1kQZzjPON69i03nublqN5tHWI8kJ/AlycoJ
	UZqXYumViQmW0cVod714pLuhcDuhHYPOjnb2Rxf1OoQJ06yW0WLgcxDd6AoNLZrWiyH4qGLqxgH
	ACpluIGB6W0XToafDclcSf21kggugehq7r1eKHyftQfz/x+bdMQw6d9ineRgpPGpyCEHCUc6b6n
	2z7pEiMZ0fpvxXgSl38NEEboLKhNi6wBSx1XxzuaOSkoNSjtGa1V5vmDK6VWgZR7pNfc75XypR3
	lkbGbo8xrQ9c8Fk+z/KNLyiXlzC+h/uUkfCopzAGtYg=
X-Received: by 2002:a05:6a21:117:b0:3c3:9df0:2d66 with SMTP id
 adf61e73a8af0-3cbada68165mr28755548637.6.1786284983216; Sun, 09 Aug 2026
 07:16:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMho2RfgwvNhWJidb_Xn3RRt71TFjQ2QBKP9Xt8ur22L-ZWP9A@mail.gmail.com>
 <20260609192542.GA3811606@google.com> <CAMho2Rem-B908oaFQzTx8Mg895LuvPcfN9+ANoHW+XfGW+wB6A@mail.gmail.com>
 <20260612183240.GA2157807@google.com> <CAMho2Re4pc4f_TkApfwsbfguiaN_Ccw770_A+0fc9G7L_GBAnA@mail.gmail.com>
 <CAMho2Ren_PucPRyyTSySdniFfBLECBL+nxH3x6-5Mxsp+89iqw@mail.gmail.com>
In-Reply-To: <CAMho2Ren_PucPRyyTSySdniFfBLECBL+nxH3x6-5Mxsp+89iqw@mail.gmail.com>
From: kstzavertaylo <kstzavertaylo@gmail.com>
Date: Sun, 9 Aug 2026 17:16:43 +0300
X-Gm-Features: AUfX_mwVe5zzOtyYSRbN7asWr1l3rJt8vcDO_-cE7uP0rFeuNBDd_rxT7QS7AgQ
Message-ID: <CAMho2Rd5GDg=qE6d9azSwRaPvSLFO550-G_-VmnS84M9=8Op0g@mail.gmail.com>
Subject: Re: [RFC] ML-KEM (FIPS 203) implementation with reusable
 decapsulation pool
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I wanted to provide a final update since my previous message. The
implementation and its documentation are now complete.

I took your earlier feedback regarding the kernel integration into
account. In particular, I abandoned the KPP-based design and ported
the implementation as a lib/crypto component instead. The kernel port
uses the same portable core as the userspace implementation, with a
thin kernel-specific integration layer.

The v1.4.0 release includes NIST KAT validation, stress tests,
timing-leakage testing, stack and memory measurements, and performance
comparisons:

https://github.com/kstzv/ml-kem/releases/tag/v1.4.0

I understand that your ML-KEM and X-Wing series remains a proof of
concept pending a concrete in-kernel user, and that the appropriate
workspace and caching model will ultimately depend on that user.

I do not want to propose patches without a concrete reason to replace
or modify the existing implementation. However, if the completed
architecture or results are of interest, I would be glad to continue
the technical discussion. If a future in-kernel user makes this
approach relevant, I would also be willing to adapt the implementation
to its requirements and prepare patches for review.

Thank you again for the earlier feedback. It directly influenced the
kernel integration design.

Best regards,
K. S. Zavertailo

On Wed, Jun 24, 2026 at 5:44=E2=80=AFPM kstzavertaylo <kstzavertaylo@gmail.=
com> wrote:
>
> Hello,
>
> Since our previous discussion, I have significantly updated the
> userspace implementation and completed a series of benchmarks and
> validation tests.
>
> The implementation allocates all memory required for a given key
> during key creation and subsequently operates entirely within that
> preallocated memory until the key is destroyed.
>
> During decapsulation, the same memory allocated at key creation is
> reused across operations, eliminating runtime memory allocations in
> the decapsulation path.
>
>
> I compared the implementation against PQClean ML-KEM. The main observatio=
ns are:
>
> * Stack usage remains approximately 1 KB regardless of the selected
> ML-KEM security level.
> * No memory allocations are performed during decapsulation.
> * Throughput is generally comparable to PQClean.
> * For ML-KEM-1024, the implementation is currently about 5=E2=80=938% slo=
wer
> than PQClean.
> * The trade-off is increased persistent memory consumption and a more
> complex internal architecture based on reusable preallocated
> resources.
>
> I also took your earlier feedback into account and came to the
> conclusion that integration through lib/crypto would be a better
> direction than the KPP interface. As a result, I am now seriously
> considering adapting the implementation for lib/crypto instead.
>
> In addition, I am continuing to investigate further optimizations in
> pure C. If these experiments produce meaningful results, I will
> publish them and would be happy to share the findings in the future.
>
> Benchmark results, methodology, stack usage measurements, memory usage
> analysis, and PQClean comparisons are available here:
>
> Release:
> https://github.com/kstzv/ml-kem/releases/tag/v1.1.0
>
> Benchmarks:
> https://github.com/kstzv/ml-kem/tree/v1.1.0/portable/userspace/benchmarks
>
> Thank you again for your earlier feedback.
>
> Best regards,
> K. S. Zavertailo
>
> On Sun, Jun 14, 2026 at 10:50=E2=80=AFAM kstzavertaylo <kstzavertaylo@gma=
il.com> wrote:
> >
> > Thank you for the detailed feedback and for outlining the historical
> > context regarding pools in the crypto subsystem.
> >
> >
> > I understand your point of view and the preference for keeping the
> > core implementation simple with per-operation allocations (or
> > caller-provided workspaces), especially given the lack of precedent
> > for pool-based designs in lib/crypto. My approach with the reusable
> > decapsulation pool was driven by a focus on constrained environments
> > where minimizing stack usage and relying on reusable preallocated
> > working memory during the hot path can be particularly valuable.
> > However, I fully agree that concrete data is needed to properly
> > evaluate the trade-offs.
> >
> >
> > I see your point regarding preallocated workspaces and caller-managed
> > caching. One of the goals of my prototype was to explore a design
> > where decapsulation operates on reusable preallocated contexts rather
> > than per-call working memory, primarily to reduce stack requirements
> > and move memory management into an initialization phase. I need to
> > analyze more carefully how much of this can already be achieved
> > through a caller-provided workspace model and whether the additional
> > complexity of a dedicated pool is actually justified.
> >
> >
> > I am currently working on benchmarks that compare stack consumption,
> > allocation behavior, memory footprint, and performance between the
> > different approaches. Once I have solid numbers, I will share the
> > results and my conclusions.
> >
> >
> > I also appreciate the clarification regarding KPP. My original
> > prototype used KPP because it appeared to be the closest existing
> > interface for key establishment, but I am not specifically attached to
> > that approach and will spend some time evaluating how the same ideas
> > could fit into the lib/crypto model as well. In the meantime, I will
> > also look into how the pre-allocated workspace support you suggested
> > could be integrated.
> >
> >
> > Best regards,
> > K. Zavertailo
> >
> >
> > On Fri, Jun 12, 2026 at 9:32=E2=80=AFPM Eric Biggers <ebiggers@kernel.o=
rg> wrote:
> > >
> > > On Fri, Jun 12, 2026 at 05:14:54PM +0300, kstzavertaylo wrote:
> > > > Thank you for the detailed reply and for pointing me to the existin=
g
> > > > ML-KEM/X-Wing patchset. I spent some time reviewing the implementat=
ion
> > > > to better understand the design choices and how they compare to the
> > > > approach I took in my own work.
> > > >
> > > > After reviewing the patchset, I can see several strengths in the
> > > > implementation. It integrates cleanly into the existing lib/crypto
> > > > infrastructure, reuses kernel cryptographic primitives, avoids larg=
e
> > > > stack allocations, and includes KUnit-based validation. The
> > > > implementation also appears intentionally compact and well aligned
> > > > with existing kernel conventions.
> > > >
> > > > While reviewing the implementation, I noticed that decapsulation
> > > > allocates a temporary workspace for each operation. This is one of =
the
> > > > areas where my design diverged, which is what originally motivated =
the
> > > > reusable pool approach.
> > > >
> > > > My implementation was developed with a somewhat different goal in
> > > > mind. I experimented with a reusable decapsulation workspace model
> > > > where memory is allocated during key initialization and then reused
> > > > across subsequent decapsulation operations. The main motivation was
> > > > reducing allocation frequency and minimizing both stack usage and
> > > > repeated memory management during decapsulation.
> > > >
> > > > As a result, the implementation avoids allocations during
> > > > decapsulation entirely by reusing preallocated workspaces associate=
d
> > > > with the key context. My original hypothesis was that moving memory
> > > > allocation to key initialization, thereby eliminating allocations f=
rom
> > > > the decapsulation path, could reduce allocation overhead during
> > > > repeated decapsulation operations and be beneficial in environments
> > > > where allocation activity is considered undesirable.
> > >
> > > In my ML-KEM code, all the decapsulation memory is consolidated into
> > > struct mlkem_decap_workspace.  It would be straightforward to support
> > > the caller providing a pre-allocated workspace.
> > >
> > > In the case of X-Wing, we could also support pre-expanding the
> > > decapsulation key.
> > >
> > > It just depends on what is actually going to be needed by the kernel
> > > feature(s) that are going to use this.  Which we don't really know ye=
t.
> > >
> > > We do know that it hasn't been found to be useful for the crypto
> > > subsystem to provide pools for any other algorithm in the kernel, for=
 a
> > > variety of reasons.  Usually callers can just allocate per-operation,=
 or
> > > they have some sort of object (inode, block device, socket, etc.) tha=
t's
> > > a natural place for them to cache whatever they need anyway.  In the
> > > rare cases where some sort of pool is needed it's implemented in the
> > > caller, optimized for the particular use case.  So I think there's a
> > > good chance your pool idea is going off on the wrong track.
> > >
> > > > Another difference is the integration level. My prototype explored
> > > > direct integration through the KPP interface, whereas the patchset
> > > > focuses on providing a reusable cryptographic library component wit=
hin
> > > > lib/crypto. These approaches address somewhat different layers of t=
he
> > > > kernel crypto stack.
> > >
> > > We don't need crypto_kpp support, as it's much more complex and harde=
r
> > > to use than the crypto library
> > > (https://docs.kernel.org/crypto/libcrypto.html).  Also it seems it's =
not
> > > really possible anyway, since crypto_kpp is an old design that works =
for
> > > Diffie-Hellman but not KEMs.
> > >
> > > - Eric
