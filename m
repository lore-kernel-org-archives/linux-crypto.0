From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 13 Jan 2017 12:36:56 +0100
Message-ID: <2829634.RJknVxGPvY@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <1704568.lHqrOxcchT@positron.chronox.de> <20170113113324.GA24021@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55548 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751552AbdAMLr7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:47:59 -0500
In-Reply-To: <20170113113324.GA24021@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 19:33:24 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Jan 13, 2017 at 12:30:15PM +0100, Stephan Müller wrote:
> > So, the patch set you want to see is:
> > 
> > - remove the AAD copy operation from authenc and not add it to any AEAD
> > implementations
> 
> Why would you remove it from authenc?

I thought I understood that you would not want to see it in any 
implementation. But, ok, if you want to leave it.

Ciao
Stephan
