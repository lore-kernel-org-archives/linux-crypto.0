From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] crypto: prevent nx 842 load if no hw driver
Date: Wed, 3 Jun 2015 08:53:29 -0400
Message-ID: <CALZtONB8ksGoPpsanDrOy9ybLLLJ15tD-ukskogFYqN8nEH_MA@mail.gmail.com>
References: <1432844491-27174-1-git-send-email-ddstreet@ieee.org> <20150603050810.GB3884@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150603050810.GB3884@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 3, 2015 at 1:08 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, May 28, 2015 at 04:21:31PM -0400, Dan Streetman wrote:
>> Change the nx-842 common driver to wait for loading of both platform
>> drivers, and fail loading if the platform driver pointer is not set.
>> Add an independent platform driver pointer, that the platform drivers
>> set if they find they are able to load (i.e. if they find their platform
>> devicetree node(s)).
>>
>> The problem is currently, the main nx-842 driver will stay loaded even
>> if there is no platform driver and thus no possible way it can do any
>> compression or decompression.  This allows the crypto 842-nx driver
>> to load even if it won't actually work.  For crypto compression users
>> (e.g. zswap) that expect an available crypto compression driver to
>> actually work, this is bad.  This patch fixes that, so the 842-nx crypto
>> compression driver won't load if it doesn't have the driver and hardware
>> available to perform the compression.
>>
>> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
>
> Applied.  Though I had to do the Makefile bit by hand because
> it contains references to nx-compress-test which doesn't exist
> in my tree.

Oops sorry, I forgot to remove that old test module patch from my tree.

Thanks.


> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
