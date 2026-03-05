Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1A4336EEE
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 07:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772697368; cv=none; b=jUb8mMeYdyPsifbFMCgQPj+Z7pP14GWpd18lQYunnZzddk6pudT0MKKx7xEmFPzPWcyDNJ3dT7ze9HOlZIX4Im8bWGlYB+qsHhbPU1OCbiPWQigacpG1FYhJMFjdHXKMGO1A8UUtUoMJCqusFCa6gtKiYR+A7fZ5v6UGKKV9CUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772697368; c=relaxed/simple;
	bh=1uvuDl/Y3gLVfquzoaiUiTSbGUo4G1mbvzG54I/wHbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uGYoxO5q65UGGqtu8EcayYDwo4/ZGklWZLTMEYljkClDKwxwNcl4EuwpAuj00ImFthLqEbdpXim8Cqv4sybSwZ59xVWXLIMijqPqjrm0myacy50AqzOFRpBz5RZZuDChIraPrPZwvEdrDTOcZ2/mKrTp9cL1bLeTGHtuaac+/FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ar/QqQQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ar/QqQQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12DCC116C6;
	Thu,  5 Mar 2026 07:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772697367;
	bh=1uvuDl/Y3gLVfquzoaiUiTSbGUo4G1mbvzG54I/wHbk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ar/QqQQz2OsbWBJA2agAoEl7GFJNApHxRpOLUZiddUZTFT3KTHMaT31dKjP9H/vjH
	 mkz91joEeAG4re6wdjo9JZbbE6HdmYT/bWTHj27RHpPNR1Y2ADEtFIyMJdeHk6EeSF
	 lxNGvefgxDiRx9MUlMRhJ6tZxUCAoMlAZiiJWLtXnlnjW89UJ+XYdZ6W/qFDjHnIPt
	 tlwg2rTck2kMwVeexTgSov5uDRMFENgQd8KGHiO0fI46mwWMGROP7+McyO0DTggR7z
	 qvs4899U2ezAKeJrC81MoFaU2qbtPoMOtbXZ2Xfy0wcNlqji1GJFUJTMzMVKHcCmj2
	 GjUS8UmfDMwGw==
Date: Wed, 4 Mar 2026 23:55:11 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: Re: [PATCH v3 0/5] pkcs7: better handling of signed attributes
Message-ID: <20260305075511.GA155793@sol>
References: <20260225211907.7368-1-James.Bottomley@HansenPartnership.com>
 <20260226021331.GA55502@quark>
 <3900433c727c1e7ab6e131003de7ca53bb0d23d1.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3900433c727c1e7ab6e131003de7ca53bb0d23d1.camel@HansenPartnership.com>

On Thu, Feb 26, 2026 at 07:43:54AM -0500, James Bottomley wrote:
> > If this is for some out-of-tree module, we don't do that.
> > 
> > I'll also note that we should generally be aiming to simplify the
> > PKCS#7 signature verification code, not making it even more complex.
> 
> I'm fine with the general goal, but since the current code verifies the
> signature, pulls out the message hash and other attributes, compares
> the message against the MessageDigest one and then frees the whole
> structure it's a bit hard to see how the current goal can be achieved
> without extracting at least the first part of that ... but if you have
> a suggestion, I'm happy to implement.

Sure, just incorporate your auxiliary data into the actual message being
signed and verified.  Something like:
    
    program_len || program || hash*

Then there's no need for the complexity of signed attributes.

You could also just use a regular signature without all the pointless
complexity and bugs of PKCS#7.

- Eric
