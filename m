Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02238C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 06:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242551AbiA1G1s (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:27:48 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60620 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346462AbiA1G1r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 01:27:47 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nDKjY-0001Ek-Rt; Fri, 28 Jan 2022 17:27:45 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jan 2022 17:27:44 +1100
Date:   Fri, 28 Jan 2022 17:27:44 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v3 0/5] crypto: hisilicon - some misc bugfix for SEC
 engine
Message-ID: <YfOM4EHwMQHRxq+c@gondor.apana.org.au>
References: <20220122081312.29121-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122081312.29121-1-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jan 22, 2022 at 04:13:07PM +0800, Kai Ye wrote:
> some misc bugfix for SEC engine.
> 
> changes v1->v2:
> 	add rate limited for printing messages.
> changes v2->v3:
> 	modify the second patch.
> 
> Kai Ye (5):
>   crypto: hisilicon/sec - fixup icv checking enabled on Kunpeng 930
>   crypto: hisilicon/sec - add some comments for soft fallback
>   crypto: hisilicon/sec - fix the max length of AAD for the CCM mode
>   crypto: hisilicon/sec - fix the CTR mode BD configuration
>   crypto: hisilicon/sec - use the correct print format
> 
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 27 +++++++++++++++-------
>  drivers/crypto/hisilicon/sec2/sec_crypto.h |  6 +++--
>  2 files changed, 23 insertions(+), 10 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
