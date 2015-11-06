From: "Li, Weigang" <weigang.li@intel.com>
Subject: RE: [PATCH] crypto: add asynchronous compression support
Date: Fri, 6 Nov 2015 01:55:42 +0000
Message-ID: <929511EA6367314D8E32364A24D45FA613009218@shsmsx102.ccr.corp.intel.com>
References: <1445008260-39367-1-git-send-email-weigang.li@intel.com>
 <20151016151354.GA16648@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Struk, Tadeusz" <tadeusz.struk@intel.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51710 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965545AbbKFBzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Nov 2015 20:55:46 -0500
In-Reply-To: <20151016151354.GA16648@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

After sync with Joonsoo Kim offline, he agreed to merge this acomp patch with his ccomp patch, thanks Joonsoo!

-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: Friday, October 16, 2015 11:14 PM
To: Li, Weigang
Cc: linux-crypto@vger.kernel.org; Struk, Tadeusz; Joonsoo Kim; Sergey Senozhatsky
Subject: Re: [PATCH] crypto: add asynchronous compression support

On Fri, Oct 16, 2015 at 11:11:00PM +0800, Weigang Li wrote:
> This patch set introduces Asynchronous Compression API.
> What is proposed is a new crypto type called crypto_acomp_type, plus 
> new struct acomp_alg and struct crypto_acomp, together with number of 
> helper functions to register acomp type algorithms and allocate tfm 
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
> New helper functions have been added to allocate crypto_acomp 
> instances and invoke the operations to make it easier to use.
> 
> Signed-off-by: Weigang Li <weigang.li@intel.com>

Thanks for the patch! Joonsoo Kim is also working on the compression interface for zram.  Could you two collaborate and come up with one interface rather than two?

Cheers,
--
Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
