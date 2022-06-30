Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90938C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 08:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiF3ISt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 04:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234094AbiF3IRi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 04:17:38 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D2F22BF6;
        Thu, 30 Jun 2022 01:16:31 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o6pLf-00CyAK-Df; Thu, 30 Jun 2022 18:16:28 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jun 2022 16:16:27 +0800
Date:   Thu, 30 Jun 2022 16:16:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lei He <helei.sig11@bytedance.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, pizhenwei@bytedance.com
Subject: Re: [PATCH] crypto: testmgr - fix version number of RSA tests
Message-ID: <Yr1b28CCjIY86Ohh@gondor.apana.org.au>
References: <20220624100625.47844-1-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624100625.47844-1-helei.sig11@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 24, 2022 at 06:06:25PM +0800, Lei He wrote:
> From: lei he <helei.sig11@bytedance.com>
> 
> According to PKCS#1 standard, the 'otherPrimeInfos' field contains
> the information for the additional primes r_3, ..., r_u, in order.
> It shall be omitted if the version is 0 and shall contain at least
> one instance of OtherPrimeInfo if the version is 1, see:
> 	https://www.rfc-editor.org/rfc/rfc3447#page-44
> 
> Replace the version number '1' with 0, otherwise, some drivers may
> not pass the run-time tests.
> 
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> ---
>  crypto/testmgr.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
