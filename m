Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0051C31E5C
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 21:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C399620861
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 21:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="cHaP85JJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbfFQVPG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 17:15:06 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:6514 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfFQVPF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 17:15:05 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45SP9z2b63z9v32h;
        Mon, 17 Jun 2019 23:15:03 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=cHaP85JJ; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id jJiF0moyPnzY; Mon, 17 Jun 2019 23:15:03 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45SP9z1XXdz9v32f;
        Mon, 17 Jun 2019 23:15:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1560806103; bh=h+ZeQk8T0DIMrL4PtUsQo0eqmuBm6tn3duZFRsoT3nA=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=cHaP85JJUAYa0hVFkS5OGdG0kjU6cP9iBcFi3rlBF0zfEVXoOkw9C+UIDR3rnwMyv
         ZY23E67E0/6ZhAweHqiohmXnhjDyLkgswY1jPcD6OCXOiRLxv1d0cBoSxVDJO2swaA
         AFUp+2aFXcDisz7uCsm9CYNhvBV8AZHOribWoj1o=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 6C21C8B84B;
        Mon, 17 Jun 2019 23:15:03 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id JwolBjh4sAp6; Mon, 17 Jun 2019 23:15:03 +0200 (CEST)
Received: from po16838vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3B9028B7FF;
        Mon, 17 Jun 2019 23:15:03 +0200 (CEST)
Received: by localhost.localdomain (Postfix, from userid 0)
        id EA5CC682B3; Mon, 17 Jun 2019 21:15:02 +0000 (UTC)
Message-Id: <f28c6b0e2f9510f42ca934f19c4315084e668c21.1560805614.git.christophe.leroy@c-s.fr>
In-Reply-To: <cover.1560805614.git.christophe.leroy@c-s.fr>
References: <cover.1560805614.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v4 1/4] lib/scatterlist: Fix mapping iterator when sg->offset
 is greater than PAGE_SIZE
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Mon, 17 Jun 2019 21:15:02 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

All mapping iterator logic is based on the assumption that sg->offset
is always lower than PAGE_SIZE.

But there are situations where sg->offset is such that the SG item
is on the second page. In that case sg_copy_to_buffer() fails
properly copying the data into the buffer. One of the reason is
that the data will be outside the kmapped area used to access that
data.

This patch fixes the issue by adjusting the mapping iterator
offset and pgoffset fields such that offset is always lower than
PAGE_SIZE.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 4225fc8555a9 ("lib/scatterlist: use page iterator in the mapping iterator")
Cc: stable@vger.kernel.org
---
 lib/scatterlist.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 739dc9fe2c55..39f00659898f 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -678,7 +678,7 @@ static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
 {
 	if (!miter->__remaining) {
 		struct scatterlist *sg;
-		unsigned long pgoffset;
+		unsigned long pgoffset, offset;
 
 		if (!__sg_page_iter_next(&miter->piter))
 			return false;
@@ -686,7 +686,12 @@ static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
 		sg = miter->piter.sg;
 		pgoffset = miter->piter.sg_pgoffset;
 
-		miter->__offset = pgoffset ? 0 : sg->offset;
+		offset = pgoffset ? 0 : sg->offset;
+		while (offset >= PAGE_SIZE) {
+			miter->piter.sg_pgoffset = ++pgoffset;
+			offset -= PAGE_SIZE;
+		}
+		miter->__offset = offset;
 		miter->__remaining = sg->offset + sg->length -
 				(pgoffset << PAGE_SHIFT) - miter->__offset;
 		miter->__remaining = min_t(unsigned long, miter->__remaining,
-- 
2.13.3

