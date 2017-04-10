From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: authenc: crash if key is not set
Date: Mon, 10 Apr 2017 12:49:16 +0200
Message-ID: <6053931.eUnbK4IiOn@tauon.chronox.de>
References: <13796038.esLDiIrSPd@positron.chronox.de> <20170410104125.GA8427@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58890 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbdDJKtT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 06:49:19 -0400
In-Reply-To: <20170410104125.GA8427@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 10. April 2017, 12:41:25 CEST schrieb Herbert Xu:

Hi Herbert,

> > 
> > Is that bug similar in nature as the algif_skcipher and algif_hash bugs
> > that were fixed with the *nokey functions?
> 
> Yes we need to add the same thing to AEAD.

May I ask that we agree on the memory management fix prior to handling this 
issue? When consolidating the common code, I plan to have common code for the 
nokey logic which then is automatically applicable to aead too.

Thanks.

Ciao
Stephan
