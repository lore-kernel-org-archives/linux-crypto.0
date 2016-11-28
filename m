From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: CTR DRBG - prevent invalid SG mappings
Date: Mon, 28 Nov 2016 21:10:27 +0800
Message-ID: <20161128131027.GA2674@gondor.apana.org.au>
References: <1833318.YYJALW9cvC@positron.chronox.de>
 <3805767.QuT5G9UC4v@positron.chronox.de>
 <2300597.UdE444b3Re@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40212 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753751AbcK1NKk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 08:10:40 -0500
Content-Disposition: inline
In-Reply-To: <2300597.UdE444b3Re@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 26, 2016 at 09:54:14AM +0100, Stephan Mueller wrote:
> Hi Herbert,
> 
> as discussed in another thread, SGs must not be used with stack memory 
> pointers. This issue was the culprit to the error I see with the CTR DRBG. The 
> attached patch fixes the issue.

Sorry but your patch is corrupted.  Please resend.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
