Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F48B4AEE0;
	Tue,  1 Apr 2025 03:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743478385; cv=none; b=AcAXdOpNNNiYjtdtoM7JGqcbkULLFhCsMYL2olEGgMhqg8jx2oVlrTtCvrLqFL+MmV0S8ZYGhCX92EW6NQZniqczLdJNSp/4cB3HPNzr9SuenVdmg7EP3bvJmX5wht2PktLgpYAd3De8tO3vNZRf458xhy+uXynsGBUi1dRNhKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743478385; c=relaxed/simple;
	bh=Sq8Q8IIdg6zgDNxdGvzay/+KN3YkB48nWuKkm2hyeZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kt3YimfQ2XxZMPqK0fWkLvay2eCoAKkFkqXOi2K0L0Ybc1agOz/6w0iUOUMgTxgoZrEkgJRffn2+YYe4ZZSNy31tOIRCOfFDknNPhaPpO9b5agOWgZrmUNyWB3F3Re5gAL9a//CXsu3bRBm9xFlobJclkSEhlpC9yWIxmGNVjXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XpUJ5KAb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XpUJ5KAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5F0C4CEE8;
	Tue,  1 Apr 2025 03:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743478384;
	bh=Sq8Q8IIdg6zgDNxdGvzay/+KN3YkB48nWuKkm2hyeZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XpUJ5KAbKusztlRjUIufkDvON7tsaoyVQSjBukUfGvcOXcapPTQMRC6trwzzLsAge
	 rSc89Mwoy2qc3NjHyW4cBZdRyS1PmmZYM7NYE4RFixcaQC0OFx3xqzAe+0Z9YLvvnb
	 0xBW3ebH0ci8jZ4rZJTX/GhEvQ/L0nG5/BEweh0qNdCv7m78dWAz5QCpJDHvKQvj7T
	 Inz6yg0AL+FVissWW9S2KXBaBrPNcCMagiApDm7gAIfcLtpOHjoNSCUobz4l9CmrKf
	 uWGQdzc7hRP+IjjaDWtW8rEJ78r/bcNrGO1KhyxcROurdhsid9bE4qQ+NWi9/fnH3F
	 zrQyUkNkysc2A==
Date: Mon, 31 Mar 2025 20:33:03 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Chaining is dead
Message-ID: <20250401033303.GA56851@sol.localdomain>
References: <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
 <20250326033404.GD1661@sol.localdomain>
 <Z-N55Yjve6wTnPqm@gondor.apana.org.au>
 <Z-itc_Qd5LLn19pH@gondor.apana.org.au>
 <20250331165630.GA3893920@google.com>
 <Z-tTEjCzpgDr9a-3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-tTEjCzpgDr9a-3@gondor.apana.org.au>

On Tue, Apr 01, 2025 at 10:44:34AM +0800, Herbert Xu wrote:
> Thanks for the pointer, I wasn't aware of its existence.  Yes
> there should definitely be only one code path for this.  So
> what's stopping you from removing fscrypt right now? IOW what's
> missing from blk-crypto?

Well, fscrypt (ext4/f2fs/ubifs/ceph encryption) wouldn't be removed; its
implementation would just change on ext4 and f2fs.  Instead of providing a
choice of whether to use blk-crypto or fs-layer crypto for file contents
en/decryption, ext4 and f2fs would always use blk-crypto.  Supporting code such
as fscrypt_decrypt_bio() that would become unused by that would be removed.

A few reasons I've waited so long:

- The fs-layer file contents en/decryption code was there first, and there
  hasn't been a strong need to remove it yet
- Much of the file contents en/decryption code in fs/crypto/ would still be
  needed, since ubifs and ceph still use it as they are not block-based
- It would make CONFIG_BLK_INLINE_ENCRYPTION, which adds a field to struct bio,
  required on more systems
- It would add the overhead of keyslot management to software crypto
- blk-crypto currently always uses inline encryption hardware when it's
  available; but, I'd like to preserve ext4's and f2fs's existing behavior where
  the use of inline encryption hardware is opt-in via a mount option.

But I'm thinking it's finally time, especially with the conversions of
filesystems to operate on folios that's going on.

dm-crypt could of course use blk-crypto too, but the dm people haven't been
super comfortable so far with delegating en/decryption to the block layer.

- Eric
