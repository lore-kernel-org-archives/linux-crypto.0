Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C85517BA3;
	Fri, 28 Feb 2025 03:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740715166; cv=none; b=tSum3rk7OHsUcyx9igsHFje8jFKnwvCmAm8BEdBxMWpUUDgz7YLf+Ju3zT6hYgWto9Oqx+nx1eBSnHWw/KuAB4KTvbMCy2/VAJI7I9Y1IfLIRt94Jlx80VeAZEmqtUHgOheV17K93r3B6v8/14lJ8SrOU5X7hBLy63XXalMiRos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740715166; c=relaxed/simple;
	bh=ArfEYZz4GlakOZn+fxr8JvCWk6hf3JRUorekS8EsSW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MByYNlHeuloCcLhrnz5Y6E56TgWHV7y8B4KoS34l8/GN5g4z9w9yYJyQdwJAO1BevB8UOnD9Jz7yOEeEBW46h/due8QWxifDAQgGlMsDgVoVIhXpwiTRuTF7EutzgrLLdVRhhqXm+7D5aQ465A0Rbu6t+gJV4Rb+YRzhPMus9HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FA2YF5hA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FA2YF5hA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C977C4CED6;
	Fri, 28 Feb 2025 03:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740715165;
	bh=ArfEYZz4GlakOZn+fxr8JvCWk6hf3JRUorekS8EsSW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FA2YF5hAfLwQZGh8cqCinGkc2XAqedmTQg8sSEPti45e4RhIjmIzbFqRZamJ9gjb6
	 UqRuxCABAEH3Yg6OPSsxgqufv6mgHEwBbv25Upxt7b7z9SP4YGRRh41/nwCT8o4E5/
	 8UH3KcfsyXGLydudB7yVUl5XE15cQeeLUfiEoI/1gNP6nmWaHRsStmxVCtTYPqMY3Z
	 M1m35oyHo3X5JGzpRqs/cN8Q92lREJD8LsGsJ7PuQozPMQskKa8gB4KSIGKJicOyOl
	 UW4eWRFQ8jO946eld5ft03xv9Y8Muy3Ils86Xttg289wpl4RzeqUvEKiafyxHJZ5Ug
	 jQ17yySR/BcpA==
Date: Thu, 27 Feb 2025 19:59:24 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Xiao Liang <shaw.leon@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH 1/2] x86/fpu: make kernel-mode FPU reliably usable in
 softirqs
Message-ID: <20250228035924.GC5588@sol.localdomain>
References: <20250220051325.340691-1-ebiggers@kernel.org>
 <20250220051325.340691-2-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220051325.340691-2-ebiggers@kernel.org>

On Wed, Feb 19, 2025 at 09:13:24PM -0800, Eric Biggers wrote:
> To comply with the requirements of local_bh_disable and local_bh_enable,
> this change also removes support for kernel-mode FPU in hardirq context
> or with hardirqs disabled.  This should not be a problem, though.  There
> does not appear to be any use case for kernel-mode FPU in such contexts,
> and notably arm64 and riscv already have these same conditions.

I found a problem with this assumption: the system suspend and resume code calls
kernel_fpu_begin() and kernel_fpu_end() with hardirqs disabled.  See
__save_processor_state() and __restore_processor_state() in
arch/x86/power/cpu.c.  That triggers the WARN_ON_FPU(!irq_fpu_usable()).

I think there are two directions we could go with this: either choose a solution
that keeps kernel_fpu_begin() usable with hardirqs disabled; or change
__save_processor_state() and __restore_processor_state() to save/restore the FPU
registers directly, e.g. via save_fpregs_to_fpstate() and
restore_fpregs_from_fpstate().  (Kernel-mode FPU isn't actually being used in
this case, so a more direct save/restore might make sense here.)

- Eric
