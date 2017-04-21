From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: algif_aead - Require setkey before accept(2)
Date: Fri, 21 Apr 2017 17:33:33 +0200
Message-ID: <3707351.rIbHDK6BJ3@tauon.chronox.de>
References: <2439869.UPpkkqdW7f@positron.chronox.de> <20170421111127.GA13925@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59126 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1036880AbdDUS2O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 14:28:14 -0400
In-Reply-To: <20170421111127.GA13925@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 21. April 2017, 13:11:27 CEST schrieb Herbert Xu:

Hi Herbert,

> Please don't mix unrelated cleanups like this with the real change.
>  It makes reviewing harder than necessary.

Apologies. I will resend it shortly.


Ciao
Stephan
