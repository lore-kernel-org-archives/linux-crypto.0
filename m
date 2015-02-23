From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: communicating from the user space
Date: Mon, 23 Feb 2015 09:30:14 +0100
Message-ID: <CAJU7zaJY53CNK18ziL5N1xjc3cEQ5WHddwERd6Zt3st+5-99KA@mail.gmail.com>
References: <CAHTT9VLmj8A7V5t+P9Zc02r5nyv37VMfa=QwPOuiMS9WFdXUxg@mail.gmail.com>
	<1424640392.22199.3.camel@gnutls.org>
	<CAHTT9VLJH4RFXBmGUeLSiiYjsvytb10NT+DyPeBkceVzuq3uRQ@mail.gmail.com>
	<1465303.BM7DbpydIc@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: sri sowj <srisowj4linux@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:44509 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbBWIaQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Feb 2015 03:30:16 -0500
Received: by lams18 with SMTP id s18so16897692lam.11
        for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2015 00:30:14 -0800 (PST)
In-Reply-To: <1465303.BM7DbpydIc@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 23, 2015 at 9:18 AM, Stephan Mueller <smueller@chronox.de> wrote:
>> one more thing while compiling openssl with above mentioned changes I
>> faced compilation issues in linux ,Please can you also let me know
>> whether there are per-requisites like any dependent libraries or
>> installing cryptodev-linux on host/target machine before compiling
>> openssl etc?
> Per default, you lack the kernel side support (there is no /dev/crypto) unless
> you patch your kernel. Thus, that cryptodev support in OpenSSL is not used on
> default kernels.

It depends. If you are working in an embedded system /dev/crypto is
most probably there. AF_ALG could be supported too, but there is
little reason to use it, unless working slow is your goal.

regards,
Nikos
