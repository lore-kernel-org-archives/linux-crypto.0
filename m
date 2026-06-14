Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99E51F78E6
	for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 07:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781423415; cv=pass; b=nFG3geP6g/UImOBP6BQRMTp6A4X6VT/rdhhqwJSYdHkK5zXM2piBWVmKjC9+j4LhW8q3mRtIkaJqFXrMtfzlZFRNWH7+HrBrUhOzoLqlOm94vuPNLIK5fGqdBxU9u9bR4Tf1e20/j1tJjDFDxDNkpcsdd1T9nMWtAIwI2FuSFC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781423415; c=relaxed/simple;
	bh=KInVQgrl+Ir8H5MwBz0OoKKJKg2uxd/IRJKHNBBS03M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qgSR1SdJz1A7WdnB62wHKcNNpu01Y0Wsiq3Bwu4PY+mW9gEFmzv7RBTrKnGjfc/Lmu+CytZosrLnH2J3P7nCRyrWSTjJu5RZipgJq+ix62/wbNCz5C9wBaP8/OOZNn1Tp82OgYqtUm2UxYRblvx7J7/nS9QbGl/IF/X/wtizLS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oEbetVnm; arc=pass smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oEbetVnm"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9157d3f2098so266747485a.3
        for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 00:50:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781423413; cv=none;
        d=google.com; s=arc-20240605;
        b=cbhYeqGeU6zP8OHROTKa7hkBcoiaASZlRceHtTjKSxwUA75mioZe1V2Kbo/QQf6yhb
         LFe7BMGo3EVdw1KcALUTSrWrTjFOugrS0bHoqUujmsjHivdDWb3DLF5J3E8Tri7E2l1B
         3AgdKy3swR8/e6b2c1jCJU9o8Eq4EiMwiDd+WsFh5UKub5TnAYEYo13lxd62VdChCIOh
         lTgQvyUcVRiZD098qG2579saFPvPTyLEOGRLOdCHj4RHGPZlpLj9yYuoTCvc/oBjpp6Z
         d/jx16H5wlNuVCXwqy7PSgNPTQvI2bCpnN+BcUE1+yf/J3rS+ZZPhyLIL35RKbONowJ4
         ecIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tyrKEA3P8IbS79llX+B0GbMOP4la0F+gvacYwstqRsY=;
        fh=9VW+1w7iumsEyOVLR1pal2ryBvkKrhVd0peJpwWbwfA=;
        b=ef2harHUx/v6QFyEdkmRybFs3HfP8N0loBAqhU6fmj8bye4ewNRkqa9fbZKDRVEVci
         1kDuK1+GMmgWZV9Q0mTLW8VoCIEoHXHpWZTA51E5fKz+5RwM97prOlHbsvY4hcF2ZLgf
         4t9BVh9wuq5fnZXOUB8lU+bz9vMOaK+tPSLXYc4TTs7l3sN3aGH29M5L3KiveEnQ47X+
         ssQVKIUopUTZKQzGbCvCtIeL3ljkLZ2RI1kazwEtaZ6OGW3o51Y6trhxFkmdGNKBKahf
         Yc+n6bx5oMi1llaLSEjSOh+i1vKXWGmddZg9drdIh25N0hu2L4SXTx3k63NnL+aq7tgg
         oHrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781423413; x=1782028213; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tyrKEA3P8IbS79llX+B0GbMOP4la0F+gvacYwstqRsY=;
        b=oEbetVnmcBW75UeHRG82/2eOdmTI24GwfzPyDFCzshhKAK2b6jvFx0DOGdUfvW7y1r
         aThIP2txVITJLf16zvWxZtca/kvDN5zZD87dhglLd8TQGkki2gVt2jhSyrCXiipQOnq0
         /ICk7/iOBeIKfI5svHGLmKQK+i91nXd41k3fkKiD59PJuz4wL2ds6IEwkb/wpHwVaXTd
         bUAkLM4xFO0gb4Sqpga3MY3DeI1TndVUTczBchiN9MUzNcfVVsfgQhLC1SXPfeRWUqBg
         9C3kfbHnAeA0HQyPBY/BazIhKvnbXLFr0SQIUQCcSXZKpLGDBoOERd0qZuK9m81Sk7D4
         bIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781423413; x=1782028213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tyrKEA3P8IbS79llX+B0GbMOP4la0F+gvacYwstqRsY=;
        b=EUzV05swdeQm0fofeAP/y6HScJaJMH46DIlKARU2PpxktD+xZFgGJ3f6urSCxlYoYm
         zxmCXKyK6x36YOYNEY0Qx2IVLoilhwFD+ORvdzsyAAW3H7DNMXF1PYEm4m/g8Iba/5um
         vSEaznAemJJyIp0BkQ3XBL0CU70aA2m5CWJQlOSr7CkgWQ4h4ESCz4X24nHsAr06mUV3
         iM6DO8Ei66kVNqYlCaZ8mz43BKamXjjvmdutka+MTK+x9h7xef7ogQPkwoxyB8ylwcDO
         y13YUq0Ve7GT+Yr0fBFgHKlEP+XqV3NScZ7/3Ryc5RXqUcR4wzF+lB6lavwGsuykwbRR
         NBzA==
X-Gm-Message-State: AOJu0YyU1Eb/ZXoYNxXqCelX5xIoU1y2jvFfUARH6UOAJhdWoWESKOTn
	UUgV1Ulya8GI2GTZbKV4dD/GiVmWdACC+nItzNsidEzVsgQ93sTN5cVN0hCtbaDyWr4OZHicWLP
	rqKau+gus8GMZS2Icb79s1Mw90pdKVo9hY0Zg
X-Gm-Gg: Acq92OEtntEc98P4MeNIOzP0uvMMHTkSTftenTf/zmOCTzc4/2z2mOBPqN4L69h6PZV
	FYm7a1wW9ccHoeeQJcndYABZUJlUOyQ4otrnniLZCL3kFmEhITecSNX6RqM8WG6DwlHfqWnonPs
	sHM8eNa74BDkp7nFvHzUlRyZn14T4gGzUMQD2NaAaJyUYp4SlvOmhX0KvpuNL+6L+GfP7cbILur
	FYk0FryOR1wI/7Erx2JGoK4BT/WavSN6aQGvq2FOVSREX8m9iA4BcZjx2HqHtRBxtfRqI89HSsz
	oOpzWw==
X-Received: by 2002:a05:620a:390c:b0:915:cf88:1e3b with SMTP id
 af79cd13be357-9161bf722a8mr1483876085a.47.1781423412781; Sun, 14 Jun 2026
 00:50:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMho2RfgwvNhWJidb_Xn3RRt71TFjQ2QBKP9Xt8ur22L-ZWP9A@mail.gmail.com>
 <20260609192542.GA3811606@google.com> <CAMho2Rem-B908oaFQzTx8Mg895LuvPcfN9+ANoHW+XfGW+wB6A@mail.gmail.com>
 <20260612183240.GA2157807@google.com>
In-Reply-To: <20260612183240.GA2157807@google.com>
From: kstzavertaylo <kstzavertaylo@gmail.com>
Date: Sun, 14 Jun 2026 10:50:11 +0300
X-Gm-Features: AVVi8Cf-0PIBfKYDeI8Hm3Ulrjz_-I2gyQlWbc_uDXAzeXNhkXOrblpwDKTdmEY
Message-ID: <CAMho2Re4pc4f_TkApfwsbfguiaN_Ccw770_A+0fc9G7L_GBAnA@mail.gmail.com>
Subject: Re: [RFC] ML-KEM (FIPS 203) implementation with reusable
 decapsulation pool
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for the detailed feedback and for outlining the historical
context regarding pools in the crypto subsystem.


I understand your point of view and the preference for keeping the
core implementation simple with per-operation allocations (or
caller-provided workspaces), especially given the lack of precedent
for pool-based designs in lib/crypto. My approach with the reusable
decapsulation pool was driven by a focus on constrained environments
where minimizing stack usage and relying on reusable preallocated
working memory during the hot path can be particularly valuable.
However, I fully agree that concrete data is needed to properly
evaluate the trade-offs.


I see your point regarding preallocated workspaces and caller-managed
caching. One of the goals of my prototype was to explore a design
where decapsulation operates on reusable preallocated contexts rather
than per-call working memory, primarily to reduce stack requirements
and move memory management into an initialization phase. I need to
analyze more carefully how much of this can already be achieved
through a caller-provided workspace model and whether the additional
complexity of a dedicated pool is actually justified.


I am currently working on benchmarks that compare stack consumption,
allocation behavior, memory footprint, and performance between the
different approaches. Once I have solid numbers, I will share the
results and my conclusions.


I also appreciate the clarification regarding KPP. My original
prototype used KPP because it appeared to be the closest existing
interface for key establishment, but I am not specifically attached to
that approach and will spend some time evaluating how the same ideas
could fit into the lib/crypto model as well. In the meantime, I will
also look into how the pre-allocated workspace support you suggested
could be integrated.


Best regards,
K. Zavertailo


On Fri, Jun 12, 2026 at 9:32=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Fri, Jun 12, 2026 at 05:14:54PM +0300, kstzavertaylo wrote:
> > Thank you for the detailed reply and for pointing me to the existing
> > ML-KEM/X-Wing patchset. I spent some time reviewing the implementation
> > to better understand the design choices and how they compare to the
> > approach I took in my own work.
> >
> > After reviewing the patchset, I can see several strengths in the
> > implementation. It integrates cleanly into the existing lib/crypto
> > infrastructure, reuses kernel cryptographic primitives, avoids large
> > stack allocations, and includes KUnit-based validation. The
> > implementation also appears intentionally compact and well aligned
> > with existing kernel conventions.
> >
> > While reviewing the implementation, I noticed that decapsulation
> > allocates a temporary workspace for each operation. This is one of the
> > areas where my design diverged, which is what originally motivated the
> > reusable pool approach.
> >
> > My implementation was developed with a somewhat different goal in
> > mind. I experimented with a reusable decapsulation workspace model
> > where memory is allocated during key initialization and then reused
> > across subsequent decapsulation operations. The main motivation was
> > reducing allocation frequency and minimizing both stack usage and
> > repeated memory management during decapsulation.
> >
> > As a result, the implementation avoids allocations during
> > decapsulation entirely by reusing preallocated workspaces associated
> > with the key context. My original hypothesis was that moving memory
> > allocation to key initialization, thereby eliminating allocations from
> > the decapsulation path, could reduce allocation overhead during
> > repeated decapsulation operations and be beneficial in environments
> > where allocation activity is considered undesirable.
>
> In my ML-KEM code, all the decapsulation memory is consolidated into
> struct mlkem_decap_workspace.  It would be straightforward to support
> the caller providing a pre-allocated workspace.
>
> In the case of X-Wing, we could also support pre-expanding the
> decapsulation key.
>
> It just depends on what is actually going to be needed by the kernel
> feature(s) that are going to use this.  Which we don't really know yet.
>
> We do know that it hasn't been found to be useful for the crypto
> subsystem to provide pools for any other algorithm in the kernel, for a
> variety of reasons.  Usually callers can just allocate per-operation, or
> they have some sort of object (inode, block device, socket, etc.) that's
> a natural place for them to cache whatever they need anyway.  In the
> rare cases where some sort of pool is needed it's implemented in the
> caller, optimized for the particular use case.  So I think there's a
> good chance your pool idea is going off on the wrong track.
>
> > Another difference is the integration level. My prototype explored
> > direct integration through the KPP interface, whereas the patchset
> > focuses on providing a reusable cryptographic library component within
> > lib/crypto. These approaches address somewhat different layers of the
> > kernel crypto stack.
>
> We don't need crypto_kpp support, as it's much more complex and harder
> to use than the crypto library
> (https://docs.kernel.org/crypto/libcrypto.html).  Also it seems it's not
> really possible anyway, since crypto_kpp is an old design that works for
> Diffie-Hellman but not KEMs.
>
> - Eric
