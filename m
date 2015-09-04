From: Andrey Ryabinin <aryabinin@odin.com>
Subject: Re: [PATCH] crypto/testmgr: don't copy from source IV too much
Date: Fri, 4 Sep 2015 19:42:26 +0300
Message-ID: <55E9C9F2.5060402@odin.com>
References: <1441279921-26838-1-git-send-email-aryabinin@odin.com>
 <20150903132057.GA31317@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:34681 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759073AbbIDQm3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Sep 2015 12:42:29 -0400
In-Reply-To: <20150903132057.GA31317@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/03/2015 04:20 PM, Herbert Xu wrote:
> On Thu, Sep 03, 2015 at 02:32:00PM +0300, Andrey Ryabinin wrote:
>> While the destination buffer 'iv' is MAX_IVLEN size,
>> the source 'template[i].iv' could be smaller. Thus
>> copying it via memcpy() leads to invalid memory access.
>> Use strlcpy() instead.
>>
>> Signed-off-by: Andrey Ryabinin <aryabinin@odin.com>
> 
> Thanks for the patch.  Unfortunately it's broken because the IV
> is not a string and can contain NULs.  So either fix it by using
> the real ivsize,

So I've tried to use crypto_ablkcipher_ivsize(tfm) for that.

But noticed that some algs don't set ivsize (which makes it zero).
E.g. "ecb-cast6-avx" doesn't set it, but test vectors (cast6_enc_tv_template[], cast6_dec_tv_template[])
have .iv of 16bytes.

So I'm not sure what part is wrong here.
Is it wrong to use crypto_ablkcipher_ivsize(tfm) to get ivsize here?
Is it bug in 'ecb-cast6-avx'?
Or maybe something else?


> or change template[i].iv to a char array.
> 
> Cheers,
> 
