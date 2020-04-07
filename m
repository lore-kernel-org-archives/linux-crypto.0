Return-Path: <SRS0=R0fc=5X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B4BC2BA80
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 01:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57BDC2072A
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 01:08:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PS7UbfI6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgDGBI4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Apr 2020 21:08:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37895 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726370AbgDGBHo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Apr 2020 21:07:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586221663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jXqTQsUO9YVhjrcDRdxdoA1nJXOlF582i9eQgnD+YFc=;
        b=PS7UbfI6NuXSRbcVEAgVVlIlFxchvVKCqXzRaUCUjE6cuE+f6zODQ251INHSTlYqFwWmiU
        GZaW+o31pRuy6JMfYd94q9L9wd88WYQlbcWspmfXlCrezeq1bWygU/DDypVy0OsYtmyvI4
        4UdsGm9Mc269oHbR/Zdrlo8vZ4e602M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-8dYr2KXLPtmUcyt5kGmxVg-1; Mon, 06 Apr 2020 21:07:41 -0400
X-MC-Unique: 8dYr2KXLPtmUcyt5kGmxVg-1
Received: by mail-wr1-f71.google.com with SMTP id u16so849736wrp.14
        for <linux-crypto@vger.kernel.org>; Mon, 06 Apr 2020 18:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jXqTQsUO9YVhjrcDRdxdoA1nJXOlF582i9eQgnD+YFc=;
        b=P7m6mL33CKgPhJG6kraA3CS8vXVmlQOixWkzEBZIuCSzygarHOr2DJfEb/VB0mpVX3
         KOIBURXU7yJ0wgI/NaCwNpMySz6diR/HEy4JSmi4c9vXWc6iUlgTnHlAFzyotVDXlDH0
         U6yMvaCucuwEu2djBLi3dGyuTjjXrE3QcAgMY8qsBrYm8s+Gj818VQQkOydUBi8dkQL7
         tKjkq3icxpKhejaPkU0UKKQ+87cvPTjJXHRln3dzn/JNCK0+WfcQHrKGkOI6a7lDnXMK
         47ub3WvHX0LaCNeYQvp6xpf6d9yDQBOQxF9Q045jT88QMNMuxZAet3ZV8Lrmgro8lCpI
         gDhw==
X-Gm-Message-State: AGi0Pub4cYMRHu9FkZ03b+A+SuspLeRQBbeLMBS3l910cdszI6Z7S05E
        ke/9Irof1xG2clBgZ6mR/zDl2c47tSF+uAPzKStQs0FQc8CdRS4kA57/GpYo8HuPYZDEKHfhpqw
        6kc0sfp1BRxWEVX4lQw9OEVnl
X-Received: by 2002:a5d:6a47:: with SMTP id t7mr1956339wrw.131.1586221660767;
        Mon, 06 Apr 2020 18:07:40 -0700 (PDT)
X-Google-Smtp-Source: APiQypLi++G08KSxRhS85KgN5Q3h/2wGkqBja4GHXhB9IEHoUEJizYJP56tBhmaJBFrG8QKxZifQnw==
X-Received: by 2002:a5d:6a47:: with SMTP id t7mr1956327wrw.131.1586221660622;
        Mon, 06 Apr 2020 18:07:40 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id k184sm103051wma.13.2020.04.06.18.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 18:07:40 -0700 (PDT)
Date:   Mon, 6 Apr 2020 21:07:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v7 06/19] virtio-rng: pull in slab.h
Message-ID: <20200407010700.446571-7-mst@redhat.com>
References: <20200407010700.446571-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407010700.446571-1-mst@redhat.com>
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

