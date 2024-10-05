Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89802B9A6;
	Sat,  5 Oct 2024 22:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728167090; cv=none; b=SmBXrNqYDIZcIyV5sROyMAptDlbC6rDhRQDYzNXijBsz9qN/t/Vq+nvM1bIuUwgb0zum0JgD7LwUy36ng7tF81QTIpvciKJRqKKCEgPs1wAWYkHRy1LzF5zTbV1k9q2nonINp3xNzhdI9rj7cPG64OstJ5bdfGVmWHcmh4rmoPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728167090; c=relaxed/simple;
	bh=kDmOTkqU+mtVkWcFBrBhjsbbyJJ+k0EDqKHVsSe00Z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3g0MqqHTBL8ryXJSDFafwUHNNKkqV79oJbN75bJi2bnc9BSIAWE8aTZtRg90m+pr0lrAXCEnu+JgrC+/OYXZY7kpB/Dd1Fi6W1OYRKiBMNNEGuCIZu347LVbXXxXLVwILLVQj1eH9p6ZdK/iTwNZC/HsCXGIlxWOQPYZEQwQ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aNOjKEd0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aNOjKEd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D771FC4CEC2;
	Sat,  5 Oct 2024 22:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728167090;
	bh=kDmOTkqU+mtVkWcFBrBhjsbbyJJ+k0EDqKHVsSe00Z4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aNOjKEd0ftkO7XKY14bg37V5n1UpAE8kDoj5j+qcNNpNH94kmzYspk/xJ/JYR9rTc
	 rC0TsOFHzXxHRpZ5V110XY5WXBagQOB3/Qs8ZzImdS2rom/3+GSXrdMebdLLsQXL2U
	 uYJu9vmKb1rKwP9+CKJ3x4Kz6QxN+AsAaVFYT2+hUsb8THzfp+PeUDQFNPqaIOwvif
	 Cjea6LInvPRRFIyVlFtwXjV40dTgS2ZcEfwqvI+a7p+XEqFhyStP2ZI7ZyOW59GVc6
	 a82C8FWbUm9PHd+4RpRSLe0cSWK6QDCV/eQmgqoVyRxz358Gq3QzTjGMKQUa90ZqUy
	 eOOdbUDhFe9eQ==
Date: Sat, 5 Oct 2024 15:24:48 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org, ltp@lists.linux.it,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: api - Fix generic algorithm self-test races
Message-ID: <20241005222448.GB10813@sol.localdomain>
References: <202408161634.598311fd-oliver.sang@intel.com>
 <ZsBJs_C6GdO_qgV7@gondor.apana.org.au>
 <ZsBJ5H4JExArHGVw@gondor.apana.org.au>
 <ZsBKG0la0m69Dyq3@gondor.apana.org.au>
 <20240827184839.GD2049@sol.localdomain>
 <Zs6SiBOdasO9Thd1@gondor.apana.org.au>
 <20240830175154.GA48019@sol.localdomain>
 <ZtQgVOnK6WzdIDlU@gondor.apana.org.au>
 <20240902170554.GA77251@sol.localdomain>
 <ZtZFOgh3WylktM1E@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtZFOgh3WylktM1E@gondor.apana.org.au>

On Tue, Sep 03, 2024 at 07:07:38AM +0800, Herbert Xu wrote:
> On Mon, Sep 02, 2024 at 10:05:54AM -0700, Eric Biggers wrote:
> >
> > With both this patch "crypto: api - Fix generic algorithm self-test races" and
> > your other patch "crypto: algboss - Pass instance creation error up" applied,
> > I'm still getting errors occasionally, e.g.:
> > 
> >     [    5.155587] alg: skcipher: failed to allocate transform for cbc(sm4-generic): -2
> >     [    5.155954] alg: self-tests for cbc(sm4) using cbc(sm4-generic) failed (rc=-2)
> >     [    5.372511] alg: aead: failed to allocate transform for gcm_base(ctr(aes-generic),ghash-generic): -2
> >     [    5.372861] alg: self-tests for gcm(aes) using gcm_base(ctr(aes-generic),ghash-generic) failed (rc=-2)
> > 
> > I can't follow your explanation of what is going on here and what the fix is.
> > Would it make any sense to just revert the commits that introduced this problem?
> 
> As I said earlier, these errors are expected.  What's happening
> is this:
> 
> __ecb-sm4-aesni-avx gets registered (but not tested)
> 
> cbc(sm4-generic) gets registered (but not tested)
> 
> __ecb-sm4-aesni-avx finishes testing
> 	with lskcipher this is equivalent to crypto_cipher sm4
> 	so it triggers the destruction of all instances of sm4
> 
> cbc(sm4-generic) gets marked as dead
> 
> cbc(sm4-generic) fails self-test because it's already dead (ENOENT)
> 
> It's harmless because whatever that is asking for cbc(sm4-generic)
> (in this case it's the extra-test mechanism) will simply retry the
> allocation which will then succeed.
> 
> I will send a patch to disable the warning when allocating X returns
> ENOENT while we're testing X itself.  This can always happen if X
> gets killed for the reason mentioned above and it's perfectly harmless.
> 
> It's just that the race window was tiny previously because testing
> occurred immediately after registration.  But now we've magnified
> that window many times with asynchronous testing.
> 

The tests are still failing on upstream:

[    0.343845] alg: self-tests for rfc4106(gcm(aes)) using rfc4106(gcm_base(ctr(aes-generic),ghash-generic)) failed (rc=-2)

To me it still seems like commit 37da5d0ffa7b ("crypto: api - Do not wait for
tests during registration") is just broken and should be reverted.

Besides the test failures, it looks like there's no longer any guarantee that
algorithms are actually available now that their module is loaded.

E.g. consider if someone does 'modprobe aesni-intel' and then immediately
creates a dm-crypt device.  Now it sounds like the AES-NI algorithms might not
have finished being tested yet and the generic algorithms can be used instead,
resulting in a performance regression.

I understand that you want to try to fix the edge cases in "fallback" ciphers.
But "fallback" ciphers have always seemed like a bad design due to how they use
the crypto API recursively.  I think the algorithms that use them should
generally be migrated off of them, e.g. as I did in commit f235bc11cc95
("crypto: arm/aes-neonbs - go back to using aes-arm directly").  That fixed the
problem in aes-neonbs that seems to have triggered this work in the first place.

- Eric
