Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53560C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 10:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C9D160D07
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 10:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhJ1KOh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Oct 2021 06:14:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230164AbhJ1KOg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Oct 2021 06:14:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635415929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=niNxNs+708zjm3j3rRaODc+lHl5+1aQR820Stcz2CGo=;
        b=aVz+Tdo+FyGRwdfSBl+R+/QgDCJ6XUBGHJBxJscxI9uiLUwx2qY5G2O5MOAjKHxiSUJWdL
        Epk59WTMcigAYLLmmaES+LZA6oH3mToHil5osCg01RflvXAfTfnM9QuSiR8SwUFiFo4Uk4
        /eVi0l/E2Jef8uKoK+kZi6d2i3gfnn0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-EH0ScqUPMOiHbfZG9hSlSA-1; Thu, 28 Oct 2021 06:12:04 -0400
X-MC-Unique: EH0ScqUPMOiHbfZG9hSlSA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BDFB10A8E02;
        Thu, 28 Oct 2021 10:12:02 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.39.194.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E90C060C04;
        Thu, 28 Oct 2021 10:11:59 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     amit@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        virtualization@lists.linux-foundation.org,
        Dmitriy Vyukov <dvyukov@google.com>, rusty@rustcorp.com.au,
        akong@redhat.com, Alexander Potapenko <glider@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        linux-crypto@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v2 4/4] hwrng: virtio - always add a pending request
Date:   Thu, 28 Oct 2021 12:11:11 +0200
Message-Id: <20211028101111.128049-5-lvivier@redhat.com>
In-Reply-To: <20211028101111.128049-1-lvivier@redhat.com>
References: <20211028101111.128049-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If we ensure we have already some data available by enqueuing
again the buffer once data are exhausted, we can return what we
have without waiting for the device answer.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 8ba97cf4ca8f..0a7dde135db1 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -20,7 +20,6 @@ struct virtrng_info {
 	struct virtqueue *vq;
 	char name[25];
 	int index;
-	bool busy;
 	bool hwrng_register_done;
 	bool hwrng_removed;
 	/* data transfer */
@@ -44,16 +43,18 @@ static void random_recv_done(struct virtqueue *vq)
 		return;
 
 	vi->data_idx = 0;
-	vi->busy = false;
 
 	complete(&vi->have_data);
 }
 
-/* The host will fill any buffer we give it with sweet, sweet randomness. */
-static void register_buffer(struct virtrng_info *vi)
+static void request_entropy(struct virtrng_info *vi)
 {
 	struct scatterlist sg;
 
+	reinit_completion(&vi->have_data);
+	vi->data_avail = 0;
+	vi->data_idx = 0;
+
 	sg_init_one(&sg, vi->data, sizeof(vi->data));
 
 	/* There should always be room for one buffer. */
@@ -69,6 +70,8 @@ static unsigned int copy_data(struct virtrng_info *vi, void *buf,
 	memcpy(buf, vi->data + vi->data_idx, size);
 	vi->data_idx += size;
 	vi->data_avail -= size;
+	if (vi->data_avail == 0)
+		request_entropy(vi);
 	return size;
 }
 
@@ -98,13 +101,7 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 	 * so either size is 0 or data_avail is 0
 	 */
 	while (size != 0) {
-		/* data_avail is 0 */
-		if (!vi->busy) {
-			/* no pending request, ask for more */
-			vi->busy = true;
-			reinit_completion(&vi->have_data);
-			register_buffer(vi);
-		}
+		/* data_avail is 0 but a request is pending */
 		ret = wait_for_completion_killable(&vi->have_data);
 		if (ret < 0)
 			return ret;
@@ -126,8 +123,7 @@ static void virtio_cleanup(struct hwrng *rng)
 {
 	struct virtrng_info *vi = (struct virtrng_info *)rng->priv;
 
-	if (vi->busy)
-		complete(&vi->have_data);
+	complete(&vi->have_data);
 }
 
 static int probe_common(struct virtio_device *vdev)
@@ -163,6 +159,9 @@ static int probe_common(struct virtio_device *vdev)
 		goto err_find;
 	}
 
+	/* we always have a pending entropy request */
+	request_entropy(vi);
+
 	return 0;
 
 err_find:
@@ -181,7 +180,6 @@ static void remove_common(struct virtio_device *vdev)
 	vi->data_idx = 0;
 	complete(&vi->have_data);
 	vdev->config->reset(vdev);
-	vi->busy = false;
 	if (vi->hwrng_register_done)
 		hwrng_unregister(&vi->hwrng);
 	vdev->config->del_vqs(vdev);
-- 
2.31.1

