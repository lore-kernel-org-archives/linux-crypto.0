From: Dimitrios Siganos <dimitris@siganos.org>
Subject: Re: hmac(sha1)
Date: Wed, 03 Mar 2010 20:17:04 +0000
Message-ID: <4B8EC3C0.60502@siganos.org>
References: <4B8DD78D.6080707@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lvps94-136-60-187.vps.webfusion.co.uk ([94.136.60.187]:36644
	"EHLO siganos.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0CCUQr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Mar 2010 15:16:47 -0500
In-Reply-To: <4B8DD78D.6080707@siganos.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dimitrios Siganos wrote:
> Hi,
>
> I am trying to write a hmac(sha1) algorithm and I have a few 
> questions. I have a HW crypto accelerator that does the actual crypto 
> work. I have already successfully implemented sha1 by creating a 
> CRYPTO_ALG_TYPE_DIGEST algorithm.
>
> 1) Can I implement hmac(sha1) as a CRYPTO_ALG_TYPE_DIGEST algorithm 
> (i.e. use very similar code to sha1)?
>
> 2) Do I need to create a CRYPTO_ALG_TYPE_HASH algorithm?
>
> 3) Is it possible to implement hmac(sha1) as both 
> CRYPTO_ALG_TYPE_DIGEST and CRYPTO_ALG_TYPE_HASH?
>
> 4) If I use a CRYPTO_ALG_TYPE_HASH, I need to understand the 
> scatterwalk api, is there any help on the subject?
>
> Regards,
> Dimitris
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
The answer to 1) is yes because I just did it and seems to work. 
Therefore the answer is to 2) is: No, it is not needed.

I believe the answer to 3) is: yes. I believe it is possible to 
implement hmac(sha1) as both CRYPTO_ALG_TYPE_DIGEST and 
CRYPTO_ALG_TYPE_HASH.

I would like to implement hmac(sha1) as a CRYPTO_ALG_TYPE_HASH but I do 
yet understand how to convert the scatterlists into virtual addresses. 
The HW crypto api that I use, hides the DMA details from me and expects 
me to pass it virtual addresses only. I can't see any examples of 
converting scatterlists to virtual addresses in a way that is safe for 
IPsec use (i.e. safe to be called from softirq context). Any help on 
this will be appreciated.

The ultimate goal of the project is to implement a authenc(hmac(sha1), 
cbc(aes)) algorithm (for IPsec use) that will offload the work to a HW 
crypto chip. In order to understand what I am doing, I am building 
slowly upwards. I have build aes as a CIPHER, cbc(aes) as a BLKCIPHER, 
sha1 as a digest and hmac(sha1) as a digest.

My next steps are to implement cbc(aes) using ABLKCIPHER and hmac(sha1) 
using HASH and AHASH. I am using linux version 2.6.28. I can see that 
the talitos driver implements algorithms at the authenc level but I 
don't completely understand the driver and I am hoping that after going 
through the exercise of building the smaller blocks I will understand 
the operation of the talitos driver.

Any help, especially pointers to relevant documentation or examples, 
will be appreciated.

Dimitris
