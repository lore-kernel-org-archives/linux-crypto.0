Return-Path: <SRS0=SmAa=EF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066FFC00A89
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 06:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE19822203
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 06:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgJ3GvJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Oct 2020 02:51:09 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60530 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgJ3GvI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Oct 2020 02:51:08 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kYOFZ-0004uJ-AU; Fri, 30 Oct 2020 17:51:02 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Oct 2020 17:51:01 +1100
Date:   Fri, 30 Oct 2020 17:51:01 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sm2 - remove unnecessary reset operations
Message-ID: <20201030065101.GH25453@gondor.apana.org.au>
References: <20201015092441.12939-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015092441.12939-1-tianjia.zhang@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 15, 2020 at 05:24:41PM +0800, Tianjia Zhang wrote:
> This is an algorithm optimization. The reset operation when
> setting the public key is repeated and redundant, so remove it.
> At the same time, `sm2_ecc_os2ec()` is optimized to make the
> function more simpler and more in line with the Linux code style.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  crypto/sm2.c | 75 ++++++++++++++++++++--------------------------------
>  1 file changed, 29 insertions(+), 46 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
