Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0256518EB0
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 00:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774916109; cv=none; b=DeWnvLSAYeoxVb2LOmD74KbFwoFxURguxpgDKt+KS1Bgiu4kG7BLRnF+2oOb8deXAHHsj18qqlgjBncl9za87PM+OQPMiiNX3JVrzAvPa/5CshE4FQvT0LSdw0R3BCeFrmnPv9ggHeRQJASDY98FTIyO4LGnVuydDnU0HQMp1MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774916109; c=relaxed/simple;
	bh=4XJyboVsJ0yxu/uemond9OcSUwty3Aslvd4eyEfsYYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N9b0ehMIwe3aUG0m5w2kFjQhqVm4HgvHT5O6zrMTgPkcA5HSALTd06Pcw/kPB+M503ph6knOfmU1gwIY4U/sojIy4gaBSdS80tis0fG7qCDzUDUqxK8ZZnZKS3TCoWff1DA8R+5fL6tvTz7I2or2yYG03vHZpyUHPhxoY4N02tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KbBr2qa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KbBr2qa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9FAC4CEF7;
	Tue, 31 Mar 2026 00:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774916108;
	bh=4XJyboVsJ0yxu/uemond9OcSUwty3Aslvd4eyEfsYYw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KbBr2qa+9arONncmAT3Z/UmnTPAAtoutZuZnz+oKNBaNyiO/fB6iCief90yoyGyWh
	 8EPbOxsRu75NFxSrnBXZStxNZDGxeFmZwqeemW2bo+OlOTgmXXnmSrd0G0RHyyiPNv
	 +/b+5tpQtA2di0wYkobF1w9HONy9V/H79WpNzUK0KDSUp+IlblUhfFEqnd02PNHSls
	 L4XMFUSiMosMaS1SPNOT87j/uxLNJ/fhF7R4XSyUk9vGR1Q0E+0dLrVFBpUNmT1ytd
	 yuTDXqdkcO6rUHnomYuAicWrGULoJ6ti81XDJImo9eYPVhOMNyTJdBAko3ph58xLj2
	 mkYHOGTd1407w==
Date: Mon, 30 Mar 2026 17:13:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ryan Appel <ryan.appel.333@gmail.com>
Cc: linux-crypto@vger.kernel.org, wireguard@lists.zx2c4.com,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: Kernel ML-KEM implementation plans
Message-ID: <20260331001358.GA5190@sol>
References: <5F9ACD7A-F3B8-463A-A00E-28F68819A66C@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5F9ACD7A-F3B8-463A-A00E-28F68819A66C@gmail.com>

On Mon, Mar 30, 2026 at 06:41:46PM -0500, Ryan Appel wrote:
> Hello all, 
> 
> Looking through the mail archives I see no information on an
> implementation of ML-KEM that has been planned, except for leancrypto
> attempting to make a Key-Agreement Scheme a Key-Encapsulation
> Mechanism.
> 
> Is there a plan to implement a KEM interface at this point? Is this
> something that needs support?  How could someone contribute to this?

We don't add new algorithms preemptively, but rather only when an
in-kernel user comes along.  Otherwise there's a risk that the code will
never be used.

Do you have a specific in-kernel user in mind?  I haven't actually heard
anyone specifically say they need ML-KEM in the kernel yet.

I guess the obvious use case would be WireGuard.  But that would require
a new WireGuard protocol version that replaces X25519 with something
like X25519MLKEM768.  It's going to be up to the WireGuard author
(Jason) to decide whether that's in the roadmap for WireGuard.

Also maybe Bluetooth, though it seems the spec for that is yet to be
defined?

Anyway, point is, before it makes sense to consider possible
implementation strategies, there needs to be a plan to actually use it.

- Eric
