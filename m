From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC] revamp fips_allowed flag
Date: Thu, 15 Sep 2016 08:23:05 +0200
Message-ID: <2606890.Z1PDhBGeZR@tauon.atsec.com>
References: <1818375.56xtGUSNII@tauon.atsec.com> <20160915055808.GA14688@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47964 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933287AbcIOGXe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 02:23:34 -0400
In-Reply-To: <20160915055808.GA14688@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 15. September 2016, 13:58:08 CEST schrieb Herbert Xu:

Hi Herbert,

> Where's the pain point here? For cases like seqiv where you want to
> say if X is FIPS-allowed then so is seqiv(X) we can certainly add
> some code to testmgr to cater for that instead of listing them
> individually.

Where shall we draw the line here? Shall that be only for authenc, or seqiv? 
Or shall we also consider rfc4106 too, knowing that there are implementations 
which provide a full rfc4106 GCM combo (x86 for example). What about the 
current pkcspad1 template where we could expect that there may be entire HW 
implementations with that?

Ciao
Stephan
