Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D783AC00;
	Sat,  9 May 2026 20:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778357128; cv=none; b=ZRnLPqcZLkIThyLNhYadf1lLJziyom6bxw/PW2EaE++zXmOhVu9eg3CIgjvEnIT7cMtqaBV8DJ9EIi7VFPnYCJc/7mS787bkxNLVbeXoilRh2gBERYxJwBMphbjUpw1dSo+zUjIs9nyGq+qlGh8oKL8TUvmKlpReaGEyzrA7f+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778357128; c=relaxed/simple;
	bh=gvCfoipjvFSyuB+Z6RDe06egz90snb/tb6jiKwmbmKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/sFpuJVEChj1c8J/j6nSEA+DoFXjd/SrKk7yljuPv0W/0afb5auFToEB+AHF7b/W9eZtDv/oVQwoYknFCqkqRA1CDQCUnlkxj7u02pjgb+b2KKcW6pDd6BPhSA7QFXfE2Vo2Hiv2bnOJNFsHiUevOn9+p5FRNE/Ju9iZnpz/QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dL+hgRhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dL+hgRhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6A4C2BCC4;
	Sat,  9 May 2026 20:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778357128;
	bh=gvCfoipjvFSyuB+Z6RDe06egz90snb/tb6jiKwmbmKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dL+hgRhySxvqBvd+CeLOETC9BXBE66RyuUS1bGENnBgeC4+xBbGhzL0VAy5fkUXKs
	 wkWg3HHJlGUUXAegTxBYQTJpmhlIEs796fBoARee4ClWIx61D2SegbFrL7eD9mfFsV
	 Cr6CmpBZ++mgxVGSco7m+zemEbpOPw4QzL/9fnRfYSv66sbI2Urx+pAXp6aDTIFPUE
	 C017ypxymB8L9MxDL/b6rHRtgIU20gJHDG1Jd3VKu7PHa+0j4glxGz/SPDS18CgYiP
	 sEw3VAzmGfA9UPVoYMMgl8Uvpbgp5e5ir3Wdp2biSQOQfrNgTOVNMQgW4ZjB3tvHWe
	 bTX7P0/myIb5g==
Date: Sat, 9 May 2026 13:05:03 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-raid@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 8/8] ARM: Remove hacked-up asm/types.h header
Message-ID: <20260509200503.GC11883@quark>
References: <20260422171655.3437334-10-ardb+git@google.com>
 <20260422171655.3437334-18-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422171655.3437334-18-ardb+git@google.com>

On Wed, Apr 22, 2026 at 07:17:04PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> ARM has a special version of asm/types.h which contains overrides for
> certain #define's related to the C types used to back C99 types such as
> uint32_t and uintptr_t.
> 
> This is only needed when pulling in system headers such as stdint.h
> during the build, and this only happens when using NEON intrinsics,
> for which there is now a dedicated header file.
> 
> So drop this header entirely, and revert to the asm-generic one.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm/include/uapi/asm/types.h | 41 --------------------
>  1 file changed, 41 deletions(-)
> 

This is actually a UAPI header.  I guess it got put there accidentally
and isn't actually needed there?

- Eric
