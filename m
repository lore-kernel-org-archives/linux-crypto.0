Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0931530C60F;
	Tue, 23 Jun 2026 19:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782242669; cv=none; b=aEhm7rWLid39lbVLPGHXDCUdTd+BT5LZyLNDaJ6sj3Ly97sQQQW76Ti8WRRkTIWBh54j8xQMDhYt7+MJnkYFht2/UvEvWi6FSG0N7TUvwmj6a8jkvV61Fc8THy/RnYslAcyM9V/aSuJxVIjp5UAgNHCpD30rnOOAjox1phxsFe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782242669; c=relaxed/simple;
	bh=duwe7C7hudDeTlEDGaySXe68HB1VQk/ik6BiGO2ecQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIRymYX5jAWYePmZaxUjQ6+Vjxp/HovnjwWbweXScjAPL5GFBWJCizRFxK8dikRZGOm4RN/h/OkdOQY4KPoiqWxgMhUcOXlGpQKfUTOZM3TI14x/jjBofYtqKcoWQ+oVer1zcX1r9qtn13VZq9VYdV71LZCg3n4kQzjok8G+2ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEx5FtqR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEx5FtqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877D91F000E9;
	Tue, 23 Jun 2026 19:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782242668;
	bh=XMcS0EpQ2E0fYrzi28F+ds/0Utj+7y1MIfluE7S/DKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HEx5FtqRiElfjqXut1Aq95AuOZ/B3JSliedT/fueoDwYgF9Q1RmBiLzcp2xXqPotX
	 BwlwaafRtbjzvnsXVjEfhMx6dKPg0A+sVaBJ3iDchlwT0LV9E9dXGSoARY1pkSL0Fk
	 X+6N2jwzr1YvcWIQUQJQiQwHfaf4kJXM7Ch+vijJZPNfBVSWsu7nUjROLzFJ7SxEAF
	 yU/e32TMU2UnfhSUJkTyIZk1JKqOjP3AxV6zMFACqf9xs8Dx4rWW2nvCNFvFpqNDP0
	 SEvrrzgSayzqmrbHedk33qW2xxJJdsFqI1J3rJdRc5DvjUyqghiE1GY/3cEQswgCEN
	 QaPTI5F10RXMA==
Date: Tue, 23 Jun 2026 12:24:28 -0700
From: Kees Cook <kees@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev,
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
Message-ID: <202606231216.14A774833@keescook>
References: <20260622234803.6982-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622234803.6982-1-ebiggers@kernel.org>

On Mon, Jun 22, 2026 at 04:48:03PM -0700, Eric Biggers wrote:
> AF_ALG is a frequent source of vulnerabilities and a maintenance
> nightmare.  It exposes far more functionality to userspace than ever
> should have been exposed, especially to unprivileged processes.  Recent
> exploits have targeted kernel internal implementation details like
> "authencesn" that have zero use case for userspace access.

I absolutely want to see this attack surface reduction.

> Add a sysctl /proc/sys/crypto/af_alg_restrict with meaning:
> [...]
> Note that the list may be tweaked in the future.  However, the common
> use cases such as iwd and bluez are taken into account already.  I've
> tested that iwd still works with the default value of 1.

I wince at this bit, though. This is a "security policy in the kernel"
which we try to avoid, and it's could be done already in userspace with
modprobe blacklist.

But, as you say, AF_ALG is deprecated. I understand that to mean that
the alg list is only ever going to *shrink* in the future.

Using a sysctl means monolithic kernels are protected, but wouldn't
those systems just compile AF_ALG out?

So, I guess, I would want a more clear rationale for why we do it this
way instead of via modprobe blacklist. I see a few reasons, but they
don't really convince me that we should ignore the "no security policy
in the kernel" rule to do it this way.

-Kees

-- 
Kees Cook
