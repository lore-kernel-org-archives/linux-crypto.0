Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795807580;
	b=H+L0fQt4mV4PoPEOnstI7m/s2+v1gjOJ8yXlY9dd1ZqTTQDFN7PezWkoRC008qQQE2wy
	 Rm6s9rH7LWTuZTYWOVw1GfJevNgL4v7MdwApzwMXxhBUtOprvuVKLzOSdqYZ+f3O8dfZ7
	 5/p/ziARik0oMJ7nsU6Fy4zMx4S2Uac/EWciRpKRLSdOHzLVPDsrft0iBia9O9VBGGE/Z
	 4D2e/2L4zbMad7jEZQQ4vyn13Fx1H99NOIKPc+9CUKkMqaDILlK+mf5V7S2AhtOVjbckr
	 eHMTYHzobcY8/eCcAqwCRQspTCeQtq0Gs54pJYvZmvMqNFeqO8Toje7eg7bULCj/vtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795807580;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ele7JgtIlV4YiyJkB0/OiVDz32EYWvMiES6IIPAQJ/Q=;
	b=HJ5yw8HyG5o4TjOVpHiPrkUhLQOdnsOyZyFiG89rfieXLZ6Ee4L0ukHWRJXvy3ZC9OLS
	 ecz9psY+qgHB0RBr79LHo8dQc6J8gD6aHs8EqnLMJySMz2eDPwuxkwOlqkBBK+3BcGHFt
	 yTWNPa7feJ86ndeJAkWPAK8xoDm6Tp/+uwHd6S+yJzG9Lm7gPCCzxu4OLXVnG+rNz6maL
	 q1WNkjHMmZaCgIHf+nyoAFDqgSCpiX1myfw+twfw0yrYvn7VdUftWZK6x5E1iQzISe3uH
	 eDlxPvrFYcEG0OnqlfupmVR97uwmrkB5i1XspbJQ4ECpgaGiIhaJJlhuUBFrHFughAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M0IBurfW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2DB606A31C;
	Fri, 27 Nov 2026 19:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M0IBurfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425531F00897;
	Fri, 27 Nov 2026 19:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795807579;
	bh=ele7JgtIlV4YiyJkB0/OiVDz32EYWvMiES6IIPAQJ/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M0IBurfWZj3WIJLLQUBUumvelapE2vCyMPYOSzVgO+yUhb75weykCiD104oqXgz9I
	 zVep6uECn6C5v1IzZAoxp0Audo7S3AWWbY5OHXzyxr2W+cYyyMrmw/UrdJdDzXoRn+
	 qh7PPZXWDSCKYjfs9yajObLIYbPKtfu7nC924kFFlzwobwxUMO19IAAsfioDU9vQhc
	 by3lNAj11kW5r5/1TnyMV7rvgeUkzeM4Vs/hBO9V/mWoYDCZRI/d0DEfrsnSDcfK2J
	 qYuLzAwzpb5QpRV+gdzv3dUb+xzVn8CmsmE8xtFV47VG03WDucfZ3ZktWBQEcjOr9W
	 cP44PRYM1PS+w==
Date: Fri, 27 Nov 2026 11:26:16 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Vedant Dave <vedantdave354@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crc: Fix kernel-doc for crc32init_le_generic
Message-ID: <20261127192616.GD8300@quark>
References: <20261127081001.327898-1-vedantdave354@gmail.com>
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
In-Reply-To: <20261127081001.327898-1-vedantdave354@gmail.com>

On Fri, Nov 27, 2026 at 01:40:01PM +0530, Vedant Dave wrote:
> kernel-doc -none -Wall lib/crc/gen_crc32table.c reports:
> 
>   function parameter 'polynomial' not described in 'crc32init_le_generic'
>   function parameter 'tab' not described in 'crc32init_le_generic'
>   expecting prototype for crc32init_le(). Prototype was for
>   crc32init_le_generic() instead
> 
> The kernel-doc comment is named crc32init_le() but sits above
> crc32init_le_generic(), and it does not describe the @polynomial and
> @tab parameters. Rename the comment to match the function and
> document both parameters.
> 
> Comment-only change with no functional difference. After the change,
> kernel-doc reports no warnings for this file.
> 
> An AI coding assistant helped draft this change. I reviewed it and
> understand it.
> 
> Signed-off-by: Vedant Dave <vedantdave354@gmail.com>
> ---
>  lib/crc/gen_crc32table.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

Thanks,

- Eric
