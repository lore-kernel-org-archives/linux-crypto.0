Return-Path: <SRS0=R0fc=5X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D25FC2BA1A
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 01:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D8EE20692
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 01:17:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AAFGIbAd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgDGBQp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Apr 2020 21:16:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25441 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726619AbgDGBQp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Apr 2020 21:16:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586222204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jXqTQsUO9YVhjrcDRdxdoA1nJXOlF582i9eQgnD+YFc=;
        b=AAFGIbAdyFtc5NBz1yNS8x42i+q+xltbp52RyK5diP9qP5Tvp2EIevJ4F6dLl34mmvOtnk
        C79/UNG1UOoK/Rt+bYBWYiy5XSVQuB/kVFmUzBKdtCT4R8//PZZfpHmkzocgHvqxYBAhKE
        3QqDwS1YXfT0J9KYhCoUViETdIB3R18=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-N80QrERYPhKGxfZzZ2uZQQ-1; Mon, 06 Apr 2020 21:16:43 -0400
X-MC-Unique: N80QrERYPhKGxfZzZ2uZQQ-1
Received: by mail-wr1-f71.google.com with SMTP id y1so866960wrp.5
        for <linux-crypto@vger.kernel.org>; Mon, 06 Apr 2020 18:16:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jXqTQsUO9YVhjrcDRdxdoA1nJXOlF582i9eQgnD+YFc=;
        b=Ef9KOfKCsgz9kAUau1u60hhCjYI+eL06u82ThizlQmjMGQphA2uKdl5XK0ybx1ToCB
         oMNQ90fWLkCG+pH1VKvMcS/aJ3Ow9M5gIPvwUkCyj5+R+g3sffO6YBQwl11XIK8XaaGh
         ddetNhEGf5Aa6m46C9DI+xV0dgK4mL24/T03Dam3DqgvikGCjs1Ai2CwpdtxxY0LRTfq
         YjvsbDp7z9xCIz6rNRROVwLamDxBtRU2yY0DzdoqItKlQbjgGZQqkzkoDImnYmIBqc2B
         R/N65QQeUtZPomVqVy4eUo3fUPjjUfwE3SVCeAj+dNVaLHIMoYCGGI3pQsaQN8aLvwVJ
         qVhg==
X-Gm-Message-State: AGi0Pua5KoPsnKjClkW95tzB1GMdP+Dpo84/SS6XATT6YWJxLSUv1ZVg
        45Fo7KsoqozVLwR13NbfVrr+OiHcb+3+5PUHz4hODx6AjBQXXtU/fOf47sU51EaLfSPtxV8LoFL
        vYuSLEfsT4iOemirK0lJFhydZ
X-Received: by 2002:a5d:474b:: with SMTP id o11mr1961489wrs.4.1586222201913;
        Mon, 06 Apr 2020 18:16:41 -0700 (PDT)
X-Google-Smtp-Source: APiQypJprcVQXQkNsVI+/t4E2rAPWsDxMCz/OELvSOO2s+GUzL8V1QEbG4QZrFErn5KfoQsv+MjzXw==
X-Received: by 2002:a5d:474b:: with SMTP id o11mr1961474wrs.4.1586222201731;
        Mon, 06 Apr 2020 18:16:41 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id j10sm11751534wru.85.2020.04.06.18.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 18:16:41 -0700 (PDT)
Date:   Mon, 6 Apr 2020 21:16:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v8 06/19] virtio-rng: pull in slab.h
Message-ID: <20200407011612.478226-7-mst@redhat.com>
References: <20200407011612.478226-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407011612.478226-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In preparation to virtio header changes, include slab.h directly as
this module is using it.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 718d8c087650..79a6e47b5fbc 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -11,6 +11,7 @@
 #include <linux/virtio.h>
 #include <linux/virtio_rng.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 static DEFINE_IDA(rng_index_ida);
 
-- 
MST

