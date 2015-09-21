From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] drivers/crypto/nx: Add CRC and validation support for nx842
Date: Mon, 21 Sep 2015 11:21:14 -0400
Message-ID: <CALZtONDbOxorPmy2A9FkD7rpY2HsOMaEs9Vvqg2kHh1qtM0GqA@mail.gmail.com>
References: <1442707362.6178.11.camel@hbabu-laptop> <20150921142607.GA2405@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Haren Myneni <haren@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Haren Myneni <hbabu@us.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33441 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbbIUPVy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 11:21:54 -0400
In-Reply-To: <20150921142607.GA2405@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 21, 2015 at 10:26 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Sat, Sep 19, 2015 at 05:02:42PM -0700, Haren Myneni wrote:
>> Hi,
>>
>> This patch allows nx842 coprocessor to add CRC for compression and
>> check the computed CRC value for uncompression. Please let me know
>> if you have any comments.
>>
>> Thanks
>> Haren
>>
>> commit d0b34d2e3ed41e7ec2afdbd654f0dd7716e4d4c0
>> Author: Haren Myneni <haren@us.ibm.com>
>> Date:   Sat Sep 12 01:20:51 2015 -0700
>>
>>     crypto/nx842: Add CRC and validation support
>>
>>     This patch adds CRC generation and validation support for nx-842.
>>     Add CRC flag so that nx842 coprocessor includes CRC during
>>     compression and validates during uncompression.
>>
>>     Signed-off-by: Haren Myneni <haren@us.ibm.com>
>
> In future please post the patch without all the metadata.  You
> can use the helper git format-patch to help you prepare the patch
> for submission.
>
> As to the CRC itself what is the purpose of this and wouldn't it
> fail our test vectors if we had any? Remember that we also have a
> software implementation now and the hardware should produce exactly
> the same output as the software version.

As far as the hw and sw drivers producing the exact same output, I
don't think that's possible with the current hw and sw drivers,
because the hw driver may have to add a header to the actual byte
stream that the hw creates, depending on buffer alignment and size
(the hw has specific restrictions).  Currently, the sw driver doesn't
understand that header that the 842 hw driver creates, although that
could be added to the sw driver.  And, the hw driver skips adding the
header if the buffers are correctly aligned/sized, which would result
in a test vector failure if it doesn't align the buffer the same way
each time.

However, you're right that if the hw driver is doing crc checking, the
sw driver needs to be updated to make sure to add the crc to anything
it encodes, otherwise the hw driver will fail decompressing it; Haren,
you'll need to update the lib/842 code to also include crc
creation/checking.

Also, it might be a good time to add what we talked about a while ago,
to push the alignment/size restrictions into the crypto compression
layer, by adding cra_alignmask and cra_blocksize support to
crypto/compress.c.  Since the 842 hw has requirements not only for
specific alignment and min/max sizes, but also a requirement for
specific length multiple (i.e. must be !(len % 8)) it might be
worthwhile to also add a cra_sizemodulo or something like that.
However, if the common crypto alignment/size handling code allows any
alignment/size buffers (instead of just returning error for mis-sized
buffers), I think a common crypto header would need to be added in
cases of mis-sizing, which may not be appropriate for common code.
Alternately, the common crypto code could just return error for
mis-sized buffers; users of the crypto comp api would just have to
check crypto_tfm_alg_blocksize() before calling.

In case I haven't said it before, I really hate how the 842 hw
requires specific alignment and sizing.  How hard is it to add support
for any alignment/size in the hw?!?


>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
