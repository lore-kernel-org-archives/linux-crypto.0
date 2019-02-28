Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDABCC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5D1C20842
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730798AbfB1GaF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:30:05 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:39820 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1GaF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 01:30:05 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzFCj-0005jh-69; Thu, 28 Feb 2019 14:30:01 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzFCh-0001dM-Tx; Thu, 28 Feb 2019 14:29:59 +0800
Date:   Thu, 28 Feb 2019 14:29:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tommi Hirvola <tommi@hirvola.fi>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/poly1305 - Clear key material from stack in
 SSE2 variant
Message-ID: <20190228062959.ugqy6l5wya4grn5s@gondor.apana.org.au>
References: <20190219154554.GA3009@hirvola.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219154554.GA3009@hirvola.fi>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 19, 2019 at 05:45:54PM +0200, Tommi Hirvola wrote:
> 1-block SSE2 variant of poly1305 stores variables s1..s4 containing key
> material on the stack. This commit adds missing zeroing of the stack
> memory. Benchmarks show negligible performance hit (tested on i7-3770).
> 
> Signed-off-by: Tommi Hirvola <tommi@hirvola.fi>
> ---
> Similarly, poly1305_blocks() in crypto/poly1305_generic.c stores s1..s4
> as well as r0..r4 to local variables which may be stored in the stack by
> the compiler. Fixing that is less trivial and left for another patch.
> 
> Tests were run with poly1305_simd_blocks() patched to call only 1-block
> SSE2 poly1305 function.
> ---
>  arch/x86/crypto/poly1305-sse2-x86_64.S | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
