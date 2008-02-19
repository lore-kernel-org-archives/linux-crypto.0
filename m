From: Patrick McHardy <kaber@trash.net>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Tue, 19 Feb 2008 17:14:24 +0100
Message-ID: <47BB0060.8080601@trash.net>
References: <47B2EDF9.6020900@trash.net> <20080213144442.GA10683@2ka.mipt.ru> <20080214093031.GA5258@2ka.mipt.ru> <47BAFF8F.7080602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:32664 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755386AbYBSQOs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Feb 2008 11:14:48 -0500
In-Reply-To: <47BAFF8F.7080602@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patrick McHardy wrote:
> Evgeniy Polyakov wrote:
>> Hi Patrick.
>>
>> On Wed, Feb 13, 2008 at 05:44:42PM +0300, Evgeniy Polyakov 
>> (johnpol@2ka.mipt.ru) wrote:
>>> Any chance you can apply following patch and check output for correct
>>> and broken cases (it will produce 2 or 3 debug strings for each crypto
>>> operation)?
>>>
>>> diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
>>> index dfbf24c..b8b088d 100644
>>> --- a/drivers/crypto/hifn_795x.c
>>> +++ b/drivers/crypto/hifn_795x.c
>>> @@ -1558,6 +1558,23 @@ err_out_unmap:
>>>      return err;
>>>  }
>>>  
>>> +static void hifn_dump_req(struct ablkcipher_request *req, const char 
>>> *prefix)
>>> +{
>>> +    int nbytes = (signed)req->nbytes;
>>> +    struct scatterlist *src, *dst;
>>> +    int idx = 0;
>>> +
>>> +    printk("%s: nbytes: %u, ", prefix, nbytes);
>>> +    while (nbytes > 0) {
>>> +        src = &req->src[idx];
>>> +        dst = &req->dst[idx];
>>> +
>>> +        printk("%u/%u ", src->length, dst->length);
>>> +        nbytes -= src->length;
>>
>> Ouch, forgot idx++;
> 
> 
> Unfortunately I'm unable to boot current -git, this time it
> hangs while trying to mount dm-crypt devices. The last output
> I get is:
> 
> [   15.148790] hifn_setup_crypto: nbytes: 512, 512/512
> [   15.148790] hifn_setup_session: nbytes: 512, 512/512
> [   15.148790] hifn_setup_crypto: nbytes: 512, 512/512
> [   15.148790] hifn_setup_session: nbytes: 512, 512/512
> [   15.148790] hifn_setup_crypto: nbytes: 512, 512/512
> [   15.148790] hifn_setup_session: nbytes: 512, 512/512
> [   15.148790] hifn_setup_crypto: nbytes: 512, 512/512
> [   15.148837] hifn_setup_session: nbytes: 512, 512/512
> [   15.148958] hifn_setup_crypto: nbytes: 512, 512/512
> [   15.149085] hifn_setup_session: nbytes: 512, 512/512
> [   15.149206] hifn_setup_crypto: nbytes: 512, 512/512
> [   15.149332] hifn_setup_session: nbytes: 512, 512/512
> [   15.149455] hifn_setup_crypto: nbytes: 512, 512/512
> [   15.149582] hifn_setup_session: nbytes: 512, 512/512
> [   15.149705] hifn_setup_crypto: nbytes: 512, 512/512
> [   15.149871] hifn_setup_session: nbytes: 512, 512/512
> 
> I'll try to narrow it down.

BTW, I also get this just before the HIFN debug output:

[   14.695659] device-mapper: uevent: version 1.0.3
[   14.697257] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) 
initialised: dm-devel@redhat.com
[   15.137123] device-mapper: crypt: Selected cipher does not support IVs

Not sure if its related, but I don't get this when using software
crypto.
