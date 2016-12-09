From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: xts(ecb(aes-asm))
Date: Fri, 09 Dec 2016 07:02:25 +0100
Message-ID: <4308953.jQs16UQPE9@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39202 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932232AbcLIGC2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2016 01:02:28 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

while testing the current cryptodev-2.6 tree, I noticed that instead of the 
driver name of xts(aes-asm) (which used to be there), I now see xts(ecb(aes-
asm)).

Is that intentional?

Ciao
Stephan
