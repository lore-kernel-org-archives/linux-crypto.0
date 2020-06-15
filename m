Return-Path: <SRS0=gCBe=74=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319BAC433E3
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 22:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04AD020739
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 22:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592259248;
	bh=/+9oMm841PV2DS5+tXwvS9/SSKKKymrkweEl/gCWAiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lyHNkB0fEbq2tZNaatNE0C6mfTgOWPSrxHt2Ds+AgrFVwHjNvjoSfX+Hae2Ceakpo
	 OXKlbY0D6AdRNvnPo5ptaz+7MbVxj7VQZe4cr6WCugRNPahxcN+7aVgMCE+eRJ+216
	 7xK0HJCKqI+ii9padwprU2e7Eo3EcKOyTkIlF9fA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgFOWOG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jun 2020 18:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgFOWOC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jun 2020 18:14:02 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D53912078E;
        Mon, 15 Jun 2020 22:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592259242;
        bh=/+9oMm841PV2DS5+tXwvS9/SSKKKymrkweEl/gCWAiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2ftYjM53KgV8apDXYNHPm1wPJE0jdf/PA5zQpqM/DRw4C8obH+vF857cOwcHEMLJ
         Q09YY7KV86SbGG3wFhmeu2oyqFcSZOJLRcm+cSyxHFWXU8+fC8cIApJTr1Ecrrsmpi
         L5jYCBV/sdqwvm5qT82y4XD1AP0ADhfyuFE4ULjY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v5 2/3] esp: select CRYPTO_SEQIV
Date:   Mon, 15 Jun 2020 15:13:17 -0700
Message-Id: <20200615221318.149558-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
In-Reply-To: <20200615221318.149558-1-ebiggers@kernel.org>
References: <20200615221318.149558-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Commit f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV") made
CRYPTO_CTR stop selecting CRYPTO_SEQIV.  This breaks IPsec for most
users since GCM and several other encryption algorithms require "seqiv"
-- and RFC 8221 lists AES-GCM as "MUST" be implemented.

Just make XFRM_ESP select CRYPTO_SEQIV.

Fixes: f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV")
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/xfrm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index d140707faddc..bfb45ee56e5f 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -86,6 +86,7 @@ config XFRM_ESP
 	select CRYPTO_SHA1
 	select CRYPTO_DES
 	select CRYPTO_ECHAINIV
+	select CRYPTO_SEQIV
 
 config XFRM_IPCOMP
 	tristate
-- 
2.27.0.290.gba653c62da-goog

