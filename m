From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH 01/10] crypto: omap-aes: Add support for lengths not aligned
 with AES_BLOCK_SIZE
Date: Thu, 2 Jul 2015 14:56:24 +0530
Message-ID: <559503C0.2020200@ti.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com> <1435814320-30347-2-git-send-email-lokeshvutla@ti.com> <20150702075341.GA4033@saruman.tx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>, <linux-omap@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <t-kristo@ti.com>, <nsekhar@ti.com>
To: <balbi@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42412 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbbGBJ0h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 05:26:37 -0400
In-Reply-To: <20150702075341.GA4033@saruman.tx.rr.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 02 July 2015 01:23 PM, Felipe Balbi wrote:
> On Thu, Jul 02, 2015 at 10:48:31AM +0530, Lokesh Vutla wrote:
>> OMAP AES driver returns an error if the data is not aligned with
>> AES_BLOCK_SIZE bytes.
>> But OMAP AES hw allows data input upto 1 byte aligned, but still
>> zeros are to be appended and complete AES_BLOCK_SIZE has to be written.
>> And correct length has to be passed in LENGTH field.
>> Adding support for inputs not aligned with AES_BLOCK_SIZE.
>>
>> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
>> ---
>>  drivers/crypto/omap-aes.c |   33 ++++++++++++++++-----------------
>>  1 file changed, 16 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
>> index 9a28b7e..a923101 100644
>> --- a/drivers/crypto/omap-aes.c
>> +++ b/drivers/crypto/omap-aes.c
>> @@ -558,6 +558,9 @@ static int omap_aes_check_aligned(struct scatterlist *sg, int total)
>>  {
>>  	int len = 0;
>>  
>> +	if (!IS_ALIGNED(total, AES_BLOCK_SIZE))
>> +		return -1;
> 
> -EINVAL?
Okay, will update it.

Thanks and regards,
Lokesh
