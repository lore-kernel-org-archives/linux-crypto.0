Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C96F4F4CF8;
	Thu, 15 Oct 2026 09:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792056541; cv=none; b=fuTIFtXD86U6+q2i3PYRjXnSjBOFxpw/XSA6xdCqjLO4d73Hu6Vta19jvREjV4HsU9gfMy4fN05HSV1ZfPyl8wY3XEIbxtLAYjczzne7X4pMA/JUx/xgvFPTuZ2XJ00/BQUOEskTaYZSvAfjrICdxa2Q5RGwwHtIDQOQe27heFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792056541; c=relaxed/simple;
	bh=Nl8VkwGaBcP/N8FspndVAhEflLmE5wqIknTXtjCmsWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FLrbGijTQmWwe4dL75VB6zm7CJUEhrRUJ5rXlF9OZGTH17rQNJCk0VSxVrGe40wiFQ2lnQMNpOPogZ+HYnqVleYCuOLCxHpe2bQYVRIA+9tl2ZrJ+SD2RiwxFsG/WjQ3MbvscTCg9l3IZd96ozXOPVFA88mwU1nxnOWHRtLSlyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Dw4qs80Q; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Dw4qs80Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Fxg1YO8+1v3pgTZaMH0CQqYIAiEVWkzSl5zghob1uo4=; 
	b=Dw4qs80QjEjfRqNgfYVRBjrN3bGbUW5KCArqu3/UP7/OpUhw6mLY/jkB/NfzbAKj8HJuyJN0TQU
	1jvjqafIT72sK829tKvsoKVL4PsaMDAj88ufYXr7JJOzSvIYPFetuaXRkMYzCHN5rzFRpEryI6R7T
	iXNN06q3N4cl5G+MhTb5gouUY7gRMkOzRHVMwyQVLwKalNAg3a/0qwTyKPPLQpWqtSvNQkYm68fUG
	mHTCdbCigffKV4rvGtw45ocF2Ujxx/ChNLqewsQiMj++xoQ1qpsFOhqOGFssdE4d69orVr6znFW4S
	D4dARR1ffGYvHYvVnSl2JxTUS3Rr/eDZNChQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHHla-000000047Ip-1hPX;
	Thu, 15 Oct 2026 17:28:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2026 20:28:50 +1100
Date: Thu, 15 Oct 2026 20:28:50 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [REPOST PATCH] crypto: caam - reject overlong RSA CRT parameters
Message-ID: <atCc0iL0RrDLwHHX@gondor.apana.org.au>
References: <20261008093553.384608-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261008093553.384608-2-Jeremy.Jean@oss.cyber.gouv.fr>

On Thu, Oct 08, 2026 at 09:35:53AM +0000, Jérémy Jean wrote:
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
> Assisted-by: LLM
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  drivers/crypto/caam/caampkc.c | 69 +++++++++++++++--------------------
>  1 file changed, 30 insertions(+), 39 deletions(-)

Sahil, could you please review this patch?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
