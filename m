Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5F77F5
	for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2023 08:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RkKFiRBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A49C433C9
	for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2023 08:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702368986;
	bh=rda77atF9tL/SazTiETXJS/w0A0m5Bw3q6mdv2bB/Po=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RkKFiRBtPEYpgJvGynwIAFG2LIOLY7a10skpL61Zub+H71xrPitzZh0xoDUqlIQHw
	 SMFjwU5VQfafBDfHxzYSzcbL1Rr/86QLINEvsRYCSiSdIMfccsAxcbHhXezQD+lC84
	 j1z6SU5KlLkoEoD79OomW42g6cnUuaAwbDWgSF7SapuWExgN1MMfoq3VtSYI18PQPB
	 PvuK95U3pO7uVTOrS5mZ7MbCgYuapfPKTSKz5P0XoBYPGiwUR7NbkNxofhxoP0+Q5v
	 7wpgMxvKo+JEqWDilyLutotqmy6qqTrXLve3fNFPi37w8RoFpyLglXA7jYPDmKcvfq
	 tMfJ7LVoVvt1Q==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2c9f7fe6623so67431581fa.3
        for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2023 00:16:25 -0800 (PST)
X-Gm-Message-State: AOJu0YyRSV/2ngFZ489WFuOzRToPfbLTJZpNBSFKIXLs3r1J8yzhFB/+
	CGxus+WeIG0I5nqGG4FVHwd+QBLrAxrZishxmf8=
X-Google-Smtp-Source: AGHT+IGfyeib3plbT3Opi1qkmSbvHY0qJxpeRs1qjYVc223MsQWRFvKpXG7nOQMk0XsCslbUE7Uf2XgTaKSD02gE0nI=
X-Received: by 2002:a05:651c:549:b0:2cb:30e6:540d with SMTP id
 q9-20020a05651c054900b002cb30e6540dmr1415462ljp.76.1702368984187; Tue, 12 Dec
 2023 00:16:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208113218.3001940-6-ardb@google.com> <170231871028.1857077.10318072500676133330.b4-ty@kernel.org>
In-Reply-To: <170231871028.1857077.10318072500676133330.b4-ty@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 12 Dec 2023 09:16:13 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE=2H_Jqyuv_gDp6QS2g2Vzdgf=fngp=ZXEUBXKOYWnbQ@mail.gmail.com>
Message-ID: <CAMj1kXE=2H_Jqyuv_gDp6QS2g2Vzdgf=fngp=ZXEUBXKOYWnbQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] arm64: Run kernel mode NEON with preemption enabled
To: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@google.com>, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, kernel-team@android.com, 
	Mark Rutland <mark.rutland@arm.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Eric Biggers <ebiggers@google.com>, Kees Cook <keescook@chromium.org>, 
	Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 11 Dec 2023 at 21:27, Will Deacon <will@kernel.org> wrote:
>
> Hey Ard,
>
> On Fri, 8 Dec 2023 12:32:19 +0100, Ard Biesheuvel wrote:
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > Currently, kernel mode NEON (SIMD) support is implemented in a way that
> > requires preemption to be disabled while the SIMD registers are live.
> > The reason for this is that those registers are not in the set that is
> > preserved/restored on exception entry/exit and context switch, as this
> > would impact performance generally, even for workloads where kernel mode
> > SIMD is not the bottleneck.
> >
> > [...]
>
> I applied the first three patches to for-next/fpsimd:
>

Thanks

> [1/4] arm64: fpsimd: Drop unneeded 'busy' flag
>       https://git.kernel.org/arm64/c/e109130b0e5e
> [2/4] arm64: fpsimd: Preserve/restore kernel mode NEON at context switch
>       https://git.kernel.org/arm64/c/1e3a3de1ff6c

I spotted a typo in the commit log of this patch:

TIF_USING_KMODE_FPSIMD -> TIF_KERNEL_FPSTATE


> [3/4] arm64: fpsimd: Implement lazy restore for kernel mode FPSIMD
>       https://git.kernel.org/arm64/c/035262623959
>
> It would be nice to have an Ack from Herbert on the last one so that
> he's aware of the possible conflicts.
>
> The other thing I tangentially wondered about is what happens now if code
> calls uaccess routines (e.g. get_user()) within a kernel_neon_{begin,end}
> section? I think previously the fact that preemption had to be disabled
> would've caused the might_fault() to explode, but now I suppose the BUG_ON()
> in kernel_neon_begin() will save us. Is that right?
>

Not sure what you mean by 'save us'. Is there anything fundamentally
wrong with doing user access from a kernel mode NEON region if
preemption remains enabled?

The BUG_ON() will only catch uses from hardirq/NMI context, or cases
where FP/SIMD is not implemented/enabled in the first place so it will
not trigger on a user access.
