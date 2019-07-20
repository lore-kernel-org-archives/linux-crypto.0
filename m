Return-Path: <SRS0=kkja=VR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFF6C7618F
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Jul 2019 02:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 819F020880
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Jul 2019 02:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbfGTCu0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 22:50:26 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:44192 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbfGTCu0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 22:50:26 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hofS1-0005Wk-GG; Sat, 20 Jul 2019 10:50:21 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hofRy-0000UT-Pi; Sat, 20 Jul 2019 10:50:18 +0800
Date:   Sat, 20 Jul 2019 10:50:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: generic ahash question
Message-ID: <20190720025018.3b7pgc6hbll3ucyd@gondor.apana.org.au>
References: <MN2PR20MB297347B80C7E3DCD19127B05CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719162303.GB1422@gmail.com>
 <MN2PR20MB2973067B1373891A5899ECBBCACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719200711.GD1422@gmail.com>
 <MN2PR20MB29737E72B082B6CAA43189FACACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB29737E72B082B6CAA43189FACACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 19, 2019 at 09:30:20PM +0000, Pascal Van Leeuwen wrote:
>
> Still, it seems rather odd to on the one hand acknowledge the fact that there is 
> hardware out there with these limitations, and add  specific support for that, and 
> on the other hand burden their drivers with implementing all these fallbacks.
> That's why I assumed there must be some flags somehere to indicate to the API
> that it should not bother my driver with requests requiring init/update/final.
> Which I now know is not the case, so fine, I either implement the fallbacks or I
> just don't bother supporting the algorithm.

If we could abstract out the fallback stuff so that it could be
reused in multiple drivers then we should do that.  It's just
that there hasn't been enough of a need to do this up until now.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
