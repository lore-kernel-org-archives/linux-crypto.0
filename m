Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D19C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 17:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE2CB22D00
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 17:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cAKB4VBi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgHERMo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Aug 2020 13:12:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22245 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728578AbgHERKg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Aug 2020 13:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596647428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X64Xsc1z0L/QmYHsVcy3UgDLuv0e4itd0R0ewdQxVFs=;
        b=cAKB4VBiWGsWoVdhTQEmJMGXUZaHU7yOmJB6Dj59PjBlD7drjLWv6SiBGULhdbsLekF8sL
        Raqv9iMpJF+B55JRm1YCe90L7e1vTvbXJqCQ47xzZ4DtIH7ZjNFuOUNFU0KB9Ih73ZPf+B
        NaiXW/IEaEXCg8qw2lk+J33HZBJivNI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-SL5FAO86PmSxjXitcJzeOQ-1; Wed, 05 Aug 2020 09:43:41 -0400
X-MC-Unique: SL5FAO86PmSxjXitcJzeOQ-1
Received: by mail-wr1-f71.google.com with SMTP id k11so13087189wrv.1
        for <linux-crypto@vger.kernel.org>; Wed, 05 Aug 2020 06:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X64Xsc1z0L/QmYHsVcy3UgDLuv0e4itd0R0ewdQxVFs=;
        b=VoNoRyKfGxNggU/pe2lrzSClt+GlbDdiD9l75uKxc6xcr27mIy+Ln2vueB4dejNEEJ
         SAPccVFTF6zIXGOLekB2b3CLVy//4aXcthmDvIXu5fQ6LLiuNhM8+mqk6B9qJZiPN/U5
         OoGzdURRWEQ/IG605XafLqWhmLcn7Q7Xo/b+YfaipkV5zn8DtqEkxLJ2cxuZLFQIdWV7
         sqz1il7j3itNjUM+MTxTJ4o9e4YF970act3uwKvXg/ABxeMY/vG5YsdsZ9tj5W+ELMzM
         iuFTogSo1MOCUyKFrxz4tkNnzReTZwOZVWtKQ7MafdSo8iF0ZGr0ji1A4yrPtbv23zpP
         iVhw==
X-Gm-Message-State: AOAM530RrUgYQDDwZvkgYTDCEJ9YxMLA/OjEWM6ixIkaOzLg3R2OwocQ
        oMQgnD463fDa1V7bxO/jXH047Bth+az7a4xzHB7SPsysQL5eMXLUG19YuWHpN5eo4t2hy7ubmKk
        CDAO1Z/nGZSr4zkVJ1WHeK4/Z
X-Received: by 2002:a1c:750f:: with SMTP id o15mr3524217wmc.182.1596635019133;
        Wed, 05 Aug 2020 06:43:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7HPK5kJbXhcBrmG1OonTHBBSwSvqaL+QYwUQafnUdvO/7RhWcIcON1LYaynur3bpXqN2OHA==
X-Received: by 2002:a1c:750f:: with SMTP id o15mr3524205wmc.182.1596635018970;
        Wed, 05 Aug 2020 06:43:38 -0700 (PDT)
Received: from redhat.com (bzq-79-180-0-181.red.bezeqint.net. [79.180.0.181])
        by smtp.gmail.com with ESMTPSA id x204sm13094657wmg.2.2020.08.05.06.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 06:43:38 -0700 (PDT)
Date:   Wed, 5 Aug 2020 09:43:36 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 08/38] virtio_crypto: correct tags for config space fields
Message-ID: <20200805134226.1106164-9-mst@redhat.com>
References: <20200805134226.1106164-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805134226.1106164-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since crypto is a modern-only device,
tag config space fields as having little endian-ness.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 include/uapi/linux/virtio_crypto.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/virtio_crypto.h b/include/uapi/linux/virtio_crypto.h
index 50cdc8aebfcf..a03932f10565 100644
--- a/include/uapi/linux/virtio_crypto.h
+++ b/include/uapi/linux/virtio_crypto.h
@@ -414,33 +414,33 @@ struct virtio_crypto_op_data_req {
 
 struct virtio_crypto_config {
 	/* See VIRTIO_CRYPTO_OP_* above */
-	__u32  status;
+	__le32  status;
 
 	/*
 	 * Maximum number of data queue
 	 */
-	__u32  max_dataqueues;
+	__le32  max_dataqueues;
 
 	/*
 	 * Specifies the services mask which the device support,
 	 * see VIRTIO_CRYPTO_SERVICE_* above
 	 */
-	__u32 crypto_services;
+	__le32 crypto_services;
 
 	/* Detailed algorithms mask */
-	__u32 cipher_algo_l;
-	__u32 cipher_algo_h;
-	__u32 hash_algo;
-	__u32 mac_algo_l;
-	__u32 mac_algo_h;
-	__u32 aead_algo;
+	__le32 cipher_algo_l;
+	__le32 cipher_algo_h;
+	__le32 hash_algo;
+	__le32 mac_algo_l;
+	__le32 mac_algo_h;
+	__le32 aead_algo;
 	/* Maximum length of cipher key */
-	__u32 max_cipher_key_len;
+	__le32 max_cipher_key_len;
 	/* Maximum length of authenticated key */
-	__u32 max_auth_key_len;
-	__u32 reserve;
+	__le32 max_auth_key_len;
+	__le32 reserve;
 	/* Maximum size of each crypto request's content */
-	__u64 max_size;
+	__le64 max_size;
 };
 
 struct virtio_crypto_inhdr {
-- 
MST

