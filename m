Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858EC13D516;
	Tue, 22 Oct 2024 11:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729597014; cv=none; b=cxfkxJQPWJ2fuvIhuFLKT/RiW+U62kGgrKtk7Ggtv/ibz/zMPfEMwPMj0S0OYprIAjSUtxEk66WulbpruiuQohSPsno3W3VJIQ0Vy2h5KO3ePuAfpJvYsMmF7HGTHrGCLYVQkcnLH+oqRfV4smIEGlhW+8UqIn/nbaBRfdXSB8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729597014; c=relaxed/simple;
	bh=cm0SwPu02Nx0TC7GgZmJeNCTIvcDdLtItHobUdKSxAA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TS+HulIR3u72eOxZ9OzPBag5Q87P+ISuOHear4O0o6gFUO5HDC464V3ZS/8WNYprQdUEoyFMI7DLqFzK3QtXHfDR/zy5qLTbyZcosb5tw5LrrOCKa/etEH9gha1qRYWqwA0dl0CdUx1NpvS16cr3Cc8YCUiRRXSPIib0ugNar/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B9BC4CECD;
	Tue, 22 Oct 2024 11:36:52 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb+git@google.com>
Cc: Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v4 0/3] arm64: Speed up CRC-32 using PMULL instructions
Date: Tue, 22 Oct 2024 12:36:49 +0100
Message-Id: <172959700464.951219.12544487122968669454.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241018075347.2821102-5-ardb+git@google.com>
References: <20241018075347.2821102-5-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 18 Oct 2024 09:53:48 +0200, Ard Biesheuvel wrote:
> The CRC-32 code is library code, and is not part of the crypto
> subsystem. This means that callers may not generally be aware of the
> kind of implementation that backs it, and so we've refrained from using
> FP/SIMD code in the past, as it disables preemption, and this may incur
> scheduling latencies that the caller did not anticipate.
> 
> This was solved a while ago, and on arm64, kernel mode FP/SIMD no longer
> disables preemption.
> 
> [...]

Applied to arm64 (for-next/crc32), thanks!

[1/3] arm64/lib: Handle CRC-32 alternative in C code
      https://git.kernel.org/arm64/c/fc7454107d1b
[2/3] arm64/crc32: Reorganize bit/byte ordering macros
      https://git.kernel.org/arm64/c/b98b23e19492
[3/3] arm64/crc32: Implement 4-way interleave using PMULL
      https://git.kernel.org/arm64/c/a6478d69cf56

-- 
Catalin

