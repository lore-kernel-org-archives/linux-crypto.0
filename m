Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D9D263C6A;
	Tue, 29 Apr 2025 20:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745958490; cv=none; b=gFaXv6O4vbEd/0HUE20AsDL1LBU8HQTkq5Jt8BWniCHQuKA+XXmX6cPeqikghQLO1K0OSERGYne52GoY835vP+vOwqz3VB0TSGWk3fuaGlCyoUFzhQFKDifR9gesaaNb23FovyEK7D+5ssIu2hf6ly+V8N8juqzy38a6Yd8lKws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745958490; c=relaxed/simple;
	bh=L9mbN09+6CLVblJuXVYcAm85xyL6UqkEzO7ZghXXv1E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eeMIk0ArgD+KhpC0u9oc97LCvD/vtD/GAr2eZhlnYWKW6WBiDLRrJeXabzoWoKMF/QnlGxkk8JOlypz/8vfbi8T0g7zHwnkiJU6gLOvIEocDR/+dL7wOcvA0Tt6ymR+5WRjJ6bVy3ypW2iPRDS5pAWFl7Vj3RqdiwJxPw5C8WgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUKKWxmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUKKWxmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706D1C4CEE3;
	Tue, 29 Apr 2025 20:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745958489;
	bh=L9mbN09+6CLVblJuXVYcAm85xyL6UqkEzO7ZghXXv1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUKKWxmqtu3Ye20oTlvA100lvRoMNSe/kK8UvwbpX5qB1r5KYSQs5ceataoyWA/by
	 zQ9/592okKhggqO46uxOq4vj+9T3VAweL1BS9ptmfudz++URq78o24/HtLsTsbNJg7
	 BsomvLDfpcM4a9UBEcbvAdfw6/AaSR99zj+65Sf+V+fg/Gfp2xvFlMplguAicXIfMS
	 FlkbCV8cWxixY80qbs8mkvKEWE88Xlxao7VuYPKd59JuWfX/NAGCGHqcS9tEhc2vzQ
	 vV2XBc+yeqi+yVbIr2k0qj+iufXnz9TT1M3abC14iFV8Pp2Aa/5PZYIg+IztmlExJ0
	 Kf4zaCqvUEQoA==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Eric Biggers <ebiggers@kernel.org>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] arm64: Kconfig: remove unnecessary selection of CRC32
Date: Tue, 29 Apr 2025 21:27:46 +0100
Message-Id: <174594004029.473481.4442846222073127279.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250414174018.6359-1-ebiggers@kernel.org>
References: <20250414174018.6359-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 14 Apr 2025 10:40:18 -0700, Eric Biggers wrote:
> The selection of CRC32 by ARM64 was added by commit 7481cddf29ed
> ("arm64/lib: add accelerated crc32 routines") as a workaround for the
> fact that, at the time, the CRC32 library functions used weak symbols to
> allow architecture-specific overrides.  That only worked when CRC32 was
> built-in, and thus ARM64 was made to just force CRC32 to built-in.
> 
> Now that the CRC32 library no longer uses weak symbols, that no longer
> applies.  And the selection does not fulfill a user dependency either;
> those all have their own selections from other options.  Therefore, the
> selection of CRC32 by ARM64 is no longer necessary.  Remove it.
> 
> [...]

Applied to arm64 (for-next/misc), thanks!

[1/1] arm64: Kconfig: remove unnecessary selection of CRC32
      https://git.kernel.org/arm64/c/e2eaeba0522d

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
