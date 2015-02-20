From: sri sowj <srisowj4linux@gmail.com>
Subject: communicating from the user space
Date: Sat, 21 Feb 2015 01:27:04 +0530
Message-ID: <CAHTT9VLmj8A7V5t+P9Zc02r5nyv37VMfa=QwPOuiMS9WFdXUxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34973 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbbBTT5F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 14:57:05 -0500
Received: by padfa1 with SMTP id fa1so10471683pad.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2015 11:57:04 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi ,

I want to interact with Crypto Hardware from user space using openssl
like libraries based applications through cryptodev-linux interface.

it looks like openssl comes with cryptodev-linux support(through
eng_cryptodev.c) .
When I downloaded openssl,eng_cryptodev.c file is available by default.

below link refers about eng_cryptodev.c for openssl support :

http://repo.or.cz/w/cryptodev-linux.git/commitdiff/56cc4e3b8b761cb34f928f4eee59755d1f0afc53

Note:looks like there are some additional changes done on
eng_cryptodev.c file available in updated openssl source code.

There seems to be some changes/patches  also available recently for
cryptodev-linux,below contains reference information.

http://rt.openssl.org/Ticket/Display.html?id=2770&user=guest&pass=guest


Please let me know if my understanding is incorrect .


BR,
Srisowj
