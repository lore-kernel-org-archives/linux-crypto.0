Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C187C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 06:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346481AbiA1G26 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:28:58 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60626 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237265AbiA1G2z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 01:28:55 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nDKkc-0001It-K9; Fri, 28 Jan 2022 17:28:51 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jan 2022 17:28:50 +1100
Date:   Fri, 28 Jan 2022 17:28:50 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tomas Paukrt <tomaspaukrt@email.cz>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: mxs-dcp - Fix scatterlist processing
Message-ID: <YfONIv8D7qs/leId@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <T0R.ZXsl.2soFymqM66b.1Xx3df@seznam.cz>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tomas Paukrt <tomaspaukrt@email.cz> wrote:
> This patch fixes a bug in scatterlist processing that may cause incorrect AES block encryption/decryption.
> 
> Fixes: 2e6d793e1bf0 ("crypto: mxs-dcp - Use sg_mapping_iter to copy data")
> Signed-off-by: Tomas Paukrt <tomaspaukrt@email.cz>
> ---
> drivers/crypto/mxs-dcp.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
