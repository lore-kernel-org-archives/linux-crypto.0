Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3751D13B2A9
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 02:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729045253; cv=none; b=koo3ApxpCYJdUe9SfD+6oCjOU8/U9srVsuRA2qVpwyzVQBTYjLjfQivJEAJ/oaARVVj+eixoCYXwLWcUAI1EqwqYIEuTkmWOkFI+FhwIm+n/hVvU8ne6G1guttEAWrA5/PGhdqOw7WOStNCMX2IjPwlzQagPJxPmoBGn6yF7iDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729045253; c=relaxed/simple;
	bh=NrtfsvshYZeCzMYCvYC9SOGWo+5vObYp1haJCA6i6m0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wbo6xfWvQV2GA62LQWoSqq4Ln+Wlvb29NhbSCruR/iLlBVWVFGjUvxUPDVgU4KcbpAdIzI4IKWqJdHFwNYOKksr+S1orUZUA0EWnpmbJZpdjZQ+iDvrl09fmb7Z+f9lnvQarlUx3c9baCL1fka3Fo2Oyzs+gYX7ZktIelS7qkZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ic4ZlSN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ic4ZlSN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A204CC4CEC6;
	Wed, 16 Oct 2024 02:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729045252;
	bh=NrtfsvshYZeCzMYCvYC9SOGWo+5vObYp1haJCA6i6m0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ic4ZlSN1MQgwSXFKt1/zgIfJU3DoLYpnKLyI/czKIHJBRvFxbeZ20ubVVzISEu+ZS
	 ZaKC/r27uU7cefr4clHdU9StxHBCFC8ndKpt6+xLUCmTQoufs0QLDISAfDP0FpgX4h
	 oGhxcxeAz5kBfgDaxKHJZG2N76qt5sYCsShUGRHCJs9k0Ab75Dzwe9adyCDNVTnBMP
	 e/MyIM74Yrb1aDKjftrMMy2VNheQhlajET2PzHbfppSeXR+ZZ9+UYH6FSPwU5JwjP0
	 BY0bY4rgkAtLoUvNVhuTekHFqcAUvHHZo61RvKIW0UmC8FlmuB/fSewMk7mtQh207g
	 MQScENIIQi4Lg==
Date: Tue, 15 Oct 2024 19:20:51 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 0/2] crypto: Enable fuzz testing for generic crc32/crc32c
Message-ID: <20241016022051.GA1138@sol.localdomain>
References: <20241015141514.3000757-4-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015141514.3000757-4-ardb+git@google.com>

On Tue, Oct 15, 2024 at 04:15:15PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> crc32-generic and crc32c-generic are built around the architecture
> library code for CRC-32, and the lack of distinct drivers for this arch
> code means they are lacking test coverage.
> 
> Fix this by providing another, truly generic driver built on top of the
> generic C code when fuzz testing is enabled.

Wouldn't it make more sense to make crc32-generic actually be the generic
implementation, and add crc32-arm64 and crc32-riscv?  Likewise for crc32c.  That
is the usual way that the algorithms get wired up.

Even if we take a shortcut and don't do that, the naming could at least be more
consistent, e.g. rename the existing crc32-generic to crc32-lib and add
crc32-generic alongside that.

- Eric
