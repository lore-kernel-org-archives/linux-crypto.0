From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v11 0/2] crypto: AF_ALG memory management fix
Date: Fri, 28 Jul 2017 21:49:36 +0800
Message-ID: <20170728134936.GA21401@gondor.apana.org.au>
References: <6602969.vlMq0gDBpR@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39870 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751690AbdG1Nto (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 09:49:44 -0400
Content-Disposition: inline
In-Reply-To: <6602969.vlMq0gDBpR@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 25, 2017 at 05:12:13PM +0200, Stephan Müller wrote:
> Hi Herbert,
> 
> Changes v11:
> - algif_skcipher: remove len < ctx->used in recvmsg as requested by Herbert
>   and verified by the latest test code in libkcapi.
> - algif_skcipher/algif_aead: simplify _recvmsg error code path
> 
> With the changes, you will see a lot of code duplication now
> as I deliberately tried to use the same struct and variable names,
> the same function names and even the same oder of functions.
> If you agree to this patch, I volunteer to provide a followup
> patch that will extract the code duplication into common
> functions.

All patches applied.  Yes please post follow-up patches to clean
up as necessary.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
