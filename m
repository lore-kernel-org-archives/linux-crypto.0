From: Lee Nipper <lee.nipper@gmail.com>
Subject: Re: Crypto Fixes for 2.6.35
Date: Fri, 23 Jul 2010 00:17:59 -0500
Message-ID: <AANLkTimqQXuiwgQep4uUrKDIAO2idw51Eu6XiZgs0HsR@mail.gmail.com>
References: <20090324044932.GA18245@gondor.apana.org.au>
	<20090613020512.GA21024@gondor.apana.org.au>
	<20090910141905.GA17948@gondor.apana.org.au>
	<20091020065442.GA5947@gondor.apana.org.au>
	<20091230021253.GA17067@gondor.apana.org.au>
	<20100201195204.GA6953@gondor.apana.org.au>
	<20100305071043.GA3548@gondor.apana.org.au>
	<20100427135547.GA4008@gondor.apana.org.au>
	<20100603100550.GA30681@gondor.apana.org.au>
	<20100716022648.GA28219@gondor.apana.org.au>
	<20100722055043.GA25689@gondor.apana.org.au>
Reply-To: lee.nipper@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34209 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab0GWFSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Jul 2010 01:18:00 -0400
Received: by qwh6 with SMTP id 6so3322337qwh.19
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jul 2010 22:17:59 -0700 (PDT)
In-Reply-To: <20100722055043.GA25689@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 22, 2010 at 00:50, Herbert Xu <herbert@gondor.apana.org.au>=
 wrote:
> Hi Linus:
>
> This push fixes a bug in the talito hash driver that causes too
> much data to be copied.
>
>
> Please pull from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
>
> or
>
> master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
>
>
> Lee Nipper (1):
> =A0 =A0 =A0crypto: talitos - fix bug in sg_copy_end_to_buffer
>
> =A0drivers/crypto/talitos.c | =A0 =A06 +++++-
> =A01 files changed, 5 insertions(+), 1 deletions(-)
>

Thanks Herbert.

But I am curious why this patch

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg04660.html

wasn't nudged along too.  It also fixed a talitos problem with ahash.
I don't mind if it needs to wait until later;  I'm just curious.

Thanks again,

Lee
