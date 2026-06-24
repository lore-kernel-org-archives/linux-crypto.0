Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631843C943F
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jun 2026 14:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782312287; cv=pass; b=n8QVUQprqxpLDPK4BnukVrzEKtnGL2GFmfE9TdaPYkG02ARX2gvOM6Eyd6vmkxhrDH75peui5MEkkfEmpV0QYYsAzeG4Wg1e/1vseqKVyD8eR5fP4ldASWj20UD2hcI8X14h6gBoOuXULXUVu+AOqaVXE/VEipFpY5SMaxuQ0uM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782312287; c=relaxed/simple;
	bh=32wZkNORP8iuzMZ+i7kPfSuj0LBIUcjLGqQt345rGGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jIYEkMOGBBdDu9/jxIduYGFQfATvcSgBOKJtPlEYtoNH6/SkKkPpU7BNDWvgfh+vxvDK4r3xEu4ATUHvr6olIrZpsJVSczl600oPELU6FVuQgBJwwYijQweSFpAkN73FLmKK6NLRy2YmKQ2L2WQp2wK3jeIrSbk/kA6qNK3xHKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mvLyshfo; arc=pass smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mvLyshfo"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3078e0dcd67so1575489eec.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Jun 2026 07:44:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782312285; cv=none;
        d=google.com; s=arc-20240605;
        b=f8sQiaw3+3CzonxRWIeJNiX1wlK8bnOqI86FyKR5ZQ47aDJ42nmUvbNtt1bNZOKGQY
         hBjRrfQLGhWbMX47TN0ipaqWDvEHDznTpj3FXipnP/kHAWSMGYyivTBHJ5FLCg+sEQO/
         pEM9X/d9yQ0GvaUUYSSFzs6qjmIbE/EndzlkeZKfz3V5VBgTuGYp6xjur7idAoe8TxJ0
         p8cF/4Isv1SZbtrrty80bCp+1tz4dxqiSbTBE/4i0IuCTY8BWvCQgt4Kan6OoYsgYpm5
         IRTmZO0UuOjJWo+mpSj97+o3hxtsLMerTj+WnxEkdH1htoOe9j+s/N42+4xmnPzl0jSn
         avxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ceZnDK/sKbEueEWuAoK1U45lE2R6s30snNQKMY7lKqQ=;
        fh=9VW+1w7iumsEyOVLR1pal2ryBvkKrhVd0peJpwWbwfA=;
        b=Aj42Xn5snJsX1M4J0GfMGkD2N9ot2u4l78Y9yBZoX+m0tB/Kt8CtDN8pFluvhJhaEz
         54PKmWRo3fdVkfKRdXUsofWNwz3lRn560PBEYqAx2onpRF34ZZzSHALbepcOZlLmYl0K
         4NSzbCKKZAMF/kyUGir47APfxvFoFPPbTRnJ2gu84RCb1UhZJpUULsemDKsxwr+w1HBS
         CgsV++iIuWZHkzb1toszp5sAUQrRT/9FFAmDTyOzLzrk2QmNVB9eqTbyxt3wESZsAfYP
         e13AGJVtAQA86X1/OLVRRSvuwq/kg1+x2ZfWwaNDeJ7uIHYCA/2jknCmzINf1wM2bNOJ
         P9fg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782312285; x=1782917085; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ceZnDK/sKbEueEWuAoK1U45lE2R6s30snNQKMY7lKqQ=;
        b=mvLyshfo2HtoIsrxqtHsiwTOdz/1XjptofLq+hajEjOyrbVkq6ooLYuoX/NvG/t2uI
         ctN0jyRwQfVuUzjBS3qo//q9JtjAZVzLVu9QDhBCew4LZomPUgRR5oTV8saO3emwCiiH
         II4v83CKmNLWVPSfsBFMaz7oE2PkQF+N1XuKxNj1f4OEhEqHtSOe5xvfBJ/HNrFnpzQE
         SpyYla5LyXmrK6e3RXb8ojitjruW+Mw31+1lexixjeP64XxMJD9eNJg8TvPKtdQgvB+R
         ec70O2t4cEp8JQIaQqUCM8WIiGLvUUSX9YOTHRS2wuyCGZ6QIKoYNiz3oCFKiPhwoYjy
         aBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782312285; x=1782917085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ceZnDK/sKbEueEWuAoK1U45lE2R6s30snNQKMY7lKqQ=;
        b=lMpD5UGofU+j8zDNTkvq/7zo4xkCEiJGBE3yhUqj0HvQ9QXge8p6/gahypZcQXQ6QJ
         k6rtQQDirxNV7JjPTtdvDb3DebmgHva6Px5UV79WOKIbVzwDZQ8fvYPkClftU/lwD1lS
         yCeE8AfeX1DDb+LOYo38CGYSmPuPYx4OCkW7Toxb6eQcIw7VmDgd6zZ0RTEnxmC/FQk1
         NrDemThFsKGCm42A64EVSUXR7V2jFAD9AZJSXmCEnDFzAQVbsUPKEORW+bc7ntXM0dJR
         hPV2JaV5Y31bYaJqFVQb9O+q8t/TQBhKfh3qJWeqt3VgwBqwZg0aGr8fVIOsEllYGT1s
         YsgQ==
X-Gm-Message-State: AOJu0YyDGSxuG04Y1NzWhB9YAvvsZBZJwS0bBAOOoopvx3YSF0mQ5E9p
	In6aQZnZFBkemzb6C1zZGWc7UHBqMQU7H4XxW+9Efr7xAmZpbNyE4XRS1B+NUKrjnhW37WyyTnj
	JaOP9N2ErquBKeQHjSdJy20UCyyJLndB7TNhn
X-Gm-Gg: AfdE7cm2NoBTZUsxm4asXkg1FPt5krPTwVVBNFU+Q+yTVXaLNagdhR4a+6dmkTGKXGn
	Jc+LKqWyRibd5FN6b+tHV1eQkScpLCvULE5WqEdmFXnNPVsU3MoBFw/otsgocVU0vy9gySoNpaO
	IceLE6+ElvprJEkBVM+oQWZyty/Ez9Jnm7YoRzBEhnT9PnMrT2IOQs4e4UjaI17AUaeS2LluCn9
	9sweMJs41PXAIFVwNMOeYfoEa0OF5OE7UmpXHVk2QPcOl8WIDhihubJt5TTe+CUpHrCPg==
X-Received: by 2002:a05:7300:214b:b0:2ed:e14:42e9 with SMTP id
 5a478bee46e88-30c68ec5a61mr4412177eec.34.1782312285061; Wed, 24 Jun 2026
 07:44:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMho2RfgwvNhWJidb_Xn3RRt71TFjQ2QBKP9Xt8ur22L-ZWP9A@mail.gmail.com>
 <20260609192542.GA3811606@google.com> <CAMho2Rem-B908oaFQzTx8Mg895LuvPcfN9+ANoHW+XfGW+wB6A@mail.gmail.com>
 <20260612183240.GA2157807@google.com> <CAMho2Re4pc4f_TkApfwsbfguiaN_Ccw770_A+0fc9G7L_GBAnA@mail.gmail.com>
In-Reply-To: <CAMho2Re4pc4f_TkApfwsbfguiaN_Ccw770_A+0fc9G7L_GBAnA@mail.gmail.com>
From: kstzavertaylo <kstzavertaylo@gmail.com>
Date: Wed, 24 Jun 2026 17:44:46 +0300
X-Gm-Features: AVVi8CfOGMG86JNsbfqdst4j4EWGC8WQsdk6iRyID4PX8ztGI8x5etSNnwj4gbI
Message-ID: <CAMho2Ren_PucPRyyTSySdniFfBLECBL+nxH3x6-5Mxsp+89iqw@mail.gmail.com>
Subject: Re: [RFC] ML-KEM (FIPS 203) implementation with reusable
 decapsulation pool
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Since our previous discussion, I have significantly updated the
userspace implementation and completed a series of benchmarks and
validation tests.

The implementation allocates all memory required for a given key
during key creation and subsequently operates entirely within that
preallocated memory until the key is destroyed.

During decapsulation, the same memory allocated at key creation is
reused across operations, eliminating runtime memory allocations in
the decapsulation path.


I compared the implementation against PQClean ML-KEM. The main observations=
 are:

* Stack usage remains approximately 1 KB regardless of the selected
ML-KEM security level.
* No memory allocations are performed during decapsulation.
* Throughput is generally comparable to PQClean.
* For ML-KEM-1024, the implementation is currently about 5=E2=80=938% slowe=
r
than PQClean.
* The trade-off is increased persistent memory consumption and a more
complex internal architecture based on reusable preallocated
resources.

I also took your earlier feedback into account and came to the
conclusion that integration through lib/crypto would be a better
direction than the KPP interface. As a result, I am now seriously
considering adapting the implementation for lib/crypto instead.

In addition, I am continuing to investigate further optimizations in
pure C. If these experiments produce meaningful results, I will
publish them and would be happy to share the findings in the future.

Benchmark results, methodology, stack usage measurements, memory usage
analysis, and PQClean comparisons are available here:

Release:
https://github.com/kstzv/ml-kem/releases/tag/v1.1.0

Benchmarks:
https://github.com/kstzv/ml-kem/tree/v1.1.0/portable/userspace/benchmarks

Thank you again for your earlier feedback.

Best regards,
K. S. Zavertailo

On Sun, Jun 14, 2026 at 10:50=E2=80=AFAM kstzavertaylo <kstzavertaylo@gmail=
.com> wrote:
>
> Thank you for the detailed feedback and for outlining the historical
> context regarding pools in the crypto subsystem.
>
>
> I understand your point of view and the preference for keeping the
> core implementation simple with per-operation allocations (or
> caller-provided workspaces), especially given the lack of precedent
> for pool-based designs in lib/crypto. My approach with the reusable
> decapsulation pool was driven by a focus on constrained environments
> where minimizing stack usage and relying on reusable preallocated
> working memory during the hot path can be particularly valuable.
> However, I fully agree that concrete data is needed to properly
> evaluate the trade-offs.
>
>
> I see your point regarding preallocated workspaces and caller-managed
> caching. One of the goals of my prototype was to explore a design
> where decapsulation operates on reusable preallocated contexts rather
> than per-call working memory, primarily to reduce stack requirements
> and move memory management into an initialization phase. I need to
> analyze more carefully how much of this can already be achieved
> through a caller-provided workspace model and whether the additional
> complexity of a dedicated pool is actually justified.
>
>
> I am currently working on benchmarks that compare stack consumption,
> allocation behavior, memory footprint, and performance between the
> different approaches. Once I have solid numbers, I will share the
> results and my conclusions.
>
>
> I also appreciate the clarification regarding KPP. My original
> prototype used KPP because it appeared to be the closest existing
> interface for key establishment, but I am not specifically attached to
> that approach and will spend some time evaluating how the same ideas
> could fit into the lib/crypto model as well. In the meantime, I will
> also look into how the pre-allocated workspace support you suggested
> could be integrated.
>
>
> Best regards,
> K. Zavertailo
>
>
> On Fri, Jun 12, 2026 at 9:32=E2=80=AFPM Eric Biggers <ebiggers@kernel.org=
> wrote:
> >
> > On Fri, Jun 12, 2026 at 05:14:54PM +0300, kstzavertaylo wrote:
> > > Thank you for the detailed reply and for pointing me to the existing
> > > ML-KEM/X-Wing patchset. I spent some time reviewing the implementatio=
n
> > > to better understand the design choices and how they compare to the
> > > approach I took in my own work.
> > >
> > > After reviewing the patchset, I can see several strengths in the
> > > implementation. It integrates cleanly into the existing lib/crypto
> > > infrastructure, reuses kernel cryptographic primitives, avoids large
> > > stack allocations, and includes KUnit-based validation. The
> > > implementation also appears intentionally compact and well aligned
> > > with existing kernel conventions.
> > >
> > > While reviewing the implementation, I noticed that decapsulation
> > > allocates a temporary workspace for each operation. This is one of th=
e
> > > areas where my design diverged, which is what originally motivated th=
e
> > > reusable pool approach.
> > >
> > > My implementation was developed with a somewhat different goal in
> > > mind. I experimented with a reusable decapsulation workspace model
> > > where memory is allocated during key initialization and then reused
> > > across subsequent decapsulation operations. The main motivation was
> > > reducing allocation frequency and minimizing both stack usage and
> > > repeated memory management during decapsulation.
> > >
> > > As a result, the implementation avoids allocations during
> > > decapsulation entirely by reusing preallocated workspaces associated
> > > with the key context. My original hypothesis was that moving memory
> > > allocation to key initialization, thereby eliminating allocations fro=
m
> > > the decapsulation path, could reduce allocation overhead during
> > > repeated decapsulation operations and be beneficial in environments
> > > where allocation activity is considered undesirable.
> >
> > In my ML-KEM code, all the decapsulation memory is consolidated into
> > struct mlkem_decap_workspace.  It would be straightforward to support
> > the caller providing a pre-allocated workspace.
> >
> > In the case of X-Wing, we could also support pre-expanding the
> > decapsulation key.
> >
> > It just depends on what is actually going to be needed by the kernel
> > feature(s) that are going to use this.  Which we don't really know yet.
> >
> > We do know that it hasn't been found to be useful for the crypto
> > subsystem to provide pools for any other algorithm in the kernel, for a
> > variety of reasons.  Usually callers can just allocate per-operation, o=
r
> > they have some sort of object (inode, block device, socket, etc.) that'=
s
> > a natural place for them to cache whatever they need anyway.  In the
> > rare cases where some sort of pool is needed it's implemented in the
> > caller, optimized for the particular use case.  So I think there's a
> > good chance your pool idea is going off on the wrong track.
> >
> > > Another difference is the integration level. My prototype explored
> > > direct integration through the KPP interface, whereas the patchset
> > > focuses on providing a reusable cryptographic library component withi=
n
> > > lib/crypto. These approaches address somewhat different layers of the
> > > kernel crypto stack.
> >
> > We don't need crypto_kpp support, as it's much more complex and harder
> > to use than the crypto library
> > (https://docs.kernel.org/crypto/libcrypto.html).  Also it seems it's no=
t
> > really possible anyway, since crypto_kpp is an old design that works fo=
r
> > Diffie-Hellman but not KEMs.
> >
> > - Eric
