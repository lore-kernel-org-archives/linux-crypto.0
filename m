Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5643C266B40;
	Thu,  2 Oct 2025 16:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759421872; cv=none; b=EEkkKDNcTpCRaAbLH8hm7xeJDGxWobGqX7IKvAUK6F8NtrUmZpoQ4IfVFqU5jZjCUPyDOd51TwsliSvP/MLyFy2RQ5lb6SfudPpmuyUkfVms82peTzUNdbb6+n0fV9E6PO7oXRL0/4ssIJJQQht49aAlvXfp8b74By3plXmVyyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759421872; c=relaxed/simple;
	bh=TdGO/UgXtuKgeNJ7B5QwoIhZurKp1jniMNAKLD4x55M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZER8nUK7LL+sRDnW89QrBUh3N13KqKF7uARBLke3gCJlHZyHpT5iN8IEyF/zUvm0H9o3Bpxl4oJJDTXW0wKCRSUWpOGTTQ+aF0LeTNxdlkTIV/oXSaa6iiIs/LtIIn2KmIY3RyHY9ccDkKCienlqhVD0AkxFWhLRv2K+2IuTWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezcaU6dP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezcaU6dP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CEAC4CEFF;
	Thu,  2 Oct 2025 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759421871;
	bh=TdGO/UgXtuKgeNJ7B5QwoIhZurKp1jniMNAKLD4x55M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ezcaU6dPQ9zoGc2Ek4Pyu0FH07Ntmutca4epdD7cs59WmG/tidw58Tc2basWIBj9/
	 TVErReFMSpFvAg8uR4RCYlnANxcCniV4w6iGNMRwhmFfXUORgJkaU+6u7gTFtQFWHw
	 ZxL2MFcz8gUmv6ryA1WJO84PCDDYdI3b1pF0jPaTdee5z4QAWxpEP1n9Yql/DnwhJF
	 jg7J1aORbcefgJFEQEJp0T4foCxIwbecMeucJQXsWx9JG057NDvmgvSk3tKUrQIHc7
	 qaLP3DDoPk60HWnbtIOm1oktLbrhGLooVMDM3FJyho6F10Xp3DfbaUJHfbbacwH/6v
	 cQePe2piMaKKA==
Date: Thu, 2 Oct 2025 09:17:50 -0700
From: Kees Cook <kees@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	linux@armlinux.org.uk, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 02/20] arm64/simd: Add scoped guard API for kernel
 mode SIMD
Message-ID: <202510020917.8BFF293824@keescook>
References: <20251001210201.838686-22-ardb+git@google.com>
 <20251001210201.838686-24-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001210201.838686-24-ardb+git@google.com>

On Wed, Oct 01, 2025 at 11:02:04PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Encapsulate kernel_neon_begin() and kernel_neon_end() using a 'ksimd'
> cleanup guard. This hides the prototype of those functions, allowing
> them to be changed for arm64 but not ARM, without breaking code that is
> shared between those architectures (RAID6, AEGIS-128)
> 
> It probably makes sense to expose this API more widely across
> architectures, as it affords more flexibility to the arch code to
> plumb it in, while imposing more rigid rules regarding the start/end
> bookends appearing in matched pairs.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
