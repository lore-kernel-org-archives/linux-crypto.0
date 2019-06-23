Return-Path: <SRS0=ZGow=UW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867AAC43613
	for <linux-crypto@archiver.kernel.org>; Sun, 23 Jun 2019 19:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40D0720656
	for <linux-crypto@archiver.kernel.org>; Sun, 23 Jun 2019 19:18:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KQ4j5ZKm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfFWTSr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 23 Jun 2019 15:18:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45132 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfFWTSr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Jun 2019 15:18:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id r1so6202137pfq.12
        for <linux-crypto@vger.kernel.org>; Sun, 23 Jun 2019 12:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=f9qXptgylHIAEQXQTAuBnq2RBq3dvQEaePaTzKc6t5o=;
        b=KQ4j5ZKmjcMZt3yJiy9ufK2L4dMLjg1mXx6wX7BtxENgmv9ZDdkCUV1I9bSu4M/8ik
         9mnLUHwkqwm3G/cVj/1SUXEbG0XWNrmOyC9l3b1H5cGyncPyiwkUg8tQEEhMFfjLuh82
         jy/is46Fjz/qQixn41IByRhOMz3Bmgb7W3xiLSejYdSh7MJ9y3BA67/GYoDe5eBU1slV
         n/Jr4PdFwyPoc7lqMcMQAyvwzCrhO52Qea7CXiW0tX1Sq4jnVyZ5bMVlHb9NAW8TiEVg
         gGwAukMIfG9ytZ1KpjlWijFFoU70ZTUa9rVf8APnhmyMsv0YX5SriHHYNsgpp+4xCAYp
         1NlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:user-agent
         :mime-version;
        bh=f9qXptgylHIAEQXQTAuBnq2RBq3dvQEaePaTzKc6t5o=;
        b=UOnMOaJS+SCB8TsdUtaBJOYKCeWNyaJGonZys1XsYX90tyjM55K7IchwFgvN8HAOLx
         bQb76ec+h89o/bypCt6zQha+P5YxtupN8t2ZYzv2xZ9gFD9JKJSTJFcHVZVwFxj46tW2
         88YmsviSZqDyJLij04TyJJc7KtaBslfBqlj+ezwjQm3vls7agrT3tL8Fzd7kUGyeQEhH
         5IDjAnv/RNdkNfkHA/1j3cdi4hGW4nrhGNzTMQDAgZVKEBeUBMaXIQKl0F24ptL4Zn5T
         a3gBAJJ0JKJpw+iD2rk1Gm3ty23Ub3Z9iPWSMshzSwp12HoENFDBARGvzBJfnfMxtCFN
         6qxg==
X-Gm-Message-State: APjAAAU58Tof/QFi3DHexGX5xzPfYNG9fn8Jr0ZOllZJZRephGMrc3zr
        SjgNBydNZA0weMHVECoLXbFxqA==
X-Google-Smtp-Source: APXvYqy6th0fKsgTaL4WunOqvuhGKOUKqQYaQw7eAE0Dqj3MtmkeNpMhyAK2c4KAlL1lXEfEpOBw9g==
X-Received: by 2002:a63:4419:: with SMTP id r25mr30247484pga.247.1561317525806;
        Sun, 23 Jun 2019 12:18:45 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id f88sm9808002pjg.5.2019.06.23.12.18.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 23 Jun 2019 12:18:44 -0700 (PDT)
Date:   Sun, 23 Jun 2019 12:18:44 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Cfir Cohen <cfir@google.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [patch] crypto: ccp - Free ccp if initialization fails
Message-ID: <alpine.DEB.2.21.1906231217040.15277@chino.kir.corp.google.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If ccp_dev_init() fails, kfree() the allocated ccp since it will otherwise
be leaked.

Fixes: 720419f01832 ("crypto: ccp - Introduce the AMD Secure Processor
device")

Reported-by: Cfir Cohen <cfir@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/crypto/ccp/ccp-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -609,6 +609,7 @@ int ccp_dev_init(struct sp_device *sp)
 
 e_err:
 	sp->ccp_data = NULL;
+	kfree(ccp);
 
 	dev_notice(dev, "ccp initialization failed\n");
 
