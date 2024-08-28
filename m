Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CCC18C919
	for <linux-crypto@vger.kernel.org>; Wed, 28 Aug 2024 16:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724861066; cv=none; b=PWz36qCyIEUkBaET6ZAT/T5tImzBgFAL4KrwzXZTWtzV3DqahJd6v9D6QZAEZldWWbcOggfsq29LW+zltKaD/W2HMAhmuxBB0U9t1Xc193t0TOBe77bnI4uoFpU7tozLS6wIi4BvpD99At6AnDcVcOMzVU/0BFSNWu7KjS9heyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724861066; c=relaxed/simple;
	bh=EZflIP148zRNH1HopvuiP9aGfBIdX6qjv1OaONSHI0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iosX+uwel2hz3lgE1XYK/MvPWo0L6r2IkX4Ct5ZcqurJ9ttd9cKMWTcvI7KIp4+lItve1Ds7JaWw2GSNJ1nMolDxJSbyKXkgGmXjFmMVdAAVTGCNILZ1DWoG50r3BepmR7tb0JsFAdLEYVLdzJeJNClyBBSKhuOuhfFqUTMf15U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iRc8eaKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iRc8eaKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6B0C4CEDF
	for <linux-crypto@vger.kernel.org>; Wed, 28 Aug 2024 16:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724861066;
	bh=EZflIP148zRNH1HopvuiP9aGfBIdX6qjv1OaONSHI0k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iRc8eaKg1EQXWOkxLNzrAtyj6h84dsLx4LeI+GRtCFc0PcEvMMQWetwq+QZzipbo+
	 IXeBMGiggbS4LyLSzyxNS9UssHgAx4X+QJ/O+tbFoRfCe4drMemgro3M6a2BMPTPyz
	 3BHO3iEPy+qDOMD6rhw774OFZ4BlwgeNLiRODrVm7G0FCCYzbpSp9I4kV7HUnn4WPI
	 Qjr8qMIEkxRk30mH2Q7obnbKFryvT2rwwIpLuC3DebHXXFvZZM55xfB+gEY/JjzdUn
	 5cenByq5EUhkE4lcbCNmQRw7DKXLMHDOGmbU4GzFwsDFPZ7um17nky0kvdj/YfAG5L
	 Xf3f98iOht9qQ==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2f5064816edso46919371fa.3
        for <linux-crypto@vger.kernel.org>; Wed, 28 Aug 2024 09:04:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXf9dPdzvM0ZSLyBlYO9BEuHxOHMuniS23IL7IDEZEGuCsLs0gRaXLJYw2Wq+qBR8eroDj/857meDX4mMw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuLVmA1Enjw/UpeD4hF8sI0bONSp3R9czChltM5h6QAwc+/U9Z
	8SL2hyoswhyRZorKqEYMvU6QrbkkHiKbMl+Luuwzyx5e9smfTLM0oT8pPIUAx1jZB574BwW46ax
	c+HzSrBUINul7+jL3kkU48C8C0fw=
X-Google-Smtp-Source: AGHT+IGZ9eAbtGbP6k2DL2CdWgBafYQgr9qvdwmrMOzGw5bW1THsb6HKw9tHITYEANxH06roEhEsTHvxplpV+Ixobms=
X-Received: by 2002:a05:6512:3503:b0:533:4aa1:a517 with SMTP id
 2adb3069b0e04-5346c63be33mr2088433e87.36.1724861064094; Wed, 28 Aug 2024
 09:04:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20201210121627.GB28441@gondor.apana.org.au> <CAMj1kXE-+35tfO87024xB274ZVOu7HTHqDa8o-hjoxDasd8p7g@mail.gmail.com>
 <CAMj1kXH5LPib2vPgLkdzHX4gSawDSE=ij451s106_xTuT19YmA@mail.gmail.com>
 <20201215091902.GA21455@gondor.apana.org.au> <062a2258-fad4-2c6f-0054-b0f41786ff85@candelatech.com>
 <Y2sj84u/w/nOgKwx@gondor.apana.org.au> <CAMj1kXG3id6ABX=5D4H0XLmVnijHCY6whp09U5pLQr0Ftf5Gzw@mail.gmail.com>
 <6e20b593-393c-9fa1-76aa-b78951b1f2f3@candelatech.com> <CAMj1kXEqcPvb-uLvGLhue=6eME-6WhuPgoG+HgLH0EoZLE9aZA@mail.gmail.com>
 <32a44a29-c5f4-f5fa-496f-a9dc98d8209d@candelatech.com> <20231017031603.GB1907@sol.localdomain>
 <CAMj1kXFRpbGJ_nkomb88o3F5Eg9ghh+xTZgGgeD7wfC3uwSk0g@mail.gmail.com> <ec3270e2-52d7-434b-8e05-d6a4df5f0af8@candelatech.com>
In-Reply-To: <ec3270e2-52d7-434b-8e05-d6a4df5f0af8@candelatech.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 28 Aug 2024 18:04:11 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFP3fT0TaxfukRegRE+5XqQ+i+CCLmK5ComgGkpS6ANbA@mail.gmail.com>
Message-ID: <CAMj1kXFP3fT0TaxfukRegRE+5XqQ+i+CCLmK5ComgGkpS6ANbA@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To: Ben Greear <greearb@candelatech.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 3 Aug 2024 at 19:20, Ben Greear <greearb@candelatech.com> wrote:
>
> On 10/16/23 23:43, Ard Biesheuvel wrote:
> > On Tue, 17 Oct 2023 at 05:16, Eric Biggers <ebiggers@kernel.org> wrote:
> >>
> >> On Mon, Oct 16, 2023 at 01:50:05PM -0700, Ben Greear wrote:
> >>> On 11/12/22 06:59, Ard Biesheuvel wrote:
> >>>> On Fri, 11 Nov 2022 at 23:29, Ben Greear <greearb@candelatech.com> wrote:
> >>>>>
> >>>>> On 11/9/22 2:05 AM, Ard Biesheuvel wrote:
> >>>>>> On Wed, 9 Nov 2022 at 04:52, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >>>>>>>
> >>>>>>> On Tue, Nov 08, 2022 at 10:50:48AM -0800, Ben Greear wrote:
> >>>>>>>>
> >>>>>>>> While rebasing my patches onto 6.1-rc4, I noticed my aesni for ccm(aes) patch didn't apply cleanly,
> >>>>>>>> and I found this patch described below is applied now.  Does this upstream patch mean that aesni is already
> >>>>>>>> supported upstream now?  Or is it specific to whatever xctr is?  If so,
> >>>>>>>> any chance the patch is wanted upstream now?
> >>>>>>>
> >>>>>>> AFAICS the xctr patch has nothing to do with what you were trying
> >>>>>>> to achieve with wireless.  My objection still stands with regards
> >>>>>>> to wireless, we should patch wireless to use the async crypto
> >>>>>>> interface and not hack around it in the Crypto API.
> >>>>>>>
> >>>>>>
> >>>>>> Indeed. Those are just add/add conflicts because both patches
> >>>>>> introduce new code into the same set of files. The resolution is
> >>>>>> generally to keep both sides.
> >>>>>>
> >>>>>> As for Herbert's objection: I will note here that in the meantime,
> >>>>>> arm64 now has gotten rid of the scalar fallbacks entirely in AEAD and
> >>>>>> skipcher implementations, because those are only callable in task or
> >>>>>> softirq context, and the arm64 SIMD wrappers now disable softirq
> >>>>>> processing. This means that the condition that results in the fallback
> >>>>>> being needed can no longer occur, making the SIMD helper dead code on
> >>>>>> arm64.
> >>>>>>
> >>>>>> I suppose we might do the same thing on x86, but since the kernel mode
> >>>>>> SIMD handling is highly arch specific, you'd really need to raise this
> >>>>>> with the x86 maintainers.
> >>>>>>
> >>>>>
> >>>>> Hello Ard,
> >>>>>
> >>>>> Could you please review the attached patch to make sure I merged it properly?  My concern
> >>>>> is the cleanup section and/or some problems I might have introduced related to the similarly
> >>>>> named code that was added upstream.
> >>>>>
> >>>>
> >>>> I don't think the logic is quite right, although it rarely matter.
> >>>>
> >>>> I've pushed my version here - it invokes the static call for CTR so it
> >>>> will use the faster AVX version if the CPU supports it.
> >>>>
> >>>> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=aesni-ccm-v6.1
> >>>
> >>> Hello Ard,
> >>>
> >>> It looks like something changed again in the intel-aesni logic for 6.6 kernel.  I was able to do a small
> >>> change to the patch to get it to compile, but the kernel crashes when I bring up a wlan port in
> >>> 6.6.  When I remove the aesni patch, the station comes up without crashing.  The aesni patch worked
> >>> fine in 6.5 as far as I can tell.
> >>>
> >>> I'm attaching my slightly modified version of the patch you sent previous.  If you have time to
> >>> investigate this it would be much appreciated.
> >>>
> >>> Thanks,
> >>> Ben
> >>
> >> If this patch is useful, shouldn't it be upstreamed?
> >>
> >
> > It was rejected by Herbert on the basis that the wireless stack should
> > be converted to use the async API instead.
>
> Hello,
>
> I'm still dragging this patch along (see attached).  I notice that there was a big re-write of
> the aesni logic in 6.11.  Anyone know if this patch would need to be (or should be)
> modified to work well with the new upstream code?
>

Those changes should be mostly orthogonal, so beyond resolving lexical
conflicts, I wouldn't expect any additional work to be needed to
forward port this.
