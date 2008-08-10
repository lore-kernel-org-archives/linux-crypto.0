From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1 v1] Add CryptoAPI PKA Support
Date: Sun, 10 Aug 2008 18:43:04 +0800
Message-ID: <20080810104304.GC4526@gondor.apana.org.au>
References: <DB599F406D04E34389140B7D99C71B1B05D9E03B@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Loc Ho <lho@amcc.com>
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41969 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752742AbYHJKnI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Aug 2008 06:43:08 -0400
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B05D9E03B@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 08, 2008 at 01:02:48PM -0700, Shasi Pulijala wrote:
>  
> This patch adds PKA support to Linux CryptoAPI. All the basic algorithms like add, sub, div, expmod and expmod-crt can be supported by this interface. Currently the max number of src and dst operands have been defined as 6 and 2 respectively. These values should fit all the above mentioned algorithms (for example add needs 2 for input and 1 for output, expmod-crt 6 for input and 1 for output). Although, there is no specific mapping of operands, it is assumed that for add, operand A would be the first entry, operand B would be the second entry of the source. The output would be the first output.

Could you please tell us why we need this at all? For instance,
what hardware devices will be supported and who will be the users?

> +struct pka_request {
> +	struct crypto_async_request base;
> +
> +	struct scatterlist		*src[6];
> +	struct scatterlist		*dst[2];
> +	u32			operand_src_size[6];
> +	u32			operand_dst_size[2];
> +
> +	int iops;
> +	int oops;

No, multiplexed interfaces are bad in general.  Please provide
separate interfaces for each operation.

You should also post a software implementation so that

1) You illustrate what this is all about.
2) We have a yardstick for the hardware devices.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
