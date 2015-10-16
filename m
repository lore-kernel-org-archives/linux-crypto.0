From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add asynchronous compression support
Date: Fri, 16 Oct 2015 23:13:54 +0800
Message-ID: <20151016151354.GA16648@gondor.apana.org.au>
References: <1445008260-39367-1-git-send-email-weigang.li@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Weigang Li <weigang.li@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52433 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbbJPPN7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Oct 2015 11:13:59 -0400
Content-Disposition: inline
In-Reply-To: <1445008260-39367-1-git-send-email-weigang.li@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 16, 2015 at 11:11:00PM +0800, Weigang Li wrote:
> This patch set introduces Asynchronous Compression API.
> What is proposed is a new crypto type called crypto_acomp_type, 
> plus new struct acomp_alg and struct crypto_acomp, together with number 
> of helper functions to register acomp type algorithms and allocate tfm 
> instances. This is to make it similar to how the existing crypto API 
> works for the ablkcipher, and akcipher types.
> The operations the new interface will provide are:
> 
> 	int (*compress)(struct acompress_request *req);
> 	int (*decompress)(struct acompress_request *req);
> 
> The benefits it gives interface are:
> - the new interface allows for asynchronous implementations and
>   scatterlist buffer that can use hardware to offload the compression
>   operations, the new asynchronous API can be called by the linux kernel
>   components (i.e., btrfs) who want to use hardware acceleration for data
>   compression.
> 
> New helper functions have been added to allocate crypto_acomp instances 
> and invoke the operations to make it easier to use.
> 
> Signed-off-by: Weigang Li <weigang.li@intel.com>

Thanks for the patch! Joonsoo Kim is also working on the compression
interface for zram.  Could you two collaborate and come up with one
interface rather than two?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
