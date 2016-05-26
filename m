From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: AES-NI: slower than aes-generic?
Date: Thu, 26 May 2016 13:25:02 -0400
Message-ID: <CAH8yC8mibb90J2rkD_YzM2X1HsNuHEOLbV7Wntq39dMxH4KCnQ@mail.gmail.com>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <stephan.mueller@atsec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:37669 "EHLO
	mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbcEZRb1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 13:31:27 -0400
Received: by mail-it0-f54.google.com with SMTP id z123so50316453itg.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 May 2016 10:31:27 -0700 (PDT)
In-Reply-To: <1567400.ZMFoPuCv2K@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> What I am wondering is that when encrypting 256 16 byte blocks, I get a speed
> of about 170 MB/s with the AES-NI driver. When using the aes-generic or aes-
> asm, I get up to 180 MB/s with all else being equal. Note, that figure
> includes a copy_to_user of the generated data.
>
> ...

Something sounds amiss.

AES-NI should be on the order of magnitude faster than a generic
implementation. Can you verify AES-NI is actually using AES-NI, and
aes-generic is a software implementation?

Here are some OpenSSL numbers. EVP uses AES-NI when available.
Omitting -evp means its software only (no hardware acceleration, like
AES-NI).

$ openssl speed -elapsed -evp aes-128-cbc
You have chosen to measure elapsed time instead of user CPU time.
...
The 'numbers' are in 1000s of bytes per second processed.
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes
aes-128-cbc     626533.60k   669884.42k   680917.93k   682079.91k   684736.51k


$ openssl speed -elapsed aes-128-cbc
You have chosen to measure elapsed time instead of user CPU time.
...
The 'numbers' are in 1000s of bytes per second processed.
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes
aes-128 cbc     106520.59k   114380.16k   116741.46k   117489.32k   117563.39k

Jeff
