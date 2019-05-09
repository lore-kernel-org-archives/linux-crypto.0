Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F50C04AAF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 05:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 647D220850
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 05:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfEIFZB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 May 2019 01:25:01 -0400
Received: from [5.180.42.13] ([5.180.42.13]:53930 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfEIFZB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 May 2019 01:25:01 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hObY8-0001Ck-7P; Thu, 09 May 2019 13:24:56 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hObY7-0001Zz-4D; Thu, 09 May 2019 13:24:55 +0800
Date:   Thu, 9 May 2019 13:24:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net, dt@chelsio.com
Subject: Re: [PATCH 1/4] crypto:chelsio Fix NULL pointer dereference
Message-ID: <20190509052455.rdfmk3qut777b6mr@gondor.apana.org.au>
References: <20190502104655.21690-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502104655.21690-1-atul.gupta@chelsio.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 02, 2019 at 03:46:55AM -0700, Atul Gupta wrote:
> Do not request FW to generate cidx update if there is less
> space in tx queue to post new request.
> SGE DBP 1 pidx increment too large
> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000124
> SGE error for queue 101
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> ---
>  drivers/crypto/chelsio/chcr_ipsec.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
