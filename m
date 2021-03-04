Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8BEC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 06:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 510A164F09
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 06:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbhCDGpw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 01:45:52 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52708 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234425AbhCDGpa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 01:45:30 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lHhj5-0007gp-KB; Thu, 04 Mar 2021 17:44:48 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Mar 2021 17:44:47 +1100
Date:   Thu, 4 Mar 2021 17:44:47 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - delete some redundant code
Message-ID: <20210304064447.GL15863@gondor.apana.org.au>
References: <1614051724-31694-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614051724-31694-1-git-send-email-yekai13@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 23, 2021 at 11:42:04AM +0800, Kai Ye wrote:
> Delete sg_data function, because sg_data function definition same as
> sg_virt(), so need to delete it and use sg_virt() replace to sg_data().
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
>  crypto/testmgr.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
