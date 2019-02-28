Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DB0C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A6D420842
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfB1Gar (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:30:47 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:39856 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1Gar (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 01:30:47 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzFDP-0005mh-6c; Thu, 28 Feb 2019 14:30:43 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzFDN-0001eM-9O; Thu, 28 Feb 2019 14:30:41 +0800
Date:   Thu, 28 Feb 2019 14:30:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg - use struct_size() in sock_kfree_s()
Message-ID: <20190228063041.mmuimz5s726lhfso@gondor.apana.org.au>
References: <20190221180423.GA5689@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221180423.GA5689@embeddedor>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 21, 2019 at 12:04:23PM -0600, Gustavo A. R. Silva wrote:
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, change the following form:
> 
> sizeof(*sgl) + sizeof(sgl->sg[0]) * (MAX_SGL_ENTS + 1)
> 
> to :
> 
> struct_size(sgl, sg, MAX_SGL_ENTS + 1)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  crypto/af_alg.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
