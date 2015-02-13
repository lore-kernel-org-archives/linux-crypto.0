From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: AF_ALG interface not marking the end of the scatter-gather list
Date: Fri, 13 Feb 2015 09:02:00 -0600
Message-ID: <54DE11E8.6030805@amd.com>
References: <54DD3A47.8010102@amd.com> <1554206.3ZPmnjpxYl@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bbn0106.outbound.protection.outlook.com ([157.56.111.106]:39215
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752105AbbBMPQ2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Feb 2015 10:16:28 -0500
In-Reply-To: <1554206.3ZPmnjpxYl@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/13/2015 05:43 AM, Stephan Mueller wrote:
> Am Donnerstag, 12. Februar 2015, 17:41:59 schrieb Tom Lendacky:
>
> Hi Tom,
>
>> I was doing some testing of the CCP driver using the AF_ALG interface
>> and encountered a BUG_ON statement during scatter-gather DMA mapping.
>>
>> In algif_skcipher.c, before submitting a request to the the Crypto API
>> the input sg list is not updated to mark the last valid sg entry of the
>> input data. So even if there is only a single valid sg entry, sg_nents
>> returns 127 (the initial value used when creating the sg table).
>>
>> In the CCP driver, when making a call to dma_map_sg I supply the number
>> of entries as returned by sg_nents. During this call, the sg elements
>> that are not valid cause a BUG_ON statement to be hit.
>>
>> I've worked around the issue in skcipher_recvmsg by marking the last
>> valid sg entry (sg_mark_end(sgl->sg + sgl->cur - 1)) just before the
>> call to ablkcipher_request_set_crypt and then unmarking the entry after
>> the return from af_alg_wait_for_completion (using sg_unmark_end).
>>
>> Is this an appropriate/valid solution for this issue?  If so, I can
>> submit a patch with the fix in algif_skcipher and algif_hash.
>
> There has been a patch around this issue -- see patch
> 0f477b655a524515ec9a263d70d51f460c05a161

Thanks for the pointer Stephan.  I had been working with the main
kernel tree where this patch hasn't been merged yet.

Thanks,
Tom

>>
>> Thanks,
>> Tom
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
