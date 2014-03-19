From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH cryptodev 1/4] crypto: caam - remove error propagation
 handling
Date: Wed, 19 Mar 2014 19:25:48 +0200
Message-ID: <5329D31C.6030807@freescale.com>
References: <1394812012-13714-1-git-send-email-horia.geanta@freescale.com> <201403171923.11855.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:56779
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759463AbaCSR0Z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Mar 2014 13:26:25 -0400
In-Reply-To: <201403171923.11855.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/17/2014 8:23 PM, Marek Vasut wrote:
> On Friday, March 14, 2014 at 04:46:49 PM, Horia Geanta wrote:
>> Commit 61bb86bba169507a5f223b94b9176c32c84b4721
>> ("crypto: caam - set descriptor sharing type to SERIAL")
>> changed the descriptor sharing mode from SHARE_WAIT to SHARE_SERIAL.
>>
>> All descriptor commands that handle the "ok to share" and
>> "error propagation" settings should also go away, since they have no
>> meaning for SHARE_SERIAL.
>
> [...]
>
>> @@ -253,7 +236,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
>>   	/* assoclen + cryptlen = seqinlen - ivsize */
>>   	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, tfm->ivsize);
>>
>> -	/* assoclen + cryptlen = (assoclen + cryptlen) - cryptlen */
>> +	/* assoclen = (assoclen + cryptlen) - cryptlen */
>
> This comment basically says 'x = x' , but it doesn't explain anything to
> uninformed observer. Can you fix such comments please ?

The line under the comment is:
append_math_sub(desc, VARSEQINLEN, REG2, REG3, CAAM_CMD_SZ);

which translates to:
VARSEQINLEN = REG2 - REG3

The comment basically says that VARSEQINLEN gets assoclen by 
substracting REG3 = cryptlen from REG2 = assoclen + cryptlen.

If you still think this is "cryptic", that's perfectly fine - I'll 
respin the patch.


>
> [...]
>
> Best regards,
> Marek Vasut
>
>
>
>


-- 
Please avoid sending me Word or PowerPoint attachments.
See http://www.gnu.org/philosophy/no-word-attachments.html
