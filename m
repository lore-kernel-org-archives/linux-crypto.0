Return-Path: <SRS0=9BFZ=XA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC75C3A5A5
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 04:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98C6B206DF
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 04:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfIEEyN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:54:13 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60534 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbfIEEyN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 00:54:13 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i5jmW-0006HY-4U; Thu, 05 Sep 2019 14:54:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Sep 2019 14:54:00 +1000
Date:   Thu, 5 Sep 2019 14:54:00 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Mack <daniel@zonque.org>
Cc:     mpm@selenic.com, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] hw_random: timeriomem_rng: relax check on memory
 resource size
Message-ID: <20190905045400.GB32038@gondor.apana.org.au>
References: <20190831115555.11708-1-daniel@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190831115555.11708-1-daniel@zonque.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 31, 2019 at 01:55:55PM +0200, Daniel Mack wrote:
> The timeriomem_rng driver only accesses the first 4 bytes of the given
> memory area and currently, it also forces that memory resource to be
> exactly 4 bytes in size.
> 
> This, however, is problematic when used with device-trees that are
> generated from things like FPGA toolchains, where the minimum size
> of an exposed memory block may be something like 4k.
> 
> Hence, let's only check for what's needed for the driver to operate
> properly; namely that we have enough memory available to read the
> random data from.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
>  Documentation/devicetree/bindings/rng/timeriomem_rng.txt | 2 +-
>  drivers/char/hw_random/timeriomem-rng.c                  | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
