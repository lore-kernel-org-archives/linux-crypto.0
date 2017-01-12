From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Thu, 12 Jan 2017 17:05:03 +0100
Message-ID: <2701907.5SyJthQSdc@tauon.atsec.com>
References: <1486189.x0AQ4O6r2j@positron.chronox.de> <20170112155127.GA19252@gondor.apana.org.au> <3051008.MbfH4VO98W@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55498 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751194AbdALQFI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 11:05:08 -0500
In-Reply-To: <3051008.MbfH4VO98W@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 12. Januar 2017, 16:56:04 CET schrieb Stephan Müller:

Hi Herbert,

> 
> That would mean that we would only support one IOCB.

As we also need to be standards compliant, would it be appropriate to only 
support one IOCB? I think this is a significant difference to other AIO 
operations like for networking.

Ciao
Stephan
