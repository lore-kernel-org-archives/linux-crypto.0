From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: "deflate" crypto module questions
Date: Fri, 27 Jun 2008 08:56:36 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806270855530.29660@vixen.sonytel.be>
References: <E1KBsxU-00084C-00@gondolin.me.apana.org.au>
 <Pine.LNX.4.64.0806261803070.15018@vixen.sonytel.be>
 <20080627011924.GA3245@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1858383843-1214549796=:29660"
Cc: jmorris@namei.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58531 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760295AbYF0G4i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Jun 2008 02:56:38 -0400
In-Reply-To: <20080627011924.GA3245@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1858383843-1214549796=:29660
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 27 Jun 2008, Herbert Xu wrote:
> On Thu, Jun 26, 2008 at 06:07:29PM +0200, Geert Uytterhoeven wrote:
> > But it also means it's not so easy to avoid allocating the compression buffer
> > if you need decompression only. Or am I missing something?
> 
> Well there are ways to solve this, e.g., by creating new interfaces
> that are compression or decompression only.  What application do
> you have in mind?

Decompression for a read-only file system.

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
---584349381-1858383843-1214549796=:29660--
