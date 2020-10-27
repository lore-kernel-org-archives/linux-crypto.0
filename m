Return-Path: <SRS0=pM9r=EC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD60C55178
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 19:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D0B821D41
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 19:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VSHjL42A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829236AbgJ0TBf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:01:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1829229AbgJ0TBf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Oct 2020 15:01:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603825294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=8RAi/H/kGv3MO4sBmaUvbuSCKIvqaL12soVzyl8Q1vc=;
        b=VSHjL42AfJKyUgXeZUUFEtgitBYa73SuXYVaCiJiRlR04V9GH9B1aAZjhdgD8KThCDI2HZ
        vxrfi5j3wu08DSHZzD2GOrA+NZ7DxnJC3+jHiNbWomVak3tGtfXv9QrRFO51f+Z/jQ1wg+
        RLLvT7V87xewzQnJT6cMfR3gx8SQzTw=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-oe-UNjA2NDGXLWDHJY7ntg-1; Tue, 27 Oct 2020 15:01:32 -0400
X-MC-Unique: oe-UNjA2NDGXLWDHJY7ntg-1
Received: by mail-oi1-f200.google.com with SMTP id j24so1110151oie.13
        for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2020 12:01:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8RAi/H/kGv3MO4sBmaUvbuSCKIvqaL12soVzyl8Q1vc=;
        b=Pjj6ptzJNwsid+KUD17xui0YbMlx30Osym3yqBVRCOnYz8mZASvZsZse6JZLu10Q03
         8ZE3NnBRpQr4tLvst+y4K3w7juKMobdXbkTmsj5HRh+M6Xdy7v9AW+0swX0fiOE1wBU4
         idrC6Qyj4qJuRhQGtfymuiA+pDyn3OU7gehLz4WBUDq6mbFo/mr6HCaG2R1Gf5OJ3XDN
         k8njqrpDyQpXkZ8f4GnHQL2vB9vkqFW+/Gozxj9h+QM8W2CUk5Tr6s9F9usWy7+h7t1Y
         6dMmH/Qhj9zE/bg0gcvJhbCSb7t+nup6QR5QM4ZFkb5R6wkpKD2Qc2vpyesbU5jigzOO
         /8kA==
X-Gm-Message-State: AOAM533UkfiPJKmQvN4x3uFKDPtadeIUHiBpRBDLrfvzySNe+WG1xEeP
        yjgTD4DE6Q2JM4DTguQ1lsBQ6XuRZzaizqwsW9YKBQO3vXEjtosk2XJaKBiof93h2gIVgY2SNQF
        LJFMqpNfrIVXhWr6CWHKWFyVk
X-Received: by 2002:aca:ed50:: with SMTP id l77mr2551957oih.42.1603825291482;
        Tue, 27 Oct 2020 12:01:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz31yjyQCJ9nTi7BotvDyi/x6qMqKMbD10mFhh2+4+odp3X/jP8VbXWjHo2AkVEg+PSOTOxaQ==
X-Received: by 2002:aca:ed50:: with SMTP id l77mr2551945oih.42.1603825291318;
        Tue, 27 Oct 2020 12:01:31 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id b21sm1384586ots.30.2020.10.27.12.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:01:30 -0700 (PDT)
From:   trix@redhat.com
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] crypto: cavium/nitrox: remove unneeded semicolon
Date:   Tue, 27 Oct 2020 12:01:25 -0700
Message-Id: <20201027190125.1587447-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A semicolon is not needed after a switch statement.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/crypto/cavium/nitrox/nitrox_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_mbx.c b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
index b51b0449b478..73993f9e2311 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_mbx.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
@@ -112,7 +112,7 @@ static void pf2vf_resp_handler(struct work_struct *work)
 	case MBX_MSG_TYPE_ACK:
 	case MBX_MSG_TYPE_NACK:
 		break;
-	};
+	}
 
 	kfree(pf2vf_resp);
 }
-- 
2.18.1

