Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DCCC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 05:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345851AbhKZFiW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 00:38:22 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57166 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347800AbhKZFgV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 00:36:21 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mqTr3-0008SD-Ef; Fri, 26 Nov 2021 13:33:01 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mqTr3-0004bG-Bc; Fri, 26 Nov 2021 13:33:01 +0800
Date:   Fri, 26 Nov 2021 13:33:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: TDES - disallow in FIPS mode
Message-ID: <20211126053301.GI17477@gondor.apana.org.au>
References: <5322078.rdbgypaU67@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5322078.rdbgypaU67@positron.chronox.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Nov 21, 2021 at 04:10:33PM +0100, Stephan Müller wrote:
> On Dec 31 2023 NIST sunsets TDES for FIPS use. To prevent FIPS
> validations to be completed in the future to be affected by the TDES
> sunsetting, disallow TDES already now. Otherwise a FIPS validation would
> need to be "touched again" end 2023 to handle TDES accordingly.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/testmgr.c | 9 ---------
>  1 file changed, 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
