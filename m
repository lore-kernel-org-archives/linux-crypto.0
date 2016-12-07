From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v4] crypto: AF_ALG - fix AEAD tag memory handling
Date: Wed, 07 Dec 2016 13:22:45 +0100
Message-ID: <7598372.KIqtLBh5Ex@tauon.atsec.com>
References: <2319539.qMqmu7oTgO@positron.chronox.de> <20161207120914.GD20680@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39092 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751710AbcLGMWu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 07:22:50 -0500
In-Reply-To: <20161207120914.GD20680@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 7. Dezember 2016, 20:09:14 CET schrieb Herbert Xu:

Hi Herbert,

> On Mon, Dec 05, 2016 at 03:26:19PM +0100, Stephan Mueller wrote:
> > Hi Herbert,
> > 
> > Changes v4: restore the old behavior -- if the caller does not provide
> > sufficient output buffer size, return an error.
> 
> Patch applied.  Thanks.

Thank you. I will prepare the release of libkcapi 0.13.0 now which contains a 
provision for this user interface change. This provision allows a calling 
application to execute on older or newer kernels without changing its logic. 
The library transparently takes care of that user space interface difference.

Ciao
Stephan
