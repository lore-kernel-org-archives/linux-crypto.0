Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC4A2661B7;
	Mon, 24 Feb 2025 18:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740420376; cv=none; b=MoMDWw0Bjh2b21lgpyqx5zAOgLeYXFd5hX2YFC0J3KiSz8W7UMWwjsX9x25ciFmOTpNrrAG+YJektWM8puudrWUgiQ/cZAUpNfSF7d60n+zdG/quJXgS40FppjeJgxTzAdgaI9rFAKLY7DkS2cSSyPZGjocHBE76lsEbWijn6Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740420376; c=relaxed/simple;
	bh=fLLXimX9ynfgWBIWIxxfLc92QfSdbBwQm11gCIosTSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mcvl7SnGMBM1d2yVzVNMVo+xC75XqyvHwDCfZjqbd6/FrG2T154qEckEZ+MsvDXmJ93q0JWmgPjB1UCPWmjHy8JX4UIGHaHfuJm8VYqGzizYkAL9WkfEbo1peFc1Lp60nPjOweB292Holn8zIUtnKlreKgSSnTtN8lWRxBUmQTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AeCL1aaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AeCL1aaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC5CC4CED6;
	Mon, 24 Feb 2025 18:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740420376;
	bh=fLLXimX9ynfgWBIWIxxfLc92QfSdbBwQm11gCIosTSY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AeCL1aaOnkeSIok2hceVAi8lIKo0Gd4fEIrcc1zJ5cdsXeHxoXEGWnCJ/hADdqtdK
	 N2ZDtbNRLQB2sPslywxDh9nlot8TGDfheps9d8+lVu7aAevaB8CNT3G9axE6AMPAX1
	 crWe0y3wP8oDb5e3mhXjPGN1bKvvrD20v9k4LMywQCaf6DththB+6ElignJRB8oV1B
	 pDo/yyC7d8EvipgNaI5sMlJcxzGtgPHVOHmXHYNobbLDDbPjUOyJz2aYaBJkvElT0S
	 ydYJt3RRTKBKERUOZFR/s82jUGV08OaAD98VyZeAEahBrMI5r/UZsfFIQ7YPeGkd9d
	 bwwgd03l6/Hsg==
Date: Mon, 24 Feb 2025 18:06:14 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>, Xiao Wang <xiao.w.wang@intel.com>,
	Charlie Jenkins <charlie@rivosinc.com>
Subject: Re: [PATCH 0/4] RISC-V CRC optimizations
Message-ID: <20250224180614.GA11336@google.com>
References: <20250216225530.306980-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250216225530.306980-1-ebiggers@kernel.org>

On Sun, Feb 16, 2025 at 02:55:26PM -0800, Eric Biggers wrote:
> This patchset is a replacement for
> "[PATCH v4] riscv: Optimize crct10dif with Zbc extension"
> (https://lore.kernel.org/r/20250211071101.181652-1-zhihang.shao.iscas@gmail.com/).
> It adopts the approach that I'm taking for x86 where code is shared
> among CRC variants.  It replaces the existing Zbc optimized CRC32
> functions, then adds Zbc optimized CRC-T10DIF and CRC64 functions.
> 
> This new code should be significantly faster than the current Zbc
> optimized CRC32 code and the previously proposed CRC-T10DIF code.  It
> uses "folding" instead of just Barrett reduction, and it also implements
> Barrett reduction more efficiently.
> 
> This applies to crc-next at
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next.
> It depends on other patches that are queued there for 6.15, so I plan to
> take it through there if there are no objections.
> 
> Tested with crc_kunit in QEMU (set CONFIG_CRC_KUNIT_TEST=y and
> CONFIG_CRC_BENCHMARK=y), both 32-bit and 64-bit.  I don't have real Zbc
> capable hardware to benchmark this on, but the new code should work very
> well; similar optimizations work very well on other architectures.

Any feedback on this series from the RISC-V side?

- Eric
