From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Fri, 13 Jan 2017 00:07:39 +0800
Message-ID: <20170112160739.GB19577@gondor.apana.org.au>
References: <1486189.x0AQ4O6r2j@positron.chronox.de>
 <20170112155127.GA19252@gondor.apana.org.au>
 <3051008.MbfH4VO98W@tauon.atsec.com>
 <2701907.5SyJthQSdc@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47999 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750907AbdALQHy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 11:07:54 -0500
Content-Disposition: inline
In-Reply-To: <2701907.5SyJthQSdc@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 05:05:03PM +0100, Stephan Müller wrote:
> Am Donnerstag, 12. Januar 2017, 16:56:04 CET schrieb Stephan Müller:
> 
> Hi Herbert,
> 
> > 
> > That would mean that we would only support one IOCB.
> 
> As we also need to be standards compliant, would it be appropriate to only 
> support one IOCB? I think this is a significant difference to other AIO 
> operations like for networking.

Why would we be limited to one IOCB?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
