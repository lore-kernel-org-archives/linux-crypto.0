From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Thu, 12 Jan 2017 17:10:14 +0100
Message-ID: <1946014.7KfpB7DN4Q@tauon.atsec.com>
References: <1486189.x0AQ4O6r2j@positron.chronox.de> <2701907.5SyJthQSdc@tauon.atsec.com> <20170112160739.GB19577@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55502 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751113AbdALQKT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 11:10:19 -0500
In-Reply-To: <20170112160739.GB19577@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 00:07:39 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Jan 12, 2017 at 05:05:03PM +0100, Stephan Müller wrote:
> > Am Donnerstag, 12. Januar 2017, 16:56:04 CET schrieb Stephan Müller:
> > 
> > Hi Herbert,
> > 
> > > That would mean that we would only support one IOCB.
> > 
> > As we also need to be standards compliant, would it be appropriate to only
> > support one IOCB? I think this is a significant difference to other AIO
> > operations like for networking.
> 
> Why would we be limited to one IOCB?

Each IOCB would transpire into an independent, separate recvmsg invocation 
without an additional sendmsg/sendpage operation. Thus, in order to support 
multiple IOCBs, all data the multiple recvmsg invocations will operate on must 
be injected into the kernel beforehand.

Ciao
Stephan
