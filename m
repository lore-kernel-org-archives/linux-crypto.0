Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8486817BB6;
	Fri, 18 Jul 2025 11:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836409; cv=none; b=MzHB4Qm/wFu/nNIeWNyYNz84vx6w2ke+suLZYEntRbX6r8qSMO/JZalxHbp9nOTgnQZMZfBmUBEIGeBZCZW8aW7lrupDg9OXz0Xx9rkGj3AVVVOG0wR+fSyIudMnfNP8jZLqDRgs9gzHYWbyAk5yONx5tveuLPgqY5zz+KU92PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836409; c=relaxed/simple;
	bh=Vnq6X88QjIg7bYh4t4GFpdJU2Tjgif0m4z1qHj5USbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gue2TKIsMMMt61WEejRwstLpfZx+JxkmovzH8EMwJAXxZITcc2f31QaNFkk0QgUJbnAQGj0SuouTRpUcXpKbYPg/CzoEOHJOSSVAMkpCqJ36so2ZZX0frn8WL1RCUU6u/MDLT5sMX1b949KeXdJWj3EwcxttEnYaOB9sJ0MIaeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FvgTRjRs; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FvgTRjRs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yHxkLkXZBZShvGvaq1jQwsUzq9TisX33LrwaTm6o5U4=; b=FvgTRjRsdx+0Dli28VmmJ40Dsd
	Tfzb2UGmRba5tJZNpTxIQ1lxRrxq05Qc8/+vNSsnxjQ1V1/+hh4NyBvOBaAHwDry7UyG5w8S3DNOm
	dMGtXS9WUaXCV5GwHzMgR/BVe5IyqRN4jM5TQ5aKmL3PR6eSUsLqUFG21rZYhb4QR5r8+IL8VUH62
	Wnu19TalmAwuZrK1U5Lm1CNT9WypYk2OiUwBcAkXuKFH49RqCrhlk9kK2W7t8f0WtRhnEOtZepsGN
	JB5ootSOLWEtkDb7Z3jYum9m6C0IaydiHvI+SIrgRepfyNwaYPhTOJhWJHwVXf73LmV+KhSXjGXxV
	VEaKmKzA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciZQ-007ye7-00;
	Fri, 18 Jul 2025 19:00:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 21:00:00 +1000
Date: Fri, 18 Jul 2025 21:00:00 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Howells <dhowells@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] crypto/krb5: Fix memory leak in krb5_test_one_prf()
Message-ID: <aHopMLTms2aK7obt@gondor.apana.org.au>
References: <20250709071140.99461-1-ebiggers@kernel.org>
 <2717585.1752056910@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2717585.1752056910@warthog.procyon.org.uk>

On Wed, Jul 09, 2025 at 11:28:30AM +0100, David Howells wrote:
> Hi Herbert,
> 
> Can you pick this up?
> 
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Fix a leak reported by kmemleak:
> > 
> >     unreferenced object 0xffff8880093bf7a0 (size 32):
> >       comm "swapper/0", pid 1, jiffies 4294877529
> >       hex dump (first 32 bytes):
> >         9d 18 86 16 f6 38 52 fe 86 91 5b b8 40 b4 a8 86  .....8R...[.@...
> >         ff 3e 6b b0 f8 19 b4 9b 89 33 93 d3 93 85 42 95  .>k......3....B.
> >       backtrace (crc 8ba12f3b):
> >         kmemleak_alloc+0x8d/0xa0
> >         __kmalloc_noprof+0x3cd/0x4d0
> >         prep_buf+0x36/0x70
> >         load_buf+0x10d/0x1c0
> >         krb5_test_one_prf+0x1e1/0x3c0
> >         krb5_selftest.cold+0x7c/0x54c
> >         crypto_krb5_init+0xd/0x20
> >         do_one_initcall+0xa5/0x230
> >         do_initcalls+0x213/0x250
> >         kernel_init_freeable+0x220/0x260
> >         kernel_init+0x1d/0x170
> >         ret_from_fork+0x301/0x410
> >         ret_from_fork_asm+0x1a/0x30
> > 
> > Fixes: fc0cf10c04f4 ("crypto/krb5: Implement crypto self-testing")
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> 
> Acked-by: David Howells <dhowells@redhat.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
