From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: Unable to decrypt message
Date: Sat, 4 Jun 2016 16:59:07 -0400
Message-ID: <CAH8yC8mexX6p5_pifk_iAV_DYCD8po1gWSJBr=pbE+MSDNcrmQ@mail.gmail.com>
References: <CAKJ7aR4cxqoDQXvcULgwrQyok7fbi_Cq4jTL8x=WZwd03YEbCg@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Gadre Nayan <gadrenayan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:38596 "EHLO
	mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbcFDU7J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 4 Jun 2016 16:59:09 -0400
Received: by mail-it0-f44.google.com with SMTP id i65so9266363ith.1
        for <linux-crypto@vger.kernel.org>; Sat, 04 Jun 2016 13:59:08 -0700 (PDT)
In-Reply-To: <CAKJ7aR4cxqoDQXvcULgwrQyok7fbi_Cq4jTL8x=WZwd03YEbCg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I am trying to encrypt decrypt data over the wire. On the receiver
> side I have a pre-routing hook where I get reference to my encrypted
> data and apply decryption using the skcipher api's, however I am
> unable to get the same data back.
>
> My algo is same on both ends "cbc(aes)" and using CRYPTO_ALG_ASYNC ,
> key is also same (content and size).

Depends on a number of things... But in general, the first thing to do
is find the self tests and run them. Finding the self tests may not be
that easy For example, afalg async tests are at
http://github.com/tstruk/afalg_async_test.

Jeff
