From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: communicating from the user space
Date: Mon, 23 Feb 2015 09:27:54 +0100
Message-ID: <CAJU7zaL8r+vbhPY3NU-6tUKcFJS_vMHr2fVci+hAquXynBdP3g@mail.gmail.com>
References: <CAHTT9VLmj8A7V5t+P9Zc02r5nyv37VMfa=QwPOuiMS9WFdXUxg@mail.gmail.com>
	<1543956.4M98jElNTF@tachyon.chronox.de>
	<CAHTT9VKQ2nB92SgRsGYemgTO6tTDucKyOs-9uCQn9+vAweQwuQ@mail.gmail.com>
	<1989293.ccvZM8v2KA@tachyon.chronox.de>
	<1424640392.22199.3.camel@gnutls.org>
	<CAHTT9VLJH4RFXBmGUeLSiiYjsvytb10NT+DyPeBkceVzuq3uRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Stephan Mueller <smueller@chronox.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: sri sowj <srisowj4linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:45292 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbbBWI14 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Feb 2015 03:27:56 -0500
Received: by lbjb6 with SMTP id b6so16840423lbj.12
        for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2015 00:27:54 -0800 (PST)
In-Reply-To: <CAHTT9VLJH4RFXBmGUeLSiiYjsvytb10NT+DyPeBkceVzuq3uRQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 23, 2015 at 5:06 AM, sri sowj <srisowj4linux@gmail.com> wrote:
> Hi Nikos,
>
> Please can you let me know my understanding regarding openssl and
> crypto are correct?
> I have mentioned my understanding in my earlier posts,but let me
> mention it here again.
> I want to interact with Crypto Hardware from user space using openssl
> like libraries based applications through cryptodev-linux interface.
> it looks like openssl comes with cryptodev-linux support(through
> eng_cryptodev.c) .
> When I downloaded openssl,eng_cryptodev.c file is available by default.
> below link refers about eng_cryptodev.c for openssl support :
> http://repo.or.cz/w/cryptodev-linux.git/commitdiff/56cc4e3b8b761cb34f928f4eee59755d1f0afc53

That's a very old link. Note that openssl's cryptodev support works
well for ciphers, but not for digests (hashes). So the best is to
compile without digest support, or use the patches in
https://github.com/openssl/openssl/pull/191

The most current instructions are:
https://github.com/cryptodev-linux/cryptodev-linux/blob/master/INSTALL
and in https://github.com/cryptodev-linux/cryptodev-linux

regards,
Nikos
