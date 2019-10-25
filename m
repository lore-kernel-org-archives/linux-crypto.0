Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BBCCA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ACEB21D7B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440707AbfJYP0d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:26:33 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36064 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731226AbfJYP0d (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Fri, 25 Oct 2019 11:26:33 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iO1Tx-0001tn-PG; Fri, 25 Oct 2019 23:26:29 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iO1Tx-0007tm-0B; Fri, 25 Oct 2019 23:26:29 +0800
Date:   Fri, 25 Oct 2019 23:26:28 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tian Tao <tiantao6@huawei.com>
Cc:     gilad@benyossef.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH v2] crypto: fix comparison of unsigned expression warning
Message-ID: <20191025152628.btnajavau4s2aq5c@gondor.apana.org.au>
References: <1571445697-33824-1-git-send-email-tiantao6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571445697-33824-1-git-send-email-tiantao6@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 19, 2019 at 08:41:37AM +0800, Tian Tao wrote:
> This patch fixes the following warnings:
> drivers/crypto/ccree/cc_aead.c:630:5-12: WARNING: Unsigned expression
> compared with zero: seq_len > 0
> 
> Signed-off-by: Tian Tao <tiantao6@huawei.com>
> 
> v2:
> change hmac_setkey() return type to unsigned int to fix the warning.
> ---
>  drivers/crypto/ccree/cc_aead.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
