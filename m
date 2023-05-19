Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F7A9C77B7A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 08:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjESIuC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 04:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjESIt5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 04:49:57 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0A4122;
        Fri, 19 May 2023 01:49:55 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pzvnv-00AnvF-Cg; Fri, 19 May 2023 16:49:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 May 2023 16:49:39 +0800
Date:   Fri, 19 May 2023 16:49:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jayesh Choudhary <j-choudhary@ti.com>
Cc:     davem@davemloft.net, kristo@kernel.org, kamlesh@ti.com,
        u-kumar1@ti.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sa2ul: change unsafe data size limit to 255 bytes
Message-ID: <ZGc4IxL5YGdTNxTW@gondor.apana.org.au>
References: <20230512104044.163279-1-j-choudhary@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512104044.163279-1-j-choudhary@ti.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 12, 2023 at 04:10:44PM +0530, Jayesh Choudhary wrote:
> From: Tero Kristo <t-kristo@ti.com>
> 
> 256 bytes is quite often used in performance benchmarks and this size
> appears to be also working just fine, so mark it as safe so that we do
> not fallback to software implementation for this packet size. Otherwise
> there is a strange bump up in crypto performance at 256 byte packet size.
> 
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
> ---
>  drivers/crypto/sa2ul.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
