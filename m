From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 23:40:58 +1000
Message-ID: <E1HdnvW-0005Ti-00@gondolin.me.apana.org.au>
References: <38b2ab8a0704170536x15920b15xedfd518cad50cee@mail.gmail.com>
Cc: herbert@gondor.apana.org.au, helge.hafting@aitel.hist.no,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: francis.moro@gmail.com (Francis Moreau)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1251 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754332AbXDQNlE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 09:41:04 -0400
In-Reply-To: <38b2ab8a0704170536x15920b15xedfd518cad50cee@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Francis Moreau <francis.moro@gmail.com> wrote:
>
>> > normal version:
>> > test 4 (128 bit key, 8192 byte blocks): 1 operation in 67991 cycles (8192
>> > bytes)
>> >
>> > optimized version:
>> > test 4 (128 bit key, 8192 byte blocks): 1 operation in 51783 cycles (8192
>> > bytes)
>> >
>> > So the gain is 16000 cycles which seems to worth the change, isn't it ?
>>
>> Sounds like it would.  It would help of course if you posted the patch :)
>>
> 
> OK, I tried to cook up something very simple. Since I don't know this
> code, please be indulgent when reading the following patch ;)

Actually, I was referring to your AES module :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
