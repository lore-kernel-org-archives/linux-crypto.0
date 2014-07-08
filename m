From: Sonny Rao <sonnyrao@chromium.org>
Subject: Re: Using s5p-sss hw crypto causes ipsec to break
Date: Mon, 7 Jul 2014 17:05:19 -0700
Message-ID: <CAPz6YkXDUaKh_-4BN9fYrCnkMPT1ir-DVv7sJKzk3_V2AnPdBw@mail.gmail.com>
References: <CAPz6YkUtGt61YNcGh2sYhaL=U5JMSOu26DvuKXuvp-oxi9ftBw@mail.gmail.com>
 <20140626063544.GA17608@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	naveen krishna <ch.naveen@samsung.com>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Vladimir Zapolskiy <vzapolskiy@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:58240 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbaGHAFk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Jul 2014 20:05:40 -0400
Received: by mail-qc0-f176.google.com with SMTP id w7so4529303qcr.7
        for <linux-crypto@vger.kernel.org>; Mon, 07 Jul 2014 17:05:40 -0700 (PDT)
In-Reply-To: <20140626063544.GA17608@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 25, 2014 at 11:35 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> Sonny Rao <sonnyrao@chromium.org> wrote:
>> Hi, I've been investigating an issue relating to hardware crypto which
>> is that when I enable the s5p-sss module for hardware cryptographic
>> acceleration on Samsung Exynos SoCs the in-kernel IPSec seems to
>> break, although cryptographic operations on filesystems/block devices
>> using this driver seem to work fine.
>>
>> Originally we were looking at an older kernel (3.8 with patches), but
>> I've now verified on linux-next from 20140612 (after 3.15) with a few
>> additional patches (to enable both s5p-sss and Exynos5420) that this
>> is still the case.
>>
>> It looks like what is happening in the kernel is that IPsec ends up
>> with this callstack
>>
>> esp_output()-> crypto_aead_givencrypt()->
>> crypto_authenc_givencrypt()-> eseqiv_givencrypt() ->
>> crypto_ablkcipher_encrypt()
>>
>>
>> which calls into the s5p-sss driver and that is returning -EINPROGRESS
>> (or possibly -EBUSY), and that is passed all the way back up the call
>> stack and that seems to be treated as an error condition by the ipsec
>> stack.
>>
>> For example esp_output does this:
>>
>>       err = crypto_aead_givencrypt(req);
>>        if (err == -EINPROGRESS)
>>                goto error;
>>
>>        if (err == -EBUSY)
>>                err = NET_XMIT_DROP;
>>
>> So, I'm not sure how this is supposed to work, or if s5p-sss is doing
>> something wrong.
>
> Something else must be happening because EINPROGRESS is meant to
> be handled by xfrm_output_resume (which gets called on the normal
> path as well as on the actual resume path).
>
> So I don't think this is your problem.
>
> Cheers,


Hi Herbert, thanks for the reply.  Sorry for the delay in my response,
I just got a chance to look at this again with the information you
provided.

It looks like the driver is rejecting the encryption request, and is
calling xfrm_output_resume with -22 (-EINVAL) because in
s5p_set_indata() this driver is calling sg_dma_len() on the sg lists
from the crypto request and getting back something that isn't a
multiple of AES_BLOCK_SIZE, and thus decides that this isn't a valid
request.

In my particular test, It looks like it's getting a dma size of
either 92 or 124 bytes while AES_BLOCK_SIZE is 16 bytes, and neither
of those are multiples of 16. I looked into why this was happening and
it looks like in eseqiv_givencrypt() we're calling
ablkcipher_request_set_crypt() with a value of either 80 or 112 (which
is a multiple of AES_BLOCK_SIZE) while reqctx->src->length is 96 or
124.

I think this is happening because the sg list associated with the
request has been set up for a network transfer, which is of a larger
size than what needs to be encrypted due to additional network
headers.

So, I'm wondering, is it correct for the HW crypto driver to be using
this sg list, which is part of the request , or should it somehow be
using different sg lists with the proper length for it's DMA
operations, or should that be happening somewhere else in the network
stack?


> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
