From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Fri, 13 Jan 2017 19:25:39 +0800
Message-ID: <20170113112539.GA23928@gondor.apana.org.au>
References: <1486189.x0AQ4O6r2j@positron.chronox.de>
 <5603535.pO8F2Xs7xC@positron.chronox.de>
 <20170113111259.GA23800@gondor.apana.org.au>
 <2278925.gEXngSfgVI@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38019 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751563AbdAMLZr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:25:47 -0500
Content-Disposition: inline
In-Reply-To: <2278925.gEXngSfgVI@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 12:16:27PM +0100, Stephan Müller wrote:
>
> > If you're making a single call, what guarantees the ordering?
> 
> Technically, io_submit is the syscall that triggers the recvmsg. Are you 
> saying that this syscall does not maintain ordering? At least the man page 
> does not add any hints that it would not (unlike the lio_list man page).

The code certainly does.  But my point is that you can do the
same thing using the current API.  Just make your list be pairs
of write/read and it should work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
