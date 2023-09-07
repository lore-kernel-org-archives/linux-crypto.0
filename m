Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858ADEC875B
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Sep 2023 20:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237568AbjIGU4z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Sep 2023 16:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjIGU4z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2023 16:56:55 -0400
X-Greylist: delayed 9000 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Sep 2023 13:56:49 PDT
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A16F1BCB
        for <linux-crypto@vger.kernel.org>; Thu,  7 Sep 2023 13:56:49 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qeC2n-00Bcfw-0D; Thu, 07 Sep 2023 18:15:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 07 Sep 2023 18:15:27 +0800
Date:   Thu, 7 Sep 2023 18:15:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC -next] crypto: add debug knob to force async crypto
Message-ID: <ZPmiv1jnci4hmsdL@gondor.apana.org.au>
References: <9d664093b1bf7f47497b2c40b3a085b45f3274a2.1694021240.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d664093b1bf7f47497b2c40b3a085b45f3274a2.1694021240.git.sd@queasysnail.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 06, 2023 at 07:48:14PM +0200, Sabrina Dubroca wrote:
> The networking code has multiple users of async crypto (tls, ipsec,
> macsec), but networking developers often don't have access to crypto
> accelerators, which limits the testing we can do on the async
> completion codepaths.
> 
> I've been using this patch to uncover some bugs [1] in the tls
> implementation, forcing AESNI (which I do have on my laptop and test
> machines) to go through cryptd.
> 
> The intent with the cryptd_delay_ms knob was to try to trigger some
> issues with async completions and closing tls sockets.
> 
> Link: https://lore.kernel.org/netdev/cover.1694018970.git.sd@queasysnail.net/ [1]
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Any reason why pcrypt can't be used for the same purpose?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
