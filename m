From: Dimitrios Siganos <dimitris@siganos.org>
Subject: Re: ABLKCIPHER
Date: Mon, 15 Mar 2010 15:23:36 +0000
Message-ID: <4B9E50F8.9030109@siganos.org>
References: <20100313123146.GA26376@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lvps94-136-60-187.vps.webfusion.co.uk ([94.136.60.187]:60400
	"EHLO siganos.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070Ab0COPXk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Mar 2010 11:23:40 -0400
In-Reply-To: <20100313123146.GA26376@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> Dimitrios Siganos <dimitris@siganos.org> wrote:
>   
>> Hi,
>>
>> I am trying to write an ABLKCIPHER algorithm for my hardware crypto 
>> engine and I have a few questions:
>>
>> 1) In struct ablkcipher_alg, what do these fields do? I see some 
>> implementations use them and some not. Do I need to implement them?
>>    int (*givencrypt)(struct skcipher_givcrypt_request *req);
>>    int (*givdecrypt)(struct skcipher_givcrypt_request *req);
>>    const char *geniv;
>>     
>
> These do not have to be implemented, unless your hardware is
> capable of generating initial IVs (e.g., through a secure RNG).
>   
My hardware (Freescale i.MX51) has a random number generator. I think I 
am confused about the giv..crypt concept in general. How is it supposed 
to work?

Let's say I want to do the classic cbc(aes). The steps are:
1) allocate a tfm object
2) set the key
3) set the iv
4) encrypt as many times as needed
5) cleanup

I can do this without the giv functions. Do the giv apply in this case?

You said that with the giv functions, the hardware generates the iv 
automatically. So if I used the giv functions, does the sequence of 
steps above, become:
1) allocate a tfm object
2) set the key
4) givencrypt
5) read the generated iv (so it can somehow passed to the decryptor)
6) encrypt as many times as needed
7) cleanup

>> 2) What is a CRYPTO_ALG_TYPE_GIVCIPHER? What does it do and how does it 
>> interface to other algorithms?
>>     
>
> That's the type to use if you do choose to provide givencrypt
> and givdecrypt.
>   
Can you point me to a simple example, if one exists?

