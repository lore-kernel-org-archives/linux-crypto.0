Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 338CCC282CE
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C5702084F
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfDHGlQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:41:16 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:45940 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfDHGlQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 02:41:16 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hDNxn-0008Af-5o; Mon, 08 Apr 2019 14:41:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hDNxl-0005qj-1P; Mon, 08 Apr 2019 14:41:01 +0800
Date:   Mon, 8 Apr 2019 14:41:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, shawnguo@kernel.org, s.hauer@pengutronix.de,
        kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH -next] crypto: mxs-dcp - return errcode in
 mxs_dcp_aes_enqueue and dcp_sha_update_fx
Message-ID: <20190408064100.ulwpxybomostllop@gondor.apana.org.au>
References: <20190330055221.24748-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190330055221.24748-1-yuehaibing@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 30, 2019 at 01:52:21PM +0800, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
> 
> 'err' is set in err path, but it's not returned to callers.
> Don't always return -EINPROGRESS, return err.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/mxs-dcp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
