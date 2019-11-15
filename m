Return-Path: <SRS0=SVjD=ZH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FDDC432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 06:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 634EF2073A
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 06:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfKOGHl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Nov 2019 01:07:41 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57956 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbfKOGHl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Nov 2019 01:07:41 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iVUlf-0004pu-3e; Fri, 15 Nov 2019 14:07:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iVUle-00068B-W2; Fri, 15 Nov 2019 14:07:39 +0800
Date:   Fri, 15 Nov 2019 14:07:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: tcrypt: constify check alg list
Message-ID: <20191115060738.obypnbrxla57fq2c@gondor.apana.org.au>
References: <1573227733-36704-1-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573227733-36704-1-git-send-email-clabbe@baylibre.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 08, 2019 at 03:42:13PM +0000, Corentin Labbe wrote:
> this patchs constify the alg list because this list is never modified.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  crypto/tcrypt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
