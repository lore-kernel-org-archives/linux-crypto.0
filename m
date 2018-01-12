From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: clear htmldocs build warnings for crypto/hash
Date: Fri, 12 Jan 2018 23:26:05 +1100
Message-ID: <20180112122605.GJ21636@gondor.apana.org.au>
References: <1515279703-14070-1-git-send-email-me@tobin.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Tobin C. Harding" <me@tobin.cc>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515279703-14070-1-git-send-email-me@tobin.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jan 07, 2018 at 10:01:43AM +1100, Tobin C. Harding wrote:
> SPHINX build emits multiple warnings of kind:
> 
> 	warning: duplicate section name 'Note'
> 
> (when building kernel via make target 'htmldocs')
> 
> This is caused by repeated use of comments of form:
> 
> 	* Note: soau soaeusoa uoe
> 
> We can change the format without loss of clarity and clear the build
> warnings.
> 
> Add '**[mandatory]**' or '**[optional]**' as kernel-doc field element
> description prefix
> 
> This renders in HTML as (prefixes in bold)
> 
> final
>     [mandatory] Retrieve result from the driver. This function finalizes the
>     transformation and retrieves the resulting hash from the driver and
>     pushes it back to upper layers. No data processing happens at this
>     point unless hardware requires it to finish the transformation (then
>     the data buffered by the device driver is processed).
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
