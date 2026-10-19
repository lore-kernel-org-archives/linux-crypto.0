Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422877;
	b=NEvVXBqfwFmNCgf03N21RrZwa2jYkJbGYB8N4r1hSw9ukVz1L+qjKtNgydj94ZEozhPE
	 FIswlJt5RVkedkwkummGqLb4oqDqkeZNpF9Dt89WJmOiaOOm93QE+WgpO1N0Z1teLp7wl
	 1FJnELvrg6ynFTJ2jeXSQu4NnSpUsrho0gAwxqy5wEKoAM3Isq1V2UnbyQQ+YDustS0pn
	 TlkPYxNQhrbGvT9yNkyH8dnmwB2ee+l3rcYR2f4xTVm48ZzMMynJbSiiu3+WxsgKInhom
	 zGf/bWzuEW2x8oCHAVSHN1AVyogHmrji7+aL09hWiBFpWtBpeEbc4b928YFBnfISmLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422877;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cG24RMmUaiXVAtObDzlYYK9d3lv/X/GCzcJFD3qOCfc=;
	b=zIuzvmFJsHesM5n6YMTz4lOvVp13BgNN9CS+PxijPE1jgbd97EAbFUoY4462AG8g8YsP
	 ELe3HFPGntFell00kYN1+32vNIAEQcU2lncpFfjrgi633E+wYgGDPwLNIgqr+4lhlaTQ0
	 F56KseSg+EifI0iVxaFyRACPBxMMKvFthy5wewPh+151MEzprbtdwoRq/on3q6K/T48e1
	 U5kdVWMecGgCV1cZQ6PnISUVHERcQas6mJlREl1ninJVbKac7QuU/eUil8H66yYfqzNKC
	 6OJk+Jn3sIlifk43p0HwQBlpKq2lCWO9FgvYIHZBW3fS4NN9SRLaGYIOTWGFq1qBUbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=G3LZGcCj;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9721B609CED2;
	Mon, 19 Oct 2026 15:14:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9721B609CED2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=G3LZGcCj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422876; x=1823958876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KTR6pKHqamqU24yuPvOmlvmDDNIEcFSj7cSOCzmOv2k=;
  b=G3LZGcCjM6c248F1ff5VoGsmgQUN0bHqQ7TS8NlXfWwGdX5LEJgneK4G
   qfBar2Le1+B6KyPTb5iPsyWQOVggDh5tpXNkmHtezI0WntOYYBJ+5/V5K
   LMyyBXZECO0bzN9hmCfgneeJvoyN6QjqPAAkyU0ZUfIRNK38ddNfGg9AD
   rH+tlFq0z9LCGG159uAwHfP/F3ABZHvflWvWH2YH/LXI1jJvQjrPrcB1v
   a9RHPTqyIQK+Qx94c/6Ru0NYQoSxyfQ6KHYqIa4mJTBTSX6xKk9Vs3r7L
   Juh77MS/FSg4SXfTS5zNQhDJG127w2sKkkRgdzLSpi2IcuKNnduWMR/Q3
   w==;
X-CSE-ConnectionGUID: qLB50olgTmu4/2LtDmwN1w==
X-CSE-MsgGUID: ry4mVDXLQWaO9b3c2OX6tg==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986903"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986903"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:34 -0700
X-CSE-ConnectionGUID: 2bccA0DES3maz9bNH6Y3bA==
X-CSE-MsgGUID: SUq4MvxvRESjMZd5Uiw6KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536954"
Received: from jf5300-15a101203tc.jf.intel.com (HELO meta-crater2c.jf.intel.com) ([10.54.113.49])
  by orviesa003.jf.intel.com with ESMTP; 19 Oct 2026 08:14:33 -0700
From: Daniel Byrne <daniel1.byrne@intel.com>
To: Vinod Koul <vkoul@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Frank Li <Frank.Li@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Kristen Accardi <kristen.c.accardi@intel.com>,
	dmaengine@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 04/17] dmaengine: idxd: list a new channel only once it is complete
Date: Mon, 19 Oct 2026 08:06:17 -0700
Message-ID: <20261019150630.4026341-5-daniel1.byrne@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261019150630.4026341-1-daniel1.byrne@intel.com>
References: <20261019150630.4026341-1-daniel1.byrne@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

idxd_register_dma_channel() links a new channel into the dma_device's
channel list before it registers the channel, and sets the channel's
work queue only after that. The dma_device is registered when the
device is enabled, before any of its work queues, and a channel
request walks the channel list of every registered device under
dma_list_mutex and may hand out any listed channel without a client.
A request that runs while a work queue is being enabled can therefore
take the half-built channel, and the allocation callback dereferences
its NULL work queue with dma_list_mutex held, after which every
channel request and release hangs. The link runs without that mutex
as well, so it races the walkers.

When the registration fails, the channel is freed but left on the
list, where the next request, the next channel's link and the device's
unregistration all reach it. Registration can fail: the core frees a
channel's id before it removes the channel's sysfs device. The channel
of a work queue enabled while another queue of the same device is
being disabled can therefore be handed an id whose sysfs name still
exists, and its registration then fails with -EEXIST.

Add dma_async_device_channel_add(), which registers a channel and only
then links it into its device's list, under dma_list_mutex, and use
it. The driver sets the channel's work queue and initializes its
descriptors before the call, so a request finds the channel complete
or not at all, and a channel that failed to register is never listed.
An enable that hits the -EEXIST race still fails, but leaves nothing
on the list.

A new helper rather than a change to dma_async_device_channel_register():
that function's contract requires the caller to have linked the channel
into the device's list already, which virt-dma's vchan_init() does for
stm32-dma3, the only other caller. That driver has the same window
between the link and the registration and is left for a follow-up.

The helper serves DMA_PRIVATE devices such as idxd's only, since the
channel list of a public device is also walked under RCU alone and its
channels hold references for the dmaengine_get() users, which the
helper does not take. The unbind still unlinks the channel without the
mutex. A later change, which reworks the unbind for channels that
clients still hold, unlinks it under the mutex.

The hang is reachable since the dma_device registration moved to the
device enable in v5.13, so this is for stable too.

Fixes: 8f47d1a5e545 ("dmaengine: idxd: connect idxd to dmaengine subsystem")
Fixes: 397862855619 ("dmaengine: idxd: fix dma device lifetime")
Cc: stable@vger.kernel.org # 5.13+
Assisted-by: Claude:claude-fable-5-1
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/dmaengine.c   | 41 +++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/dma.c    | 12 +++++++++---
 include/linux/dmaengine.h |  2 ++
 3 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index c71763047126..ced78c985d1c 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1155,6 +1155,47 @@ int dma_async_device_channel_register(struct dma_device *device,
 }
 EXPORT_SYMBOL_GPL(dma_async_device_channel_register);
 
+/**
+ * dma_async_device_channel_add - register a channel and make it available
+ * @device: the dmaengine device, DMA_PRIVATE and registered already
+ * @chan: the channel, not on @device's channel list
+ * @name: the channel's name, or NULL for the default one
+ *
+ * Channel requests walk the channel list of every registered device under
+ * dma_list_mutex and may hand out any listed channel that has no client.
+ * A channel added to a registered device is therefore linked to the list
+ * only once it is registered, and under that mutex, so that a request
+ * never finds it half initialized. The driver's own state behind the
+ * channel must be complete before the call. A channel that fails to
+ * register is not linked.
+ *
+ * Only a DMA_PRIVATE device may add channels this way. The channel list
+ * of a public device is also walked under RCU alone, and its channels
+ * hold references for the dmaengine_get() users, which this function
+ * does not take.
+ *
+ * Return: 0 on success or a negative errno.
+ */
+int dma_async_device_channel_add(struct dma_device *device,
+				 struct dma_chan *chan, const char *name)
+{
+	int rc;
+
+	if (WARN_ON_ONCE(!dma_has_cap(DMA_PRIVATE, device->cap_mask)))
+		return -EINVAL;
+
+	rc = __dma_async_device_channel_register(device, chan, name);
+	if (rc < 0)
+		return rc;
+
+	mutex_lock(&dma_list_mutex);
+	list_add_tail(&chan->device_node, &device->channels);
+	dma_channel_rebalance();
+	mutex_unlock(&dma_list_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dma_async_device_channel_add);
+
 static void __dma_async_device_channel_unregister(struct dma_device *device,
 						  struct dma_chan *chan)
 {
diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
index c116416e10e5..defd1af74c0a 100644
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -279,7 +279,7 @@ static int idxd_register_dma_channel(struct idxd_wq *wq)
 
 	chan = &idxd_chan->chan;
 	chan->device = dma;
-	list_add_tail(&chan->device_node, &dma->channels);
+	idxd_chan->wq = wq;
 
 	for (i = 0; i < wq->num_descs; i++) {
 		struct idxd_desc *desc = wq->descs[i];
@@ -288,14 +288,20 @@ static int idxd_register_dma_channel(struct idxd_wq *wq)
 		desc->txd.tx_submit = idxd_dma_tx_submit;
 	}
 
-	rc = dma_async_device_channel_register(dma, chan, NULL);
+	/*
+	 * The dma_device is registered already, so a channel request may
+	 * take the channel as soon as it is on the device's list. The core
+	 * links it only once it is registered, and everything a client
+	 * reaches through it is set up by then. What follows serves the
+	 * unbind, which cannot run before this probe returns.
+	 */
+	rc = dma_async_device_channel_add(dma, chan, NULL);
 	if (rc < 0) {
 		kfree(idxd_chan);
 		return rc;
 	}
 
 	wq->idxd_chan = idxd_chan;
-	idxd_chan->wq = wq;
 	get_device(wq_confdev(wq));
 
 	return 0;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index fe33a20abc61..4178248611d9 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1751,6 +1751,8 @@ static inline int dmaengine_desc_free(struct dma_async_tx_descriptor *desc)
 int dma_async_device_register(struct dma_device *device);
 int dmaenginem_async_device_register(struct dma_device *device);
 void dma_async_device_unregister(struct dma_device *device);
+int dma_async_device_channel_add(struct dma_device *device,
+				 struct dma_chan *chan, const char *name);
 int dma_async_device_channel_register(struct dma_device *device,
 				      struct dma_chan *chan,
 				      const char *name);
-- 
2.43.0

