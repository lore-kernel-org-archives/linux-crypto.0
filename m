Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1028CC6FD19
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Mar 2023 04:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCPEEU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Mar 2023 00:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjCPEER (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2023 00:04:17 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3549285B25;
        Wed, 15 Mar 2023 21:04:07 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pceq6-004zOf-DZ; Thu, 16 Mar 2023 12:03:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Mar 2023 12:03:42 +0800
Date:   Thu, 16 Mar 2023 12:03:42 +0800
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
Message-ID: <ZBKVHvlNEKG4t8Pv@gondor.apana.org.au>
References: <202303141631511535639@zte.com.cn>
 <dbbd6ff3-5e17-9b63-9027-359e37ace668@csgroup.eu>
 <ZBA1EVdy1DvfxgRO@gondor.apana.org.au>
 <87mt4fobmj.fsf@mpe.ellerman.id.au>
 <ZBE8/Rg9mK3JGBi8@gondor.apana.org.au>
 <87r0tpmjoz.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0tpmjoz.fsf@mpe.ellerman.id.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 16, 2023 at 02:58:04PM +1100, Michael Ellerman wrote:
>
> Although one question I do have for you is what rules, if any, do we
> have for deciding whether crypto code goes in drivers/crypto vs
> arch/*/crypto?

If it's on the CPU then it should probably live under arch.  Yes
there have been exceptions in the past, with VIA PadLock on x86
and vmx on PPC being prime examples.

> I wonder if we should move drivers/crypto/vmx into arch/powerpc/crypto,
> so that all the powerpc CRYPTOGAMS code is in one place. That would help
> to clean up some of the duplication of perl scripts we now have.

Yes I think that would certainly make sense.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
