Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F3EC43603
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 13:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91D992073D
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 13:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfLJNj2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 08:39:28 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56340 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727131AbfLJNj2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 08:39:28 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iefja-0004X1-JE; Tue, 10 Dec 2019 21:39:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iefjY-00044n-1z; Tue, 10 Dec 2019 21:39:24 +0800
Date:   Tue, 10 Dec 2019 21:39:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yunfeng Ye <yeyunfeng@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.or,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "linfeilong@huawei.com" <linfeilong@huawei.com>
Subject: Re: [PATCH] crypto: user - use macro CRYPTO_MSG_INDEX() to instead
 of index calculation
Message-ID: <20191210133923.aab65usf4xyqd3wv@gondor.apana.org.au>
References: <6306e685-51fa-1a04-e9d9-07d4c80b5400@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6306e685-51fa-1a04-e9d9-07d4c80b5400@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 10, 2019 at 07:07:36PM +0800, Yunfeng Ye wrote:
> There are multiple places using CRYPTO_MSG_BASE to calculate the index,
> so use macro CRYPTO_MSG_INDEX() instead for better readability.
> 
> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>

I don't think your patch makes it any more readable.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
