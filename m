Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF64A1DEFF3
	for <linux-crypto@vger.kernel.org>; Tue, 11 Mar 2025 04:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741667814; cv=none; b=XNbxIE0C7i8w+eZW2O8KGVAo6P6+vIuDD31lkhKvr6/HM7yOga9FkhcY05i/Wux0SAffc8gCYA7Bc28r5vi6OeSCu7ZK3MxdHqEIq9SUUB1OQoioaT8pBQtmdrg8ohNLfVMfRQM9scuLmJQs3w182nLd2qr3u2Wa88iHQSao5T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741667814; c=relaxed/simple;
	bh=c4W81ZvmYn9grfmgsES+E1br7CFkxMQFDhCQVqvxjcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KJb/eaZumQdqqVkepin+8twJy0av3FPeG647Ts9be0m0xgm96rl1cnszzCFsKQ8HaSmEqS0SWaahMQOxDR+omj5AfBMPFVKAbMgGIKH219hzdtR7NVBSj1mIjYaZeCYu3ztmYHVQsDHrYfMXHR7UGwezn9M8Qb9SULN34metxCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=st91uS89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="st91uS89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD81C4CEE9;
	Tue, 11 Mar 2025 04:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741667813;
	bh=c4W81ZvmYn9grfmgsES+E1br7CFkxMQFDhCQVqvxjcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=st91uS89oHB0qqmfaHxdvwEiYwBP9M3t5qjMKVG8Dv6MkLW3fpE4ZuvKrG6X2TNOs
	 KLruV+J4SmveSau9gW+oHGKiRYbQX7sqxWJ4DAHkTxAVNRY6ajllnsxa3o7QGevAyC
	 OJksXNoeLsMiBGzwLrXkUYGmvG4sDkbIOzSQeswSQz1lzwC//aqPwUXEyl3xjkivwf
	 tXB4qqQbhRiJjwxXLUXLBSyCgJ8f4xESAoVkmC8jZkcXrbwu7XfRJ5q6mI2VEr4hi0
	 0g7pR85ydjIQ1fL1j3BqdL7zQsCDoW+ToIjIUrIHN7Em6br55fLWtLOMSgPJKErOA4
	 cHoDl/mf2hvYw==
Date: Mon, 10 Mar 2025 21:36:51 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 2/3] crypto: scatterwalk - Add memcpy_sglist
Message-ID: <20250311043651.GA1263@sol.localdomain>
References: <cover.1741318360.git.herbert@gondor.apana.org.au>
 <18a6df64615a10be64c3c902f8b1f36e472548d7.1741318360.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18a6df64615a10be64c3c902f8b1f36e472548d7.1741318360.git.herbert@gondor.apana.org.au>

On Fri, Mar 07, 2025 at 11:36:19AM +0800, Herbert Xu wrote:
> Add memcpy_sglist which copies one SG list to another.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/scatterwalk.c         | 27 +++++++++++++++++++++++++++
>  include/crypto/scatterwalk.h |  3 +++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
> index 20a28c6d94da..8225801488d5 100644
> --- a/crypto/scatterwalk.c
> +++ b/crypto/scatterwalk.c
> @@ -86,6 +86,33 @@ void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
>  }
>  EXPORT_SYMBOL_GPL(memcpy_to_sglist);
>  
> +void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
> +		   unsigned int nbytes)
> +{
> +	struct scatter_walk swalk;
> +	struct scatter_walk dwalk;
> +
> +	if (unlikely(nbytes == 0)) /* in case sg == NULL */
> +		return;
> +
> +	scatterwalk_start(&swalk, src);
> +	scatterwalk_start(&dwalk, dst);
> +
> +	do {
> +		unsigned int slen, dlen;
> +		unsigned int len;
> +
> +		slen = scatterwalk_next(&swalk, nbytes);
> +		dlen = scatterwalk_next(&dwalk, nbytes);
> +		len = min(slen, dlen);
> +		memcpy(dwalk.addr, swalk.addr, len);
> +		scatterwalk_done_dst(&dwalk, len);
> +		scatterwalk_done_src(&swalk, len);
> +		nbytes -= len;
> +	} while (nbytes);
> +}
> +EXPORT_SYMBOL_GPL(memcpy_sglist);

Actually this new function is useless as-is, since it invokes undefined behavior
when the source and destination coincide (which can happen even when src ==
dst), and all the potential callers need to handle that case.  I'm working on a
fixed version.

- Eric
