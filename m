Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD22B537FE
	for <linux-crypto@vger.kernel.org>; Mon, 11 Dec 2023 20:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W45Ulq5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBF4C433CB;
	Mon, 11 Dec 2023 20:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702326461;
	bh=xKFe2YCP0owG+PMR65Uk7wgCp72Kqzn6CiBGLIKZk2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W45Ulq5NnHf+eu4swJyOhJ2YY8hvS0/xKjkTQnNJ6QQx4ybXRJJStNqiPpNAphEQ/
	 aLYQTWgBRdSjqo5+JJZ0gZFCo7Arb820zAJBJAvvcJds6pFKqivVJXHVnjoS8Ud+J/
	 o/CDTOZhkmzAggO5qZxig5ZUV/dMF15lyc2Ab2CvUpdFsNGV/+lOcpikbZwsd9dk64
	 2CJG6tPCR2QtfMhenv+kmsvmdes97LQj8j9OPTFqFhQceHerOw/PEB8xRaDo4e2mu8
	 h8De1RUZNlu5hriP/A59RdBszqGsM1IrgbySf232YUb6Cm2jltISfB55hxcldnoXBO
	 0b+IpNXPNd9pg==
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@google.com>,
	linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Eric Biggers <ebiggers@google.com>,
	Kees Cook <keescook@chromium.org>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 0/4] arm64: Run kernel mode NEON with preemption enabled
Date: Mon, 11 Dec 2023 20:27:27 +0000
Message-Id: <170231871028.1857077.10318072500676133330.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20231208113218.3001940-6-ardb@google.com>
References: <20231208113218.3001940-6-ardb@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hey Ard,

On Fri, 8 Dec 2023 12:32:19 +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Currently, kernel mode NEON (SIMD) support is implemented in a way that
> requires preemption to be disabled while the SIMD registers are live.
> The reason for this is that those registers are not in the set that is
> preserved/restored on exception entry/exit and context switch, as this
> would impact performance generally, even for workloads where kernel mode
> SIMD is not the bottleneck.
> 
> [...]

I applied the first three patches to for-next/fpsimd:

[1/4] arm64: fpsimd: Drop unneeded 'busy' flag
      https://git.kernel.org/arm64/c/e109130b0e5e
[2/4] arm64: fpsimd: Preserve/restore kernel mode NEON at context switch
      https://git.kernel.org/arm64/c/1e3a3de1ff6c
[3/4] arm64: fpsimd: Implement lazy restore for kernel mode FPSIMD
      https://git.kernel.org/arm64/c/035262623959

It would be nice to have an Ack from Herbert on the last one so that
he's aware of the possible conflicts.

The other thing I tangentially wondered about is what happens now if code
calls uaccess routines (e.g. get_user()) within a kernel_neon_{begin,end}
section? I think previously the fact that preemption had to be disabled
would've caused the might_fault() to explode, but now I suppose the BUG_ON()
in kernel_neon_begin() will save us. Is that right?

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
