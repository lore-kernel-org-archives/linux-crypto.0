Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D7DC433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 08:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19847613AC
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 08:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhEUIX5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 04:23:57 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56058 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhEUIX5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 04:23:57 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lk0QN-0004zX-2F; Fri, 21 May 2021 16:22:27 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lk0QL-0007W2-11; Fri, 21 May 2021 16:22:25 +0800
Date:   Fri, 21 May 2021 16:22:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - fix initialization of 'secret_size'
Message-ID: <20210521082224.dzarrsqzxygschlw@gondor.apana.org.au>
References: <1620636848-38909-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620636848-38909-1-git-send-email-tanghui20@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 10, 2021 at 04:54:08PM +0800, Hui Tang wrote:
> Actual data length of the 'secret' is not equal to the 'secret_size'.
> 
> Since the 'curve_id' has removed in the 'secret', the 'secret_size'
> should subtract the length of the 'curve_id'.
> 
> Fixes: 6763f5ea2d9a(crypto: ecdh - move curve_id of ECDH from ...)
> 
> Signed-off-by: Hui Tang <tanghui20@huawei.com>
> ---
>  crypto/testmgr.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
