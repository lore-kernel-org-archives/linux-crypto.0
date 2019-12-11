Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01D0C2D0C6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 763B2205C9
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfLKJpd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 04:45:33 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:55356 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbfLKJpc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 04:45:32 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ieyYe-0000Uq-DL; Wed, 11 Dec 2019 17:45:24 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ieyYe-0002rB-5R; Wed, 11 Dec 2019 17:45:24 +0800
Date:   Wed, 11 Dec 2019 17:45:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] padata: update documentation
Message-ID: <20191211094524.jd5hchz2pd4zndbh@gondor.apana.org.au>
References: <20191203193114.238912-1-daniel.m.jordan@oracle.com>
 <20191203193114.238912-6-daniel.m.jordan@oracle.com>
 <20191210164441.gikjbbusik4fan5y@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210164441.gikjbbusik4fan5y@ca-dmjordan1.us.oracle.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 10, 2019 at 11:44:41AM -0500, Daniel Jordan wrote:
> Small fixup for this patch.
> 
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9d3a5c54a41d..eefd665d41a1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12253,7 +12253,7 @@ L:	linux-crypto@vger.kernel.org
>  S:	Maintained
>  F:	kernel/padata.c
>  F:	include/linux/padata.h
> -F:	Documentation/padata.txt
> +F:	Documentation/core-api/padata.rst
>  
>  PAGE POOL
>  M:	Jesper Dangaard Brouer <hawk@kernel.org>

Please resend this as an incremental patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
