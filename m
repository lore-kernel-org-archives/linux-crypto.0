Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3583E1A6827;
	Sun, 22 Mar 2026 14:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774188803; cv=none; b=Is9RtWdzur7bjn+g+lzdBGvkh7ht+QK0Ie2pY8+HGbP20qsQMW8tMzvapGNwxo+DB7b/YAfg25S5X2in7xG0y12qrKPL0AhES8SSytgoCPndVwhzgGBPeWQ9CaY1LvYxUut4O8aM8SrO9qoBwsKGaA4MtdE2+o8n7oja9RQOT8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774188803; c=relaxed/simple;
	bh=ODtejCTrMPRZwhcc5FoT5OR98Z99jl1psD2MBk+gIZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZlQ/VwnIOkaucWx7kBUcSgzwlSIsYA1UqPNFors2WRAGs3qEvqbgYOFbAiO9A85ntUFUQ7OWO0+YPks/Oq5TgnmLp0KIO+UTICh03hanTyDbVl4cyp6v8HeJzbM+hzjRy6PZ2Xo0JPKbMMUvxa3d3+77A/V/fh2xFta2OKZKO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sLeFHPkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sLeFHPkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84763C19424;
	Sun, 22 Mar 2026 14:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774188802;
	bh=ODtejCTrMPRZwhcc5FoT5OR98Z99jl1psD2MBk+gIZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sLeFHPkJzTOOHD1mQk7VEwmOCXeoV2H+HLjt1Yad0ByA04nLoLBCO5Hd/To2QTPt/
	 K8zaFWySxwtkTE6QlP/yHbQyELYpT/pZwj8yhxzF+PJK3SxcXH7JT/p8OVLWEXKfyt
	 ruWooYO/t7PhEbOt3/nZjAGMMahiP4Y123/D4HCD+IyJWWrgXhTMieooEIJ60Z3a2s
	 5U5/jVD4r0BnwoQWzyMOCjOOdg3i5rH8ncTktCQRR/T+0xsbm7mtFqmPYRACc9p9Nn
	 80kwynGb9b9mX38kXoowVVtkwajZZX4YPxgBqb27kG6ZBC/t8MU/KIDbgL/V0/qg+l
	 PLRepXqcYewDA==
Date: Sun, 22 Mar 2026 07:13:20 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Demian Shulhan <demyansh@gmail.com>
Cc: David Laight <david.laight.linux@gmail.com>, ardb@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crc: arm64: add NEON accelerated CRC64-NVMe
 implementation
Message-ID: <20260322141320.GA2183@quark>
References: <20260317065425.2684093-1-demyansh@gmail.com>
 <20260319190908.GB10208@quark>
 <20260320103624.0e13d26f@pumpkin>
 <20260320200039.GA2085@quark>
 <CAOLeWCvSokaVROhg7f8pM=G7GaRS9OBp2q4T5WPP18C+wJuyVA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOLeWCvSokaVROhg7f8pM=G7GaRS9OBp2q4T5WPP18C+wJuyVA@mail.gmail.com>

On Sun, Mar 22, 2026 at 11:29:36AM +0200, Demian Shulhan wrote:
> Hi Eric, David,
> 
> Thanks to both of you for the review and suggestions! I've addressed
> all your comments and will send the v2 patch shortly.
> 
> The idea of a unified PMULL template for ARM64 is very interesting. I
> can own it and work on it, but as it requires careful design (parallel
> folding across multiple vectors, handling LSB/MSB differences, and
> generalizing Barrett reduction), it will take some time to implement
> and test properly.
> 
> Do you think it makes sense to merge this current solution(with fixed
> comments) for now, and I will follow up with the general template
> implementation in a separate patchset later?
> 
> Thanks,
> Demian

That sounds good to me.  Thanks!

- Eric
