From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: "deflate" crypto module questions
Date: Thu, 26 Jun 2008 18:07:29 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806261803070.15018@vixen.sonytel.be>
References: <E1KBsxU-00084C-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-419258858-1214496449=:15018"
Cc: jmorris@namei.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:47067 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752491AbYFZQHa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Jun 2008 12:07:30 -0400
In-Reply-To: <E1KBsxU-00084C-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-419258858-1214496449=:15018
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 26 Jun 2008, Herbert Xu wrote:
> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> >  2. Why was the lazy allocation removed back in 2004?
> >     If you're interested in decompression only, it's a bit wasteful to
> >     allocate 262 KiB of memory for compression and never use it.
> 
> The burden to save memory was simply moved to the user :)
> 
> As Sebastian correctly pointed out, the only user of deflate as
> it is is IPComp (there were some talk about using it for file
> systems but that never worked out).

Typically file systems seem to use the `zlib data format', while
crypto/deflate.c uses the `raw deflate data format'.
So I guess they would need a new crypto/zlib.c module anyway.

> As such we cannot sleep when operating on the data.  Since we're
> allocating more than a page worth of memory, it must be allocated
> in a process context.  That's why the lazy allocation was removed.

Thanks, that's a good reason!

> Having said that, the user is free to use lazy allocation if it
> is in a sleepable context by simply deferring the allocation of
> the tfm.

But it also means it's not so easy to avoid allocating the compression buffer
if you need decompression only. Or am I missing something?

Thanks again!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Technology and Software Centre Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-419258858-1214496449=:15018--
