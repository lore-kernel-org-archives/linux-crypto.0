Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8DBC433E1
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D120D23119
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:47:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QKumoDKS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgHFQrD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:47:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729207AbgHFQpP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 12:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596732313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yq06NoGira3XJqUtq4OjZJOaAZeoUPCFVsdiIYhXg5k=;
        b=QKumoDKSyhlrP3AWcV+Ky64NMseRT+67caqbtGZnqxP/ZNgjxsBmP0VeUSKO6H4czJwwny
        ri5aMhpVUtN/enEgF3g4nF+qaBifs/yuovp13eZCXYeGBfSdnCp1kY8EPRhQD7erN1ubSI
        0uiirNnL0MA9Y3DdY2HsNM/lmtgLlUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-07Wt8F2CPnqXy1snbvub0g-1; Thu, 06 Aug 2020 11:28:17 -0400
X-MC-Unique: 07Wt8F2CPnqXy1snbvub0g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5BFF1005504;
        Thu,  6 Aug 2020 15:28:16 +0000 (UTC)
Received: from thinkpad.redhat.com (ovpn-113-9.ams2.redhat.com [10.36.113.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A8D05DA6B;
        Thu,  6 Aug 2020 15:28:15 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Amit Shah <amit@kernel.org>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH] hwrng: core - allocate a one page buffer
Date:   Thu,  6 Aug 2020 17:28:14 +0200
Message-Id: <20200806152814.1325776-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This allows the driver to move bigger data block when the backend allows
it.

Add a backend buffer_size for this purpose. For the moment only
virtio-rng defines it.

Using bigger buffer with virtio-rng improves performance from:

  # dd if=/dev/hwrng of=/dev/null bs=1024 count=1024000
  1048576000 bytes (1.0 GB, 1000 MiB) copied, 674.303 s, 1.6 MB/s
  # dd if=/dev/hwrng of=/dev/null bs=4096 count=256000
  1048576000 bytes (1.0 GB, 1000 MiB) copied, 622.394 s, 1.7 MB/s

to

  # dd if=/dev/hwrng of=/dev/null bs=1024 count=1024000
  1048576000 bytes (1.0 GB, 1000 MiB) copied, 41.0579 s, 25.5 MB/s
  # dd if=/dev/hwrng of=/dev/null bs=4096 count=256000
  1048576000 bytes (1.0 GB, 1000 MiB) copied, 14.394 s, 72.8 MB/s

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/char/hw_random/core.c       | 37 ++++++++++++++++++++---------
 drivers/char/hw_random/virtio-rng.c |  1 +
 include/linux/hw_random.h           |  2 ++
 3 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 8c1c47dd9f46..3d8ce3c4d79c 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -56,15 +56,25 @@ static void start_khwrngd(void);
 static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
 			       int wait);
 
-static size_t rng_buffer_size(void)
+static size_t rng_min_buffer_size(void)
 {
-	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
+	return max_t(size_t, 32, SMP_CACHE_BYTES);
+}
+
+static size_t rng_max_buffer_size(struct hwrng *rng)
+{
+	size_t size;
+
+	size = max_t(size_t, rng->buffer_size, SMP_CACHE_BYTES);
+
+	/* rng_buffer can store up to PAGE_SIZE */
+	return min(PAGE_SIZE, size);
 }
 
 static void add_early_randomness(struct hwrng *rng)
 {
 	int bytes_read;
-	size_t size = min_t(size_t, 16, rng_buffer_size());
+	size_t size = min_t(size_t, 16, rng_min_buffer_size());
 
 	mutex_lock(&reading_mutex);
 	bytes_read = rng_get_data(rng, rng_buffer, size, 0);
@@ -226,9 +236,14 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			goto out_put;
 		}
 		if (!data_avail) {
-			bytes_read = rng_get_data(rng, rng_buffer,
-				rng_buffer_size(),
-				!(filp->f_flags & O_NONBLOCK));
+			size_t to_read;
+			/* read at least 32 bytes, up to rng_max_buffer_size()
+			 * but no more than size
+			 */
+			to_read = max_t(size_t, 32,
+					min(size, rng_max_buffer_size(rng)));
+			bytes_read = rng_get_data(rng, rng_buffer, to_read,
+						  !(filp->f_flags & O_NONBLOCK));
 			if (bytes_read < 0) {
 				err = bytes_read;
 				goto out_unlock_reading;
@@ -440,7 +455,7 @@ static int hwrng_fillfn(void *unused)
 			break;
 		mutex_lock(&reading_mutex);
 		rc = rng_get_data(rng, rng_fillbuf,
-				  rng_buffer_size(), 1);
+				  rng_min_buffer_size(), 1);
 		mutex_unlock(&reading_mutex);
 		put_rng(rng);
 		if (rc <= 0) {
@@ -614,11 +629,11 @@ static int __init hwrng_modinit(void)
 	int ret;
 
 	/* kmalloc makes this safe for virt_to_page() in virtio_rng.c */
-	rng_buffer = kmalloc(rng_buffer_size(), GFP_KERNEL);
+	rng_buffer = (u8 *)get_zeroed_page(GFP_KERNEL);
 	if (!rng_buffer)
 		return -ENOMEM;
 
-	rng_fillbuf = kmalloc(rng_buffer_size(), GFP_KERNEL);
+	rng_fillbuf = kmalloc(rng_min_buffer_size(), GFP_KERNEL);
 	if (!rng_fillbuf) {
 		kfree(rng_buffer);
 		return -ENOMEM;
@@ -627,7 +642,7 @@ static int __init hwrng_modinit(void)
 	ret = register_miscdev();
 	if (ret) {
 		kfree(rng_fillbuf);
-		kfree(rng_buffer);
+		free_page((unsigned long)rng_buffer);
 	}
 
 	return ret;
@@ -637,7 +652,7 @@ static void __exit hwrng_modexit(void)
 {
 	mutex_lock(&rng_mutex);
 	BUG_ON(current_rng);
-	kfree(rng_buffer);
+	free_page((unsigned long)rng_buffer);
 	kfree(rng_fillbuf);
 	mutex_unlock(&rng_mutex);
 
diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index a90001e02bf7..b71c137fcd05 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -104,6 +104,7 @@ static int probe_common(struct virtio_device *vdev)
 
 	vi->hwrng = (struct hwrng) {
 		.read = virtio_read,
+		.buffer_size = PAGE_SIZE,
 		.cleanup = virtio_cleanup,
 		.priv = (unsigned long)vi,
 		.name = vi->name,
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 8e6dd908da21..582c8787f808 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -31,6 +31,7 @@
  * @read:		New API. drivers can fill up to max bytes of data
  *			into the buffer. The buffer is aligned for any type
  *			and max is a multiple of 4 and >= 32 bytes.
+ * @buffer_size:	Optional. if not 0, optimal buffer size.
  * @priv:		Private data, for use by the RNG driver.
  * @quality:		Estimation of true entropy in RNG's bitstream
  *			(in bits of entropy per 1024 bits of input;
@@ -43,6 +44,7 @@ struct hwrng {
 	int (*data_present)(struct hwrng *rng, int wait);
 	int (*data_read)(struct hwrng *rng, u32 *data);
 	int (*read)(struct hwrng *rng, void *data, size_t max, bool wait);
+	size_t buffer_size;
 	unsigned long priv;
 	unsigned short quality;
 
-- 
2.26.2

