From: Jorgen Lundman <lundman@lundman.net>
Subject: Re: Crypto causes panic in scatterwalk_done with large/multiple buffers
Date: Sun, 18 Nov 2012 09:29:05 +0900
Message-ID: <50A82BD1.4000505@lundman.net>
References: <50A4AFEE.9030206@lundman.net> <20121117024220.12381ph1ph0fu3q8@www.dalek.fi> <20121117103901.664145ijlv5r29wk@www.dalek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.lundman.net ([210.157.1.114]:60362 "EHLO mail.lundman.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab2KRA3J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Nov 2012 19:29:09 -0500
In-Reply-To: <20121117103901.664145ijlv5r29wk@www.dalek.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> 
> Appearently this patch only fixed my debug printk loop that used sg_next
> from scatterlist API instead of scatterwalk_sg_next from scatterwalk API.
> Sorry for the noise.
> 

Thanks for looking at this. I think I am dealing with 2 problems, one is
that occasionally my buffers are from vmalloc, and needs to have some logic
using vmalloc_to_page().  But I don't know if ciphers should handle that
internally, blkcipher.c certainly seems to have several modes, although I
do not see how to *set* them.

Second problem is most likely what you were looking at. It is quite easy to
make the crypto code die.

For example, if I use "ccm(aes)" which can take the dst buffer, plus a hmac
buffer;

  cipher = kmalloc( ciphersize, ...
  hmac = kmalloc( 16, ...
  sg_set_buf( &sg[0], cipher, ciphersize);
  sg_set_buf( &sg[1], hmac, 16);
  aead_encrypt()...

and all is well, but if you shift hmac address away from PAGE boundary, like:

  hmac = kmalloc( 16 + 32, ...
  hmac += 32;
  sg_set_buf( &sg[1], hmac, 16);

ie, allocate a larger buffer, and put the pointer into the page a bit. And
it will die in scatterwalk very often. +32 isnt magical, any non-zero
number works.

Lund



-- 
Jorgen Lundman       | <lundman@lundman.net>
Unix Administrator   | +81 (0)3 -5456-2687 ext 1017 (work)
Shibuya-ku, Tokyo    | +81 (0)90-5578-8500          (cell)
Japan                | +81 (0)3 -3375-1767          (home)
