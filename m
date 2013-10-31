From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [RFC] Unaligned CTR mode tests in crypto/testmgr.h
Date: Thu, 31 Oct 2013 10:40:57 +0200
Message-ID: <52721799.8020404@iki.fi>
References: <52704EAB.5000308@ti.com> <5270E903.3020502@iki.fi> <527174DD.1010504@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Joel Fernandes <joelf@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50465 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab3JaIlE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Oct 2013 04:41:04 -0400
In-Reply-To: <527174DD.1010504@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 30.10.2013 23:06, Joel Fernandes wrote:
> On 10/30/2013 06:09 AM, Jussi Kivilinna wrote:
>> On 30.10.2013 02:11, Joel Fernandes wrote:
>>> Hi,
>>>
>>> Some tests such as test 5 in AES CTR mode in crypto/testmgr.h have a unaligned
>>> input buffer size such as 499 which is not aligned to any > 0 power of 2.
>>>
>>> Due to this, omap-aes driver, and I think atmel-aes too error out when
>>> encryption is requested for these buffers.
>>>
>>> pr_err("request size is not exact amount of AES blocks\n") or a similar message.
>>>
>>> Is this failure considered a bug? How do we fix it?
>>
>> Counter mode turns block cipher into stream cipher and implementation must handle
>> buffer lengths that do not match the block size of underlying block cipher.
>>
>>>
>>> How were the result output vectors generated, did you use 0 padding? Do we 0 pad
>>> the inputs to align in these cases to get correct results?
>>
>> See crypto/ctr.c:crypto_ctr_crypt_final() how to handle trailing bytes when
>> 'buflen % AES_BLOCK_SIZE != 0'.
>>
>> Basically, you encrypt the last counter block to generate the last keystream
>> block and xor only the 'buflen % AES_BLOCK_SIZE' bytes of last keystream block
>> with the tail bytes of source buffer:
>>
>>  key_last[0..15] = ENC(K, counter[0..15]);
>>  dst_last[0..trailbytes-1] = src_last[0..trailbytes-1] ^ key_last[0..trailbytes-1];
>>  /* key_last[trailbytes..15] discarded. */
>>
>> Or if you want to use hardware that only does block-size aligned CTR encryption,
>> you can pad input to block size aligned length, do encryption, and then discard
>> those padding bytes after encryption:
>>
>>  src_padded[0..trailbytes-1] = src_last[0..trailbytes-1]
>>  src_padded[trailbytes..15] = /* don't care, can be anything/uninitialized */
>>  src_padded[0..15] = ENC_HW_CTR(src_padded[0..15]);
>>  dst_last[0..trailbytes-1] = src_padded[0..trailbytes-1];
>>  /* src_padded[trailbytes..15] discarded. */
>>
>> Here, ENC_HW_CTR(in) internally does:
>>  keystream[0..15] = ENC(K, counter[0..15]); INC_CTR(counter);
>>  out[0..15] = in[0..15] ^ keystream[0..15];
>>
> 
> Thanks, I'll try that. Just one question- is it safe to assume the output buffer
> (req->dst) is capable of holding those many bytes?
> 
> In your algorithm above, we're assuming here without allocating explicitly that
> the output buffer passed to the driver has trailbytes..15 available. Because
> otherwise we are in danger of introducing a memory leak, if we just assume they
> are available in the output buffer.

In above example, I meant src_padded being temporary block-sized buffer to handle
the last trailing bytes. I don't think you can assume that req->dst would have
this extra space.

> 
> That said, I don't want to allocate new buffer in the driver and then do copying
> of encrypted data back into the output buffer. Because I did lot of hard work to
> get rid of such code as it is slower.
> 

Could you handle first 'buflen - buflen % blocksize' bytes as done currently without
extra copies and then handle the trailing bytes separately?

-Jussi

> thanks,
> 
> -Joel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
