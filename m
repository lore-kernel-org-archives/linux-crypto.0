From: "Dey, Megha" <megha.dey@intel.com>
Subject: RE: [PATCH] crypto : async implementation for sha1-mb
Date: Mon, 13 Jun 2016 19:10:26 +0000
Message-ID: <C440BA31B54DCD4AAC682D2365C8FEE703CABA2C@ORSMSX111.amr.corp.intel.com>
References: <1465323282-2235-1-git-send-email-megha.dey@intel.com>
 <20160613082202.GA7148@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160613082202.GA7148@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: Monday, June 13, 2016 1:22 AM
To: Dey, Megha <megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com; davem@davemloft.net; linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Yu, Fenghua <fenghua.yu@intel.com>; Megha Dey <megha.dey@linux.intel.com>
Subject: Re: [PATCH] crypto : async implementation for sha1-mb

On Tue, Jun 07, 2016 at 11:14:42AM -0700, Megha Dey wrote:
>
> -	desc->tfm = child;
> -	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +	ahash_request_set_tfm(desc, child);
> +	ahash_request_set_callback(desc, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, 
> +NULL);

Why are the callbacks set to NULL/NULL? The child is async so you should have a valid callback function here.

Instead of continuing to do the broken callback handling outside of the API (i.e., rctx->complete) please use the API mechanism that is provided for this purpose.

> In the current implementation, the inner algorithm is called directly, and we use the outer algorithm's callback. We do not use the callback in inner algorithm. We are actually calling the child functions directly and the child is using the parent's call back function. Probably I can add a comment before the set callback function.. will this be ok?

Thanks,
