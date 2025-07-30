Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6EA2D8DD0;
	Wed, 30 Jul 2025 16:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753891963; cv=none; b=ifh+KdnXXmzcoEDFSFOuGx0J1pQp6W/u4UrVYSqacwA+XdaibjmrUTbx6r6maOUeOQcILhN6efHJm3Q+LeYbujdmyfR75F6UwZttTKVZd+E4zSGnLAc7JPhBCk24U/R+D7g8VY06X32/3Fa4KbencSwwHcLL2g6HiYd0+ZT1kCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753891963; c=relaxed/simple;
	bh=aHfuhbgPN8slZRgKZ6sa4dHmZTF2eaTUTZxss+yKVjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jr2WWmRnw2hkNcvxhuExt+Dz/pria+1+HwcRhLqK9J1jEg5psrbuPqQ7bpiA5WroAXP8gepmkiw7OoHHNn/RDViQuOK/KncDi/7ERmc8d8hd2i2mTsJrPmKMaIfdA+ySskm57/9tgwT0cs36Y7vGzQDj0wdzFWtheyKv/nX7+QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AhSRgKtP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AhSRgKtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6337FC4CEE3;
	Wed, 30 Jul 2025 16:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753891962;
	bh=aHfuhbgPN8slZRgKZ6sa4dHmZTF2eaTUTZxss+yKVjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AhSRgKtPFGjtjO5mv7+geQdueZ4Hr5pupEEI6I303KGy1fcRAGkPrzv+NEJTiBysN
	 BWW88kTJhIZT5X5FpHHF3dp8xKA74p4jL8699LdRcbgvfrTixMvWjLYmHy02emn0hY
	 xeBjQn5SmDuJhYsAZ++OEsbs9PpbZ6cxYlcT7tow9WtAApGNe8idhUW8MgXWY8+Cmx
	 lKYfSRRQEqaBy6U2kllOsq0czGTxBVrPISNJ2aHBftZSrTIYK5IbUqe/gxjZnMzYJy
	 ZnnYd4PKPHfRCzq62S40XNA759CREYaDXQB3kTx4kyS7K6fzSD/n9I24aw5IGS6Hff
	 usTLN/vaGsP+g==
Date: Wed, 30 Jul 2025 09:11:49 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: Regression: hmac(sha3-224) is missing in newer kernels on s390?
Message-ID: <20250730161149.GA1162@sol>
References: <8b954aa1-ce73-4f3a-9c8a-5667fac602c9@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b954aa1-ce73-4f3a-9c8a-5667fac602c9@linux.ibm.com>

On Wed, Jul 30, 2025 at 10:11:47AM +0200, Ingo Franzki wrote:
> Hi Eric, Herbert,
> 
> I just noticed that the algorithm 'hmac(sha3-224)' is not supported anymore.
> This is at least on yesterday's 6.17 as well as on linux-next.
> On earlier kernels 'hmac(sha3-224)' was available. I don't exactly know when it started to be missing. 
> I can't tell if the same is true on other archs. 
> 
> 'sha3-224' as digest is there, but 'hmac(sha3-224)' is not. All the other sha3 and all sha2 variants are there as well (digest and hmac).
> 
> # grep "sha3-" /proc/crypto
> name         : hmac(sha3-512)
> driver       : hmac(sha3-512-s390)
> name         : hmac(sha3-384)
> driver       : hmac(sha3-384-s390)
> name         : hmac(sha3-256)
> driver       : hmac(sha3-256-s390)
> name         : sha3-384
> driver       : sha3-384-s390
> name         : sha3-512
> driver       : sha3-512-s390
> name         : sha3-224
> driver       : sha3-224-s390   
> name         : sha3-256
> driver       : sha3-256-s390
> name         : sha3-512
> driver       : sha3-512-generic
> name         : sha3-384
> driver       : sha3-384-generic
> name         : sha3-256
> driver       : sha3-256-generic
> name         : sha3-224
> driver       : sha3-224-generic
> 
> On a 6.11 kernel:
> 
> # grep "sha3-" /proc/crypto
> name         : sha3-384
> driver       : sha3-384-s390
> name         : sha3-512
> driver       : sha3-512-s390
> name         : sha3-224           <---- its there
> driver       : sha3-224-s390
> name         : sha3-256
> driver       : sha3-256-s390
> name         : sha3-512
> driver       : sha3-512-generic
> name         : sha3-384
> driver       : sha3-384-generic
> name         : sha3-256
> driver       : sha3-256-generic
> name         : sha3-224
> driver       : sha3-224-generic

I haven't touched SHA-3 yet.  This is a bug from the following commit:

    commit 6f90ba7065515d69b24729cf85c45b2add99e638
    Author: Herbert Xu <herbert@gondor.apana.org.au>
    Date:   Fri Apr 18 11:00:13 2025 +0800

        crypto: s390/sha3 - Use API partial block handling

        Use the Crypto API partial block handling.

        Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

That increased the descsize of hmac(sha3-224-s390) from 368 to 369,
which made it exceed HASH_MAX_DESCSIZE, causing it to fail to register.

- Eric
