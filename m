Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406CEC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 19:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CB0E2077D
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 19:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591298611;
	bh=c3DBGwcZ8sraH7L/mwTGntnwmsoxoCi4SD32HIHoV8g=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ic5GOipXqL0mhZB19GSzCyTwffg+0kd627RV7yu5QA5LafSJSnTE9Q9TobsepwWL6
	 bn1OBp3woUqmbU5iqmXU+qOZrimgVC+bg/48CISK0YaXzU0JBBw4S8AWsH0b8b1UKb
	 +Phs/m2l5bFvioUQ01TxCBqnz44EVmwA54bM6PFM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgFDTXa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 15:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgFDTXa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 15:23:30 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEC0C206E6;
        Thu,  4 Jun 2020 19:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591298609;
        bh=c3DBGwcZ8sraH7L/mwTGntnwmsoxoCi4SD32HIHoV8g=;
        h=From:To:Cc:Subject:Date:From;
        b=ZS5/ipRuPQKepxxaajeBbJ+iAXOrdNLbuzTtQcF8scMVbg3grMTy4xKkGrNR98srX
         B0Xc2lsRYc6DO12YAyR7844UIA/9UGRsmcCWYKa7mLt+L/fCryIDK6B0H8nbdxV8XY
         JRcCCKaAvBaj2/OfUHItE2kgZDo3oSB4UJuXv3MU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net] esp: select CRYPTO_SEQIV
Date:   Thu,  4 Jun 2020 12:23:22 -0700
Message-Id: <20200604192322.22142-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since CRYPTO_CTR no longer selects CRYPTO_SEQIV, it should be selected
by INET_ESP and INET6_ESP -- similar to CRYPTO_ECHAINIV.

Fixes: f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV")
Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/ipv4/Kconfig | 1 +
 net/ipv6/Kconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 23ba5045e3d3..d393e8132aa1 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -361,6 +361,7 @@ config INET_ESP
 	select CRYPTO_SHA1
 	select CRYPTO_DES
 	select CRYPTO_ECHAINIV
+	select CRYPTO_SEQIV
 	---help---
 	  Support for IPsec ESP.
 
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 4f03aece2980..f2f4563c8dbf 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -70,6 +70,7 @@ config INET6_ESP
 	select CRYPTO_SHA1
 	select CRYPTO_DES
 	select CRYPTO_ECHAINIV
+	select CRYPTO_SEQIV
 	---help---
 	  Support for IPsec ESP.
 
-- 
2.27.0.278.ge193c7cf3a9-goog

