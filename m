Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589BFC433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Dec 2021 05:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhLCFKd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Dec 2021 00:10:33 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57378 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhLCFKd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Dec 2021 00:10:33 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1mt0mm-00028b-BN; Fri, 03 Dec 2021 16:07:05 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Dec 2021 16:07:04 +1100
Date:   Fri, 3 Dec 2021 16:07:04 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sa2ul - Use bitfield helpers
Message-ID: <20211203050704.GB20393@gondor.apana.org.au>
References: <a1445d3abb45cfc95cb1b03180fd53caf122035b.1637593297.git.geert+renesas@glider.be>
 <ca89d204ef2e40193479db2742eadf0d9cf3c0ff.1637593297.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca89d204ef2e40193479db2742eadf0d9cf3c0ff.1637593297.git.geert+renesas@glider.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 22, 2021 at 04:54:02PM +0100, Geert Uytterhoeven wrote:
> Use the FIELD_PREP() helper, instead of open-coding the same operation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Compile-tested only.
> 
> See "[PATCH 00/17] Non-const bitfield helper conversions"
> (https://lore.kernel.org/r/cover.1637592133.git.geert+renesas@glider.be)
> for background and more conversions.
> ---
>  drivers/crypto/sa2ul.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
