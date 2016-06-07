From: "Dey, Megha" <megha.dey@intel.com>
Subject: RE: [PATCH V2 2/2] crypto : async implementation for sha1-mb
Date: Tue, 7 Jun 2016 18:10:14 +0000
Message-ID: <C440BA31B54DCD4AAC682D2365C8FEE703C662A9@ORSMSX111.amr.corp.intel.com>
References: <1464922430-26976-1-git-send-email-megha.dey@intel.com>
 <1464922430-26976-3-git-send-email-megha.dey@intel.com>
 <20160607103515.GB325@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	"Megha Dey" <megha.dey@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6498 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422842AbcFGSKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 14:10:16 -0400
In-Reply-To: <20160607103515.GB325@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: Tuesday, June 7, 2016 3:35 AM
To: Dey, Megha <megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com; davem@davemloft.net; linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Yu, Fenghua <fenghua.yu@intel.com>; Megha Dey <megha.dey@linux.intel.com>
Subject: Re: [PATCH V2 2/2] crypto : async implementation for sha1-mb

On Thu, Jun 02, 2016 at 07:53:50PM -0700, Megha Dey wrote:
>
> +	struct ahash_alg *shash = crypto_ahash_alg(tfm);
>  
>  	/* alignment is to be done by multi-buffer crypto algorithm if 
> needed */
>  
> -	return shash->finup(desc, NULL, 0, req->result);
> +	return shash->finup(desc);

You're still poking in the guts of the API.  Now that it's a real ahash you don't need to do that.

Just do crypto_ahash_finup.  That way you don't need to export crypto_ahsh_alg either.

> I have made these changes and re-sent the patch.

Thanks,
--
Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
