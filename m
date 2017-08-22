From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - get_page upon reassignment to TX SGL
Date: Tue, 22 Aug 2017 15:57:41 +0800
Message-ID: <20170822075741.GD6269@gondor.apana.org.au>
References: <2704295.VBAGuigrBX@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:40854 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754645AbdHVH5v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 03:57:51 -0400
Content-Disposition: inline
In-Reply-To: <2704295.VBAGuigrBX@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 10, 2017 at 04:40:03PM +0200, Stephan Müller wrote:
> Hi Herbert,
> 
> The error can be triggered with the following test. Invoking that test
> in a while [ 1 ] loop shows that no memory is leaked.

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
