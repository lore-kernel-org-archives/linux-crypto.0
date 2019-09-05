Return-Path: <SRS0=9BFZ=XA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADECCC3A5A5
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 04:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 898C520870
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 04:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725209AbfIEEwc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:52:32 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60474 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbfIEEwb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 00:52:31 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i5jks-0006EF-4s; Thu, 05 Sep 2019 14:52:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Sep 2019 14:52:18 +1000
Date:   Thu, 5 Sep 2019 14:52:18 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vic Wu <vic.wu@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Ryder Lee <ryder.lee@mediatek.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] crypto: mediatek: move mtk_aes_find_dev() to the
 right place
Message-ID: <20190905045218.GA32038@gondor.apana.org.au>
References: <20190828063716.22689-1-vic.wu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828063716.22689-1-vic.wu@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 28, 2019 at 02:37:12PM +0800, Vic Wu wrote:
> From: Ryder Lee <ryder.lee@mediatek.com>
> 
> Move mtk_aes_find_dev() to right functions as nobody uses the
> 'cryp' under current flows.
> 
> We can also avoid duplicate checks here and there in this way.
> 
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> Signed-off-by: Vic Wu <vic.wu@mediatek.com>
> ---
>  drivers/crypto/mediatek/mtk-aes.c | 39 +++++++++++--------------------
>  1 file changed, 14 insertions(+), 25 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
