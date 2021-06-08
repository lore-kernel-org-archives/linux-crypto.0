Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B35C47082
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Jun 2021 21:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04AE16139A
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Jun 2021 21:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbhFHV0k (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:26:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29479 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234596AbhFHV0V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Jun 2021 17:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623187467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sgq7YpZfI377cjTuKzZzdMcYM8vZyb+R30zx+84A9yI=;
        b=PxUKAZwzQKYQDMnSi9/40KU/uhJnyoDTTtjGuaEs8Jj4W7IaERiBuoLrrQvo8j6xJBRJhr
        A+Gq9M2y7Dzkgq/FiOUnac9paHy0EUwQN+M9n29kI/ox7OLsyw5l8CaiRLUq07oAK0hs1X
        i3nc1Q2jat7xwmYcsRwQy5ocVl4lQWQ=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-4ikVy3JVMNKu4YU0FxWrSg-1; Tue, 08 Jun 2021 17:24:26 -0400
X-MC-Unique: 4ikVy3JVMNKu4YU0FxWrSg-1
Received: by mail-oo1-f70.google.com with SMTP id n62-20020a4a53410000b0290246a4799849so13467285oob.8
        for <linux-crypto@vger.kernel.org>; Tue, 08 Jun 2021 14:24:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sgq7YpZfI377cjTuKzZzdMcYM8vZyb+R30zx+84A9yI=;
        b=Kyusx+eYSjwRRLTbjsuzTmb6/Glh6XhZDdv8fjZ3SRTpeGL8nYI1hoYFIWd5X8rzau
         dActz+nmLEhMzjNP4qZcpYWOBDirjxyHzNmBwRWHvdu6gHvmwF37Vy0sKFwwXsLaqmrj
         3XmPUvYVYMiym1wHHgkKHxUXqqq0dTd6L4F9NgHI8xNwUPt5fTGUgGytNWpEibqsOuhE
         DhKMoXvkiC1WN19mQVoNDOvO62TqrbioaL3LkUD/pPYZfcuAT4edN/3245bOndbgzQTe
         XJmMCy/zuTEIFzegta2Uv4/emCehKhNafcpVYnyUh0KqWfrhWVwJTo5WebSjz3U5p61z
         sEQA==
X-Gm-Message-State: AOAM532sNPeI88sNA5ze1V+WQK7xKuX8H4oQWMl+iP2Eej/5O3XfWQe2
        59CAVmLewA0tgxwJ2koXt0HYvOW+XHAOoyz0wXP8XPv9cr3jpSfcyYop5MTb37O9cDnt68fL48u
        khg7F8Kk6nJ3pRLX2MGArTSIe
X-Received: by 2002:aca:33d4:: with SMTP id z203mr4176771oiz.51.1623187465854;
        Tue, 08 Jun 2021 14:24:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysr+C3bZgIQEZy/8wCr9Q5uLj3VqD8M6xSNa0dsASWBdlkV/63bU+lwSL+xyqD9OEYmwRjzg==
X-Received: by 2002:aca:33d4:: with SMTP id z203mr4176741oiz.51.1623187465720;
        Tue, 08 Jun 2021 14:24:25 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id x199sm1954310oif.5.2021.06.08.14.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 14:24:25 -0700 (PDT)
From:   trix@redhat.com
To:     mdf@kernel.org, robh+dt@kernel.org, hao.wu@intel.com,
        corbet@lwn.net, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        gregkh@linuxfoundation.org, Sven.Auhagen@voleatech.de,
        grandmaster@al2klimov.de
Cc:     linux-fpga@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-staging@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH 10/11] fpga: stratix10-soc: change FPGA indirect article to an
Date:   Tue,  8 Jun 2021 14:23:49 -0700
Message-Id: <20210608212350.3029742-12-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210608212350.3029742-1-trix@redhat.com>
References: <20210608212350.3029742-1-trix@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Change use of 'a fpga' to 'an fpga'

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/fpga/stratix10-soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/stratix10-soc.c b/drivers/fpga/stratix10-soc.c
index 657a70c5fc996..2aeb53f8e9d0f 100644
--- a/drivers/fpga/stratix10-soc.c
+++ b/drivers/fpga/stratix10-soc.c
@@ -271,7 +271,7 @@ static int s10_send_buf(struct fpga_manager *mgr, const char *buf, size_t count)
 }
 
 /*
- * Send a FPGA image to privileged layers to write to the FPGA.  When done
+ * Send an FPGA image to privileged layers to write to the FPGA.  When done
  * sending, free all service layer buffers we allocated in write_init.
  */
 static int s10_ops_write(struct fpga_manager *mgr, const char *buf,
-- 
2.26.3

