Return-Path: <SRS0=WdwO=YZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A041CA9EC9
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 06:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 298D620656
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 06:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbfKAGNT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Nov 2019 02:13:19 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37788 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfKAGNT (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Fri, 1 Nov 2019 02:13:19 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iQQBR-00020U-4x; Fri, 01 Nov 2019 14:13:17 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iQQBQ-0004vW-V3; Fri, 01 Nov 2019 14:13:16 +0800
Date:   Fri, 1 Nov 2019 14:13:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Shukun Tan <tanshukun1@huawei.com>
Subject: Re: [PATCH] crypto: hisilicon - fix to return sub-optimal device
 when best device has no qps
Message-ID: <20191101061316.ks34f6mn6d3hxoxz@gondor.apana.org.au>
References: <1572058816-185603-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572058816-185603-1-git-send-email-wangzhou1@hisilicon.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 26, 2019 at 11:00:16AM +0800, Zhou Wang wrote:
> Currently find_zip_device() finds zip device which has the min NUMA
> distance with current CPU.
> 
> This patch modifies find_zip_device to return sub-optimal device when best
> device has no qps. This patch sorts all devices by NUMA distance, then
> finds the best zip device which has free qp.
> 
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c           | 21 ++++++++++
>  drivers/crypto/hisilicon/qm.h           |  2 +
>  drivers/crypto/hisilicon/zip/zip_main.c | 74 ++++++++++++++++++++++++---------
>  3 files changed, 77 insertions(+), 20 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
