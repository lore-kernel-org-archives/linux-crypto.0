Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8B414F124
	for <linux-crypto@vger.kernel.org>; Fri,  9 Aug 2024 18:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723228061; cv=none; b=tFwYDBQA/cd3RY5lT+xb3Gk6eN6VKg7am68b8te/AUxWZiyeo9ugqRszZXY7hXEd7oiJW5ZX/yro3c9xNFr1wC1MGzCnq1+grBqU4K/mgSAGlPZ5XkM3CV7nfz4vmJ0Lp0pM8/A0sBEw0h0MeV/THOUSX1f1nml3NM360mFvLtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723228061; c=relaxed/simple;
	bh=AKsQjCJ02Z/I1BlmU8tyAyLrZ9GwnE28xmKVIclGcWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hM7D5J1SDb99fRYeJdD8GeN/bi5jzoj5j/ieHOqyLbqJDN8mBSdcZtaKSmOadK1qfE6CQ4sf8U6TsgHVZqFCupOufl+8ky1FjrJ/ezTZx9GmUnEbLjMw001nDi9/Ow18IHPSccGg5FCgwRlvKmObzu6a/vG0wIAgbSYoeh0728g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RfEXvnYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RfEXvnYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA53CC32782;
	Fri,  9 Aug 2024 18:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723228060;
	bh=AKsQjCJ02Z/I1BlmU8tyAyLrZ9GwnE28xmKVIclGcWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RfEXvnYyBOTiV5wM+QEAq06S1/dKw7OWHb5LDXaW7taDlH/0vW/Jzxh3amg5BRhxc
	 q+h7gB3bSpvSFzTCaJafyG0sjcfdY+vIxJnM39rkGf7aO/wVe0Nymr8kEhvZd3SWFu
	 A/lwIscHaPWeqQ2VFx5UIjvsQBv+4JBT8bDAyAN7jwgw6S9Xhyz0/6Pw4Du0ziVGCr
	 /OdiJvbzFnYDp424OZ1+wJbB4SH3GVQS3lQ34pxSzBpGmO8Pmum7+YmdTiftmAyJyU
	 u2kA49aDCsquKlLg5Boj2fXjf1O1UX7amF7+hP6/5Gg6Sj5Q7A3TMAQSHeEOVmwBTU
	 6dx9Rx0niSZvw==
Date: Fri, 9 Aug 2024 18:27:39 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [BUG] More issues with arm/aes-neonbs
Message-ID: <20240809182739.GA3897645@google.com>
References: <ZrFHLqvFqhzykuYw@shell.armlinux.org.uk>
 <ZrH8Wf2Fgb_qS8N4@gondor.apana.org.au>
 <ZrRjDHKHUheXkYTH@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrRjDHKHUheXkYTH@gondor.apana.org.au>

On Thu, Aug 08, 2024 at 02:17:48PM +0800, Herbert Xu wrote:
> IOW we're loading aes-arm-bs which provides cbc(aes).  However, this
> needs a fallback of cbc(aes) to operate, which is made out of the
> generic cbc module + any implementation of aes, or ecb(aes).  The
> latter happens to also be provided by aes-arm-cb so that's why it
> tries to load the same module again.

IMO, for CBC encryption aes-neonbs should just implement it itself on top of the
assembly function __aes_arm_encrypt(), which is actually what it did originally
before commit b56f5cbc7e08 ("crypto: arm/aes-neonbs - resolve fallback cipher at
runtime").  I don't find the motivation of that commit particularly convincing,
since aes-arm has a higher priority than aes-fixed-time anyway.  Also since
commit 913a3aa07d16, aes-arm is partially hardened against cache-timing attacks.

- Eric
