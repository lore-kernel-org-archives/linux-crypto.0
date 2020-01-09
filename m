Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0AC3C32771
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA27D20721
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgAIFOo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 00:14:44 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:40438 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgAIFOn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 00:14:43 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ipQ9a-0003In-JE; Thu, 09 Jan 2020 13:14:42 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ipQ9V-0003X6-3f; Thu, 09 Jan 2020 13:14:37 +0800
Date:   Thu, 9 Jan 2020 13:14:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gary R Hook <gary.hook@amd.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com
Subject: Re: [PATCH] crypto: ccp - Update MAINTAINERS for CCP driver
Message-ID: <20200109051437.5g5hubtkduu3ylf2@gondor.apana.org.au>
References: <20200102195703.7841-1-gary.hook@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102195703.7841-1-gary.hook@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 02, 2020 at 01:57:03PM -0600, Gary R Hook wrote:
> From: Gary R Hook <gary.hook@amd.com>
> 
> Remove Gary R Hook as CCP maintainer.
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
