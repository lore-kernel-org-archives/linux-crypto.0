From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: fix AEAD tag memory handling
Date: Tue, 01 Nov 2016 15:18:53 +0100
Message-ID: <7741046.u5ygJjeQJs@tauon.atsec.com>
References: <4006219.iWaCqWYv1B@positron.chronox.de> <2822295.gL4fqFHz8h@positron.chronox.de> <alpine.OSX.2.20.1610311456250.4111@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47062 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966205AbcKAOS5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Nov 2016 10:18:57 -0400
In-Reply-To: <alpine.OSX.2.20.1610311456250.4111@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 31. Oktober 2016, 16:18:32 CET schrieb Mat Martineau:

Hi Mat,

> My main concern is getting the semantics correct and consistent in a
> single patch series. It would be a big problem to explain that AF_ALG AEAD
> read and write works one way in 4.x, another way in 4.y, and some
> different way in 4.z.

Ok, I will prepare another patch with this one fixed as well.


Ciao
Stephan
