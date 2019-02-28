Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD30C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10F7920842
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbfB1G3F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:29:05 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:39744 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfB1G3F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 01:29:05 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzFBn-0005gC-F2; Thu, 28 Feb 2019 14:29:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzFBh-0001bu-Sz; Thu, 28 Feb 2019 14:28:57 +0800
Date:   Thu, 28 Feb 2019 14:28:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        mcoquelin.stm32@gmail.com, clabbe.montjoie@gmail.com,
        gilad@benyossef.com, ebiggers@google.com, keescook@chromium.org,
        alexandre.torgue@st.com
Subject: Re: [PATCH] crypto: stm32 - drop pointless static qualifier in
 stm32_hash_remove()
Message-ID: <20190228062857.rtxuq6lwns4cqu6m@gondor.apana.org.au>
References: <20190218144900.142544-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218144900.142544-1-maowenan@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 18, 2019 at 10:49:00PM +0800, Mao Wenan wrote:
> There is no need to have the struct stm32_hash_dev *hdev static
> since new value always be assigned before use it.
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  drivers/crypto/stm32/stm32-hash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
