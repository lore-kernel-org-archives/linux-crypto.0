Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DFAC32771
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 05:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07B502465A
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 05:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgAVFvR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 00:51:17 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:48298 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgAVFvR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 00:51:17 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iu8v5-0002Ax-IE; Wed, 22 Jan 2020 13:51:15 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iu8v1-0002uN-Mr; Wed, 22 Jan 2020 13:51:11 +0800
Date:   Wed, 22 Jan 2020 13:51:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     monstr@monstr.eu
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>, Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>
Subject: Re: [PATCH V4 0/4] Add Xilinx's ZynqMP AES-GCM driver support
Message-ID: <20200122055111.azr7zzhredywyusx@gondor.apana.org.au>
References: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
 <BN7PR02MB51241CCD25BD1269B4394D9AAF320@BN7PR02MB5124.namprd02.prod.outlook.com>
 <20200120075559.kra4dqdphbbnid5h@gondor.apana.org.au>
 <1abdf222-9517-976e-b3d3-bfc1c92c4663@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1abdf222-9517-976e-b3d3-bfc1c92c4663@seznam.cz>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 21, 2020 at 10:26:07AM +0100, Michal Simek wrote:
>
> All these drivers which requires firmware interface extension can be
> added via your tree or I can take them via arm-soc tree with your ack.
> 
> It is really up to you. I am happy to just ack patches out of crypto and
> feel free to take them via your tree.
> Or please let me know when you are done with review and I will take them.

Thanks Michal. If you could ack them once they've been resubmitted
then I can just take them via the cryptodev tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
