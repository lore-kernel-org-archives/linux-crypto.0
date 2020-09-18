Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D476C43464
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4089B2176B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgIRHaX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:30:23 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57658 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgIRHaX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:30:23 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kJAqX-0003YJ-JV; Fri, 18 Sep 2020 17:30:18 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2020 17:30:17 +1000
Date:   Fri, 18 Sep 2020 17:30:17 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal van Leeuwen <pvanleeuwen@rambus.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        davem@davemloft.net
Subject: Re: [PATCH] crypto: inside-secure - Add support for EIP197 with
 output classifier
Message-ID: <20200918073017.GI23319@gondor.apana.org.au>
References: <1599810399-14999-1-git-send-email-pvanleeuwen@rambus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599810399-14999-1-git-send-email-pvanleeuwen@rambus.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 11, 2020 at 09:46:39AM +0200, Pascal van Leeuwen wrote:
> This patch adds support for EIP197 instances that include the output
> classifier (OCE) option, as used by one of our biggest customers.
> The OCE normally requires initialization and dedicated firmware, but
> for the simple operations supported by this driver, we just bypass it
> completely for now (using what is formally a debug feature).
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@rambus.com>
> ---
>  drivers/crypto/inside-secure/safexcel.c | 44 ++++++++++++++++++++++++++++++---
>  drivers/crypto/inside-secure/safexcel.h | 13 ++++++++++
>  2 files changed, 54 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
