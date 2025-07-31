Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACE13C38;
	Thu, 31 Jul 2025 21:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753998118; cv=none; b=gSy45aUq9TXzr1+lZ9Iz+2SK+DaBoNctIf71nze1jB1pntNiPipisSw5kuRMZ/NmCDAwknympUui8m8bAmk9R4wpiERykTDydppYDOTmGCfMiGbc72rlH1qJ2tYkGY0pYO7rAYCWDBa7bAM72e5kT3HY+QK5rRgC5S/gFg/quC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753998118; c=relaxed/simple;
	bh=Pgmdw2ckeRNgVTHeHOfWV/yopX50cqTxEghI5ertBMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kKbL+fEx4bfKb5bjpubRYF8LAXQRNAbn67hFZpTeOrt+Xyz4hsbTY9QoY/4xPaOBEBIPhG8CQjBXS42B6pKFKK+aFQI0cZj6UTnrbJdpM9iSO3lUh5z3DmA4/DRpJtDpyGiNS/zy5EgwnnF6rwSm9Sp7mZQfChDK2AozQI3h7Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l8YzM/f/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l8YzM/f/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3A6C4CEEF;
	Thu, 31 Jul 2025 21:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753998118;
	bh=Pgmdw2ckeRNgVTHeHOfWV/yopX50cqTxEghI5ertBMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l8YzM/f/+zwYWRNO+F7U/SeTg0tLJB9s1QyM77LgvCJl7P2Yu1fDLnqqU8K7o6VLo
	 Xg50PkmcvDvmS3KEO6fa0A9ldDGYhQfl7BiKPxrk2V9gIhvb1bmBJg4Y2SxTbB/AOI
	 vh+doUC17RgIM82229GYa23UeWNE7QYDxYZZzCd1kYCjNdMf3rWPdnH11517MIiWuz
	 RR8ODV6s6GcD7wTVxQ5NfOet+WFLdLallhWz5R+qCpb8Z4aeJ5GQGCcewkjP9LBLTR
	 qCkYVNkYJGtRUwz16OQpqDUt3kFscFOuZU2kLg5PWFagPKwXQGmH+N+QIoI1sRHmSY
	 jGN3nvJ55D0Yw==
Date: Thu, 31 Jul 2025 14:41:56 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>, netdev@vger.kernel.org,
	mptcp@lists.linux.dev
Subject: Re: [PATCH net] mptcp: use HMAC-SHA256 library instead of open-coded
 HMAC
Message-ID: <20250731214156.GB1312@quark>
References: <20250731195054.84119-1-ebiggers@kernel.org>
 <245ef75d-44d5-4b66-9f28-68182f177fad@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <245ef75d-44d5-4b66-9f28-68182f177fad@kernel.org>

On Thu, Jul 31, 2025 at 11:27:50PM +0200, Matthieu Baerts wrote:
> Hi Eric,
> 
> On 31/07/2025 21:50, Eric Biggers wrote:
> > Now that there are easy-to-use HMAC-SHA256 library functions, use these
> > in net/mptcp/crypto.c instead of open-coding the HMAC algorithm.
> > 
> > Remove the WARN_ON_ONCE() for messages longer than SHA256_DIGEST_SIZE.
> > The new implementation handles all message lengths correctly.
> > 
> > The mptcp-crypto KUnit test still passes after this change.
> 
> Thank you for this patch! It is a good idea, and it looks good to me!
> 
> Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> 
> One small detail: net-next is currently closed [1], and I don't think
> this patch can be applied in -net. So except if you plan to take it in
> the libcrypto tree for 6.17 -- but that's probably strange -- what I can
> do is to apply it in the MPTCP tree, and send it to net-next later on.
> Is this OK for you?
> 
> [1] https://patchwork.hopto.org/net-next.html
> 
> Cheers,
> Matt
> --

The MPTCP tree (and then net-next) for 6.18 is fine.  I know this isn't
a great time to send patches, but I just happened to have some time now.

- Eric
