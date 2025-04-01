Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29C920ED;
	Tue,  1 Apr 2025 02:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743475489; cv=none; b=ILCdeQZrAUJhx5Ih316RUujdtt80cS4GDHXlV8CLzJOetf/6h6fIrhATSNyca1e6nyPNZKl3lbioF7sdo/qfd6eAZij/ehKo680LwMa4wXTiVVV6TTHJ8cgdwEQWdxtPibkhPM98LYayKBZ9dn2mG96Y2NusE3n1Gbpsa9A572U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743475489; c=relaxed/simple;
	bh=MaU432fM0ph/cWFPCSRNrrfCcdEmQ32AimHMm1XlUMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uVo/RBLl9w1jRqceVygG+rXrwwxSZ1yu01Hi0A6jVQYhVkFR6bq0DZWwM6it2YL4xd8FgckVYZl2OmfaGFEpJyfoB4kGYLQNAdO46OfgRmdgt8Z4mbEnJfHMgHpMnIKNUcF1GzNHs0r1H9YaAyOh+nF1GUTGTVeMkeXRrfW6Yko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=K1L2huJc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="K1L2huJc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kQOTTlqQ8wKvVI2WKoxwQW4K7c7RwcYzE8Add8oeXm4=; b=K1L2huJcsalalbzxMf4uvPRjjq
	mA6up6wC29ex1Vmln8/qvtAtrMZOC3ytxFY8P2Q3Zaa6ICmNos4mdEYVNsVRFAwSNSh9irJFzCnzh
	X8DbR0/Fv2OFECT8oUqTGFXZKADJWaHXMlO7dQtwOlvKw5N9fpaLk62TTq0oWngNsIo2Jx1vtfeqE
	b0TrFb5VcwFekZREkYy6YzmLrRgOw8epnX8vlZu3MmlWWhzsLvOHI12PI5WKpkdPP0MoSxSH238kZ
	d9IFf1mtQsn5bUZcAg9rwAqc7sAxhEb8bgEwoB4IWx2IAYPDG20r6lGgBVj+q8QGUtEsM7p24l8la
	ThgA4KNQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzRcA-00BjNC-1z;
	Tue, 01 Apr 2025 10:44:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Apr 2025 10:44:34 +0800
Date: Tue, 1 Apr 2025 10:44:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Chaining is dead
Message-ID: <Z-tTEjCzpgDr9a-3@gondor.apana.org.au>
References: <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
 <20250326033404.GD1661@sol.localdomain>
 <Z-N55Yjve6wTnPqm@gondor.apana.org.au>
 <Z-itc_Qd5LLn19pH@gondor.apana.org.au>
 <20250331165630.GA3893920@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331165630.GA3893920@google.com>

On Mon, Mar 31, 2025 at 04:56:30PM +0000, Eric Biggers wrote:
>
> With the bio and folio support in the generic crypto infrastructure, there would
> be lots of work to do with adding support in all the underlying algorithms, and
> adding tests for all the new APIs.

It doesn't need to be all that complex.  My plan is to add a fallback
template at the top, which could then be implemented by strategic
algorithms at the bottom through an extension of the skcipher walk
mechanism.

So you'd allocate "fscrypt(xts(aes))" instead of "xts(aes)", and
the xts-vaes code could simply use the normal skcipher walker with
zero changes.  The only changes needed in the aesni module is to
hook up the xts code to the new "fscrypt(xts(aes))" algorithm.

The real reason why I think this is the way to go is that the same
speed-up would apply everywhere.  So just as I could gain a 15%
speed-up with xts in fscrypt without any actual multibuffer code,
a similar speed-up is expected with gcm in networking.  In fact
if anything the speed-up could be greater there because the data
unit size is smaller at under 1500 bytes.

You see the Crypto API as the problem here, but for me the problem
is the legacy data unit size.  It's 2025 and there is no reason why
anyone should be dealing with units of 1500 or 4096 bytes.

> For hashing, users would need to allocate an array to hold the digest for every
> block in the bio or folio.  That would add an additional memory allocation to
> every I/O.  You said you'd like to fall back to a smaller buffer if the memory
> allocation fails.  But that's silly; if we have to support that anyway, we might
> as well do it that way only.  In which case the bio interface is pointless.

Sure if you decide to go down the lib/crypto route then there is
no gain.  All it means is that you can't support hardware offload,
but neither of us really care about that.

> Also note that the kernel also *already* has an abstraction layer that allows
> doing en/decryption on bios.  It's called blk-crypto, and it makes it possible
> to do the en/decryption using either inline encryption hardware (i.e., the newer
> style of crypto accelerator that is actually commonly used and doesn't use the
> Crypto API at all) or the Crypto API.  I have plans to remove the fs-layer bio
> en/decryption code from fscrypt and always use blk-crypto instead.

Thanks for the pointer, I wasn't aware of its existence.  Yes
there should definitely be only one code path for this.  So
what's stopping you from removing fscrypt right now? IOW what's
missing from blk-crypto?

> Adding bio support to the Crypto API feels duplicative of blk-crypto, and we'd
> end up with too many abstraction layers.  I think my preferred approach is that
> blk-crypto-fallback would directly call the library functions.  The legacy
> Crypto API really has no useful role to play anymore.

I'd certainly like to see that :)

> FWIW, there are also people thinking about developing inline hashing hardware,
> in which case something similar would apply to blk-integrity.

Offloading a whole bio rather than a page or two is definitely
the way to go.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
