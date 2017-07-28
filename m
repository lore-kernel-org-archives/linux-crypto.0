From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v11 0/2] crypto: AF_ALG memory management fix
Date: Fri, 28 Jul 2017 15:53:55 +0200
Message-ID: <3098923.xryRsmobXR@tauon.chronox.de>
References: <6602969.vlMq0gDBpR@positron.chronox.de> <20170728134936.GA21401@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60830 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751697AbdG1Nx5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 09:53:57 -0400
In-Reply-To: <20170728134936.GA21401@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 28. Juli 2017, 15:49:36 CEST schrieb Herbert Xu:

Hi Herbert,

> All patches applied.  Yes please post follow-up patches to clean
> up as necessary.

Thank you. I will do that asap.

I would add the common service code to crypto/af_alg.c or do you prefer a 
separate or different file?

As the copy-AAD patch is also outstanding, in which order would you like to 
receive the patches (first the code consolidation patches or first the copy-
AAD patch)?

Ciao
Stephan
