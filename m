Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339C72D73A1;
	Sun, 10 May 2026 23:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778456695; cv=none; b=VnikULIu4O81PNom+ak46oWhuCEewzBt9hcUi8UEqjmmmOm7mtDmruZzlflB3lNFxg4VHFCjDBmq3EajZuj7C4p5ip3MXU/WpVDyTFIwHCOtGPpIXYpwSLYp6Vsn+lhF24vBovSJVq5I+HuuHMpRcoSiCtoZhWndSBe0VzlB+0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778456695; c=relaxed/simple;
	bh=RcUKnhWi6qaoj8tAgzmERbuOfoMtnEGv+rXyWR1mvkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9Xjq6csDhuXVfOHlhaW4S5LAzf7xa5etgwksDCWflzPT9SCucHjWBBillwhdJ2iBGMGS75PavriaaBWZ2f3BxLABH10u16uovMiZ3egg4FnBfH2nRr005XP6BWKX1QBADp6miOFlq9ahnYhwRxBHxKigPCrHb+aKF0tlzY5asM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mqGN+HGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mqGN+HGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC89C2BCB8;
	Sun, 10 May 2026 23:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778456694;
	bh=RcUKnhWi6qaoj8tAgzmERbuOfoMtnEGv+rXyWR1mvkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mqGN+HGRDpOFz0qS3hjk1d09ghZMea8IJ/Pzf+HddzlcMFXTHH4nrS3Rip1Bi/6/7
	 WjWQM0uJjB8FGUeH4oM4PVVAO9DNThHmwi9DCJUeOzJvEg3zzuLX+EPuaktxlewAXS
	 Dfc5yLvDkBaBSSkqAN23ZTPRhi/YInn8Zrudz9djBqaxt2XJBxZY7hDWvdtnRdtSKI
	 7LDarBWpr/+emkdFZhZaYAwI/xvlbSLeIThZN6OxnRQsdmYZsBpZVq+m7vyOKivEls
	 zCyE9w0Yu2GG5UjUdmVEuI/68AYiiQMA/unWmyG47zvFXABdjgvgxq88+0ui/LgZiT
	 XdN5QZ9sH6wEQ==
Date: Sun, 10 May 2026 16:44:52 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: herbert@gondor.apana.org.au, "David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH] crypto: ctr - Convert from skcipher to lskcipher
Message-ID: <20260510234452.GB60510@quark>
References: <20260510230901.1772949-1-knecht.alexandre@gmail.com>
 <20260510233237.GA60510@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260510233237.GA60510@quark>

On Sun, May 10, 2026 at 04:32:39PM -0700, Eric Biggers wrote:
> On Mon, May 11, 2026 at 01:09:01AM +0200, Alexandre Knecht wrote:
> > Replace the existing skcipher CTR template with an lskcipher version,
> > following the pattern established by the CBC conversion (705b52fef3c7).
> > 
> > This enables BPF programs using the bpf_crypto kfuncs to use CTR mode
> > ciphers like ctr(aes), which previously failed because
> > crypto_alloc_lskcipher() could not find an lskcipher implementation.
> > ECB and CBC already have lskcipher support; CTR was the missing piece.
> > 
> > The rfc3686 template remains as an skcipher and continues to work
> > through the automatic lskcipher-to-skcipher bridge.
> > 
> > Tested with NIST SP 800-38A test vectors (AES-128/192/256-CTR),
> > partial block handling, and rfc3686 compatibility. Kernel self-tests
> > pass on instantiation (selftest: passed in /proc/crypto).
> > 
> > Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
> > Assisted-by: Claude:claude-opus-4-6 checkpatch
> 
> I'm confused.  Why was that BPF crypto feature even added with ECB mode
> as the only supported encryption mode?  Who is using that, and why?
> 
> CTR isn't necessarily much better, either.
> 
> What is the use case for the BPF crypto?  The first step should be to
> decide what *specific* algorithm(s) it needs.  It doesn't seem like that
> has ever happened, and I'm not sure this patch helps much.
> 
> That needs to be done anyway.  But that would also be helpful for a
> potential future switch to lib/crypto/, which would avoid all the weird
> issues with lskcipher etc.

Also note that lskcipher doesn't provide access to the accelerated AES
mode implementations.  Indeed, almost nothing is supported by lskcipher.
The fact that you found something to be missing isn't surprising.

I think "lskcipher" is kind of a dead end, to be honest.  It's not clear
why it got added.  The path forwards is to get the AES encryption modes
added to lib/crypto/ and to just use that instead.

- Eric
