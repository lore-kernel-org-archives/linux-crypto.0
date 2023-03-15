Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2ECFC6FD1D
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Mar 2023 04:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjCOEdo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Mar 2023 00:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjCOEdn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Mar 2023 00:33:43 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A5B26869;
        Tue, 14 Mar 2023 21:33:36 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pcHvB-004UR2-QU; Wed, 15 Mar 2023 11:35:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Mar 2023 11:35:25 +0800
Date:   Wed, 15 Mar 2023 11:35:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "ye.xingchen@zte.com.cn" <ye.xingchen@zte.com.cn>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dtsen@linux.ibm.com
Subject: Re: [PATCH] crypto: p10-aes-gcm - remove duplicate include header
Message-ID: <ZBE8/Rg9mK3JGBi8@gondor.apana.org.au>
References: <202303141631511535639@zte.com.cn>
 <dbbd6ff3-5e17-9b63-9027-359e37ace668@csgroup.eu>
 <ZBA1EVdy1DvfxgRO@gondor.apana.org.au>
 <87mt4fobmj.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mt4fobmj.fsf@mpe.ellerman.id.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 14, 2023 at 09:44:52PM +1100, Michael Ellerman wrote:
>
> Hmm. Seems none of them were ever Cc'ed to linuxppc-dev. So this is the
> first I've seen of them.

Sorry, I didn't know that you weren't aware of this change.  I
will be more careful with these ppc patches in future.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
