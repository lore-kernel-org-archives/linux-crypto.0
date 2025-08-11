Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C991A9F9D;
	Mon, 11 Aug 2025 16:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754931494; cv=none; b=EiPOWCG0k12r+LffznYHCIYS2axAqvHoqIulCGsXdViMIkjaHCfQpwK076ml5j2Paw0EBAxx2SeTW2xw0cPV1hHhKSpLAAANnOUgwfCtAQMeW7MeTwY6mnkJbGpa41b1Nesh7B45aXuFoidRippjLSU6P0GMleWW1jvHMMtTN0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754931494; c=relaxed/simple;
	bh=vhIWkMe9xZuLR1MCYOu+lScCuk2ix+fF30y3C/lLH/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NuhD4yKmCA+fAXAsCA5nlKwLIesSO/Vb73lZhMtIyb1sYp6NymU0nNndOEUnqnV0JuVyDoBVTrcxeAEGdW/USQe2JyfHgV/zHaIY6PmR9ZAOwHJrOfAVmR+cO9kTJEAbEdC3s0g1cBmOJ7GbVGGaKN/bS7d4bHT/ern0DO06e74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sONXsW60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sONXsW60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848D1C4CEED;
	Mon, 11 Aug 2025 16:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754931493;
	bh=vhIWkMe9xZuLR1MCYOu+lScCuk2ix+fF30y3C/lLH/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sONXsW60pwmGh8AZKW4mmEi7e4WghqFXFlxWHF8TGVs8W3gwzUPjzArztRizMzZrN
	 jAVTegyaKXUArPPiwydGWhN3U884GH1bCbff/RPDrDHwpZ1nXu1Qx1Iq7jsPvI9HWH
	 0nNX86+ZqnViDgiyuBL6nXYOQTd9ZDwrVx4WTRlwY7aBNUz2hrRmKmTiSGLMJVTPqV
	 6fsrh7byLck/KEc6bR4FwEmXxRzamAJS4h+ekTnQUQQhTJZSHVpYKrrl8gv6OEKYRg
	 Q9LI5UrBOw7mkDMjW7pbAh7DcE/wwcE6zmPNYkibYyirqhu6vdoF8yju52Rb8Z1OIm
	 8HffxoUxwr2lQ==
Date: Mon, 11 Aug 2025 09:57:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: hash - Make HASH_MAX_DESCSIZE a bit more obvious
Message-ID: <20250811165712.GB1268@sol>
References: <aJWOH9GgXhoJsHp6@gondor.apana.org.au>
 <CAHk-=wgE=tX+Bv5y0nWwLKLjrmUTx4NrMs4Qx84Y78YpNqFGBA@mail.gmail.com>
 <72186af9-50c4-461a-bf61-f659935106cc@oracle.com>
 <CAHk-=wjn5AtuNixX36qDGWumG4LiSDuuqfbaGH2RZu2ThXzV-A@mail.gmail.com>
 <aJl1EIoSHnZRIQNO@gondor.apana.org.au>
 <CAHk-=wg1okLMc41jaxS+WRXigw7Fu+OUc6QsnL+BbvYAGTdZYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg1okLMc41jaxS+WRXigw7Fu+OUc6QsnL+BbvYAGTdZYA@mail.gmail.com>

On Mon, Aug 11, 2025 at 10:10:44AM +0300, Linus Torvalds wrote:
> On Mon, 11 Aug 2025 at 07:44, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > The patch below should make the constant a bit more obvious.
> 
> Indeed.
> 
> It would be good to maybe minimize the on-stack max-sized allocations,
> but that's a separate issue. Several hundred bytes is a noticeable
> part of the stack, and it's not always clear that it's a shallow stack
> with not a lot else going on..
> 
> (I just randomly picked the btrfs csum hash to look at, which can
> apparently be one of crc32c / xxhash64 / sha256 or blake2b, and which
> is then used at bio submission time, and I wouldn't be surprised if it
> probably has a pretty deep stack at that point already).

HASH_MAX_DESCSIZE has to be enough for *any* algorithm accessible via
the crypto_shash API, which makes HMAC-SHA3-224 be the limiting factor.
By converting users to use the library APIs instead, they will instead
use strongly-typed contexts that are sized correctly for the algorithms
actually being used.  In the btrfs csum case, the applicable sizes are:

    shash_desc + HASH_MAX_DESCSIZE: 377
    blake2b: 232
    sha256: 104
    xxhash64: 76
    crc32c: 4

So the reduction for btrfs will be 377 => 232.  But blake2b is missing a
library API, so I need to add that first.

- Eric
