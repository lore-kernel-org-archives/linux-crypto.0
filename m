Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14DDC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 06:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B25206B5
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 06:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgHTGum (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 02:50:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48892 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgHTGum (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 02:50:42 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k8eP2-0005jN-Hc; Thu, 20 Aug 2020 16:50:25 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 20 Aug 2020 16:50:24 +1000
Date:   Thu, 20 Aug 2020 16:50:24 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     haren@us.ibm.com, ddstreet@ieee.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib: Verify array index is correct before using it
Message-ID: <20200820065024.GA21086@gondor.apana.org.au>
References: <20200728122157.23120-1-huangguobin4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728122157.23120-1-huangguobin4@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 28, 2020 at 08:21:57AM -0400, Huang Guobin wrote:
> This code reads from the array before verifying that "c" is a valid
> index. Move test array offset code before use to fix it.
> 
> Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")
> Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
> ---
>  lib/842/842_compress.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

Did you check whether the out-of-bounds condition is even possible?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
