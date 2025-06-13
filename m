Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4301B20F09B;
	Fri, 13 Jun 2025 18:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749840124; cv=none; b=h8KAqxczrg/2hLpkVhulREMeQ54E0Hp31VIERqe7q+4UdG+PKb2hey1fRQbBVbkKXxxybh1cvx/6nl+OyvmyY6kJ9gy6RbELl63/CqnOkK1DiMx6WTPEEzYWdE/h6f9d4lLRq+KqHhYvEi6GTw8wY0j+SoXqzneIiQVucLWjAyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749840124; c=relaxed/simple;
	bh=pdy5Hwp96I3rx1x+TyAh9Gpfyv0JRjqm+vSVNYC8tiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X7d/mXOyCHGoGXcwzgBaRrAAb2L9g1e/DUFbUrTe4keJWo9jtvLActO+Ci2c/C3/ZqUcDUQNXw8fEYqWSy6Nx41615e51vWoBzu7LhAG96PgJ4NLWcVtqEimnx6UOVLEVOdqHqkUMwhQhV8JGzMT8VcXUIdvuTpMEjE0D3O8DeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npmxHRwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npmxHRwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3869C4CEE3;
	Fri, 13 Jun 2025 18:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749840124;
	bh=pdy5Hwp96I3rx1x+TyAh9Gpfyv0JRjqm+vSVNYC8tiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=npmxHRwSOmm5IprZpRbHjWCy1y+vdgTrRPG7K//LEjygumL8Rfj8vpXBIDL87rX2V
	 Y5ty1Gwcu24esEajGxLydfKFjpBUwIVaE0xByASTKJ4O+yr6YHV7BSfP4TA7WANudl
	 Qm2gN1kkisFMiXz3u++psFfKOIAuqBL7w8HDPeVo5JOG7Hvz36WjqejZ4F9Kr1xbFw
	 lbnc2in7Bac5in9IHLQD6+EtqanIFHBhNvk8c5eMtzBE59abVlFfURaEQoC+lCiVwa
	 1gdLwsq4t3KN3TWVrC8pSNFBQa54/45XvYdT0+UhEWZVW1c0XQMjNY2OWlwypbfkrz
	 m8LIkRRnQO3hQ==
Date: Fri, 13 Jun 2025 11:41:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld " <Jason@zx2c4.com>, x86@kernel.org
Subject: Re: [PATCH] lib/crc: re-disable optimized CRC code on user-mode Linux
Message-ID: <20250613184137.GC1284@sol>
References: <20250612054514.142728-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612054514.142728-1-ebiggers@kernel.org>

On Wed, Jun 11, 2025 at 10:45:14PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The reorganization of lib/crc/ unintentionally enabled the x86-optimized
> CRC64 code on user-mode Linux.  (It's enabled when CONFIG_X86_64, which
> is set by arch/x86/um/Kconfig.  Note that this is a different option
> from the "normal" CONFIG_X86_64 which is defined in arch/x86/Kconfig.)
> Since this is not being taken into account, a build error results:
> 
>     CC      lib/crc/crc64-main.o
>     cc1: error: ./lib/crc/um: No such file or directory [-Werror=missing-include-dirs]
>     lib/crc/crc64-main.c:58:10: fatal error: crc64.h: No such file or directory
>        58 | #include "crc64.h" /* $(SRCARCH)/crc64.h */
>           |          ^~~~~~~~~
>     compilation terminated.
>     cc1: all warnings being treated as errors
> 
> Fix this by re-disabling the optimized CRC code on user-mode Linux.
> 
> Fixes: e2fd1883971d ("lib/crc: prepare for arch-optimized code in subdirs of lib/crc/")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  lib/crc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

FYI: I folded this into the fixed commit, so that it won't be a bisection
hazard.

- Eric
