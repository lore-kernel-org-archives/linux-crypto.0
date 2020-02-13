Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293D4C2BA83
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 09:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BA2320848
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 09:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgBMJCv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 04:02:51 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:41830 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbgBMJCv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 04:02:51 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j2AOT-0003zG-Rn; Thu, 13 Feb 2020 17:02:45 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j2AOP-000407-Pf; Thu, 13 Feb 2020 17:02:41 +0800
Date:   Thu, 13 Feb 2020 17:02:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kalyani Akula <kalyani.akula@xilinx.com>
Cc:     davem@davemloft.net, monstr@seznam.cz,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        git-dev <git-dev@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Kalyani Akula <kalyania@xilinx.com>,
        Mohan Marutirao Dhanawade <mohan.dhanawade@xilinx.com>
Subject: Re: [PATCH V6 3/4] crypto: Add Xilinx AES driver
Message-ID: <20200213090241.fksu33yszqi5fjat@gondor.apana.org.au>
References: <1580192308-10952-1-git-send-email-kalyani.akula@xilinx.com>
 <1580192308-10952-4-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580192308-10952-4-git-send-email-kalyani.akula@xilinx.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 28, 2020 at 11:48:27AM +0530, Kalyani Akula wrote:
> This patch adds AES driver support for the Xilinx ZynqMP SoC.
> 
> Signed-off-by: Mohan Marutirao Dhanawade <mohan.dhanawade@xilinx.com>
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
> V5 Changes:
> - Replaced ARCH_ZYNQMP with ZYNQMP_FIRMWARE in Kconfig
> - Removed extra new lines. 
> - Moved crypto: Add Xilinx AES driver patch from 4/4 to 3/4.
> - Updated Signed-off-by sequence.

Sorry but this patch doesn't compile against the current cryptodev
tree.  Please fix and respost.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
