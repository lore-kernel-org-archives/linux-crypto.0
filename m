Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5C43090C2
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 01:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774919564; cv=none; b=oYnMMGWnkCshGt+EFOosbcnmx2TwDXWEXxgG81xwvTgyDNWrrDROs8qA64f6yfUVKAmCDpiLN0Q52Gw78HC6rrR9EtpD35iuXETUll8ehxo0CerDm/eRFIHE/m7JhIA54yeqNwTCGOiz38iMnflBOX3lcb0EJRGbERkcrmJ+EeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774919564; c=relaxed/simple;
	bh=iCfC32gPCOq3jfIEnZRFSUBxARxVZ4ChIy/597rHi84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eFdLwRy+476BiaM+4Eyaz1mhoD7KZQDzkUw5gUUzSmtidPRicGHKZ5hmJKyfT+u4tgjWhqMFWdL43vE2ohrA4vcAdpzH2HFI0jyLMBSrBbyYa1tFtYMuctyfkG5rv6A29bDNIa6BrtmlYIIUWkxIR2mxmbCDDTU199zK8Csim7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WaZ2UQdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WaZ2UQdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9165FC4CEF7;
	Tue, 31 Mar 2026 01:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774919563;
	bh=iCfC32gPCOq3jfIEnZRFSUBxARxVZ4ChIy/597rHi84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WaZ2UQdK/SNt4rlJZJ2QJQnScNiPJJZPTE6s4sEv2QaN+SXcJiHKlIDYpbrgpaMzM
	 WB9Us2Ejcc4+WWb+NDeusT/wSYGNDZbyakla24p2ZADDJ5sB5kDUE50oxQYqX3K28F
	 3vHcPNNFvoblgKyP4QKYYDW9BMUiRmvJ6ntWQytwShEWOA8zxJQ6ziF8HloS0igUsZ
	 /v8VIww1IEHPKHj3nGfcRiL+xxkNWTz6y2XenMNkMbiVpW6bU9UN0BCzPGT9OVE5sx
	 7pBxRvKg7zNZjHbSczCTKJ438sprrcCZvHkCyyjxN0/eXpEEQ536d5UmymmQjQvDFW
	 ql+h1lqba+mag==
Date: Mon, 30 Mar 2026 18:11:33 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ryan Appel <ryan.appel.333@gmail.com>
Cc: linux-crypto@vger.kernel.org, wireguard@lists.zx2c4.com,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: Kernel ML-KEM implementation plans
Message-ID: <20260331011133.GB5190@sol>
References: <20260331001358.GA5190@sol>
 <7507DE2E-1507-4D03-B6EF-9C139BBF34F8@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7507DE2E-1507-4D03-B6EF-9C139BBF34F8@gmail.com>

On Mon, Mar 30, 2026 at 07:44:55PM -0500, Ryan Appel wrote:
> WireGuard was my big implementation user.

Any more details on this?  Googling for research papers shows that there
have indeed been several proposals for quantum-resistant WireGuard.  But
some use algorithms other than ML-KEM.  Others don't modify the kernel
code but rather do the key establishment in userspace.  I haven't looked
into the details, but it also sounds like it's not as simple as swapping
out the algorithm, either.

I think step 1 is work out some plan with the WireGuard folks.  Which
may or may not turn out to involve in-kernel ML-KEM.

> I also know that VMware uses the kernel crypto space for many of its
> crypto operations.  I do not know when they will want ML-KEM and if
> they will want it only within BoringCrypto or OpenSSL, but if there is
> need for it in the market before it can be developed then that makes
> sense.

That code isn't upstream though, right?  So even if hypothetically they
(will?) need ML-KEM in the kernel (for what?), that doesn't count for
upstream purposes.

- Eric
