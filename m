From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: skcipher - noop for enc/dec with NULL data
Date: Sat, 07 Oct 2017 04:49:10 +0200
Message-ID: <3683903.fccHZfxTmM@positron.chronox.de>
References: <3874163.dZU00zCVt8@positron.chronox.de> <1612247.TXa8PiMVpk@positron.chronox.de> <20171007024635.GB28489@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34718 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751485AbdJGCtY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 22:49:24 -0400
In-Reply-To: <20171007024635.GB28489@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 7. Oktober 2017, 04:46:35 CEST schrieb Herbert Xu:

Hi Herbert,

> Hmm this just papers over bugs in the underlying code.  Which
> algorithm is causing the crash with a zero input? They're supposed
> to handle this case.

The bug happens with authenc. It is surely possible to modify authenc. Yet I 
thought that covering such issue at a central spot at least prevents similar 
buts to be exploitable from userspace.

Ciao
Stephan
