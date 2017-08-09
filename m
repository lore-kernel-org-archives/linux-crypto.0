From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - return error code when no data was
 processed
Date: Wed, 9 Aug 2017 21:56:18 +0800
Message-ID: <20170809135618.GA743@gondor.apana.org.au>
References: <3015646.VmS85RP8pt@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36788 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752671AbdHIN41 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2017 09:56:27 -0400
Content-Disposition: inline
In-Reply-To: <3015646.VmS85RP8pt@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jul 30, 2017 at 02:31:18PM +0200, Stephan Müller wrote:
> If no data has been processed during recvmsg, return the error code.
> This covers all errors received during non-AIO operations.
> 
> If any error occurs during a synchronous operation in addition to
> -EIOCBQUEUED or -EBADMSG (like -ENOMEM), it should be relayed to the
> caller.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
