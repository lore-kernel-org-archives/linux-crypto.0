Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6530D184D
	for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2024 06:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713334490; cv=none; b=rZnBbjuI36jdCnBsPS0BCZ9KhymwTZU+dCyksUp9jef1qZ0k//GmAj9EKixcMkgJLGJHfI9uN9mscnnKi5Oxvs9QEMOR4NZ7LGTRFeTSUXjjeYrIBBEdfa6fX+deTHDIuCYEUZKOtBiZYgrPMpLHY0FoUhQUQ7hnsocsB7hMF0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713334490; c=relaxed/simple;
	bh=A4RPwYBRHz5Wo3c+mG/mFw/Z0jetzFa4Lzv/Xqu0Vjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HAjSOjFdRN+6p3QedeEkHN0QoomlanRJp1XmFYMdlhwwNvwaefyyaN0zknXIDhndpvDieFsjLFtRGM2GAJxrEHidpVVXj8+sLYcF3mE5l/N/GHNdOPtBuqoC/Y0gdVgwbAtyWVFqr6daYZhurO8Sv8rDu5dHC6dfT/KCMeOU+v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AK3L4FQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AK3L4FQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E90C072AA;
	Wed, 17 Apr 2024 06:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713334489;
	bh=A4RPwYBRHz5Wo3c+mG/mFw/Z0jetzFa4Lzv/Xqu0Vjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AK3L4FQploa/8XLopgUs2qrPfFv65nEby01w8kuB6IUH9XjXk4bPfABnh09VXW6yH
	 dqPqH8E/+Q74s04rt1RcjvVJb6BMsMRKfI1Cbfiu5gMikLPwee3BqN8H//nH6HF5of
	 symPbCY3+LDv/tSvbFsdHU3lV3C0ZwiYHp2xzr26VUM9X0nn7LxOrUQSZP5a3gbbET
	 ru656FoRfRd4PjkJbd2QVEYLMnM2tETH/6zxjLLeeqkQVKs47cy82G8pvG/HWJu9Ye
	 wvbxzR9a+ghkYYLsWujRuMPPNdvCSpaXzzmNliXRe1Jg0kkFvisnhZHXCRn1GNQJVl
	 sF/OzsUxLSgWQ==
Date: Tue, 16 Apr 2024 23:14:48 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: arm64/aes-ce - Simplify round key load sequence
Message-ID: <20240417061448.GB47903@quark.localdomain>
References: <20240415130425.2414653-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240415130425.2414653-2-ardb+git@google.com>

On Mon, Apr 15, 2024 at 03:04:26PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Tweak the round key logic so that they can be loaded using a single
> branchless sequence using overlapping loads. This is shorter and
> simpler, and puts the conditional branches based on the key size further
> apart, which might benefit microarchitectures that cannot record taken
> branches at every instruction. For these branches, use test-bit-branch
> instructions that don't clobber the condition flags.
> 
> Note that none of this has any impact on performance, positive or
> otherwise (and the branch prediction benefit would only benefit AES-192
> which nobody uses). It does make for nicer code, though.
> 
> While at it, use \@ to generate the labels inside the macros, which is
> more robust than using fixed numbers, which could clash inadvertently.
> Also, bring aes-neon.S in line with these changes, including the switch
> to test-and-branch instructions, to avoid surprises in the future when
> we might start relying on the condition flags being preserved in the
> chaining mode wrappers in aes-modes.S
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/aes-ce.S   | 34 ++++++++++++++--------------------
>  arch/arm64/crypto/aes-neon.S | 20 ++++++++++----------
>  2 files changed, 24 insertions(+), 30 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
