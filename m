Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79093315A7
	for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aQJw8k8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBA2C433C8
	for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 15:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701098283;
	bh=q61v1sAcs4eH9MGgr5HHVpAWAuhHhcBVwM2Xjr0zyt0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aQJw8k8Ab1ZhNuzFszdCXdVfuI43cyi9YathMm+TKrZTYcyFerZJ+/2SRuCrbYLIV
	 +TmnWYh43/m8wqc7JBX4F8DKN6x2h16hzHSnh36cRQnFWZFgfXNVE9lBs5jFzmI7Qz
	 hGt0BhQTEd7neiPXMmFGNye2ubJInBXLlUkj7xc3MDlwJW05X6tkRE8NcnEQa3UQKX
	 vI4Clmj9An+RK5ATpuephFnFZfsspjI8B6zoIyNsOaGTU+o+K3N4kMM9jmJgaU0pkl
	 +xeoyjrp4psq5+RxdHrNsZDQqoksedA728DBQZ7T4yUrJhdU7MndBGAVY6g5ql5/R7
	 7VezNIcWiPR1w==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2c503da4fd6so52663851fa.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 07:18:02 -0800 (PST)
X-Gm-Message-State: AOJu0Yw5VDf0e0U98nakRdEChltGmvtza8QB4JJUN/GXMwxD7ctsZ3/S
	aoOkaJJFBC6haiHJzIb58RE5cdlT91Vn4mtxxIk=
X-Google-Smtp-Source: AGHT+IFmjXvhZEmpqDwgr2c2XCz6Z1ABK9KdU0X9ofveSo4GWP+x+T3tComUTL4xxZN/SzP1OwTPJp33183H1F+a4KU=
X-Received: by 2002:a2e:545d:0:b0:2c9:a495:2a42 with SMTP id
 y29-20020a2e545d000000b002c9a4952a42mr1786917ljd.16.1701098281114; Mon, 27
 Nov 2023 07:18:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231127122259.2265164-7-ardb@google.com> <20231127122259.2265164-11-ardb@google.com>
 <ZWSdsUIcCCuWlVhM@FVFF77S0Q05N>
In-Reply-To: <ZWSdsUIcCCuWlVhM@FVFF77S0Q05N>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 27 Nov 2023 16:17:49 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE47vFVQjrdjx63u=zTjDSrrscvinACK0WfdZHBB-g2hQ@mail.gmail.com>
Message-ID: <CAMj1kXE47vFVQjrdjx63u=zTjDSrrscvinACK0WfdZHBB-g2hQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] arm64: crypto: Remove conditional yield logic
To: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ardb@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Will Deacon <will@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Eric Biggers <ebiggers@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Nov 2023 at 14:46, Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Mon, Nov 27, 2023 at 01:23:04PM +0100, Ard Biesheuvel wrote:
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > Some classes of crypto algorithms (such as skciphers or aeads) have
> > natural yield points, but SIMD based shashes yield the NEON unit
> > manually to avoid causing scheduling blackouts when operating on large
> > inputs.
> >
> > This is no longer necessary now that kernel mode NEON runs with
> > preemption enabled, so remove this logic from the crypto assembler code,
> > along with the macro that implements the TIF_NEED_RESCHED check.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> I definitely want to get rid of all of the voluntary preemption points, but
> IIUC for the moment we need to keep these for PREEMPT_NONE and
> PREEMPT_VOLUNTARY (and consequently for PREEMPT_DYNAMIC). Once the preemption
> rework lands, these should no longer be necessary and can be removed:
>
>   https://lore.kernel.org/lkml/20231107215742.363031-1-ankur.a.arora@oracle.com/
>

Oh, right - yeah, good point.

So until that lands, we could at least simplify cond_yield and go back
to the original logic, given that yielding to a pending softirq will
no longer be necessary. (The original logic does not deal with
softirqs specifically, but relies on the preempt_count() not being
equal to PREEMPT_DISABLE_OFFSET to avoid yielding in sofirq context
unnecessarily)

This also means that only PREEMPT_VOLUNTARY is implicated here -
PREEMPT_NONE only has the yield-to-pending-softirq behavior atm.
