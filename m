Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4617F2A1BA;
	Sun,  8 Jun 2025 23:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426320; cv=none; b=TfKbNSSH4oRFQaZvOyq6jI/hThnahOCJUGkkPHKe/WtZr8dbS1CpPpuQjZdPpu8n07iwdO/sqM1b6cxW7P9MHohOv62uia2nbS8UYWEO700M/kCMhAr89jN7oAXvf0VPcNZvsFjjoDVZJZdvF7fTxvj4OyGrpquUTkusy+0MjLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426320; c=relaxed/simple;
	bh=SHfCoZY5hYY5EDnVkDKQicNcun5i2yE7XuOeEa1hNrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrop1y7m93zzWGm6uadE/n1OnahDofpJJWwpNom9KdM63AWkbdyOSk+h0TOMzwKRYHhtbOloQba+/FKNDUyG6ZxNQNFq4U/u5b7EXc2fS9/5zqKyWYFKP3BbwbnfOtC6s+FCb1emSzD5MMFD+pOv222jU94v/ejduew2lf5JKMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6D3CEGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6D3CEGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF91C4CEEE;
	Sun,  8 Jun 2025 23:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749426320;
	bh=SHfCoZY5hYY5EDnVkDKQicNcun5i2yE7XuOeEa1hNrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P6D3CEGGvc2nZYavYAxIrB/ZRVSwpIQSF70OXeyC1QkQIZpo93PhK/7z9uw9BKYFZ
	 XZpAUnN/X2kjMXTUmuv3HlTimpGu+mRcy7JkjEfXJPuIei1128Bd84JKkhgNRbtCxG
	 6D4xSjOuwyryM02DMsRWphcQ1rEWNr2tG0G7v+n8NPpeKpGz6oIeASQNT1JcWH3+N8
	 TYKabPoPam5ybUHgOeo0/bIrEAb+9L0RAreMSzqw9OfAA2gvynNb6hzvyvpBampeJT
	 i3rZqHPq1xXtV2SCXEIUdWCvTrpz0Vf30rk/MwqeYHarVjoAro1EsT1SOz7+CX7Z8e
	 4JWGaQB2jp0bQ==
Date: Sun, 8 Jun 2025 16:44:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Fabien Dessenne <fabien.dessenne@foss.st.com>,
	Lionel Debieve <lionel.debieve@foss.st.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v2] crypto: stm32 - remove crc32 and crc32c support
Message-ID: <20250608234458.GD1259@sol>
References: <20250601193441.6913-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250601193441.6913-1-ebiggers@kernel.org>

On Sun, Jun 01, 2025 at 12:34:41PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Remove the crc32 and crc32c support from the stm32 driver.  Since it's
> not wired up to the CRC library, almost no CRC user in the kernel can
> actually be taking advantage of it, so it's effectively dead code.
> 
> Support for this hardware could be migrated to the CRC library, but
> there doesn't seem to be much point.  This CRC engine is present only on
> a couple older SoCs that lacked CRC instructions.
> 
> Even on those SoCs, it's probably not worthwhile.  This driver has to
> deal with things like locking and runtime power management that do not
> exist in software CRC code and are a source of bugs (as is clear from
> the commit log) and add significant overhead to the processing of short
> messages, which are common.  The patch that originally added this driver
> seemed to justify it based purely on a microbenchmark on Cortex-M7 on
> long messages, not a real use case.  These days, if this driver were to
> be used at all it would likely be on Cortex-A7 instead.  This CRC engine
> is also not supported by QEMU, making the driver not easily testable.
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Fabien Dessenne <fabien.dessenne@foss.st.com>
> Cc: Lionel Debieve <lionel.debieve@foss.st.com>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> v2: reworked commit message and added Acked-by
> 
>  arch/arm/configs/multi_v7_defconfig |   1 -
>  drivers/crypto/stm32/Kconfig        |   9 -
>  drivers/crypto/stm32/Makefile       |   1 -
>  drivers/crypto/stm32/stm32-crc32.c  | 480 ----------------------------
>  4 files changed, 491 deletions(-)
>  delete mode 100644 drivers/crypto/stm32/stm32-crc32.c

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

Adjusted wording in commit message slightly:

"Even on those SoCs, it's probably not worthwhile."

=>

"Even for those SoCs, it probably wouldn't be worthwhile."

... since it's talking about a hypothetical port to the CRC library, not the
status quo where the driver is almost never used anyway.

- Eric
