Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AB517C211;
	Tue,  1 Apr 2025 04:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743480534; cv=none; b=iL7+AwCRMq8e7K94LDiCkqgqcZizOHsMoGYo2rWYcgX+qMDGz6Smh6I+bKsBak/Xv5pSC+Eg3mY4lSDypCmYifvnbvbRcBkj75ekX6YsDGaJzIsq1OArs+Uuwb/ztpWGxB3WEFDkv+ygXvgrxgrTEQ7cnPBa5FsIMSbZW3I4vOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743480534; c=relaxed/simple;
	bh=9DGhHeh0aIhG9M8O0Tnzda6njR3alclN8vXawDmwNZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0fGrJO4oAPfSIl1BzLT9P53FsYJ1KRZOyEQ2Zm5SyoVIywz7VxoIXXI2ZVKw2CSRi20HKMoS9A9OJpTBT4aJC8PUtTAlZbcqbsrLEk8dxa/3KF7pZ/7FLYkrEW3w0R1fsF6/O7zMIgsvAtpnLP/EIGqu/Edi7Jmn/utDKR6k5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lEle6GKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lEle6GKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822C7C4CEE8;
	Tue,  1 Apr 2025 04:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743480533;
	bh=9DGhHeh0aIhG9M8O0Tnzda6njR3alclN8vXawDmwNZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lEle6GKhMhjQhhXq6dVg05ETdxpJ+liuA1a4DSE99lTpoTWlEHgcGDpWXVC7HtWJN
	 t1uSmZObzwA/McrcV20fC9Zn7/V0NK6iGtcm9sZr/kFZFK4TOReyfWkClF1mQg8l7D
	 Tuk2TY2ljleU3gzeNa3L5tCtmi0negxNYr2YV67w7D3QCVR0grnF19k0gxYSaRX+12
	 dAsAul8IUcyCecIUrRd27k8378AB9aiiGGvOp9px1ytjtRhwgKZYfxezLICoUqtBOq
	 FcrRRb4j+zMPtJFrmb8FyOjtT+YgAk3xWyjQY817Da8R4QxKh4WWjdwlzkgzAUWNbM
	 vTZLAqFSSDLXw==
Date: Mon, 31 Mar 2025 21:08:52 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Chaining is dead
Message-ID: <20250401040852.GC56851@sol.localdomain>
References: <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
 <20250326033404.GD1661@sol.localdomain>
 <Z-N55Yjve6wTnPqm@gondor.apana.org.au>
 <Z-itc_Qd5LLn19pH@gondor.apana.org.au>
 <20250331165630.GA3893920@google.com>
 <Z-tTEjCzpgDr9a-3@gondor.apana.org.au>
 <20250401033303.GA56851@sol.localdomain>
 <Z-tjluCx71ti6Ngq@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-tjluCx71ti6Ngq@gondor.apana.org.au>

On Tue, Apr 01, 2025 at 11:55:02AM +0800, Herbert Xu wrote:
> On Mon, Mar 31, 2025 at 08:33:03PM -0700, Eric Biggers wrote:
> >
> > - It would add the overhead of keyslot management to software crypto
> 
> That seems to be a design error in blk_crypto.  Why should we
> model the inadequacies of hardware in software?
> 
> If we're going through the software crypto path in blk_crypto,
> it should be done as a first-clsas citizen, and not as a poor
> man's version of hardware crypto.

Interesting seeing this argument coming from you when the whole Crypto API is
built around forcing software crypto to use interfaces designed for hardware.

Currently the blk-crypto keyslots are "needed" even for blk-crypto-fallback
since otherwise it would be necessary to expand the key
(crypto_skcipher_setkey() in the Crypto API, or its library equivalent like
aes_expandkey() if we switch to that) for every I/O request.  The blk-crypto
interface could be reworked to support pre-expansion of the key, but that would
differ from what actual inline encryption hardware needs.  So this is just
another case where the needs of hardware vs. software diverge...

- Eric
