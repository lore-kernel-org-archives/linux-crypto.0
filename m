Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5BFC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 10:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1B8C6023D
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 10:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhJ1KOf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Oct 2021 06:14:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230164AbhJ1KOd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Oct 2021 06:14:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635415926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x2sevkXopPa/npZcOtqrWwrkEQ1OQe4Rd6KhlqcskKY=;
        b=S86rmGTmUmatmY5lRkXqnNVA1hqkvlbo94ZNNTBo4YBTjJrZRetl/YQt3hMEqIvTMUE9wj
        RMJCYSH1rThocZqeRUGmrWbnkjq1O2lecV1DgxvuwmLUo5PmTOp3KcMy2gisEi7G7YTLIn
        961OLy2YWh2UAj6g36xKLErqnCXu+8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-jQeU5JeWNrGSDkOfpfp7dg-1; Thu, 28 Oct 2021 06:12:01 -0400
X-MC-Unique: jQeU5JeWNrGSDkOfpfp7dg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9128F1966323;
        Thu, 28 Oct 2021 10:11:59 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.39.194.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7FEA60C04;
        Thu, 28 Oct 2021 10:11:56 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     amit@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        virtualization@lists.linux-foundation.org,
        Dmitriy Vyukov <dvyukov@google.com>, rusty@rustcorp.com.au,
        akong@redhat.com, Alexander Potapenko <glider@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        linux-crypto@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v2 3/4] hwrng: virtio - don't waste entropy
Date:   Thu, 28 Oct 2021 12:11:10 +0200
Message-Id: <20211028101111.128049-4-lvivier@redhat.com>
In-Reply-To: <20211028101111.128049-1-lvivier@redhat.com>
References: <20211028101111.128049-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

if we don't use all the entropy available in the buffer, keep it
and use it later.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 52 +++++++++++++++++++----------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 173aeea835bb..8ba97cf4ca8f 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -26,6 +26,7 @@ struct virtrng_info {
 	/* data transfer */
 	struct completion have_data;
 	unsigned int data_avail;
+	unsigned int data_idx;
 	/* minimal size returned by rng_buffer_size() */
 #if SMP_CACHE_BYTES < 32
 	u8 data[32];
@@ -42,6 +43,9 @@ static void random_recv_done(struct virtqueue *vq)
 	if (!virtqueue_get_buf(vi->vq, &vi->data_avail))
 		return;
 
+	vi->data_idx = 0;
+	vi->busy = false;
+
 	complete(&vi->have_data);
 }
 
@@ -58,6 +62,16 @@ static void register_buffer(struct virtrng_info *vi)
 	virtqueue_kick(vi->vq);
 }
 
+static unsigned int copy_data(struct virtrng_info *vi, void *buf,
+			      unsigned int size)
+{
+	size = min_t(unsigned int, size, vi->data_avail);
+	memcpy(buf, vi->data + vi->data_idx, size);
+	vi->data_idx += size;
+	vi->data_avail -= size;
+	return size;
+}
+
 static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 {
 	int ret;
@@ -68,17 +82,29 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 	if (vi->hwrng_removed)
 		return -ENODEV;
 
-	if (!vi->busy) {
-		vi->busy = true;
-		reinit_completion(&vi->have_data);
-		register_buffer(vi);
+	read = 0;
+
+	/* copy available data */
+	if (vi->data_avail) {
+		chunk = copy_data(vi, buf, size);
+		size -= chunk;
+		read += chunk;
 	}
 
 	if (!wait)
-		return 0;
+		return read;
 
-	read = 0;
+	/* We have already copied available entropy,
+	 * so either size is 0 or data_avail is 0
+	 */
 	while (size != 0) {
+		/* data_avail is 0 */
+		if (!vi->busy) {
+			/* no pending request, ask for more */
+			vi->busy = true;
+			reinit_completion(&vi->have_data);
+			register_buffer(vi);
+		}
 		ret = wait_for_completion_killable(&vi->have_data);
 		if (ret < 0)
 			return ret;
@@ -88,20 +114,11 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 		if (vi->data_avail == 0)
 			return read;
 
-		chunk = min_t(unsigned int, size, vi->data_avail);
-		memcpy(buf + read, vi->data, chunk);
-		read += chunk;
+		chunk = copy_data(vi, buf + read, size);
 		size -= chunk;
-		vi->data_avail = 0;
-
-		if (size != 0) {
-			reinit_completion(&vi->have_data);
-			register_buffer(vi);
-		}
+		read += chunk;
 	}
 
-	vi->busy = false;
-
 	return read;
 }
 
@@ -161,6 +178,7 @@ static void remove_common(struct virtio_device *vdev)
 
 	vi->hwrng_removed = true;
 	vi->data_avail = 0;
+	vi->data_idx = 0;
 	complete(&vi->have_data);
 	vdev->config->reset(vdev);
 	vi->busy = false;
-- 
2.31.1

