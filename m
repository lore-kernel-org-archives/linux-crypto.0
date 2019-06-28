Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3E7C5B577
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 02:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D05F2086D
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 02:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfF1CH0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 22:07:26 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50980 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbfF1CH0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 22:07:26 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hggII-0002U6-C6; Fri, 28 Jun 2019 10:07:18 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hggIF-0000Za-MF; Fri, 28 Jun 2019 10:07:15 +0800
Date:   Fri, 28 Jun 2019 10:07:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Haren Myneni <haren@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] crypto/NX: Set receive window credits to max number
 of CRBs in RxFIFO
Message-ID: <20190628020715.6qopmtm4q63lsdxm@gondor.apana.org.au>
References: <20190627062610.olw3ojckkwil4jlk@gondor.apana.org.au>
 <87tvcascwb.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tvcascwb.fsf@concordia.ellerman.id.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 28, 2019 at 11:43:16AM +1000, Michael Ellerman wrote:
>
> No. I assumed you'd take it because it's in drivers/crypto.
> 
> If you want me to take it that's fine, just let me know.

No that's fine Michael.  I'll pick it up.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
