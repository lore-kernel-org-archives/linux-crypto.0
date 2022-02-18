Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6531DC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Feb 2022 05:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiBRFij (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Feb 2022 00:38:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiBRFij (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Feb 2022 00:38:39 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2331A8CE7;
        Thu, 17 Feb 2022 21:38:23 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nKvyB-0005Hc-EC; Fri, 18 Feb 2022 16:38:16 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Feb 2022 16:38:15 +1100
Date:   Fri, 18 Feb 2022 16:38:15 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/sec - add the register configuration
 for HW V3
Message-ID: <Yg8wx4oQoKGXzZf/@gondor.apana.org.au>
References: <20220211090758.55352-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211090758.55352-1-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 11, 2022 at 05:07:58PM +0800, Kai Ye wrote:
> Added the register configuration of the SVA mode for HW V3.
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec_main.c | 51 +++++++++++++++++++-----
>  1 file changed, 40 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
