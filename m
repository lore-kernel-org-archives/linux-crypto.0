Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27F4C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A17D220842
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfB1GjH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:39:07 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:40108 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1GjG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 01:39:06 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzFLV-00061i-8w; Thu, 28 Feb 2019 14:39:05 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzFLT-0001x4-Le; Thu, 28 Feb 2019 14:39:03 +0800
Date:   Thu, 28 Feb 2019 14:39:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Jan Glauber <jglauber@cavium.com>
Subject: Re: [PATCH] crypto: cavium/zip - fix collision with generic
 cra_driver_name
Message-ID: <20190228063903.5vb3tas63z3dcwau@gondor.apana.org.au>
References: <20190223082323.4126-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190223082323.4126-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 23, 2019 at 12:23:23AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The cavium/zip implementation of the deflate compression algorithm is
> incorrectly being registered under the generic driver name, which
> prevents the generic implementation from being registered with the
> crypto API when CONFIG_CRYPTO_DEV_CAVIUM_ZIP=y.  Similarly the lzs
> algorithm (which does not currently have a generic implementation...)
> is incorrectly being registered as lzs-generic.
> 
> Fix the naming collision by adding a suffix "-cavium" to the
> cra_driver_name of the cavium/zip algorithms.
> 
> Fixes: 640035a2dc55 ("crypto: zip - Add ThunderX ZIP driver core")
> Cc: Mahipal Challa <mahipalreddy2006@gmail.com>
> Cc: Jan Glauber <jglauber@cavium.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/cavium/zip/zip_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
