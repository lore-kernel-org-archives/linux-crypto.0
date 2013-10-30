From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [RFC] Unaligned CTR mode tests in crypto/testmgr.h
Date: Wed, 30 Oct 2013 13:09:55 +0200
Message-ID: <5270E903.3020502@iki.fi>
References: <52704EAB.5000308@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Joel Fernandes <joelf@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52562 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab3J3LJ7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Oct 2013 07:09:59 -0400
In-Reply-To: <52704EAB.5000308@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 30.10.2013 02:11, Joel Fernandes wrote:
> Hi,
> 
> Some tests such as test 5 in AES CTR mode in crypto/testmgr.h have a unaligned
> input buffer size such as 499 which is not aligned to any > 0 power of 2.
> 
> Due to this, omap-aes driver, and I think atmel-aes too error out when
> encryption is requested for these buffers.
> 
> pr_err("request size is not exact amount of AES blocks\n") or a similar message.
> 
> Is this failure considered a bug? How do we fix it?

Counter mode turns block cipher into stream cipher and implementation must handle
buffer lengths that do not match the block size of underlying block cipher.

> 
> How were the result output vectors generated, did you use 0 padding? Do we 0 pad
> the inputs to align in these cases to get correct results?

See crypto/ctr.c:crypto_ctr_crypt_final() how to handle trailing bytes when
'buflen % AES_BLOCK_SIZE != 0'.

Basically, you encrypt the last counter block to generate the last keystream
block and xor only the 'buflen % AES_BLOCK_SIZE' bytes of last keystream block
with the tail bytes of source buffer:

 key_last[0..15] = ENC(K, counter[0..15]);
 dst_last[0..trailbytes-1] = src_last[0..trailbytes-1] ^ key_last[0..trailbytes-1];
 /* key_last[trailbytes..15] discarded. */

Or if you want to use hardware that only does block-size aligned CTR encryption,
you can pad input to block size aligned length, do encryption, and then discard
those padding bytes after encryption:

 src_padded[0..trailbytes-1] = src_last[0..trailbytes-1]
 src_padded[trailbytes..15] = /* don't care, can be anything/uninitialized */
 src_padded[0..15] = ENC_HW_CTR(src_padded[0..15]);
 dst_last[0..trailbytes-1] = src_padded[0..trailbytes-1];
 /* src_padded[trailbytes..15] discarded. */

Here, ENC_HW_CTR(in) internally does:
 keystream[0..15] = ENC(K, counter[0..15]); INC_CTR(counter);
 out[0..15] = in[0..15] ^ keystream[0..15];

-Jussi

> 
> thanks,
> 
> -Joel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
