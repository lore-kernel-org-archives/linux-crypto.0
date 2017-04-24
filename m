From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif_aead - Require setkey before accept(2)
Date: Mon, 24 Apr 2017 17:03:13 +0800
Message-ID: <20170424090313.GA20718@gondor.apana.org.au>
References: <2439869.UPpkkqdW7f@positron.chronox.de>
 <2572320.UaipMWf1ob@positron.chronox.de>
 <20170424084324.GA20473@gondor.apana.org.au>
 <3234815.BdC1qsBGSt@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:45226 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1167361AbdDXJD7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 05:03:59 -0400
Content-Disposition: inline
In-Reply-To: <3234815.BdC1qsBGSt@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 24, 2017 at 11:01:50AM +0200, Stephan Müller wrote:
>
> Shall I send an updated patch with aead_sock_destruct cleared?

Yes please.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
