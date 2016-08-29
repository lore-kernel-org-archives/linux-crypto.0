From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCHv3 03/11] crypto: omap-sham: implement context
 export/import APIs
Date: Mon, 29 Aug 2016 17:11:35 +0300
Message-ID: <d828fca9-a97a-7722-c4cb-24e07816cbc4@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
 <1470306526-27219-4-git-send-email-t-kristo@ti.com>
 <20160809100633.GA6751@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <lokeshvutla@ti.com>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34849 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932211AbcH2OMO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2016 10:12:14 -0400
In-Reply-To: <20160809100633.GA6751@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/08/16 13:06, Herbert Xu wrote:
> On Thu, Aug 04, 2016 at 01:28:38PM +0300, Tero Kristo wrote:
>> Context export/import are now required for ahash algorithms due to
>> required support in algif_hash. Implement these for OMAP SHA driver,
>> saving and restoring the internal state of the driver.
>>
>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>> ---
>>  drivers/crypto/omap-sham.c | 31 +++++++++++++++++++++++++++++--
>>  1 file changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
>> index 6e53944..aa71e61 100644
>> --- a/drivers/crypto/omap-sham.c
>> +++ b/drivers/crypto/omap-sham.c
>> @@ -1379,6 +1379,27 @@ exit_unlock:
>>  	return ret;
>>  }
>>
>> +static int omap_sham_export(struct ahash_request *req, void *out)
>> +{
>> +	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
>> +
>> +	while (omap_sham_flush(req) == -EINPROGRESS)
>> +		msleep(10);
>
> Do we really need this? You must not call export until the previous
> operation has completed.
>
> Cheers,
>

Sorry about a late reply, I was out on vacation.

For OMAP SHAM, this is actually needed, because the driver still has a 
very large internal buffer for performance reasons, and the whole buffer 
can't be exported. The flush functionality pushes out sufficient amount 
of data to the hardware, so that the rest of the buffer can be exported 
to the available space.

This is pretty much related to the discussion we had previously here:

https://patchwork.kernel.org/patch/9192881/

Basically I decided to keep the driver buffer the same size as 
previously, but flush out any extra data.

-Tero
