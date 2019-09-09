Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AD8C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 07:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF76B21479
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 07:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388315AbfIIHqt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 03:46:49 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:32860 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388282AbfIIHqt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 03:46:49 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i7ENi-0007V3-Pf; Mon, 09 Sep 2019 17:46:39 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 09 Sep 2019 17:46:37 +1000
Date:   Mon, 9 Sep 2019 17:46:37 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: crypto: caam - Cast to long first before pointer conversion
Message-ID: <20190909074636.GA21024@gondor.apana.org.au>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-5-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190904023515.7107-5-andrew.smirnov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 03, 2019 at 07:35:07PM -0700, Andrey Smirnov wrote:
> With IRQ requesting being managed by devres we need to make sure that
> we dispose of IRQ mapping after and not before it is free'd (otherwise
> we'll end up with a warning from the kernel). To achieve that simply
> convert IRQ mapping to rely on devres as well.
> 
> Fixes: f314f12db65c ("crypto: caam - convert caam_jr_init() to use devres")
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Horia Geantă <horia.geanta@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/caam/jr.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)

I needed to apply this on top of it to shut up the compiler:

---8<---
While storing an int in a pointer is safe the compiler is not
happy about it.  So we need some extra casting in order to make
this warning free.

Fixes: 1d3f75bce123 ("crypto: caam - dispose of IRQ mapping only...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 8a30bbd7f2aa..c5acd9e24e14 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -500,7 +500,7 @@ static int caam_jr_init(struct device *dev)
 
 static void caam_jr_irq_dispose_mapping(void *data)
 {
-	irq_dispose_mapping((int)data);
+	irq_dispose_mapping((unsigned long)data);
 }
 
 /*
@@ -558,7 +558,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 	}
 
 	error = devm_add_action_or_reset(jrdev, caam_jr_irq_dispose_mapping,
-					 (void *)jrpriv->irq);
+					 (void *)(unsigned long)jrpriv->irq);
 	if (error)
 		return error;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
