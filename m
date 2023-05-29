Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA24C77B7E
	for <linux-crypto@archiver.kernel.org>; Mon, 29 May 2023 06:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjE2Gqg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 May 2023 02:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbjE2Gqb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2023 02:46:31 -0400
X-Greylist: delayed 487 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 28 May 2023 23:46:26 PDT
Received: from mail.tkos.co.il (mail.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870B5B1
        for <linux-crypto@vger.kernel.org>; Sun, 28 May 2023 23:46:26 -0700 (PDT)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id 3DC8E440861;
        Mon, 29 May 2023 09:38:05 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1685342285;
        bh=2JXq3X36Px6GD3JHLl0BmiIEPlM7msoX9EVhInTyiII=;
        h=From:To:Cc:Subject:Date:From;
        b=sEVv4p9emOM9muyqNymSmfCw4UGbTyFIIJikbnOgVVe9jK4gCFOmuJusAmNO2RMzQ
         mJWfJI7QOiRqNhOUgr0As5FIgKT5mEeiJeoe0zza5c5O5MpZWS67Z3sRuu/HXL5IlP
         XaTgIicNQu9Y2NE71sK4yCEiohIJcC3KW74dy0AadDvQcJ/+kMe5ElkZHHOfgxfha3
         vf+nsC+Q9XZ32zciSo/VkGLvSwIAoj0qCkhxsyyIeEL7zORos1JKgcUAueYbNxjSyU
         djNe+FMzSVp1ehnU6NHhBjsNfw2ucbUlobUXq2rfkGIPU7qLLAFJwglV4z62Kdx0dJ
         qebZlBE4JVo+Q==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-crypto@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] docs: crypto: async-tx-api: fix typo in struct name
Date:   Mon, 29 May 2023 09:38:11 +0300
Message-Id: <2ef9dfaa33c1eff019e6fe43fe738700c2230b3d.1685342291.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add missing underscore.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 Documentation/crypto/async-tx-api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/crypto/async-tx-api.rst b/Documentation/crypto/async-tx-api.rst
index bfc773991bdc..27c146b54d71 100644
--- a/Documentation/crypto/async-tx-api.rst
+++ b/Documentation/crypto/async-tx-api.rst
@@ -66,7 +66,7 @@ features surfaced as a result:
 ::
 
   struct dma_async_tx_descriptor *
-  async_<operation>(<op specific parameters>, struct async_submit ctl *submit)
+  async_<operation>(<op specific parameters>, struct async_submit_ctl *submit)
 
 3.2 Supported operations
 ------------------------
-- 
2.39.2

