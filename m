From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 20 Jan 2017 21:28:23 +0100
Message-ID: <4544061.XCvI0LW5oE@tauon.atsec.com>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <20170113113906.GA24096@gondor.apana.org.au> <2a4fab23-3ea7-a0f7-7c30-55d301f51ec9@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55616 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752481AbdATU23 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2017 15:28:29 -0500
In-Reply-To: <2a4fab23-3ea7-a0f7-7c30-55d301f51ec9@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 20. Januar 2017, 18:07:04 CET schrieb Cyrille Pitchen:

Hi Cyrille,

> 
> I've taken Stephan's other comments into account from his review of the
> atmel-authenc driver so I'm preparing a new series but I don't know what to
> do for the associated data copy.
> 
> Please let me know what you recommend, thanks!

The question is where the null context shall be saved. As Herbert mentioned, 
he may not want to have it in crypto_aead.

Herbert, as this implementation also requires the copy, shall we leave the 
null context in crypto_aead? If so, Cyrille can simply use patch 01 from this 
series and apply the change to his code similar to what I did in patches 02 - 
13.

Ciao
Stephan
