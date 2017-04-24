From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: algif_aead - Require setkey before accept(2)
Date: Mon, 24 Apr 2017 12:26:15 +0200
Message-ID: <41476204.egAyRFCtmD@tauon.chronox.de>
References: <2439869.UPpkkqdW7f@positron.chronox.de> <1688100.DB4uBLsSBi@positron.chronox.de> <20170424102239.GE20943@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59260 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1168460AbdDXK0S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 06:26:18 -0400
In-Reply-To: <20170424102239.GE20943@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 24. April 2017, 12:22:39 CEST schrieb Herbert Xu:

Hi Herbert,

> Patch applied.  Thanks.

Thank you.

The patch regarding the memory management of algif_aead is affected by this 
change as well. Shall I roll a new version of that patch for algif_aead or do 
you want me to wait for another review round?

Ciao
Stephan
