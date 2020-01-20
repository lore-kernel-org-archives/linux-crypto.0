Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AB0C33CA1
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 07:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 210412073A
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 07:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgATH4E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 02:56:04 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56254 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgATH4E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 02:56:04 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1itRul-0005qD-1j; Mon, 20 Jan 2020 15:56:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1itRuh-0004iZ-W1; Mon, 20 Jan 2020 15:56:00 +0800
Date:   Mon, 20 Jan 2020 15:55:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kalyani Akula <kalyania@xilinx.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>, Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>
Subject: Re: [PATCH V4 0/4] Add Xilinx's ZynqMP AES-GCM driver support
Message-ID: <20200120075559.kra4dqdphbbnid5h@gondor.apana.org.au>
References: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
 <BN7PR02MB51241CCD25BD1269B4394D9AAF320@BN7PR02MB5124.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN7PR02MB51241CCD25BD1269B4394D9AAF320@BN7PR02MB5124.namprd02.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 20, 2020 at 06:59:22AM +0000, Kalyani Akula wrote:
> Hi Herbert,
> 
> Any review comments on below patch set.

Please resubmit your patch series once you have acks for the
non-crypto bits ready.  Please also state how you want it to
be merged, i.e., whether only the crypto patch is meant  for
the crypto tree or whether it needs to go in as a whole.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
