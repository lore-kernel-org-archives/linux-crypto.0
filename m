Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0615223322;
	Thu, 26 Jun 2025 23:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750979640; cv=none; b=eSMcLULXS3grRk1RSNekuYFWQKTnfdJLw9GVEcYolRUnOWFJ+GdGiCK3WTG+y+XTT9k+v+OttNpnP3Ty6Tl+evGVtPJH8G+hOwhiSBj4URFQAcpKfS3ZATlDTjztbeRFOanj6ncoqA9GMAzj9iEZwITZy2hnQLuycVpM+c2L72E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750979640; c=relaxed/simple;
	bh=czkY1fdq231E9rF5h0BaiIp2+V4zrgMV8EPLXjXOBBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ffT9w8SCwBnSnChRjFi98en000KAaPVTpZM2OonuxWC9yi0GFtHwFEcb1ZslPZ8VlOTFdIYI8Nr2mTSSokhOTxlhIaHm8xPfvp1HEy034JS3x0iejufO97gd7S1wZb+hgTDzru/g1wiRENF3oc3qKrwJJTIVmgsnJqcZsVi5MJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A7+iA2+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A7+iA2+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284C6C4CEEB;
	Thu, 26 Jun 2025 23:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750979639;
	bh=czkY1fdq231E9rF5h0BaiIp2+V4zrgMV8EPLXjXOBBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A7+iA2+zq/gD6y1t9WU4z3RBIcMF33WaxHdIW24TG03bnYx28CcbzyE5lnvlMDBG/
	 ansF2TVveve7R1/VTF66hIHcgJ86uFMYFSH8rwL5HT95dda+nAU5aoro0g6rablkbt
	 ymTbyGydfM83PaEfwNVZtvEuZPaX4hyBFMAjV/4+HXQXdDPFaS+7Ut6fpb7ztspOY4
	 i7HH9r/S/kuZJ1gHUr2/sGxC0s4zNfSjd6klWKZfNBHn9PDfUc9rDLqvc6UjAsRdMY
	 QtC9S+LHJxWZo6jQjcH5fPkgVhe9jwbGj9TQCy4v/5RUxnmO3YePY3dzMoxyS5S/AO
	 4GlwHS4JgBMOA==
Date: Thu, 26 Jun 2025 23:13:57 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	Joerg Schmidbauer <jschmidb@de.ibm.com>
Subject: Re: Syzbot finding: invalid-load in arch/s390/crypto/sha_common.c
Message-ID: <20250626231357.GA3143208@google.com>
References: <12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com>
 <20250626173441.GA1207@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626173441.GA1207@sol>

On Thu, Jun 26, 2025 at 10:34:41AM -0700, Eric Biggers wrote:
> On Thu, Jun 26, 2025 at 03:54:58PM +0200, Ingo Franzki wrote:
> > Hi Eric, Herbert,
> > 
> > There is a Syzbot finding in arch/s390/crypto/sha_common.c.
> > Yes that's s390 specific code, but I guess its due to the recent changes in the digest code....
> > 
> > Seems that field first_message_part (bool) of struct s390_sha_ctx has an invalid value when s390_sha_update_blocks() gets called.
> > No idea why it could have an invalid value, I only see it being set to 0 or 1. Maybe ctx is pointing to an entirely wrong context in that call chain (bad pointer)? 
> > 
> > Does this ring a bell for you? 
> > 
> > Status: reporting: reported C repro on 2025/06/09 15:22
> > Reported-by: syzbotz+cb049f03e0851197b31a@linux.ibm.com
> > First crash: 16d, last: now
> 
> This is an issue in hmac_s390_sha512, which I haven't touched.  I see there were
> recent changes to it, though:
> 
>     commit 89490e6b80c53bf7783fe183a2fda8d0944f52d2
>     Author: Herbert Xu <herbert@gondor.apana.org.au>
>     Date:   Tue Apr 29 16:49:32 2025 +0800
> 
>         crypto: s390/hmac - Extend hash length counters to 128 bits
> 
>     commit 08811169ac016a234765e23deb45a5c8dd8aee6b
>     Author: Herbert Xu <herbert@gondor.apana.org.au>
>     Date:   Fri May 2 17:00:43 2025 +0800
> 
>         crypto: s390/hmac - Use API partial block handling
> 
>     commit 1b39bc4a703a63a22c08232015540adfb31f22ba
>     Author: Herbert Xu <herbert@gondor.apana.org.au>
>     Date:   Fri May 23 19:24:34 2025 +0800
> 
>         crypto: s390/hmac - Fix counter in export state
> 

Sorry, looking at the stack trace again, I realize that's not quite correct:

 [<00026a33d51d0d6e>] s390_sha_update_blocks+0x2ae/0x310 arch/s390/crypto/sha_common.c:26
 [<00026a33d7de95c4>] crypto_shash_finup+0x424/0x720 crypto/shash.c:152
 [<00026a33d7e06022>] crypto_shash_update include/crypto/hash.h:992 [inline]
 [<00026a33d7e06022>] hmac_setkey+0x5c2/0x7a0 crypto/hmac.c:73
 [<00026a33d7de8e1c>] crypto_shash_setkey+0x8c/0x1f0 crypto/shash.c:56
 [<00026a33d7dee7c2>] hkdf_extract+0x42/0xa0 crypto/hkdf.c:50
 [<00026a33d5fd5c16>] fscrypt_init_hkdf+0x146/0x280 fs/crypto/hkdf.c:73

This issue actually occurred with hmac(sha512-s390), i.e. the hmac template on
top of the algorithm with driver name sha512-s390.  So this seems to be a
regression from earlier commits.  I think this one:

    commit 88c02b3f79a61e659749773865998e0c33247e86
    Author: Joerg Schmidbauer <jschmidb@de.ibm.com>
    Date:   Wed Aug 28 13:52:30 2024 +0200

        s390/sha3: Support sha3 performance enhancements

That introduced 'first_message_part' but forgot to make sha512_init() set it.
So s390_sha_update() started using an uninitialized variable.

The following more recent commit then changed 'first_message_part' to a bool,
which made UBSAN sometimes able to report its uninitialized use:

    commit 7b83638f962c30cb6271b5698dc52cdf9b638b48
    Author: Herbert Xu <herbert@gondor.apana.org.au>
    Date:   Fri Apr 18 10:59:34 2025 +0800

        crypto: s390/sha1 - Use API partial block handling

Fortunately, this issue no longer exists in SHA-512 in the latest linux-next,
since my SHA-512 library work
(https://lore.kernel.org/linux-crypto/20250616014019.415791-15-ebiggers@kernel.org/).
greatly simplified how the s390-optimized SHA-512 code is integrated.

However, my SHA-512 library work is targeting 6.17.  I think you'll need a fix
for 6.16 and Cc'ed to stable that just initializes 'first_message_part' in the
old code...

- Eric
