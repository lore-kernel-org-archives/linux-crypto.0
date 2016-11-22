From: Gonglei <arei.gonglei@huawei.com>
Subject: [PATCH v2 1/2] virtio: introduce little edian functions for virtio_cread/write# family
Date: Tue, 22 Nov 2016 16:10:22 +0800
Message-ID: <1479802223-121104-2-git-send-email-arei.gonglei@huawei.com>
References: <1479802223-121104-1-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <luonengjun@huawei.com>, <mst@redhat.com>, <stefanha@redhat.com>,
        <weidong.huang@huawei.com>, <wu.wubin@huawei.com>,
        <xin.zeng@intel.com>, <claudio.fontana@huawei.com>,
        <herbert@gondor.apana.org.au>, <pasic@linux.vnet.ibm.com>,
        <davem@davemloft.net>, <jianjay.zhou@huawei.com>,
        <hanweidong@huawei.com>, <arei.gonglei@hotmail.com>,
        <cornelia.huck@de.ibm.com>, <xuquan8@huawei.com>,
        <longpeng2@huawei.com>, <salvatore.benedetto@intel.com>,
        Gonglei <arei.gonglei@huawei.com>
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <virtio-dev@lists.oasis-open.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:1484 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752101AbcKVILM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 03:11:12 -0500
In-Reply-To: <1479802223-121104-1-git-send-email-arei.gonglei@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Virtio modern devices are always little edian, let's introduce
the LE functions for read/write configuration space for
virtio modern devices, which avoid complaint by Sparse when
we use the virtio_creaed/virtio_cwrite in VIRTIO_1 devices.

Signed-off-by: Gonglei <arei.gonglei@huawei.com>
---
 include/linux/virtio_config.h | 45 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 26c155b..de05707 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -414,4 +414,49 @@ static inline void virtio_cwrite64(struct virtio_device *vdev,
 		_r;							\
 	})
 
+static inline __le16 virtio_cread16_le(struct virtio_device *vdev,
+				 unsigned int offset)
+{
+	__le16 ret;
+
+	vdev->config->get(vdev, offset, &ret, sizeof(ret));
+	return ret;
+}
+
+static inline void virtio_cwrite16_le(struct virtio_device *vdev,
+				   unsigned int offset, __le16 val)
+{
+	vdev->config->set(vdev, offset, &val, sizeof(val));
+}
+
+static inline __le32 virtio_cread32_le(struct virtio_device *vdev,
+				 unsigned int offset)
+{
+	__le32 ret;
+
+	vdev->config->get(vdev, offset, &ret, sizeof(ret));
+	return ret;
+}
+
+static inline void virtio_cwrite32_le(struct virtio_device *vdev,
+				   unsigned int offset, __le32 val)
+{
+	vdev->config->set(vdev, offset, &val, sizeof(val));
+}
+
+static inline __le64 virtio_cread64_le(struct virtio_device *vdev,
+				 unsigned int offset)
+{
+	__le64 ret;
+
+	__virtio_cread_many(vdev, offset, &ret, 1, sizeof(ret));
+	return ret;
+}
+
+static inline void virtio_cwrite64_le(struct virtio_device *vdev,
+				   unsigned int offset, __le64 val)
+{
+	vdev->config->set(vdev, offset, &val, sizeof(val));
+}
+
 #endif /* _LINUX_VIRTIO_CONFIG_H */
-- 
1.8.3.1
