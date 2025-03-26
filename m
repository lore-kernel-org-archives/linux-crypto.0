Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0EE2904;
	Wed, 26 Mar 2025 01:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742953769; cv=none; b=ODnXroUjXuuOIP0Tm+PzG2EKPa+yeon0DWogogtdU2gHqJ30EpNe8roBdoMNLPELjUmmF+AHRE4FtY5BV1wXnGZcGFCMOuPQldKyCgSgUTH7K18bSxi9e+10CeLBI7dhx3wUBkMQ3YnRnOxzSGj5bzp7mRUWLDliJO3jxvt6Rtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742953769; c=relaxed/simple;
	bh=BSfQB3vhohoeGSPH7IwYQ017sMULToSA3/gaTifVxQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ghc1fBX8eeQeObzl8ziIzRzG21pDZrSIznoXulLl/ZRBS9p9RbsW0OHFaNHFxcPv7kENRxJJ+f1WBOT8parAq39K0AYHAEVkQHPfACW7SkOEBoV3F0Y7Xd5Iuw3Rhyw8xXzSzCQulIxQIYoNOFGxIZnG6Qa2irF+eToY4P3zFv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MG3/ndUy; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MG3/ndUy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xYq0PhsJ8psxpLRbnzh1yCpqivdOZMN2vnW/V/lGh6w=; b=MG3/ndUyyH2iN3kLDOcla02bMh
	7FZomY4TDfjztMR4qwZgF7BAqwZR9aV1N4dHmeoWN9tGy4VcznqSSRxw9uCLany3INZzbK1OsId16
	owOqlq4S+Ww4Sjryd6eVHifnaAIk9zw8UODoJ7/V+VtbK97okN6q4B0d8I+y0cHPVJO5LKijg+N/4
	gKafujWN/L7A36pMoBwrDs9Sm2WhHSYM5fbejyRWqqIh7mSB9l7ATZdh2QQiO24L5zmY/L7eQVXM4
	3QwxeDTlPRsW1QZJo9yfWT3FiqbMmVbSdVrm5bDkWt5d6KEugWQUDEg2fGkhBdIHKF1MVQEym9Ega
	9TdhN31g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1txFtK-00AAN9-2P;
	Wed, 26 Mar 2025 09:49:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Mar 2025 09:49:14 +0800
Date: Wed, 26 Mar 2025 09:49:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 6.15
Message-ID: <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
References: <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325152541.GA1661@sol.localdomain>

On Tue, Mar 25, 2025 at 08:25:41AM -0700, Eric Biggers wrote:
> 
> Herbert didn't mention that I have nacked this patch, which he is insisting on
> pushing for some reason instead of my original version that is much better.

Let's see how your version is so much better:

https://lore.kernel.org/all/20250212154718.44255-6-ebiggers@kernel.org/

-	/* Up to 1 + FS_VERITY_MAX_LEVELS pages may be mapped at once */
-	BUILD_BUG_ON(1 + FS_VERITY_MAX_LEVELS > KM_MAX_IDX);
+	/*
+	 * Up to FS_VERITY_MAX_PENDING_DATA_BLOCKS + FS_VERITY_MAX_LEVELS pages
+	 * may be mapped at once.
+	 */
+	BUILD_BUG_ON(FS_VERITY_MAX_PENDING_DATA_BLOCKS +
+		     FS_VERITY_MAX_LEVELS > KM_MAX_IDX);

This arbitrary limit is a direct result of your welded-on commitment
to an API that supports virtually mapped addresses only.  Make no
mistake, virtual addresses are simple and easy to use, but the kernel
added more complicated constructs for real reasons.

I've gone through your use-case in fsverity/dm-verity, and they
never touch the data at all so the only reason for it to kmap the
data at all is to feed it to the Crypto API, which is capable of
doing its own kmap but you elected not to use that because you
hate the interface.

In fact it's a recurring theme, the zswap code jumps through multiple
hoops to map the data they're working on so that they can feed it to
the Crypto API as a virtually mapped pointer, even though they never
touch the mapped data at all.  The same thing also happened in ubifs,
which I managed to simplify by switching away from kmapped pointers:

https://patchwork.kernel.org/project/linux-crypto/patch/99ae6a15afc1478bab201949dc3dbb2c7634b687.1742034499.git.herbert@gondor.apana.org.au/

-		addr += UBIFS_BLOCK_SIZE;
-		if (folio_test_highmem(folio) && (offset_in_page(addr) == 0)) {
-			kunmap_local(addr - UBIFS_BLOCK_SIZE);
-			addr = kmap_local_folio(folio, i * UBIFS_BLOCK_SIZE);
-		}
+		offset += UBIFS_BLOCK_SIZE;

All this complexity was added because the legacy compression
interface only supported virtually mapped addresses.

Sure the ahash/acomp interface was suboptimal for *only* supporting
SG lists, which is what this pull request addresses by adding virtual
address (and folio) support.

> Let me reiterate why "request chaining" is a bad idea and is going to cause
> problems.

I'm more than willing to discuss with you the implementation details
of how the chaining is done and improving it.  However, if you proceed
to only issue blanket nacks without providing any constructive feedback,
then the only thing I can do is ignore you.

> In contrast, my patchset
> https://lore.kernel.org/r/20250212154718.44255-1-ebiggers@kernel.org/ supports
> multibuffer hashing in a much better way and has been ready for a year already.
> It actually works; it has a smaller diffstat; it is faster; it has a much
> simpler API; and it actually includes all needed pieces including x86 and arm64
> support, dm-verity and fs-verity support, and full documentation and tests.

Everybody wants to sratch their itch but my job as the maintainer is
to ensure that the subsystem doesn't collapse into an unmaintainable
hodgepodge of individual contributions.

Yes I get that batching is useful for you, but your use-case is not
unique at all.  The compression people are proposing pretty much the
same thing

https://patchwork.kernel.org/project/linux-crypto/patch/20250303084724.6490-15-kanchana.p.sridhar@intel.com/

I don't want to be pressured by you into committing to an interface
that works for you only.
 
> Nacked-by: Eric Biggers <ebiggers@kernel.org>

This pull request doesn't even contain the meat of the hash changes
since I've been busy with the compression work.  So this is simply
a pre-emptive strike to stop further work from rendering your patches
obsolete.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
