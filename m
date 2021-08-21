Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A272C4338F
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Aug 2021 07:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32B2D611C8
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Aug 2021 07:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhHUH0m (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Aug 2021 03:26:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53800 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232195AbhHUH0k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Aug 2021 03:26:40 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mHLOC-00062O-EV; Sat, 21 Aug 2021 15:26:00 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mHLO9-0008Cv-Ia; Sat, 21 Aug 2021 15:25:57 +0800
Date:   Sat, 21 Aug 2021 15:25:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH 2/5] crypto: hisilicon/sec - add ahash alg features for
 Kunpeng920
Message-ID: <20210821072557.GA31491@gondor.apana.org.au>
References: <1628847626-24383-1-git-send-email-yekai13@huawei.com>
 <1628847626-24383-3-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628847626-24383-3-git-send-email-yekai13@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 13, 2021 at 05:40:23PM +0800, Kai Ye wrote:
>
> +static int sec_ahash_import(struct ahash_request *req, const void *in)
> +{
> +	/*
> +	 * Import partial state of the transformation. This function loads the
> +	 * entire state of the ongoing transformation from a provided block of
> +	 * data so the transformation can continue from this point onward.
> +	 */
> +	struct sec_req *sreq = ahash_request_ctx(req);
> +
> +	memcpy(sreq, in, sizeof(struct sec_req));
> +	return 0;
> +}

Please explain how this works given that you've got pointers in
struct sec_req?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
