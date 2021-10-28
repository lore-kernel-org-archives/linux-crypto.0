Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84148C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 10:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 697026103C
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 10:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhJ1KO3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Oct 2021 06:14:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230054AbhJ1KO2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Oct 2021 06:14:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635415921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Du5vZNXnhXvnlyGaYPOtC+IJQXZjh+l7JG2ObOtN8d0=;
        b=NUa+7fRt8R4q19ByDwUArUsIxej7trY2WyBrY3y08qndttRSXuws3RQqIpWklmxAW6fBl/
        gNRXEGGiPWTeJlm9t33tDD4hukGJtrqVrIm5ilNpkjkQBV4PwQdycqxXbesX9t6vVdTKai
        V8Sm+1RTDmILMt0gkNdy51U/+rAYtfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-dxtiFGm-NyuBUa_Y-ZIraA-1; Thu, 28 Oct 2021 06:11:58 -0400
X-MC-Unique: dxtiFGm-NyuBUa_Y-ZIraA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F0D65074B;
        Thu, 28 Oct 2021 10:11:56 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.39.194.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69D3A60C04;
        Thu, 28 Oct 2021 10:11:36 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     amit@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        virtualization@lists.linux-foundation.org,
        Dmitriy Vyukov <dvyukov@google.com>, rusty@rustcorp.com.au,
        akong@redhat.com, Alexander Potapenko <glider@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        linux-crypto@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v2 2/4] hwrng: virtio - don't wait on cleanup
Date:   Thu, 28 Oct 2021 12:11:09 +0200
Message-Id: <20211028101111.128049-3-lvivier@redhat.com>
In-Reply-To: <20211028101111.128049-1-lvivier@redhat.com>
References: <20211028101111.128049-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When virtio-rng device was dropped by the hwrng core we were forced
to wait the buffer to come back from the device to not have
remaining ongoing operation that could spoil the buffer.

But now, as the buffer is internal to the virtio-rng we can release
the waiting loop immediately, the buffer will be retrieve and use
when the virtio-rng driver will be selected again.

This avoids to hang on an rng_current write command if the virtio-rng
device is blocked by a lack of entropy. This allows to select
another entropy source if the current one is empty.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 208c547dcac1..173aeea835bb 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -82,6 +82,11 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 		ret = wait_for_completion_killable(&vi->have_data);
 		if (ret < 0)
 			return ret;
+		/* if vi->data_avail is 0, we have been interrupted
+		 * by a cleanup, but buffer stays in the queue
+		 */
+		if (vi->data_avail == 0)
+			return read;
 
 		chunk = min_t(unsigned int, size, vi->data_avail);
 		memcpy(buf + read, vi->data, chunk);
@@ -105,7 +110,7 @@ static void virtio_cleanup(struct hwrng *rng)
 	struct virtrng_info *vi = (struct virtrng_info *)rng->priv;
 
 	if (vi->busy)
-		wait_for_completion(&vi->have_data);
+		complete(&vi->have_data);
 }
 
 static int probe_common(struct virtio_device *vdev)
-- 
2.31.1

