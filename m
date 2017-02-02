From: Anup Patel <anup.patel@broadcom.com>
Subject: [PATCH 1/6] mailbox: Add new API mbox_channel_device() for clients
Date: Thu,  2 Feb 2017 10:17:11 +0530
Message-ID: <1486010836-25228-2-git-send-email-anup.patel@broadcom.com>
References: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-raid@vger.kernel.org, Anup Patel <anup.patel@broadcom.com>
To: Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jassi Brar <jassisinghbrar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The remote processor can have DMAENGINE capabilities and client
can pass data to be processed via main memory. In such cases,
the client will require DMAble memory for remote processor.

This patch adds new API mbox_channel_device() which can be
used by clients to get struct device pointer of underlying
mailbox controller. This struct device pointer of mailbox
controller can be used by clients to allocate DMAble memory
for remote processor.

Signed-off-by: Anup Patel <anup.patel@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
---
 drivers/mailbox/mailbox.c      | 21 +++++++++++++++++++++
 include/linux/mailbox_client.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 4671f8a..d4380fc 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -281,6 +281,27 @@ int mbox_send_message(struct mbox_chan *chan, void *mssg)
 EXPORT_SYMBOL_GPL(mbox_send_message);
 
 /**
+ * mbox_channel_device - Get device pointer of a mailbox channel.
+ * @chan: Mailbox channel assigned to this client.
+ *
+ * The remote processor can have DMAENGINE capabilities and client
+ * can pass data to be processed via main memory. In such cases,
+ * the client will require struct device pointer of the mailbox
+ * channel to map/unmap/allocate/free DMAble memory.
+ *
+ * Return: Pointer to the struct device of mailbox channel.
+ *	   ERR_PTR on failure.
+ */
+struct device *mbox_channel_device(struct mbox_chan *chan)
+{
+	if (!chan || !chan->cl)
+		return ERR_PTR(-EINVAL);
+
+	return chan->mbox->dev;
+}
+EXPORT_SYMBOL_GPL(mbox_channel_device);
+
+/**
  * mbox_request_channel - Request a mailbox channel.
  * @cl: Identity of the client requesting the channel.
  * @index: Index of mailbox specifier in 'mboxes' property.
diff --git a/include/linux/mailbox_client.h b/include/linux/mailbox_client.h
index 4434871..3daffad 100644
--- a/include/linux/mailbox_client.h
+++ b/include/linux/mailbox_client.h
@@ -40,6 +40,7 @@ struct mbox_client {
 	void (*tx_done)(struct mbox_client *cl, void *mssg, int r);
 };
 
+struct device *mbox_channel_device(struct mbox_chan *chan);
 struct mbox_chan *mbox_request_channel_byname(struct mbox_client *cl,
 					      const char *name);
 struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index);
-- 
2.7.4
