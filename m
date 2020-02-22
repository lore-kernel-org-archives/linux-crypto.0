Return-Path: <SRS0=tFxg=4K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A62C35670
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 01:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3837206EF
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 01:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgBVBm6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 20:42:58 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52252 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727723AbgBVBm4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 20:42:56 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1j5Joa-0002xe-1W; Sat, 22 Feb 2020 12:42:45 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Feb 2020 12:42:43 +1100
Date:   Sat, 22 Feb 2020 12:42:43 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Kosina <trivial@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] crypto: qat - spelling s/Decrytp/Decrypt/
Message-ID: <20200222014243.GE19028@gondor.apana.org.au>
References: <20200212084536.9083-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212084536.9083-1-geert+renesas@glider.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 12, 2020 at 09:45:36AM +0100, Geert Uytterhoeven wrote:
> Fix a typo in a comment.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/crypto/qat/qat_common/qat_algs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
