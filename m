Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17572C11D1
	for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760461034; cv=none; b=T/wyTk7BXwAsvWcgOrLZqu2wetMGnLxb/N9l0yzuIEnQAXwThuygHEU2+X/nK/CWkQVFr4u/vyxYdl//pQcWl/tOdczayAC3bTBHjREcY0agb28KZkIS6oiHkkt7RgxO82b2GlFSyNbBrMXHH866yfST+zfbeZdpn9JBuLGZgqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760461034; c=relaxed/simple;
	bh=jhU5OSU6sx+ZIRGEQoIvZaJhGdkp2J2TcO2wusofJZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T80Pgm0tIB0yFLJlFyy6t0q9a4nrY1VpC1aACElAm3nFcw923gqVA8mcV8HuPZMweEEiuclf8zzVlO2C16gxj7ha0hZSylaMCbSqUwwWHPNAJqPry1FyR9qRjqRl0nkz2cweULN/fOWsXdQmloaCmNXAFcU1rEavBN2XkG/T4zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hhWcuWUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhWcuWUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16454C4CEE7;
	Tue, 14 Oct 2025 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760461034;
	bh=jhU5OSU6sx+ZIRGEQoIvZaJhGdkp2J2TcO2wusofJZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hhWcuWUCqq7FI0r2OZBta+eowIRgz6qk/YLWCXEn8YjWnzF9c0z6LlvrWANCA3U05
	 SSLRsllTT6XG+D86lAe+tmhBnOA+qQKnwdAr2MfTX6iwMo/OYHL7yBzEHDQQzkTYdP
	 yQrxV1m2IVsuam7wbASPbG548pkt6aE7HUB0wty+Vy6ZY2wHtE8enmMSXbS7hzVii3
	 +1p4cnEdyMcqXlWg/FzjeHVxaeVvEFYy818oOFYcoTFZ4gGgb9xGi5ZSCQDFWpukmc
	 Dfen7YouwZ3cui0m3gWXZ2sGqNvav2V78I+Fy6HxDApW/mu7VJ+zWXIolGXkeT+qUU
	 D179aGnQCMhKg==
Date: Tue, 14 Oct 2025 09:55:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: Adding algorithm agility to the crypto library functions
Message-ID: <20251014165541.GA1544@sol>
References: <d4449ec09cf103bf3d937f78a13720dcae93fb4e.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4449ec09cf103bf3d937f78a13720dcae93fb4e.camel@HansenPartnership.com>

On Tue, Oct 14, 2025 at 12:01:34PM -0400, James Bottomley wrote:
> The TPM session calculation functions recently got converted to use the
> rawkey functions instead of open coding it 64a7cfbcf548 ("tpm: Use
> HMAC-SHA256 library instead of open-coded HMAC").

To be clear, drivers/char/tpm/tpm2-sessions.c has always been hard-coded
to use SHA-256 and HMAC-SHA256, and it's always used the SHA-256
library.  It just open-coded the HMAC construction.

> because the user has no input on the hmac hash algorithm so, although
> the TPM specifies it to be agile, we can simply choose sha256. 
> However, we have plans to use what are called policy sessions, which
> have require the same hash as the user supplied object used for its
> name (essentially a hash chosen by the user).  In a TPM these hashes
> can be any of the family sha1 sha256, sha384 sha512 plus a few esoteric
> ones like sm3.  So the question becomes: to avoid going back to open
> coding the hmac and using the shash API, is there a way of adding hash
> agility to the library algorithms?  I suppose I could also do this
> inside our hmac code using a large set of switch statements, but that
> would be a bit gross.
> 
> If no-one's planning to do this I can take a stab ... it would probably
> still be a bunch of switch statements, but not in my code ...

This isn't the job of lib/crypto/.

If a caller would like to support a certain set of algorithms, it should
just write the 'if' or 'switch' statement itself.

The nice thing about that is that it results in the minimum number of
branches and the minimum stack usage for the possible set of algorithms
at that particular call site.  (Compare to crypto_shash which always
uses indirect calls and always uses almost 400 bytes for each
SHASH_DESC_ON_STACK().  SHASH_DESC_ON_STACK() has to be sized for the
worst possible case among every hash algorithm in existence, regardless
of whether the caller is actually using it or not.)

That approach is already used successfully in fs/verity/ and net/sctp/.
I'm planning to make fs/btrfs/ adopt it too.  It works fine, and it's
the most efficient solution.

If a particular caller has a super long list of algorithms or is dealing
with a legacy arbitrary user-specified string, then it's of course still
free to use crypto_shash.

But I have to wonder, do you really need to add support for all these
hash algorithms?  Adding SHA-1 and SM3 support, really?

What stops you from just saying that the kernel supports SHA-256 for
these user supplied objects, and that's it?

Getting kernel developers to think carefully about what set of crypto
algorithms they'd like to support in their features, rather than punting
the problem to a generic crypto layer that supports all sorts of
insecure and esoteric options, isn't necessarily a bad thing...

- Eric
