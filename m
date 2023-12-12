Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068FB53815
	for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2023 10:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8p/TsfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF15C433C8;
	Tue, 12 Dec 2023 10:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702378519;
	bh=s2JNh92769JXDjX+tRer5QC+0r1XR8VxRjUPp8VSJ8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U8p/TsfRprRxToug9Ovpb7T/deNKuOKurqqDMt0NItyspaQyCNHZ31rCnU2/SXOre
	 +E8AK5v/qGWws8ra/mlXrVIByKSrUrNIY9n8jbWB4QXaN6giXmwXYgX2Z0uH4/FAfn
	 hKPGUzVJ4NB8FlzE3DwdT1oHsbzuoq7zD6udN9QGfX4MnM0XIE4tiiKycWiTWNhjq9
	 uKTOI06vIL2YuqPj4ifBxCNdUC4ir7ENeBuzGz+UkKfxYmeNbVj9cFIJoMvsCw7OGU
	 Xpm71dWXkAVCzuoIsW6DjIqYzfCdrvqw7RVgp+x6/3amnu7YBk9z67NMVxfh6SH5UG
	 dPblU6q9AOpQw==
Date: Tue, 12 Dec 2023 10:55:13 +0000
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ard Biesheuvel <ardb@google.com>, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, kernel-team@android.com,
	Mark Rutland <mark.rutland@arm.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Eric Biggers <ebiggers@google.com>,
	Kees Cook <keescook@chromium.org>, Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 0/4] arm64: Run kernel mode NEON with preemption
 enabled
Message-ID: <20231212105513.GA28416@willie-the-truck>
References: <20231208113218.3001940-6-ardb@google.com>
 <170231871028.1857077.10318072500676133330.b4-ty@kernel.org>
 <CAMj1kXE=2H_Jqyuv_gDp6QS2g2Vzdgf=fngp=ZXEUBXKOYWnbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXE=2H_Jqyuv_gDp6QS2g2Vzdgf=fngp=ZXEUBXKOYWnbQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Dec 12, 2023 at 09:16:13AM +0100, Ard Biesheuvel wrote:
> On Mon, 11 Dec 2023 at 21:27, Will Deacon <will@kernel.org> wrote:
> > [1/4] arm64: fpsimd: Drop unneeded 'busy' flag
> >       https://git.kernel.org/arm64/c/e109130b0e5e
> > [2/4] arm64: fpsimd: Preserve/restore kernel mode NEON at context switch
> >       https://git.kernel.org/arm64/c/1e3a3de1ff6c
> 
> I spotted a typo in the commit log of this patch:
> 
> TIF_USING_KMODE_FPSIMD -> TIF_KERNEL_FPSTATE

Cheers, I'll go in and fix that (so the SHAs will change).

> > [3/4] arm64: fpsimd: Implement lazy restore for kernel mode FPSIMD
> >       https://git.kernel.org/arm64/c/035262623959
> >
> > It would be nice to have an Ack from Herbert on the last one so that
> > he's aware of the possible conflicts.
> >
> > The other thing I tangentially wondered about is what happens now if code
> > calls uaccess routines (e.g. get_user()) within a kernel_neon_{begin,end}
> > section? I think previously the fact that preemption had to be disabled
> > would've caused the might_fault() to explode, but now I suppose the BUG_ON()
> > in kernel_neon_begin() will save us. Is that right?
> >
> 
> Not sure what you mean by 'save us'. Is there anything fundamentally
> wrong with doing user access from a kernel mode NEON region if
> preemption remains enabled?
> 
> The BUG_ON() will only catch uses from hardirq/NMI context, or cases
> where FP/SIMD is not implemented/enabled in the first place so it will
> not trigger on a user access.

As discussed off-list, the vague concern was if kernel_neon_begin() is
nested off the back of a user fault. The BUG_ON() should fire in that case,
so we're all good.

Thanks!

Will
