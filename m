From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Fri, 13 Jan 2017 12:51:37 +0100
Message-ID: <1629913.CiS9dHAudq@positron.chronox.de>
References: <1486189.x0AQ4O6r2j@positron.chronox.de> <2278925.gEXngSfgVI@positron.chronox.de> <20170113112539.GA23928@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55550 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751498AbdAMLvq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:51:46 -0500
In-Reply-To: <20170113112539.GA23928@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 19:25:39 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Jan 13, 2017 at 12:16:27PM +0100, Stephan Müller wrote:
> > > If you're making a single call, what guarantees the ordering?
> > 
> > Technically, io_submit is the syscall that triggers the recvmsg. Are you
> > saying that this syscall does not maintain ordering? At least the man page
> > does not add any hints that it would not (unlike the lio_list man page).
> 
> The code certainly does.  But my point is that you can do the
> same thing using the current API.  Just make your list be pairs
> of write/read and it should work.

How shall these pairs come into existence? The read/write system calls may 
come at unspecified times with potentially dissimilar buffer lengths.


Ciao
Stephan
