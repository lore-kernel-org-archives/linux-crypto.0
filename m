Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96AD9C6FD1F
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Mar 2023 08:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjCNIuR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Mar 2023 04:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCNIuR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Mar 2023 04:50:17 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC0A19696;
        Tue, 14 Mar 2023 01:49:48 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pc0LR-0042pK-FE; Tue, 14 Mar 2023 16:49:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Mar 2023 16:49:21 +0800
Date:   Tue, 14 Mar 2023 16:49:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "ye.xingchen@zte.com.cn" <ye.xingchen@zte.com.cn>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: p10-aes-gcm - remove duplicate include header
Message-ID: <ZBA1EVdy1DvfxgRO@gondor.apana.org.au>
References: <202303141631511535639@zte.com.cn>
 <dbbd6ff3-5e17-9b63-9027-359e37ace668@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbbd6ff3-5e17-9b63-9027-359e37ace668@csgroup.eu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 14, 2023 at 08:47:30AM +0000, Christophe Leroy wrote:
>
> Any reason for resending ?

The p10 patches were reverted, and have only just been re-instated.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
