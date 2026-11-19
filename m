Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795085904;
	b=m8iZ03ljU17faS4q6sZwRY1k9xVLd55+NuyyTGdQKgvXcLEDeWFb7cTh5IkgJOJkqdSG
	 gntrFKzAVvWKW9keZO907fKsp7c8N7znN1yXYlr1dE+i8g8LiyY6CVtpR6iH1rRZMUg6y
	 bc/N4zvnw8w8sNul60elwuEZxj5Ak2MKNXAaE1A+f5nAdasrWayHvQyB7FYXQ22fl/Fkf
	 UwL0Hkzmy/no08JXRzyHn+2v9zCHKWwtGt03ZKbQPHupVcNZ6nXLlcew0YcNVkptKtqhL
	 BmIrSgcQbPwh3rSd202pFmekd6CrFXk9m9yb5rVmVVfL/HDqqY989MVLpAVn6iyeMJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795085904;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=8r8tiXdG1EXIMaxQR5APcNuE1bo5BJirn9lWOpCi1tw=;
	b=gLbAFk7xzlXxuZXFdco4dgiar6ugm8KZf90Q+pDOiZm6+1k2x8Oep62klEANaLNDMRV3
	 skrg1Z9g905tCskZOKfTJDiDmwmlrlVfV/Hsre0/R4t7WDuEBhVUwoQDJ6fNTS78+9vkp
	 X33S2IAxYSAikMA1y9KKcMHEaMLDty7jw3DpibPgsde/aBzsTxd2NLNusgGaB3NfKUvZ/
	 Poo51PTt04ToNkFcvxHSiZoCJ7WLruWws/RBDFaNPXTljkB4lz7fUdxyzyzMOEec5XK+l
	 nN1nSgn5yt1C3oG3SUm5IP7SKHDhVnmGAILLDeDidp3wMpZD2DhqLPIDBrO2C7vC/pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ngY7agX8;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D3C606A320;
	Thu, 19 Nov 2026 10:58:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50D3C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ngY7agX8
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1D1F1575;
	Thu, 19 Nov 2026 02:58:20 -0800 (PST)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D526D3F673;
	Thu, 19 Nov 2026 02:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795085903; bh=pe4EV1QOr5xk+JHbmfciYoro1feJcKk+4rYD3gTII9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngY7agX8gN1NeAaDRB1rCm/aHkF76DvMsGPOQAY3cIrOO/gULycnAcgJfhKmNdYgz
	 gBoAlPjd/ZEZd6Q0EswY6Lc7cmKjHl4KWk2xewL5oqTiRKMtU48hRl+cv46B47owPd
	 JigKITBwhGBY+6cgsEwL+U4I7xhdZ6RgzAs1O0cU=
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb+git@google.com>
Cc: Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Subject: Re: (subset) [PATCH 0/4] Get rid of all NEON intrinsics stdint.h type hacks
Date: Thu, 19 Nov 2026 10:51:16 +0000
Message-ID: <179508547602.2557572.9682726373932810888.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029135020.272082-6-ardb+git@google.com>
References: <20261029135020.272082-6-ardb+git@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 29 Oct 2026 14:50:20 +0100, Ard Biesheuvel wrote:
> Recent Clang has become more finicky when it comes to overriding the
> type macros that the freestanding stdint.h consumes when defining the
> uintXX_t types, and so it is time to finally get rid of this entirely.
> 
> So instead of making stdint.h (which comes from the compiler when
> -ffreestanding is set on the command line) agree with the kernel's
> linux/types.h header, avoid the latter entirely in the compilation units
> that actually use the NEON intrinsics (which are always leaf functions
> that are not tightly coupled to kernel APIs).
> 
> [...]

Applied the first three patches to arm64 (for-next/fixes), thanks! I
also added a cc stable, though it won't be a straightforward
cherry-pick. I left the last patch out, IIUC it's just clean-up rather
than fixing a problem on arm32 and can go separately via Russell's tree
during the next merge window (let me know if you think otherwise).

(cc'ed the md maintainers for their information as the patches touch
their code)

[1/4] lib/crc: Don't include <linux/types.h> in NEON intrinsics code
      https://git.kernel.org/arm64/c/ff049836f05f
[2/4] xor: arm/arm64: Move NEON xor_gen() dispatch into the glue code
      https://git.kernel.org/arm64/c/14e346032143
[3/4] arm64: Drop stdint.h type overrides from asm/neon-intrinsics.h
      https://git.kernel.org/arm64/c/a041bdbe1f3a
