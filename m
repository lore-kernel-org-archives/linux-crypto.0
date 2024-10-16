Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B70920F5AB;
	Wed, 16 Oct 2024 16:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729095853; cv=none; b=CJ51kU9YvLunYJP4GVzx/2kCsqtTKVkVSPA/X9LxEYw94ZnvPIL73s7NeD29MpR4CIswD5En1POmR1Lwaz4EzGCvfwZd48IL0ske/uOEdNsBEw9k6vED0PRbRuUuG6rjnitpY8N5S70qbmV/Y13qwe4MZYlXJfselUjVMp+2BwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729095853; c=relaxed/simple;
	bh=ELkQCkvnvsqAkcqwDniUM4x92rERmqEI7Yu0ccyKwIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SyNYgz0KXyoy8i5Z86MK9OLD5qGnWyq6qpl0bCBmTD1Qc4cgAn7E6F1bPG9ze73reT5xV8TDOuY9K0VydN6TYBdMnSy0PRPwvoEcQM7Ee5/Sj+oCV6TgI5Su6Ta4DCwhC1TOrBVghPGNCNIFFaAoHkViqBJWwW69WBwd4UAYKMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LI1p4dZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LI1p4dZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238EBC4CEC5;
	Wed, 16 Oct 2024 16:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729095853;
	bh=ELkQCkvnvsqAkcqwDniUM4x92rERmqEI7Yu0ccyKwIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LI1p4dZ0tqVMNN2oq8AWE3gnu4GavO7BVvIZE+MP92vuVOQ9b5kFaDnCJbr0k3l+j
	 10CIWlynzgTSz9CnLiXHZROmYp8a040ZXnuDwnW6/CJDxq9DaZMNCYUOHtH95XaAqt
	 PA6nn93gtOgH9k6lj1mmfoi0A2+pWKWoLJfgGVIa+19P5aEq/x2J/dWoPkajOVxORO
	 XFfSRURIiS7A2ZSKdGgrgLUuE5T/vcD1Jrwip43/lERBW0IcTNSgIedKMZsM8uSVqp
	 5gtLUO9F0KcGpRZ2UakmZd1ElpWWJQp26iZTSaS/TjVCykxE2tZ3pQDPIOV0p4Fo1q
	 cAbjMnKQL33HA==
Date: Wed, 16 Oct 2024 16:24:11 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	will@kernel.org, catalin.marinas@arm.com,
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH 2/2] arm64/crc32: Implement 4-way interleave using PMULL
Message-ID: <20241016162411.GA3228925@google.com>
References: <20241015104138.2875879-4-ardb+git@google.com>
 <20241015104138.2875879-6-ardb+git@google.com>
 <20241016030349.GD1138@sol.localdomain>
 <CAMj1kXHDqD29TzE=2cw55qeKrnybgkYFCdy4jU_4E=OaUOkZNg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHDqD29TzE=2cw55qeKrnybgkYFCdy4jU_4E=OaUOkZNg@mail.gmail.com>

On Wed, Oct 16, 2024 at 09:12:41AM +0200, Ard Biesheuvel wrote:
> > I'd recommend calling the file crc32-4way.S and the functions
> > crc32*_arm64_4way(), rather than crc32-pmull.S and crc32*_pmull().  This would
> > avoid confusion with a CRC implementation that is actually based entirely on
> > pmull (which is possible).
> 
> I'm well aware :-)
> 
> commit 8fefde90e90c9f5c2770e46ceb127813d3f20c34
> Author: Ard Biesheuvel <ardb@kernel.org>
> Date:   Mon Dec 5 18:42:27 2016 +0000
> 
>     crypto: arm64/crc32 - accelerated support based on x86 SSE implementation
> 
> commit 598b7d41e544322c8c4f3737ee8ddf905a44175e
> Author: Ard Biesheuvel <ardb@kernel.org>
> Date:   Mon Aug 27 13:02:45 2018 +0200
> 
>     crypto: arm64/crc32 - remove PMULL based CRC32 driver
> 
> I removed it because it wasn't actually faster, although that might be
> different on modern cores.

The PMULL-based code removed by commit 598b7d41e544 was only 4-wide.  On
Apple M1, a 12-wide PMULL-based CRC32 is actually faster than 4-way CRC32,
especially if the eor3 instruction from the sha3 extension is utilized.

This was not the case on non-Apple CPUs I tested (in 2022), though.  12-wide is
very wide and is a bit inconvenient, and IMO it's not worth doing in the kernel
at this point.  It would be interesting to test the very latest CPUs, though.

- Eric
