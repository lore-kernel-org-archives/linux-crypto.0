From: Stephan Mueller <smueller@chronox.de>
Subject: Re: md5sum (from libkcapi) fails on kernel 4.9 but not on 4.13
Date: Tue, 17 Oct 2017 18:43:03 +0200
Message-ID: <1773201.ETJ2E9HBJ8@tauon.chronox.de>
References: <5c552c4b-c05e-7098-6e60-fdc6f7ed5d4b@c-s.fr> <2174001.55GM1Rvaqa@tauon.chronox.de> <64a7edb0-b9c0-32cd-cc6e-096f2911d5bc@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Christophe LEROY <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34932 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932961AbdJQQnK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2017 12:43:10 -0400
In-Reply-To: <64a7edb0-b9c0-32cd-cc6e-096f2911d5bc@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 17. Oktober 2017, 09:58:31 CEST schrieb Christophe LEROY:

Hi Christophe,

> 
> > If you tamper with the code shown above from libkcapi and set
> > alg_max_pages to a low value, the library reverts to sendmsg after the
> > given number of pages.
> Couldn't we get the libkcapi to splice until the last full page, then
> only use sendmsg() for the last chunk once it is smaller than an entire
> page ?

Adding such loop to the libkcapi invocation of sendmsg to send page-wise is 
easy. Yet, I am wondering whether this is the right thing to do. The 
algif_hash uses the standard in-kernel interface to invoke the cipher 
implementation.

Thus, when fixing the issue in user space, the issue is still present in the 
kernel. Thus, if for some reason the kernel wants to hash more than 32kb in a 
row, it will fall with the Talitos driver. Thus, wouldn't it make more sense 
that the loop to process the data in chunks inside the Talitos driver?

Ciao
Stephan
