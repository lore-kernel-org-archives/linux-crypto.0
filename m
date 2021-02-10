Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9401FC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A18364E45
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhBJHXR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Feb 2021 02:23:17 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:50214 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232341AbhBJHXN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Feb 2021 02:23:13 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l9jpR-0001FD-48; Wed, 10 Feb 2021 18:22:26 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Feb 2021 18:22:24 +1100
Date:   Wed, 10 Feb 2021 18:22:24 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     horia.geanta@nxp.com, aymen.sghaier@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: caam - Replace DEFINE_SIMPLE_ATTRIBUTE with
 DEFINE_DEBUGFS_ATTRIBUTE
Message-ID: <20210210072224.GD4493@gondor.apana.org.au>
References: <1612231575-15646-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612231575-15646-1-git-send-email-jiapeng.chong@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 02, 2021 at 10:06:15AM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warning:
> 
> ./drivers/crypto/caam/debugfs.c:23:0-23: WARNING: caam_fops_u64_ro
> should be defined with DEFINE_DEBUGFS_ATTRIBUTE.
> 
> ./drivers/crypto/caam/debugfs.c:22:0-23: WARNING: caam_fops_u32_ro
> should be defined with DEFINE_DEBUGFS_ATTRIBUTE.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
> Changes in v2:
>   -Modified subject.
> 
>  drivers/crypto/caam/debugfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
