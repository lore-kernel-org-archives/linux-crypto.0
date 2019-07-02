Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3C9C5B578
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 00:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48C4E21473
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 00:02:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ab0ZyOF0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGBAC1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jul 2019 20:02:27 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:33611 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfGBAC1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jul 2019 20:02:27 -0400
Received: by mail-qt1-f202.google.com with SMTP id y19so14926603qtm.0
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jul 2019 17:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=14MOM6ICngoLLgb1hrf/bM8O+6Uy5LcBnEPwLhZGisA=;
        b=ab0ZyOF0ZZkkQMOBm16TGGEeQFK/jjtvGf3wEx27RMnXQxrDBNdaJYXoBBeGr5LnO2
         yCn6V8eE+fGZvJcjh8XYGMVFt8fgkv2h31llQxIwD0pszH2nCXpm4pmE/yAxWGiqducr
         Um/F4GZ5f+4xXzJnSDUyhYRr75CeDapfZf+W+E6QIIIEcvN/2bmVLsbnDVtTg92I11bF
         Xvi2CyLVmX4o/fXUISIVyJFG0yhus80Kd98bDgXNFc08pLguDIzHn40en5csghrqJdP/
         CoVBUT6A1KZCzgFSRU9yuIebcKq6qj/wydhx0jBqZEIurcaCWB5wcib9YZTFizzNAgmw
         Kt3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=14MOM6ICngoLLgb1hrf/bM8O+6Uy5LcBnEPwLhZGisA=;
        b=bZUJ+DEie+178EtgVfCYGv6+/pF42JmqZGl2BGFGd6uGC4eIol9igXclQqlpo1rOsp
         b23dA+x9eBl6MzLYPoMz7Aq7re5ZKQ0PBuD+++c6JeDiT+Gm+ZN9EU3Op2RuyZpSVlDG
         TSK4CNDVu6bPNPKQj1uGa6iFdb0UjmrEFuOn5R7scrFlHRx7wGlDpCgUUcAvs3g8SYj+
         PAH0ZBfyedjvfMfIqK80O3aHDoZt3puFkJ26gVBQIdC1BiRPS+9awU0GLozIxM+rvZ23
         s4eOCzUHvfZyN0vSFa0TYcCTQkAvxMcdtN7CwHZLTHHndNJS2i/OdPt6rAj65SwPI/89
         D4Zg==
X-Gm-Message-State: APjAAAUv+VeKQY3ChKJqeKiyJ0XuOtnkFuFnTVuXOFBc2NnVzWVaBCKJ
        3oSI44BVn0Ij7Tm4JYFn8PULA7Yi
X-Google-Smtp-Source: APXvYqxrjtJzzGyzen9dN3F04N0Z8Svgc4wGjY+W5ZyOubaozgAQD8lN8zC3uAhG2jkMQE/hKlKPNVyS
X-Received: by 2002:aed:38c2:: with SMTP id k60mr21843273qte.83.1562025746390;
 Mon, 01 Jul 2019 17:02:26 -0700 (PDT)
Date:   Mon,  1 Jul 2019 17:01:32 -0700
Message-Id: <20190702000132.88836-1-cfir@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH] crypto: ccp/gcm - use const time tag comparison.
From:   Cfir Cohen <cfir@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Cfir Cohen <cfir@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Avoid leaking GCM tag through timing side channel.

Signed-off-by: Cfir Cohen <cfir@google.com>
---
 drivers/crypto/ccp/ccp-ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index db8de89d990f..633670220f6c 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -840,7 +840,8 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
 		if (ret)
 			goto e_tag;
 
-		ret = memcmp(tag.address, final_wa.address, AES_BLOCK_SIZE);
+		ret = crypto_memneq(tag.address, final_wa.address,
+				    AES_BLOCK_SIZE) ? -EBADMSG : 0;
 		ccp_dm_free(&tag);
 	}
 
-- 
2.22.0.410.gd8fdbe21b5-goog

