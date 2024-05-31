Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F093A1C6A7;
	Fri, 31 May 2024 04:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717131035; cv=none; b=MiiGyPEdzvsbFuLcKgrUT8O1pxhEUIyNiAeiIn06XAK8J/LhBLvH9Yw61rt4y/tmKxcom3v/NTogrSMU6QF42F0A5bDOdu06iz1o84sEo/mlRfQsS9Qvip/pHAEn0YKoSVaWmnzGHtvsbVqKf0Ibo3p/vnRPcvaHhSOmn6LCIpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717131035; c=relaxed/simple;
	bh=igaylIAIXNq3yDPXmBHyR1WE47ou5VpVBjrJAWMfgpA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=badcscIfq1UJjQXtcN7nG4mECbqtLXP01AXZYw8hyj1bC6jM2vEUBHt2tervnj5aVymHPVLa8v1AdYI2sdx34+aEcYCkr5UvAGybO9dJdOcMSuOQ9m6yLEm0drdmXNGj4xKwTO1OvzY/4aYLsgUP4wMMIZUb+V1CgPHC10mgWWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCuDa-0044PA-1x;
	Fri, 31 May 2024 12:50:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 12:50:20 +0800
Date: Fri, 31 May 2024 12:50:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org
Subject: Re: [PATCH v3 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <ZllXDOJKW2pHWBTz@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507002343.239552-7-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
>
> +               if (multibuffer) {
> +                       if (ctx->pending_data) {
> +                               /* Hash and verify two data blocks. */
> +                               err = fsverity_hash_2_blocks(params,
> +                                                            inode,
> +                                                            ctx->pending_data,
> +                                                            data,
> +                                                            ctx->hash1,
> +                                                            ctx->hash2);
> +                               kunmap_local(data);
> +                               kunmap_local(ctx->pending_data);
> +                               ctx->pending_data = NULL;
> +                               if (err != 0 ||
> +                                   !verify_data_block(inode, vi, ctx->hash1,
> +                                                      ctx->pending_pos,
> +                                                      ctx->max_ra_pages) ||
> +                                   !verify_data_block(inode, vi, ctx->hash2,
> +                                                      pos, ctx->max_ra_pages))
> +                                       return false;
> +                       } else {
> +                               /* Wait and see if there's another block. */
> +                               ctx->pending_data = data;
> +                               ctx->pending_pos = pos;
> +                       }
> +               } else {
> +                       /* Hash and verify one data block. */
> +                       err = fsverity_hash_block(params, inode, data,
> +                                                 ctx->hash1);
> +                       kunmap_local(data);
> +                       if (err != 0 ||
> +                           !verify_data_block(inode, vi, ctx->hash1,
> +                                              pos, ctx->max_ra_pages))
> +                               return false;
> +               }
> +               pos += block_size;

I think this complexity is gross.  Look at how we did GSO in
networking.  There should be a unified code-path for aggregated
data and simple data, not an aggregated path versus a simple path.

I think ultimately it stems from the fact that this code went from
ahash to shash.  What were the issues back then? If it's just vmalloc
we should fix ahash to support that, rather than making users of the
Crypto API go through contortions like this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
