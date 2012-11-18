From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: Crypto causes panic in scatterwalk_done with large/multiple
 buffers
Date: Sun, 18 Nov 2012 19:40:33 +0200
Message-ID: <20121118194033.20427f1141j4ic4c@www.dalek.fi>
References: <50A4AFEE.9030206@lundman.net>
 <20121117024220.12381ph1ph0fu3q8@www.dalek.fi>
 <20121117103901.664145ijlv5r29wk@www.dalek.fi>
 <50A82BD1.4000505@lundman.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Jorgen Lundman <lundman@lundman.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:41431 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2KRRkh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2012 12:40:37 -0500
In-Reply-To: <50A82BD1.4000505@lundman.net>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Jorgen Lundman <lundman@lundman.net>:

>>
>> Appearently this patch only fixed my debug printk loop that used sg_next
>> from scatterlist API instead of scatterwalk_sg_next from scatterwalk API.
>> Sorry for the noise.
>>
>
> Thanks for looking at this. I think I am dealing with 2 problems, one is
> that occasionally my buffers are from vmalloc, and needs to have some logic
> using vmalloc_to_page().  But I don't know if ciphers should handle that
> internally, blkcipher.c certainly seems to have several modes, although I
> do not see how to *set* them.

 From what I now researched, you must not pass vmalloc'd memory to  
sg_set_buf() as it internally uses virt_to_page() to get page of  
buffer address. You most likely need to walk through your vmalloc'd  
buffer and pass all individual pages to scatterlist with sg_set_page().

>
> Second problem is most likely what you were looking at. It is quite easy to
> make the crypto code die.
>
> For example, if I use "ccm(aes)" which can take the dst buffer, plus a hmac
> buffer;
>
>   cipher = kmalloc( ciphersize, ...
>   hmac = kmalloc( 16, ...
>   sg_set_buf( &sg[0], cipher, ciphersize);
>   sg_set_buf( &sg[1], hmac, 16);
>   aead_encrypt()...
>
> and all is well, but if you shift hmac address away from PAGE boundary, like:
>
>   hmac = kmalloc( 16 + 32, ...
>   hmac += 32;
>   sg_set_buf( &sg[1], hmac, 16);
>
> ie, allocate a larger buffer, and put the pointer into the page a bit. And
> it will die in scatterwalk very often. +32 isnt magical, any non-zero
> number works.

This is strange as crypto subsystem's internal test mechanism uses  
such offsetted buffers.

-Jussi
