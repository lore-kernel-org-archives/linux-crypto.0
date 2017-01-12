From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Thu, 12 Jan 2017 13:43:30 +0100
Message-ID: <1571098.j2fg6WcoZx@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <20170112061936.GA10325@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55472 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750807AbdALMnk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 07:43:40 -0500
In-Reply-To: <20170112061936.GA10325@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 12. Januar 2017, 14:19:36 CET schrieb Herbert Xu:

Hi Herbert,

> 
> I think it's too much churn.  Let's get the algif_aead code fixed
> up first, and then pursue this later.

To eliminate the extra churn of having all AEAD implementations changed to 
invoke copy operation, what about adding the callback to crypto_aead_encrypt?

This way, all AEAD implementations benefit from it without having an extra 
call added to each of them?

Ciao
Stephan
