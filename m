From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: "deflate" crypto module questions
Date: Thu, 26 Jun 2008 23:00:24 +0800
Message-ID: <E1KBsxU-00084C-00@gondolin.me.apana.org.au>
References: <Pine.LNX.4.64.0806251916240.8685@vixen.sonytel.be>
Cc: jmorris@namei.org, linux-crypto@vger.kernel.org,
	Geert.Uytterhoeven@sonycom.com
To: Geert.Uytterhoeven@sonycom.com (Geert Uytterhoeven)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46498 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751898AbYFZPAb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Jun 2008 11:00:31 -0400
In-Reply-To: <Pine.LNX.4.64.0806251916240.8685@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
>  2. Why was the lazy allocation removed back in 2004?
>     If you're interested in decompression only, it's a bit wasteful to
>     allocate 262 KiB of memory for compression and never use it.

The burden to save memory was simply moved to the user :)

As Sebastian correctly pointed out, the only user of deflate as
it is is IPComp (there were some talk about using it for file
systems but that never worked out).

As such we cannot sleep when operating on the data.  Since we're
allocating more than a page worth of memory, it must be allocated
in a process context.  That's why the lazy allocation was removed.

Having said that, the user is free to use lazy allocation if it
is in a sleepable context by simply deferring the allocation of
the tfm.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
