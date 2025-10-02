Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ACD17A586;
	Thu,  2 Oct 2025 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759421355; cv=none; b=gAQTtg3ImwEEVOrb6LkkbzNv74ZiDfxLPmsWbT6V11f83oPvC2YDJZFgnBaPIRqX+M1zEUQ8VMtgRhFPvxm0rfKTtrKBDuoWPFzqabmGMQjyNBB63yFeG0ruWuB1MeVZHN4f5TxFDrspdCkhfRkIYvzW02n9qY73jEK54cgr0rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759421355; c=relaxed/simple;
	bh=xrpQZHO3iI+KPMeFcf7bviH6GVHikFXA0GPqGdBZ8ks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X8b545zqq0zP4ayxpTLbJ9hL9cO6ojqp1hUMV9+gZOYc6XE7GucySO5OunxnZIJBTjmfE3jKCVtQFx/+9oojC9t1x+99prqKb7PrzlDqcOnLN567L08Tt9l2y7X04bwo8lXC0RRKD9p5ZeK7vHWOjUXCIIlrwlFKaExXE5imhb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UN64/055; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UN64/055"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7765C4CEF4;
	Thu,  2 Oct 2025 16:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759421354;
	bh=xrpQZHO3iI+KPMeFcf7bviH6GVHikFXA0GPqGdBZ8ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UN64/055mJnSv3/yUQ+UES7WSqhgevBRTzm6cbDLq2+hPBHNjdPW8BlnYw1joqaEM
	 Rmkj08FwmJPeF51eSSN4t8ImTVQOCUudH54sBc+u+pt9ChCvkLtSEGInWDrYXIG0da
	 gNaiVh5wGpYdXyMXLAZ7JRQ7bBMJPLbLo8m0v16edtHhZ+fYidkbW21lrcit5V2ixJ
	 uj+gkrOwpLisRptFEvFPhwc4xYWNxDcPpUhLzlqq9GyIzl21Y/g4EtiI+mEiLoqmZO
	 cW4fh9gP1Rfs36x44OBIHfmDAHvmAbPkVMr0zN4ezxetS6xZl/a0q6npu+Xo8bTxGk
	 AohSlfrYnfkWQ==
Date: Thu, 2 Oct 2025 09:07:51 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/8] lib/crypto: Add SHA3 kunit tests
Message-ID: <20251002160751.GA1697@sol>
References: <20251001160435.GC1592@sol>
 <20250926141959.1272455-1-dhowells@redhat.com>
 <20250926141959.1272455-6-dhowells@redhat.com>
 <2636465.1759410347@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2636465.1759410347@warthog.procyon.org.uk>

On Thu, Oct 02, 2025 at 02:05:47PM +0100, David Howells wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > SHA3-386 => SHA3-384
> 
> Hah.  Possibly I'm too practised at writing "386".
> 
> > If these expected outputs are from an external source, then that source
> > needs to be documented.  If they aren't, then the way in which they were
> > generated needs to be easily reproducible and documented, e.g. by adding
> > support for generating them to gen-hash-testvecs.py.
> 
> I generated them with openssl.  I'll add a note in the code.
> 
> > If that's the case, then running "./scripts/crypto/gen-hash-testvecs.py
> > sha3-256 > lib/crypto/tests/sha3_testvecs.h" should reproduce this file
> > exactly.  But it doesn't, so you must have manually edited this file.
> > 
> > It should match exactly.  That can be done by tweaking
> > gen-hash-testvecs.py to use the correct *_DIGEST_SIZE constant and
> > skipping the HMAC test if sha3-256 is requested.
> 
> gen-hash-testvecs.py doesn't know how to handle dashes in the algo name and
> they end up coming in the output as "SHA3-256_DIGEST_SIZE".
> 
> It also generated an HMAC thing despite sha3-256 not having HMAC support, so I
> just trimmed that off.
> 
> Anyway, I can modify the gen script to deal with both of those.

Yes, that's what I'm asking for.

> > >  def hash_final(ctx):
> > > +    if ctx.name == "shake_128":
> > > +        return ctx.digest(16)
> > > +    if ctx.name == "shake_256":
> > > +        return ctx.digest(32)
> > 
> > This addition is unnecessary.
> 
> Well, you can't generate SHAKE128 or SHAKE256 without it as the digest()
> method has a mandatory parameter for XOF algorithms.  This fixes that.

I know, but the script is never actually used with SHAKE128 or SHAKE256.

- Eric
