Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137AC175A6D;
	Wed, 26 Aug 2026 00:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787704718; cv=none; b=eaSC2pIfkYUD482j2DxBVksuEK0Jzq1UAwlcq/z4excQ/1bmPe1YAHkE5znfHHPEfvYnl6B/zNHfcdwUm/32zx94hcKjR/2FKpqAZkLK/iwfvc6Q1Cf9n6l+JEIHDGqBEzUV2oZdY1DsPxWjeZ51LIr+MTs0v9t0GBpnWKQZaUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787704718; c=relaxed/simple;
	bh=rwfgkzP5NZCPPLQJmLN8/8Fa9N87UlW4m3MdlWNTwjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ecf4JeNzyFKstZzYnA+fl7EWkkyC7UwUqXpqZtDYun3gKRy4Nz4HASapZKp0h9/xDyyU8DOv/RKyL1XVZ+P0CzJRX3KegbY+cFgyEinlYF7IYsN8uApZuYA+I1GKZUngdFu1zgPvPXy+4I+zUvyFSDUESTRwzWRTsNcMZ8zOm50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=f40WgMbG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="f40WgMbG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=rgRa5kD7aJJjA/AUbzq1fvReS9l34CYblqzybp581H4=; 
	b=f40WgMbGN3WOjFWoYwMP8vmGD1scDeA9wA3lSI7fO1L0XnYY/eAqpRy+3Xqw/KnIKiVBODF0RVf
	qLWcoIB9H/MwdI/T3ALk2EPbsgIL8iTCW1mMjFrEzj2uHES3oWI3BFbyokRBloELpi3tcdwaFoa2c
	SMWIflDdnfm9CvJ9v3Vb0qv3xTrsFtVmrHPdGRxzZ7rSpQQyIvAdF2nZWvp7UMxpuA/ohOuCc9DHm
	hZpF3VZ9qqx4MRcRB0CAHa5CECFRdnMvjXOT2slUNGYHSFcFr7YAy2Z1YJ/d15daqWA2LULl6QkM7
	yHDzr73KowH4MS10paFWovrGnTzVQ1p15aWw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wz1Or-00000007t5n-4Aix;
	Wed, 26 Aug 2026 08:21:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Aug 2026 10:21:53 +1000
Date: Wed, 26 Aug 2026 10:21:53 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - reject overlong RSA CRT parameters
Message-ID: <ao4xobfWhs5Ss8Uy@gondor.apana.org.au>
References: <20260810154024.3178145-1-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260810154024.3178145-1-Jeremy.Jean@oss.cyber.gouv.fr>

On Mon, Aug 10, 2026 at 03:40:24PM +0000, Jérémy Jean wrote:
> caam_read_rsa_crt() right-aligns dP, dQ, and qInv in buffers sized
> from the corresponding prime. rsa_parse_priv_key() only bounds these
> integers against n, so a malformed key can provide, for example, a
> two-byte dP with a one-byte p. dstlen - nbytes then underflows and
> memcpy() writes outside the allocation during set_priv_key(). KASAN
> reports a slab-out-of-bounds write in caam_read_rsa_crt().
> 
> Reject empty or overlong CRT parameters after stripping leading zeros.
> qInv is consumed by CAAM as a p-sized value, so size it from p rather
> than q to match the DMA mapping in set_rsa_priv_f3_pdb(). Let the
> top-level key cleanup handle partial form-3 allocations and return the
> specific error to the caller.
> 
> Also test nbytes before dereferencing it while stripping zeros, so an
> all-zero integer does not read one byte beyond its input.
> 
> Fixes: 4a651b122adb ("crypto: caam - add support for RSA key form 3")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  drivers/crypto/caam/caampkc.c | 69 +++++++++++++++--------------------
>  1 file changed, 30 insertions(+), 39 deletions(-)

Is this driver still maintained? If not let's just remove it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
