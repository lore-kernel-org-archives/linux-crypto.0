From: Stephan Mueller <smueller@chronox.de>
Subject: Re: communicating from the user space
Date: Fri, 20 Feb 2015 21:58:41 +0100
Message-ID: <1522393.KEIVXizgKy@tachyon.chronox.de>
References: <CAHTT9VLmj8A7V5t+P9Zc02r5nyv37VMfa=QwPOuiMS9WFdXUxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: sri sowj <srisowj4linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60277 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbbBTU6o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 15:58:44 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S1670F> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Fri, 20 Feb 2015 21:58:42 +0100
In-Reply-To: <CAHTT9VLmj8A7V5t+P9Zc02r5nyv37VMfa=QwPOuiMS9WFdXUxg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 21. Februar 2015, 01:27:04 schrieb sri sowj:

Hi sri,

> Hi ,
> 
> I want to interact with Crypto Hardware from user space using openssl
> like libraries based applications through cryptodev-linux interface.
> 
> it looks like openssl comes with cryptodev-linux support(through
> eng_cryptodev.c) .
> When I downloaded openssl,eng_cryptodev.c file is available by default.
> 
> below link refers about eng_cryptodev.c for openssl support :
> 
> http://repo.or.cz/w/cryptodev-linux.git/commitdiff/56cc4e3b8b761cb34f928f4ee
> e59755d1f0afc53
> 
> Note:looks like there are some additional changes done on
> eng_cryptodev.c file available in updated openssl source code.
> 
> There seems to be some changes/patches  also available recently for
> cryptodev-linux,below contains reference information.
> 
> http://rt.openssl.org/Ticket/Display.html?id=2770&user=guest&pass=guest
> 
> 
> Please let me know if my understanding is incorrect .

See AF_ALG and a generic user space library around it:

http://www.chronox.de/libkcapi.html
> 
> 
> BR,
> Srisowj
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ciao
Stephan
