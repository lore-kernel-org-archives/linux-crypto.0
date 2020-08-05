Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531DBC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 17:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18596206F6
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 17:15:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SiS3asl9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgHERO6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Aug 2020 13:14:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54425 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728462AbgHERLO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Aug 2020 13:11:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596647470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PnsUzUfj/maYqHomtkyX8zOTJsr1HA4XmfpAedp5w54=;
        b=SiS3asl9/tCJGaOTceK+WwqQ19iOPVSqtLmY60+MV9bQ9/oYg3eYYm+hZELDbGU1pjiRNt
        C8z7owXNwYPNc1T41B5qhBty4OzA8v7mcu9+z/ZrSDmkpOTL/XVPdH2ac67XyTU8M6jjEy
        XOakbCIccAFRgnjQAdpnkGFJ4meffHw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-a6AtVRg6N3uOB97NBBCr9g-1; Wed, 05 Aug 2020 09:44:46 -0400
X-MC-Unique: a6AtVRg6N3uOB97NBBCr9g-1
Received: by mail-wr1-f72.google.com with SMTP id z12so13641426wrl.16
        for <linux-crypto@vger.kernel.org>; Wed, 05 Aug 2020 06:44:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PnsUzUfj/maYqHomtkyX8zOTJsr1HA4XmfpAedp5w54=;
        b=lUFXxaHVodC50FIWaHO6D96k4BNbMtUCa4Yr0aC+7oEF2pUnXSwX496DKZIcrtMf8Y
         4eqg+TdBBJjnZhoNMUq8TliCpw/m2UTxRZSPHgNEADYCSiPkqo/sdVC8rdvzsLie4/TP
         BzMo9h81a8eAiQoAojydvUpbbjxFEFP0N5x9fPKIKiRsjwlRSAl0BRT3Aqz5k4LhHO7H
         VYmeOAajmg1zg00qf+q7mUOAFModzRl+td6NGn9AL14zpTQk7IaMTn37EtymR80wUi4q
         b6N09GKpV7JFrf9GxprLbhQ0o6tiWgdWx7ZIJonTo2i721HUEC8h9YWcxau3iaGuXvyQ
         hkFg==
X-Gm-Message-State: AOAM532aTfuetRKCXci7/5c6hSJ159scGKPtLMIMx5xUiXoZ3flPhd4N
        YW4sxtHNodnc34fZ63BgZPjziKkO+3WHR11mufxIoCcg+nwc6qHsbighNfL0PzRgoGaux9Pc+Ar
        DYJenOz3S3O7TdHnltLMWsaxC
X-Received: by 2002:a7b:ce83:: with SMTP id q3mr3330208wmj.5.1596635085325;
        Wed, 05 Aug 2020 06:44:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxspf2A9DeJp/XDd6wXksBjAJ9F8IN1IMgFckmDgI4O8zQGWyVV23BOfPLRsaeXGpCTmqk5Bg==
X-Received: by 2002:a7b:ce83:: with SMTP id q3mr3330187wmj.5.1596635085095;
        Wed, 05 Aug 2020 06:44:45 -0700 (PDT)
Received: from redhat.com (bzq-79-178-123-8.red.bezeqint.net. [79.178.123.8])
        by smtp.gmail.com with ESMTPSA id l21sm2648720wmj.25.2020.08.05.06.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 06:44:44 -0700 (PDT)
Date:   Wed, 5 Aug 2020 09:44:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Gonglei <arei.gonglei@huawei.com>,
        Jason Wang <jasowang@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 32/38] virtio_crypto: convert to LE accessors
Message-ID: <20200805134226.1106164-33-mst@redhat.com>
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

Virtio crypto is modern-only. Use LE accessors for config space.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/crypto/virtio/virtio_crypto_core.c | 46 +++++++++++-----------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index c8a962c62663..aeecce27fe8f 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -204,8 +204,8 @@ static int virtcrypto_update_status(struct virtio_crypto *vcrypto)
 	u32 status;
 	int err;
 
-	virtio_cread(vcrypto->vdev,
-	    struct virtio_crypto_config, status, &status);
+	virtio_cread_le(vcrypto->vdev,
+			struct virtio_crypto_config, status, &status);
 
 	/*
 	 * Unknown status bits would be a host error and the driver
@@ -323,31 +323,31 @@ static int virtcrypto_probe(struct virtio_device *vdev)
 	if (!vcrypto)
 		return -ENOMEM;
 
-	virtio_cread(vdev, struct virtio_crypto_config,
+	virtio_cread_le(vdev, struct virtio_crypto_config,
 			max_dataqueues, &max_data_queues);
 	if (max_data_queues < 1)
 		max_data_queues = 1;
 
-	virtio_cread(vdev, struct virtio_crypto_config,
-		max_cipher_key_len, &max_cipher_key_len);
-	virtio_cread(vdev, struct virtio_crypto_config,
-		max_auth_key_len, &max_auth_key_len);
-	virtio_cread(vdev, struct virtio_crypto_config,
-		max_size, &max_size);
-	virtio_cread(vdev, struct virtio_crypto_config,
-		crypto_services, &crypto_services);
-	virtio_cread(vdev, struct virtio_crypto_config,
-		cipher_algo_l, &cipher_algo_l);
-	virtio_cread(vdev, struct virtio_crypto_config,
-		cipher_algo_h, &cipher_algo_h);
-	virtio_cread(vdev, struct virtio_crypto_config,
-		hash_algo, &hash_algo);
-	virtio_cread(vdev, struct virtio_crypto_config,
-		mac_algo_l, &mac_algo_l);
-	virtio_cread(vdev, struct virtio_crypto_config,
-		mac_algo_h, &mac_algo_h);
-	virtio_cread(vdev, struct virtio_crypto_config,
-		aead_algo, &aead_algo);
+	virtio_cread_le(vdev, struct virtio_crypto_config,
+			max_cipher_key_len, &max_cipher_key_len);
+	virtio_cread_le(vdev, struct virtio_crypto_config,
+			max_auth_key_len, &max_auth_key_len);
+	virtio_cread_le(vdev, struct virtio_crypto_config,
+			max_size, &max_size);
+	virtio_cread_le(vdev, struct virtio_crypto_config,
+			crypto_services, &crypto_services);
+	virtio_cread_le(vdev, struct virtio_crypto_config,
+			cipher_algo_l, &cipher_algo_l);
+	virtio_cread_le(vdev, struct virtio_crypto_config,
+			cipher_algo_h, &cipher_algo_h);
+	virtio_cread_le(vdev, struct virtio_crypto_config,
+			hash_algo, &hash_algo);
+	virtio_cread_le(vdev, struct virtio_crypto_config,
+			mac_algo_l, &mac_algo_l);
+	virtio_cread_le(vdev, struct virtio_crypto_config,
+			mac_algo_h, &mac_algo_h);
+	virtio_cread_le(vdev, struct virtio_crypto_config,
+			aead_algo, &aead_algo);
 
 	/* Add virtio crypto device to global table */
 	err = virtcrypto_devmgr_add_dev(vcrypto);
-- 
MST

