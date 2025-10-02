Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EF524467E;
	Thu,  2 Oct 2025 16:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759421895; cv=none; b=ODHCs6I3exg1sQxf5l/xvUUqNRhi+vcsWzgARByoRnn+dyifFnP9rTlJnEEftUbJKA6hqZv7ZnxPZByJGgYiu2Bj27qGX4DeM58l8Y3TvBj3p/ZHM/AnJx4ejhF7GiMMZDWC29v91/U7sdL6fe6q1vEdW+hDkFMBjuhFBLND8X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759421895; c=relaxed/simple;
	bh=haU7UA3i4VxOH2x3gB+UMfWD8mNozTHeaUCvV8ZhUxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+y/Du2wWnwyZn4pqXKkboq9W1GH1ASqWo046ncOinbaGIxYQl525pYmQVumoGfjUIb91NZJI1dji1kE8RMQqT7d7fT4xEYXz/48MSacX12PEhjH4auB3CJ/ItRMsAJBS95xVKQuCMcsCVNzp+B8em+9eVs4shR2kNSwpoB1eA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBmlw+YW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBmlw+YW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDC0C4CEF4;
	Thu,  2 Oct 2025 16:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759421895;
	bh=haU7UA3i4VxOH2x3gB+UMfWD8mNozTHeaUCvV8ZhUxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mBmlw+YWycUFfd6+awCdzyisCKm2spoUtagB+p9j/yRzbVr/hhvDwBU/QAPohipeV
	 msMFYutoNwZkH2eh/72ISHoSdFbauACTHfh0ZI+kSuPCseSVrpTWw3EPBLOSdswDon
	 E9oo9Uc2zygnGmelyniEKiDwLM/UccJGeuLmpwBW+Uzgcr16ToY7ptR0r8JxGGb1ih
	 +iUUdzgAWCUmBY/F892FlqueGw+hCN6CnIEUrYpzKId3//HeLkbWfwvyKYHYdXo9as
	 +PT6HHOjsGtuTmyQRmG8rCnye6L5V1XBCSN6dvssFqFbC4P3sLle3yRgAdjVVkTqLz
	 fx5KB23rMjLog==
Date: Thu, 2 Oct 2025 09:18:14 -0700
From: Kees Cook <kees@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	linux@armlinux.org.uk, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 03/20] ARM/simd: Add scoped guard API for kernel mode
 SIMD
Message-ID: <202510020918.AEFA1A195@keescook>
References: <20251001210201.838686-22-ardb+git@google.com>
 <20251001210201.838686-25-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001210201.838686-25-ardb+git@google.com>

On Wed, Oct 01, 2025 at 11:02:05PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Implement the ksimd scoped guard API so that it can be used by code that
> supports both ARM and arm64.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
