Return-Path: <SRS0=sEgb=BN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE06C433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 20:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55F5122C9F
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 20:59:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S11nOOoP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgHCU7R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Aug 2020 16:59:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33766 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728557AbgHCU7Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Aug 2020 16:59:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596488355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pbr1N8DSevefC/5XR/FPYq4gph7eMtDNIH83d+s2qxE=;
        b=S11nOOoPCQUk4UpUd7qlBd9MgD98aIJziBk8D8FMaCiJYiz1k8499nTLp1NyrGKKz1rgz8
        Xio+L1apAkuyOa+F7oPmnFp3ESqJjq2HqhSGiWlpOWAIP3EkCeivwBjcIVON03DinoV2fz
        TTAVEQuP2IGEWIv72jRtSOs8g0mfSI0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-R5x3ob5UP0mGBegX3ELCGA-1; Mon, 03 Aug 2020 16:59:13 -0400
X-MC-Unique: R5x3ob5UP0mGBegX3ELCGA-1
Received: by mail-qt1-f200.google.com with SMTP id r9so27754467qtp.7
        for <linux-crypto@vger.kernel.org>; Mon, 03 Aug 2020 13:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pbr1N8DSevefC/5XR/FPYq4gph7eMtDNIH83d+s2qxE=;
        b=Bs4xxv5VYkmhGoVz7Hs16hsQfYukxAzfoPL59jJDX9/nytoE/P/Jt/pOudJCPOKvwn
         emqbgg0BkEQmYkCN11/26QaWhIURAhyoQ9ieLkEW81H8bsDIq6QIMK9pYb1IysIG+eWq
         JPDj/M6LlHICAsxjqt/RZ1vieMI9q2KIh9w964qdKT+l9LuSD5Rafaqw+lL8vcSyJfTT
         tJHIh0kZGjOFKcIwQYY1Z0dxHFZqs6luxpmkgAc8iXPAv082K4ZaMmOA1SyeeyBKSs3f
         ijPnXEKJfRREke7HtrYDyd3O/gYaUDS3rmDiPMzym4E3ThhODfSZ04q7cPdl3s+mJ+1b
         7YYg==
X-Gm-Message-State: AOAM530j9t7f2G+CekCdYwoH2KDTIUHuwDhMFXNAyKEH1DdPIQ9ygmBv
        XgbCsI3dAouAJsUJr0B/0HvZC1gxDpqhDqiAnYXFbMzhtDm+NGjX14LGZkz+yFL+XNzP5oQfWx4
        uRJ3fEptaYKisQ9te58FOgKgG
X-Received: by 2002:a37:97c5:: with SMTP id z188mr17625692qkd.185.1596488353342;
        Mon, 03 Aug 2020 13:59:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpOGU4uU2+OZrgzDbQ/8jdl4TOLFPS5AcU+IWHZ8zsJRTTGwbHFRTkcrWAk9H50yW4pnfpSQ==
X-Received: by 2002:a37:97c5:: with SMTP id z188mr17625681qkd.185.1596488353070;
        Mon, 03 Aug 2020 13:59:13 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id k2sm21549694qkf.127.2020.08.03.13.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 13:59:12 -0700 (PDT)
Date:   Mon, 3 Aug 2020 16:59:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        Gonglei <arei.gonglei@huawei.com>, linux-crypto@vger.kernel.org
Subject: [PATCH v2 08/24] virtio_crypto: correct tags for config space fields
Message-ID: <20200803205814.540410-9-mst@redhat.com>
References: <20200803205814.540410-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803205814.540410-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since crypto is a modern-only device,
tag config space fields as having little endian-ness.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
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

