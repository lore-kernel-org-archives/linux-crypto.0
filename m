Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B56A3D3D18;
	Sun,  4 Oct 2026 16:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791132745; cv=none; b=ZgVXvXERT5EkFdywiC+Wi92qyCEyhTHwlrIhMqeZ7pGyxWmjTa15R8L1aZq1vVbUyWKan8+XCX+XeucK19dKMLqmcOqdAeFh3yTdfc2fgg7hnO84D6sO1Tq2knwH2K+8KRxuCK3sDUeR22Q/jPBOEcq9H2zZYZzp1JRuz1ZAI1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791132745; c=relaxed/simple;
	bh=qX2kD00LoShHUJeqfQ0txX5qVkmYqqfCL20wCxM2a9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WaUA/Ep6y43gHP366M8mhR8WGk7dlonL6nOK0wPpJsNfUDhfMpV+XA31SJPw0GkIGS6vd3KZsUJF/FznC7DI/2lHCUJp06hiiabnimkl3UGmPNq9fYJqqbX4C8dl70ZPeRr57HCoaxbc0xQe5rsDrlVCjRaNTDOFCihO7wb0X7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/lDAlZg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/lDAlZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA6B1F000FF;
	Sun,  4 Oct 2026 16:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791132743;
	bh=kmAKu2vBNEAoE9JjYsHDWA/wFqOqWYoE1rkFuq+61LI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C/lDAlZgbSfDKHkdlV8Gnm47G8kS+374jKA5pIUeTKBMf0nQma3saj5b/sd2JiQnM
	 GmlC6Vli9EXH+x8MA2iSidAZYfgeMYJE5kfiCMnbKu3MEtx+yPfsu+BX9r/NNV+wI1
	 xBsQQeZqg4DoAoYhy8IP73Yzl2317vllv5lWV5+jns9Ao98+8NRKpJnI9+LXyYirpL
	 km2jbkBOr4D2FfXYHV2dx/MXyA+hdliSIqp3XpawZt3Mi9iLU7z+BV6RAB/VmvAzKF
	 fcZVnbaoPU30b4/4DFrFAd7LtP99xlo4OmBPBSypWcR7OzeOg2Ef9pXjYNfWMZDlY+
	 YfiyrcFKMyLtg==
Date: Sun, 4 Oct 2026 18:52:17 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, ardb@kernel.org,
	skhan@linuxfoundation.org, me@brighamcampbell.com,
	jkoolstra@xs4all.nl, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: chacha20poly1305 - Fix missing state zeroization
 in xchacha decrypt
Message-ID: <20261004165217.GA1906@quark>
References: <20261003060826.7792-1-raizudeen.kerneldev@gmail.com>
 <asFj6Nxf6fglYfor@zx2c4.com>
 <asHGD1_z-N9k0czy@kernel>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asHGD1_z-N9k0czy@kernel>

On Sun, Oct 04, 2026 at 08:50:47AM +0530, Mohamad Raizudeen wrote:
> No, none that exist today. The only in-tree callers are the wireguard
> cookie code and the kunit test and I agree the cookie has no forward
> secrecy concerns. My only thought is that the function is
> EXPORT_SYMBOL()ed, so a future caller with a long term key would leave
> the derived subkey on the stack and since chacha20poly1305_decrypt()
> already wipes the state, having the xchacha variant do the same seemed
> like safer default.
> 
> Also, Eric requested a v2 that moves the zeroization into the helper
> function for consistency with the encrypt path, so I will be sending
> that out shortly.
> 
> Thanks,
> Mohamad Raizudeen

I agree: the crypto code should be compatible with callers that need the
key to be zeroized, even if none needs it right now.  Otherwise it's
just way too subtle, with some functions doing it and others not.

- Eric
