Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C17C433E2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 08:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE36206C9
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 08:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgIDI2c (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 04:28:32 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42690 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbgIDI2c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 04:28:32 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kE75B-0001R7-EJ; Fri, 04 Sep 2020 18:28:30 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2020 18:28:29 +1000
Date:   Fri, 4 Sep 2020 18:28:29 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Denis Efremov <efremov@linux.com>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: sun8i-ss - remove redundant memzero_explicit()
Message-ID: <20200904082829.GD1214@gondor.apana.org.au>
References: <20200827080310.GA29222@Red>
 <20200827121611.18308-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827121611.18308-1-efremov@linux.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 03:16:11PM +0300, Denis Efremov wrote:
> Remove redundant memzero_explicit() in sun8i_ss_cipher() before calling
> kfree_sensitive(). kfree_sensitive() will zero the memory with
> memzero_explicit().
> 
> Fixes: 453431a54934 ("mm, treewide: rename kzfree() to kfree_sensitive()")
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
> Changes in v2:
>  - fixes tag added
> 
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
