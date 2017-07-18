From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sahara : make of_device_ids const.
Date: Tue, 18 Jul 2017 18:35:42 +0800
Message-ID: <20170718103542.GE6479@gondor.apana.org.au>
References: <6324a0d5dc00bcc8f082d268a15b209ee6a4ee7a.1498563591.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6324a0d5dc00bcc8f082d268a15b209ee6a4ee7a.1498563591.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 27, 2017 at 05:11:23PM +0530, Arvind Yadav wrote:
> of_device_ids are not supposed to change at runtime. All functions
> working with of_device_ids provided by <linux/of.h> work with const
> of_device_ids. So mark the non-const structs as const.
> 
> File size before:
>    text	   data	    bss	    dec	    hex	filename
>    9759	   2736	      8	  12503	   30d7	drivers/crypto/sahara.o
> 
> File size after constify:
>    text	   data	    bss	    dec	    hex	filename
>   10367	   2128	      8	  12503	   30d7	drivers/crypto/sahara.o
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
