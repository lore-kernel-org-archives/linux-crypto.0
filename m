Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 123ECC61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Feb 2023 22:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjBWWoG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Feb 2023 17:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjBWWnv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2023 17:43:51 -0500
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38C729E04;
        Thu, 23 Feb 2023 14:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
        s=the; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:
        Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date
        :Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
        References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
        List-Owner:List-Archive; bh=OayevMSfxq/5eX7TpSmF0QlP82H2HgfsyAnEkZU+mEc=; b=S
        4GmgWq5qCgQofTIzv22+JjJsXXugKSV9oHd74EDUz29uCCD+x27smX83w2au/Pak1aeR7oljs7Mqg
        4u4BeLksHOyzJz7omYcjK9tGt/NwmuowgzSTSYrqLTA7I6Gtj0YSw+OZClJgKs27ssmY0ulZf/qSQ
        L8GCkGLRmutnhsg/SJAORok3iX16wiLk9N7igXf7PSEsWr0MkjW+xg70R6LkcuUkLQXB+KIFOW/Ph
        lkJv6kaX/1Obz+55c6SFSIG7glMurpxpU33TMAp6i89QRbi2vfQgA9ttNGIxt0Y87dnLHlABckvEu
        JLANLMVg9c/9pO/kAmZi4QCof0KW0M8wQ==;
Received: from [2001:4d48:ad59:1403::17ca] (helo=sevai.o362.us)
        by the.earth.li with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <noodles@earth.li>)
        id 1pVJnR-0047pv-Ji; Thu, 23 Feb 2023 22:10:37 +0000
Date:   Thu, 23 Feb 2023 22:10:33 +0000
From:   Jonathan McDowell <noodles@earth.li>
To:     Antoine Tenart <atenart@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: inside-secure: Raise firmware load failure
 message to error
Message-ID: <Y/fkWe1aP4SGbZsC@sevai.o362.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

At the moment if there is no firmware available for the safexcel driver
it will fail to load with a cryptic:

crypto-safexcel f2800000.crypto: TRC init: 15360d,80a (48r,256h)
crypto-safexcel f2800000.crypto: HW init failed (-2)

Raise the logging level of the firmware load failure to err rather than
dbg so that it's obvious what the reason for the HW init failure is.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 6858753af6b3..5e10ab24be3b 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -474,7 +474,7 @@ static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 		goto retry_fw;
 	}
 
-	dev_dbg(priv->dev, "Firmware load failed.\n");
+	dev_err(priv->dev, "Firmware load failed.\n");
 
 	return ret;
 }
-- 
2.39.1

