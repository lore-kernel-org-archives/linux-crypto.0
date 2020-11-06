Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C13C2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 07:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F8CA208FE
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 07:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgKFHDQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 02:03:16 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:35094 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgKFHDQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 02:03:16 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kavlf-000843-Re; Fri, 06 Nov 2020 18:02:41 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2020 18:02:39 +1100
Date:   Fri, 6 Nov 2020 18:02:39 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nigel Christian <nigel.l.christian@gmail.com>
Cc:     dan.carpenter@oracle.com, martin@kaiser.cx, mpm@selenic.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com,
        linux-crypto@vger.kernel.org, prasannatsmkumar@gmail.com,
        m.felsch@pengutronix.de, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH resend] hwrng: imx-rngc - irq already prints an error
Message-ID: <20201106070239.GH11620@gondor.apana.org.au>
References: <20201029005217.GA28008@fedora-project>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029005217.GA28008@fedora-project>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 28, 2020 at 08:52:17PM -0400, Nigel Christian wrote:
> Clean up the check for irq. dev_err() is superfluous as
> platform_get_irq() already prints an error. Check for zero
> would indicate a bug. Remove curly braces to conform to
> styling requirements.
> Signed-off-by: Nigel Christian <nigel.l.christian@gmail.com>
> ---
>  drivers/char/hw_random/imx-rngc.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
