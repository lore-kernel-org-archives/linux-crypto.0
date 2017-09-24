From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 0/2] fix authenc() kernel crash
Date: Sun, 24 Sep 2017 08:28:31 +0200
Message-ID: <5715632.7er1IYYKWG@positron.chronox.de>
References: <3874163.dZU00zCVt8@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34942 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751355AbdIXG2i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Sep 2017 02:28:38 -0400
In-Reply-To: <3874163.dZU00zCVt8@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 24. September 2017, 08:22:54 CEST schrieb Stephan Müller:

Hi Herbert,

(private)

> Hi Herbert,
> 
> The two patches together fix a kernel crash that can be triggered via
> AF_ALG when using authenc() with zero plaintext.
> 
> The changes are also tested to verify that the hashing on null data
> is still supported.

You can test / verify the patch with the HEAD code of libkcapi found in [1].

Please execute:

./configure --enable-kcapi-test
make
bin/kcapi -h -x 2 -c "authenc(hmac(sha256),cbc(aes))" -d 2

Note, the last command may take a couple of seconds.

[1] https://github.com/smuellerDD/libkcapi


Ciao
Stephan
