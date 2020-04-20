Return-Path: <SRS0=BVES=6E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A5EC3815B
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 08:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 958F72078E
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 08:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgDTI2x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Apr 2020 04:28:53 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42642 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgDTI2x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Apr 2020 04:28:53 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jQRmu-0001q2-3o; Mon, 20 Apr 2020 18:28:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Apr 2020 18:28:19 +1000
Date:   Mon, 20 Apr 2020 18:28:19 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: hwrng: cctrng - Remove unnecessary FIPS ifdef
Message-ID: <20200420082819.GA23022@gondor.apana.org.au>
References: <1587155926-32663-1-git-send-email-hadar.gat@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587155926-32663-1-git-send-email-hadar.gat@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch removes the unnecessary FIPS ifdef in cctrng.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index e82716c12c3a..49fb65a221f3 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -331,13 +331,11 @@ void cc_trng_compwork_handler(struct work_struct *w)
 	ehr_valid = CC_REG_FLD_GET(RNG_ISR, EHR_VALID, isr);
 	dev_dbg(dev, "Got RNG_ISR=0x%08X (EHR_VALID=%u)\n", isr, ehr_valid);
 
-#ifdef CONFIG_CRYPTO_FIPS
-	if (CC_REG_FLD_GET(RNG_ISR, CRNGT_ERR, isr) && fips_enabled) {
+	if (fips_enabled && CC_REG_FLD_GET(RNG_ISR, CRNGT_ERR, isr)) {
 		fips_fail_notify();
 		/* FIPS error is fatal */
 		panic("Got HW CRNGT error while fips is enabled!\n");
 	}
-#endif
 
 	/* Clear all pending RNG interrupts */
 	cc_iowrite(drvdata, CC_RNG_ICR_REG_OFFSET, isr);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
