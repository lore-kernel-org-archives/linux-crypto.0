Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907743;
	b=xR7AKwUWLucHe+hOFXr3Qz5vslA52ipl58fbiofF+hw30jWSuvxe7beO9H3xZ4iDmFz0
	 zLLzf7emNryZMPhx95x9hjcQg9ib2excV+mTzF2OOfzSfINghP6yDtJ2D00c10HxNTTdE
	 AOeNVOMueQ0OpwS1LZKHdGc8pkPa34T7siOMDyjZfRjz/byIBImIjYqw7iCUGU31IRALQ
	 JU2v7ghq44LPGwvw/2RU/amP4RH11XggFPiv6V4jApe6t+Ep5KamPb5hx9zo/3jyKkRSi
	 N/S7YYQntQU/rs97PsslBmH44n7hVgJ0twn2qtcOk2xUcz1DvozkNtpMspJY2I6j7Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907743;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/ASifYxMvbZYAJqQ9CETs0I1+qbM48qcyKYo9L5msDM=;
	b=bJo9qXQqERPueGQ16d+TbJ6qhjdcKD3BGS8naxDt2UM9PKeA6963dCsBz7YCY4pclNPA
	 5vCt8+jqym+ODAImBsKBPnWSD4rdpSlF3s/b+TppQ5x8+DeOFmn2KKsnnRsIpTpfWYxDV
	 mM3AWXCKa2cgMxR0xytaKr6Fstwq78+080fzzrRdieJNqmdcG1h84sActlbQ5op9cJLqy
	 3R+iXEj+ufP9TQ40x8FVO/moArEAIKwvrA1R8nlfUXjT/eh21L5lCE1DksNoqWujh9L2F
	 g7e7Ut0sC+V8QF0If7SyC5nZYybH+FsE9FChNxZhkJYY+16SK1/oO+aQy8iiZiu8csw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IsLFFzyx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31FA606B9D1;
	Thu,  5 Nov 2026 19:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IsLFFzyx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C211F0089F;
	Thu,  5 Nov 2026 19:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907742;
	bh=/ASifYxMvbZYAJqQ9CETs0I1+qbM48qcyKYo9L5msDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IsLFFzyxBeJkjVkWlr1ZbIZEua5S3YCf8nC47IraXq2xcyjsSed6uQ82wtVPz/Y3n
	 BI8b4LWQ3nNynA2WMtO/v/duDzS7s93Xkpmqi9a6KW3rD1mqmWZ8pQOvCuCY/hpJIJ
	 y5DMQc7rHvL2lYddjbSvUaVOKe+EqHk04kMpmVXhGB0kcqycQG7OslfXeAVbzvOZ/6
	 8qPwTp9eNLqCmptajkEyFh6CZB4OJCySdK4WUvc+v2W+TXJDsy/ebi6EYh4XQYlB+L
	 RRgDiBq/nYlfBBuLKaKzrCXz0ejc/AG2y59zLoHX65WW73KEWKdLPV9XlwlqS2gDdB
	 3psIb17z0Mf7Q==
Date: Thu, 5 Nov 2026 19:42:20 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Emanuele Rocca <emanuele.rocca@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crc: arm64: use .arch_extension to enable CRC and
 crypto
Message-ID: <20261105194220.GC3266627@google.com>
References: <20261105154145.557042-1-emanuele.rocca@arm.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105154145.557042-1-emanuele.rocca@arm.com>

On Thu, Nov 05, 2026 at 03:41:45PM +0000, Emanuele Rocca wrote:
> Instead of using ".cpu generic+crc+crypto", use ".arch_extension crc" and
> ".arch_extension crypto" to enable the required instructions.
> 
> The ".cpu generic+crc+crypto" directive replaces the assembler's current
> feature set with generic+crc+crypto, dropping any other features that were
> previously enabled, for example by -march or by a toolchain configured with
> --with-arch=armv9-a. In contrast, ".arch_extension" enables the requested
> extensions while preserving the current feature set.
> 
> This is not a functional change: crc32-core.S only uses base A64
> instructions plus CRC32 and PMULL, which remain available, and BTI landing
> pads are emitted as HINT instructions. However, using .arch_extension
> avoids the pitfall of silently disabling features. See commit 9142c2f8f84b
> ("octeontx2: use arch_extension to enable LSE").
> 
> Signed-off-by: Emanuele Rocca <emanuele.rocca@arm.com>

Thanks.  Just to confirm, all supported versions of binutils and clang
support this?  (As per Documentation/process/changes.rst, the kernel
currently supports binutils 2.30 and later, and clang 17.0.1 and later.)

A lot of the arm64 crypto code uses ".arch armv8-a+crypto".  Should
those be replaced with ".arch_extension	crypto" for the same reason?

- Eric
