Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5D516DEC2;
	Wed, 12 Jun 2024 09:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718185346; cv=none; b=epWFw1TqpDzo2pbLrPhMrpiaubDctO7QuHGaBTsjUcCMFQNlz1OKtHMo9gszB0htOWqL/OztuvVpGS0dxhtY+26rst/ev9uJoNPSk4Dm6+4t3xkjKIJ0NqUq6OxOquJA3nSkE/fCpfAVwIjng/DRoBJjdbeRYFns2Ii5wHOWUQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718185346; c=relaxed/simple;
	bh=R+t/3TmfWGMMVfcJMYGOsubLVJg+XEloNKBXBBV1p8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PC/HmD2TsT3ori2BvoqEvur7IKe/z3q6uILVOqqNTFDojS+dPe8Jtk4ML8hueJprpZyGBX6svzzHrsYtKvyF9DlQGoO9wTm4fLXH5baAPr9DOcfseRlSnhuqceAzQz7tOn8BM3lVWIAWgAvE+buEZomTPivULAbPJ4NdheHmB9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sHKUj-008QIU-1m;
	Wed, 12 Jun 2024 17:42:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Jun 2024 17:42:20 +0800
Date: Wed, 12 Jun 2024 17:42:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v5 04/15] crypto: x86/sha256-ni - add support for finup_mb
Message-ID: <ZmltfGWFTj2Kq7hN@gondor.apana.org.au>
References: <20240611034822.36603-1-ebiggers@kernel.org>
 <20240611034822.36603-5-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611034822.36603-5-ebiggers@kernel.org>

On Mon, Jun 10, 2024 at 08:48:11PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add an implementation of finup_mb to sha256-ni, using an interleaving
> factor of 2.  It interleaves a finup operation for two equal-length
> messages that share a common prefix.  dm-verity and fs-verity will take

I think the limitation on equal length is artificial.  There is
no reason why the code couldn't handle two messages with different
lengths.  Simply execute in dual mode up until the shorter message
runs out.  Then carry on as if you have a single message.

In fact, there is no reason why the two hashes have to start from
the same initial state either.  It has no bearing on the performance
of the actual hashing as far as I can see.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
