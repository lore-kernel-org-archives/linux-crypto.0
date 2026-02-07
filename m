Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FCC2E6CDF;
	Sat,  7 Feb 2026 18:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770488416; cv=none; b=NMRB9q/VfboEp3L51Kdtg9xZEyGrS0VT+5YgizZuMIv+33E+yOXYFV6Qtvr8gOtcL/R179sHRvQjJjNnAFT4K0Bw33sAb7G8FmAzxQZypRvOtcZ4Rie5/QOyuMfD3/9WpiqD7Sdv3p174HpYqM+4jBrr9TOzMrP1EYLiPdEpMx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770488416; c=relaxed/simple;
	bh=VQ/+d4GtvWgsueFwR/GePFVNJiRwnBr+ARdraOOAr5c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uqYR9/UisTD6jespdL+2HQVZOyLZJp0oFJsziT8vM+zCR7BM5atqLqNutaVOOuvtNbln8teHxWveEmSvpxddbfbuh2XXYSTwIUqMVl99MmIuwnNM2FDD2w6nncDqDFA3OYZmwVf9SxNa6ERDqL8jmbaIwxopU9cU+dTHa1t7k5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=likewhatevs.io; spf=pass smtp.mailfrom=likewhatevs.io; dkim=pass (2048-bit key) header.d=likewhatevs.io header.i=@likewhatevs.io header.b=hj+1ZigH; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=scnshh+E; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=likewhatevs.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=likewhatevs.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=likewhatevs.io header.i=@likewhatevs.io header.b="hj+1ZigH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="scnshh+E"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 326377A00D0;
	Sat,  7 Feb 2026 13:20:14 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sat, 07 Feb 2026 13:20:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=likewhatevs.io;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1770488413; x=1770574813; bh=IO9ywlmGfc
	BO8cnAVToZ1n7BPbwOAGIfRGMDEBBgO1w=; b=hj+1ZigHU81o+NgMkXYIWGF7ac
	JxJOZbGFRp6ULfRHAASao55TltRLZtYcW9GHH2MludYrrFV7tATV7/7e7ePf2o1z
	4BsjKpRVnuHFzLsZgMyAMA659mn3gxv1e2LSZZWeFX5esJ5ej0jnkRI0TVB9sW79
	8zl+RaAmxOZNI+57wjI4eoC/YE/Riu4rZi9iBy0grsndc3EcKasG9YtnEHwj6xzt
	IYxuQMHJ1Y8tcE39whOiHgrLGyLJybG5C+6UM1/DJpamUcWLvP3W8eCNUTog1pUA
	1YvMjbJjQFvSD4psvjnC7o7RDqdZBSUvlnh/zqApuLuFqCxSaPvqdHfxGrAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1770488413; x=1770574813; bh=IO9ywlmGfcBO8cnAVToZ1n7BPbwOAGIfRGM
	DEBBgO1w=; b=scnshh+Eyp8vbWpEJZwXyQ42wx9fOMRLdG/Inh/AhATRedpgXqt
	TplI1PiNZEnH0DBwnu/rgFAY+IJKIG+WOTFHZ5V37/c8Qq3Jqe8v5OYHBjn8ZzoD
	6UQaSzULcm8GqLl+4VXWvhq8p+/05P1OAB4tdj/i9FwcMU3nI7GGO5PL4BdMr/W6
	/GO6Ktf4RaVCjPHjouE4zaLqCtcqYTaaX8hmANPgRDnmx5yRzkkje/T+nsZuqXFX
	grW1MfMECRCpjm6BtA47cSNqFzWi9l5UfUkfT/cLcdxj8sZ2Q1VYc1cMhFsuzGhi
	FFPSqaJbYJMfsEQA500weji+vwsZEX4+ggg==
X-ME-Sender: <xms:W4KHaTMiwKZ77nWxK0cjRY_0OfM9c4E8cJA7gUHWhEFDysakuaIjMQ>
    <xme:W4KHabdEetlCfRR1QHP__0XUWwZyh9iirILazW9OhONVoxULHV_n-IarcdHg_fTHh
    uUzSPfEm0laaPJepuUIKqgNPVvY9vc2gN_kAy_DgGrt1xPQzYO8w5U>
X-ME-Received: <xmr:W4KHaU6fRRvaVC2AA6nCDc_ZaEwn2V9cUezqrkTchOS7IYmmT24TrxbnHEKj5jZjAvxqK-3SItW5Kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduledujeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheprfgrthcuufhomhgr
    rhhuuceophgrthhsoheslhhikhgvfihhrghtvghvshdrihhoqeenucggtffrrghtthgvrh
    hnpeefveeiveeijefgueettdejleelieefvddtkeekudduveetveeutdehffeiueehuden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehprghtsh
    hosehlihhkvgifhhgrthgvvhhsrdhiohdpnhgspghrtghpthhtohepuddvpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegrrhgvihdrghhonhhglhgviheshhhurgifvghird
    gtohhmpdhrtghpthhtohephhgvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhg
    rdgruhdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpth
    htohepmhhsthesrhgvughhrghtrdgtohhmpdhrtghpthhtohepjhgrshhofigrnhhgsehr
    vgguhhgrthdrtghomhdprhgtphhtthhopehtjheskhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepgihurghniihhuhhosehlihhnuhigrdgrlhhisggrsggrrdgtohhmpdhrtghpthht
    ohepvghpvghrvgiimhgrsehrvgguhhgrthdrtghomhdprhgtphhtthhopehvihhrthhurg
    hlihiirghtihhonheslhhishhtshdrlhhinhhugidruggvvh
X-ME-Proxy: <xmx:W4KHadI1JHH2Bey7c4l-btoCiMwH0fV3m__YW9Oun14EW6bW2M3nYQ>
    <xmx:W4KHaeXd3Z79DGZAKbFUFXV-eLdT6XlVispDxwSXQWL8Yy9uR_oTzg>
    <xmx:W4KHaZHAWT7FOxBsqgGnyVW0v5KF52nkq7Ugr865wijjbypWt8JbnQ>
    <xmx:W4KHad6CAxE5JcDe3KW55Zfyb5lOYxQ60rNHATA-ooL38bPRvPJFhg>
    <xmx:XYKHabyKJEV_eTRBlBauzhDr9DX0WO9d0KD1aj0eQJNc-8aT1RSeri2M>
Feedback-ID: i7f194913:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Feb 2026 13:20:11 -0500 (EST)
From: Pat Somaru <patso@likewhatevs.io>
To: Gonglei <arei.gonglei@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Tejun Heo <tj@kernel.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pat Somaru <patso@likewhatevs.io>
Subject: [PATCH] crypto: virtio: Convert from tasklet to BH workqueue
Date: Sat,  7 Feb 2026 13:20:01 -0500
Message-ID: <20260207182001.2242836-1-patso@likewhatevs.io>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only generic interface to execute asynchronously in the BH context
is tasklet; however, it's marked deprecated and has some design flaws
such as the execution code accessing the tasklet item after the
execution is complete which can lead to subtle use-after-free in certain
usage scenarios and less-developed flush and cancel mechanisms.

To replace tasklets, BH workqueue support was recently added. A BH
workqueue behaves similarly to regular workqueues except that the queued
work items are executed in the BH context.

Convert virtio_crypto_core.c from tasklet to BH workqueue.

Semantically, this is an equivalent conversion and there shouldn't be
any user-visible behavior changes. The BH workqueue implementation uses
the same softirq infrastructure, and performance-critical networking
conversions have shown no measurable performance impact.

Signed-off-by: Pat Somaru <patso@likewhatevs.io>
---
 Hi, I'm working on converting tasklet usages to the BH WQ API.

 The virtio-crypto driver uses a tasklet per data queue to process
 completed crypto operations in BH context. This converts that tasklet
 to use the BH workqueue infrastructure.

 This patch was tested by:
    - Building with allmodconfig: no new warnings (compared to v6.18)
    - Building with allyesconfig: no new warnings (compared to v6.18)
    - Booting defconfig kernel via vng and running `uname -a`:
    Linux virtme-ng 6.18.0-virtme #1 SMP PREEMPT_DYNAMIC 0 x86_64 GNU/Linux

 Maintainers can apply this directly to the crypto subsystem tree or ack
 it for the workqueue tree to carry.

 drivers/crypto/virtio/virtio_crypto_common.h |  3 ++-
 drivers/crypto/virtio/virtio_crypto_core.c   | 11 +++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index 19c934af3df6..c758a5a37729 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -11,6 +11,7 @@
 #include <linux/crypto.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/workqueue.h>
 #include <crypto/aead.h>
 #include <crypto/aes.h>
 #include <crypto/engine.h>
@@ -29,7 +30,7 @@ struct data_queue {
 	char name[32];
 
 	struct crypto_engine *engine;
-	struct tasklet_struct done_task;
+	struct work_struct done_work;
 };
 
 struct virtio_crypto {
diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index 3d241446099c..345d1f1ed195 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -70,9 +70,9 @@ int virtio_crypto_ctrl_vq_request(struct virtio_crypto *vcrypto, struct scatterl
 	return 0;
 }
 
-static void virtcrypto_done_task(unsigned long data)
+static void virtcrypto_done_work(struct work_struct *work)
 {
-	struct data_queue *data_vq = (struct data_queue *)data;
+	struct data_queue *data_vq = from_work(data_vq, work, done_work);
 	struct virtqueue *vq = data_vq->vq;
 	struct virtio_crypto_request *vc_req;
 	unsigned int len;
@@ -91,7 +91,7 @@ static void virtcrypto_dataq_callback(struct virtqueue *vq)
 	struct virtio_crypto *vcrypto = vq->vdev->priv;
 	struct data_queue *dq = &vcrypto->data_vq[vq->index];
 
-	tasklet_schedule(&dq->done_task);
+	queue_work(system_bh_wq, &dq->done_work);
 }
 
 static int virtcrypto_find_vqs(struct virtio_crypto *vi)
@@ -145,8 +145,7 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
 			ret = -ENOMEM;
 			goto err_engine;
 		}
-		tasklet_init(&vi->data_vq[i].done_task, virtcrypto_done_task,
-				(unsigned long)&vi->data_vq[i]);
+		INIT_WORK(&vi->data_vq[i].done_work, virtcrypto_done_work);
 	}
 
 	kfree(vqs_info);
@@ -497,7 +496,7 @@ static void virtcrypto_remove(struct virtio_device *vdev)
 	if (virtcrypto_dev_started(vcrypto))
 		virtcrypto_dev_stop(vcrypto);
 	for (i = 0; i < vcrypto->max_data_queues; i++)
-		tasklet_kill(&vcrypto->data_vq[i].done_task);
+		cancel_work_sync(&vcrypto->data_vq[i].done_work);
 	virtio_reset_device(vdev);
 	virtcrypto_free_unused_reqs(vcrypto);
 	virtcrypto_clear_crypto_engines(vcrypto);
-- 
2.52.0

