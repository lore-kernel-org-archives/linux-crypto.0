From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto:drbg- Fixes panic in wait_for_completion call.
Date: Thu, 22 Jun 2017 16:59:10 +0800
Message-ID: <20170622085910.GA25859@gondor.apana.org.au>
References: <ea78b839-5717-2edb-c073-82fa82a0b403@gmail.com>
 <12466881.1IDO9Q7xg5@positron.chronox.de>
 <20170610041727.GG14719@gondor.apana.org.au>
 <CAFXBA=kWYZuVFDqKrrBEhDZa6n6SCTwM6g9ovx-_8B=RuqHjeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:34650 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752783AbdFVI7d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 04:59:33 -0400
Content-Disposition: inline
In-Reply-To: <CAFXBA=kWYZuVFDqKrrBEhDZa6n6SCTwM6g9ovx-_8B=RuqHjeA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 12, 2017 at 12:00:49PM +0530, Harsh Jain wrote:
> Hi Herbert,
> 
> Since It's a panic BUG.  Can we push this fix to stable kernel releases?

I have added it to crypto with a stable CC.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
