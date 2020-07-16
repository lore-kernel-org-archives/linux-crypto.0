Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33854C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 11:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 097F220739
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 11:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgGPLzZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 07:55:25 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40130 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgGPLzZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 07:55:25 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jw2TI-0008Mw-8v; Thu, 16 Jul 2020 21:54:41 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Jul 2020 21:54:40 +1000
Date:   Thu, 16 Jul 2020 21:54:40 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     mpm@selenic.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        alexander.sverdlin@nokia.com, dinghao.liu@zju.edu.cn,
        yuehaibing@huawei.com, ben.dooks@codethink.co.uk,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HARDWARE RANDOM NUMBER GENERATOR CORE: Replace HTTP
 links with HTTPS ones
Message-ID: <20200716115440.GE31166@gondor.apana.org.au>
References: <20200709103539.24319-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709103539.24319-1-grandmaster@al2klimov.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 09, 2020 at 12:35:39PM +0200, Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>  Continuing my work started at 93431e0607e5.
>  See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
>  (Actually letting a shell for loop submit all this stuff for me.)
> 
>  If there are any URLs to be removed completely or at least not HTTPSified:
>  Just clearly say so and I'll *undo my change*.
>  See also: https://lkml.org/lkml/2020/6/27/64
> 
>  If there are any valid, but yet not changed URLs:
>  See: https://lkml.org/lkml/2020/6/26/837
> 
>  If you apply the patch, please let me know.
> 
> 
>  drivers/char/hw_random/ks-sa-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
