From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Fri, 13 Jan 2017 12:16:27 +0100
Message-ID: <2278925.gEXngSfgVI@positron.chronox.de>
References: <1486189.x0AQ4O6r2j@positron.chronox.de> <5603535.pO8F2Xs7xC@positron.chronox.de> <20170113111259.GA23800@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55534 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751373AbdAMLQc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:16:32 -0500
In-Reply-To: <20170113111259.GA23800@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 19:12:59 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Jan 13, 2017 at 12:10:02PM +0100, Stephan Müller wrote:
> > > Well if ordering is not guaranteed that I don't see how your code
> > > can work either.  Or am I missing something?
> > 
> > The patch simply stores all data it gets from sendmsg in the src SGL. In
> > addition it maintains an offset pointer into that src SGLs.
> > 
> > When the recvmsg call comes in and the dst SGL is prepared, it simply
> > takes as much data from the src SGL as needed to cover the request
> > defined by the dst SGL. After completing that operation, the offset
> > pointer is moved forward to point to a yet unused part of the src SGL. If
> > another recvmsg comes in without an intermediate sendmsg, it simply
> > starts using the data from the src SGL starting from the offset.
> > 
> > Therefore, the code should now be able to handle a write / write / read /
> > read scenario. Or it can handle, say, a write(32 bytes) / read (16 bytes)
> > / read (16 bytes). At least my tests covered a successful testing of that
> > scenario which always crashed the kernel before.
> 
> Are you making separate read calls or just a single one? If you're
> making separate calls, then this is no differnt to just doing
> write/read pairs.  You're not saving any overhead.

I make one read call.
> 
> If you're making a single call, what guarantees the ordering?

Technically, io_submit is the syscall that triggers the recvmsg. Are you 
saying that this syscall does not maintain ordering? At least the man page 
does not add any hints that it would not (unlike the lio_list man page).

Ciao
Stephan
