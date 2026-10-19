Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422877;
	b=LHhcm8OB5kuijtzeWXFCkwS5sl9pFDzZ7KYAg/BkGKbjfMFp/9DICI6ecXb9EfChF6lY
	 IUluuip4zLnNfFX70seWWv2sN5bmgdc2vYBfj421xyJc2ZtI3+/lfMSsqZWxtunfd546I
	 N30IUUNYTXhi5hOUdcxodHKzMPTpbht/SKNcZ82yDPreaQYVIxcN8d58xwyG9b5BtdwXz
	 YWfEORNKrQc8X84kbRxPTuMYz8iUpow+uwKTtMFFtNzXS3RzUZvts7DuyCKxHM7ALXLjb
	 acHG8H7o8ZOHnMn+Elyj7SJ12yI3Ay5v5KZez88dZQ79xlMkMdX3ghLy+6GKve+AMxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422877;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Xfhcl/tnBKhomUEe29FQKwdYefKI9CRM2uefptsw0PQ=;
	b=aXrYXvArFSVVFTVDmhfTW223cevpXks3wOomIYGTTJ5x9tzkhqxoIr2OKrqTKTQoobue
	 aTwMSWfWcADK/i+b/4HJSNcNBl6W08mnvpRMMEQJvO3omDEpOdhUGTf/0CxISJ+i71Tj5
	 kzY3dFa+WGcpOZSYqC7cTWlXoKuFO2NBRxknTaR88gfIpgF3AkOl7ZnJb8WVHmKLIPP65
	 6C19F5rI+QEb9nI0vl55tYZvbPipUZ83R4PNtOpNOMAV8zlZ0SQbK4FZX0Tj8T0yniQTb
	 BW6kSZ/Y2nw4NmsOEKhm+ViyJ1/8ah6QEl9evD4g54u2nAB447+Plcj4PwjlJdv7Orw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=W1AV22pg;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1301609CEDA;
	Mon, 19 Oct 2026 15:14:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1301609CEDA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=W1AV22pg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422877; x=1823958877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZfeOTfLcnNBlh1mE4JwdF2XkVLvyx9LjhRUEehl5Ikg=;
  b=W1AV22pgHv0bfeHCI/3v31eaNAG9w9jPC1AraM+rbzdilikpAY5l+2wG
   1bg98tgvFI2T8r5kwF9d+y3GycSmCc3jk/Xrd3OIEgZYnoxHd4C+NBOxP
   jYq5bPzNNVyyl/OjBCRc41a7DZsdrtL9vfsYmZPz31lWCLiJXwoqJeQnm
   K2hsDQgxyvh4Azp8Hg8dJ/CywYtNiT0T+2hWdNofBEyU3em68pnBdbWLw
   FQzslTVYi5sy/j0u1HcobIhxKrRjboGETXtpyJIBp9AwfnYjDl+b8FC2G
   Vd43qoIoLwgOBfJAh/it6mnaH0x9/AySn/dFeWgAIKavAbYnP/nhQHZCK
   g==;
X-CSE-ConnectionGUID: iSPUpAVAQ/SU3vqezAdwKA==
X-CSE-MsgGUID: skxx0iL9QxKLRW8wjUxMUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986912"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986912"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:34 -0700
X-CSE-ConnectionGUID: sqTnvNHVSWWuNkX5SQc+bw==
X-CSE-MsgGUID: 1FXx7HkYSCOjIsKMYbWG5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536966"
Received: from jf5300-15a101203tc.jf.intel.com (HELO meta-crater2c.jf.intel.com) ([10.54.113.49])
  by orviesa003.jf.intel.com with ESMTP; 19 Oct 2026 08:14:34 -0700
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
Subject: [PATCH 07/17] dmaengine: idxd: bound device command waits and fail fast after a timeout
Date: Mon, 19 Oct 2026 08:06:20 -0700
Message-ID: <20261019150630.4026341-8-daniel1.byrne@intel.com>
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

idxd_cmd_exec() waits forever, twice: first for a previous command to
finish, then for the interrupt that completes its own command. A device
command that never completes therefore leaves the caller in an
uninterruptible sleep, and every subsequent command joins the queue
behind it. Observed with a DRAIN_WQ issued from cdev release while a
descriptor sat blocked on a page fault that could not be serviced: the
releasing process became unkillable, every later process exit queued
behind it in D state, and the reboot hung until a power cycle.

Bound both waits at 30 seconds; a drain of a loaded work queue is the
slowest legitimate command and healthy commands complete in
microseconds. Only the owner of a command can tell that it is stuck. A
caller waiting for the running command restarts its budget whenever
another command starts running and gives up when the owner marks the
device, so healthy commands queued behind one another never add up to
a false timeout. On its own timeout the owner sets
IDXD_FLAG_CMD_TIMEDOUT, so waiters and later commands fail fast with
IDXD_CMDSTS_HW_ERR, and leaves IDXD_FLAG_CMD_RUNNING set, since the
device may still be executing the command and writing another to the
command register would be undefined. The command completion lives on
the owner's stack, so it is detached under cmd_lock on timeout, and
the interrupt handler checks under that lock that it is still set.

A timeout fences the device: every command fails fast and nothing is
freed. A late completion interrupt clears both flags, so a device that
was merely slow is usable again, and so do a PCI reset and the recovery
from a halt, which also forget the running command and wake its owner
instead of letting it sleep out the timeout. The owner checks under
cmd_lock that the command is still its own before it reads the status;
a forgotten command is reported failed and marks nothing. There is no
sysfs lever to clear the state.

The interrupt-handle release polled the command register under
cmd_lock, which idxd_cmd_exec() does not hold while its command runs,
so it could be written over a running command, and it spun unbounded
with preemption off. Send it through idxd_cmd_exec() like the request.

Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/device.c | 157 +++++++++++++++++++++++++++++++++-----
 drivers/dma/idxd/idxd.h   |   3 +
 drivers/dma/idxd/init.c   |   9 +++
 drivers/dma/idxd/irq.c    |  25 +++++-
 4 files changed, 175 insertions(+), 19 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index a461cae7a409..5ebc2c1a3859 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -12,6 +12,9 @@
 #include "idxd.h"
 #include "registers.h"
 
+/* generous bound: drain of a loaded WQ is the slowest legitimate command */
+#define IDXD_CMD_TIMEOUT_MS	30000
+
 static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 			  u32 *status);
 static void idxd_device_wqs_clear_state(struct idxd_device *idxd);
@@ -498,7 +501,7 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 	union idxd_command_reg cmd;
 	DECLARE_COMPLETION_ONSTACK(done);
 	u32 stat;
-	unsigned long flags;
+	unsigned long flags, left;
 
 	if (idxd_device_is_halted(idxd)) {
 		dev_warn(&idxd->pdev->dev, "Device is HALTED!\n");
@@ -507,21 +510,69 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 		return;
 	}
 
+	if (test_bit(IDXD_FLAG_CMD_TIMEDOUT, &idxd->flags)) {
+		dev_warn(&idxd->pdev->dev,
+			 "Not sending command %#x: an earlier device command timed out, device needs a reset\n",
+			 cmd_code);
+		if (status)
+			*status = IDXD_CMDSTS_HW_ERR;
+		return;
+	}
+
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.cmd = cmd_code;
 	cmd.operand = operand;
 	cmd.int_req = 1;
 
 	spin_lock_irqsave(&idxd->cmd_lock, flags);
-	wait_event_lock_irq(idxd->cmd_waitq,
-			    !test_bit(IDXD_FLAG_CMD_RUNNING, &idxd->flags),
-			    idxd->cmd_lock);
+	/*
+	 * Wait for the running command, if any. Only its owner can tell
+	 * that it is stuck, so this wait does not declare a timeout of its
+	 * own: its budget covers one owner and restarts whenever another
+	 * command starts running, and it ends early when the owner gives
+	 * up and marks the device. Several healthy commands queued behind
+	 * one another therefore never add up to a false timeout.
+	 */
+	while (test_bit(IDXD_FLAG_CMD_RUNNING, &idxd->flags)) {
+		u32 seq = idxd->cmd_seq;
+
+		if (test_bit(IDXD_FLAG_CMD_TIMEDOUT, &idxd->flags)) {
+			spin_unlock_irqrestore(&idxd->cmd_lock, flags);
+			dev_err(&idxd->pdev->dev,
+				"not sending command %#x: the running device command timed out, device needs a reset\n",
+				cmd_code);
+			if (status)
+				*status = IDXD_CMDSTS_HW_ERR;
+			return;
+		}
+		if (!wait_event_lock_irq_timeout(idxd->cmd_waitq,
+				!test_bit(IDXD_FLAG_CMD_RUNNING, &idxd->flags) ||
+				test_bit(IDXD_FLAG_CMD_TIMEDOUT, &idxd->flags) ||
+				idxd->cmd_seq != seq,
+				idxd->cmd_lock,
+				msecs_to_jiffies(IDXD_CMD_TIMEOUT_MS))) {
+			/*
+			 * The owner started before this wait and has the
+			 * same budget, so its own timeout is due; it marks
+			 * the device and wakes this queue. Give up without
+			 * marking anything here.
+			 */
+			spin_unlock_irqrestore(&idxd->cmd_lock, flags);
+			dev_err(&idxd->pdev->dev,
+				"timed out waiting for the running device command before %#x\n",
+				cmd_code);
+			if (status)
+				*status = IDXD_CMDSTS_HW_ERR;
+			return;
+		}
+	}
 
 	dev_dbg(&idxd->pdev->dev, "%s: sending cmd: %#x op: %#x\n",
 		__func__, cmd_code, operand);
 
 	idxd->cmd_status = 0;
 	__set_bit(IDXD_FLAG_CMD_RUNNING, &idxd->flags);
+	idxd->cmd_seq++;
 	idxd->cmd_done = &done;
 	iowrite32(cmd.bits, idxd->reg_base + IDXD_CMD_OFFSET);
 
@@ -530,9 +581,57 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 	 * the command completes via interrupt.
 	 */
 	spin_unlock_irqrestore(&idxd->cmd_lock, flags);
-	wait_for_completion(&done);
-	stat = ioread32(idxd->reg_base + IDXD_CMDSTS_OFFSET);
+	left = wait_for_completion_timeout(&done,
+				msecs_to_jiffies(IDXD_CMD_TIMEOUT_MS));
 	spin_lock(&idxd->cmd_lock);
+	/*
+	 * A reset, or the recovery from a halt, forgot this command
+	 * meanwhile, and another may be running by now. Forgetting the
+	 * command completes the wait, but it can also happen between the
+	 * interrupt's completion and this lock, or after the wait ran out,
+	 * so ownership is checked whichever way the wait ended. The device
+	 * is not stuck on this command, and the command state belongs to
+	 * whatever runs now. Mark nothing and leave that state alone, even
+	 * if this command completed just before the reset or the halt: its
+	 * status can no longer be trusted.
+	 */
+	if (idxd->cmd_done != &done) {
+		spin_unlock(&idxd->cmd_lock);
+		dev_err(&idxd->pdev->dev,
+			"device command %#x was ended by a reset\n",
+			cmd_code);
+		if (status)
+			*status = IDXD_CMDSTS_HW_ERR;
+		return;
+	}
+	/* A timeout, unless the interrupt beat the lock. */
+	if (!left && !completion_done(&done)) {
+		/*
+		 * The device did not complete the command. Detach the
+		 * on-stack completion so a late interrupt cannot touch it,
+		 * and leave IDXD_FLAG_CMD_RUNNING set: the device may still
+		 * be executing, so no further commands may be issued.
+		 * IDXD_FLAG_CMD_TIMEDOUT makes waiters and future callers
+		 * fail fast; a late completion interrupt or a device reset
+		 * clears both flags.
+		 */
+		idxd->cmd_done = NULL;
+		set_bit(IDXD_FLAG_CMD_TIMEDOUT, &idxd->flags);
+		wake_up(&idxd->cmd_waitq);
+		spin_unlock(&idxd->cmd_lock);
+		dev_err(&idxd->pdev->dev,
+			"device command %#x timed out, device needs a reset\n",
+			cmd_code);
+		if (status)
+			*status = IDXD_CMDSTS_HW_ERR;
+		return;
+	}
+	/*
+	 * Read the status while this command still owns the register: no
+	 * other command is written before RUNNING is cleared below.
+	 */
+	stat = ioread32(idxd->reg_base + IDXD_CMDSTS_OFFSET);
+	idxd->cmd_done = NULL;
 	if (status)
 		*status = stat;
 	idxd->cmd_status = stat & GENMASK(7, 0);
@@ -543,6 +642,33 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 	spin_unlock(&idxd->cmd_lock);
 }
 
+/*
+ * Forget the running command, whether its owner still waits for it or
+ * has given up on it. Called when the device has been reset or has
+ * halted, so the command can no longer be executing. A waiting owner is
+ * woken instead of sleeping out its timeout. It finds that it no longer
+ * owns the command and returns without touching the command state,
+ * which belongs to whatever command runs next.
+ */
+void idxd_cmd_reset_state(struct idxd_device *idxd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&idxd->cmd_lock, flags);
+	/*
+	 * The completion is on the owner's stack. It is valid while
+	 * cmd_done points to it, since the owner clears cmd_done, or sees
+	 * that it points elsewhere, under cmd_lock before it returns.
+	 */
+	if (idxd->cmd_done)
+		complete(idxd->cmd_done);
+	idxd->cmd_done = NULL;
+	__clear_bit(IDXD_FLAG_CMD_RUNNING, &idxd->flags);
+	clear_bit(IDXD_FLAG_CMD_TIMEDOUT, &idxd->flags);
+	wake_up(&idxd->cmd_waitq);
+	spin_unlock_irqrestore(&idxd->cmd_lock, flags);
+}
+
 int idxd_device_enable(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
@@ -644,31 +770,20 @@ int idxd_device_release_int_handle(struct idxd_device *idxd, int handle,
 {
 	struct device *dev = &idxd->pdev->dev;
 	u32 operand, status;
-	union idxd_command_reg cmd;
 
 	if (!(idxd->hw.cmd_cap & BIT(IDXD_CMD_RELEASE_INT_HANDLE)))
 		return -EOPNOTSUPP;
 
 	dev_dbg(dev, "release int handle, handle %d\n", handle);
 
-	memset(&cmd, 0, sizeof(cmd));
 	operand = handle & GENMASK(15, 0);
 
 	if (irq_type == IDXD_IRQ_IMS)
 		operand |= CMD_INT_HANDLE_IMS;
 
-	cmd.cmd = IDXD_CMD_RELEASE_INT_HANDLE;
-	cmd.operand = operand;
-
 	dev_dbg(dev, "cmd: %u operand: %#x\n", IDXD_CMD_RELEASE_INT_HANDLE, operand);
 
-	spin_lock(&idxd->cmd_lock);
-	iowrite32(cmd.bits, idxd->reg_base + IDXD_CMD_OFFSET);
-
-	while (ioread32(idxd->reg_base + IDXD_CMDSTS_OFFSET) & IDXD_CMDSTS_ACTIVE)
-		cpu_relax();
-	status = ioread32(idxd->reg_base + IDXD_CMDSTS_OFFSET);
-	spin_unlock(&idxd->cmd_lock);
+	idxd_cmd_exec(idxd, IDXD_CMD_RELEASE_INT_HANDLE, operand, &status);
 
 	if ((status & IDXD_CMDSTS_ERR_MASK) != IDXD_CMDSTS_SUCCESS) {
 		dev_dbg(dev, "release int handle failed: %#x\n", status);
@@ -1340,6 +1455,12 @@ void idxd_wq_free_irq(struct idxd_wq *wq)
 	if (ie->int_handle == INVALID_INT_HANDLE)
 		return;
 
+	/*
+	 * The release waits for a running command like any other command.
+	 * It is not sent, or does not complete, only on a halted device or
+	 * after a command timed out, and the reset such a device needs
+	 * revokes the handle. The handle is forgotten in any case.
+	 */
 	if (idxd->request_int_handles)
 		idxd_device_release_int_handle(idxd, ie->int_handle, IDXD_IRQ_MSIX);
 	idxd_device_clear_perm_entry(idxd, ie);
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 2343f0367d62..221a7302bb0c 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -267,6 +267,7 @@ enum idxd_device_state {
 enum idxd_device_flag {
 	IDXD_FLAG_CONFIGURABLE = 0,
 	IDXD_FLAG_CMD_RUNNING,
+	IDXD_FLAG_CMD_TIMEDOUT,
 	IDXD_FLAG_PASID_ENABLED,
 	IDXD_FLAG_USER_PASID_ENABLED,
 	IDXD_FLAG_REMOVING,	/* PCI remove under way, refuse binds */
@@ -332,6 +333,7 @@ struct idxd_device {
 	spinlock_t dev_lock;	/* spinlock for device */
 	spinlock_t cmd_lock;	/* spinlock for device commands */
 	struct completion *cmd_done;
+	u32 cmd_seq;		/* bumps when a command starts running */
 	struct idxd_group **groups;
 	struct idxd_wq **wqs;
 	struct idxd_engine **engines;
@@ -779,6 +781,7 @@ int idxd_device_enable(struct idxd_device *idxd);
 int idxd_device_disable(struct idxd_device *idxd);
 void idxd_device_reset(struct idxd_device *idxd);
 void idxd_device_clear_state(struct idxd_device *idxd);
+void idxd_cmd_reset_state(struct idxd_device *idxd);
 int idxd_device_config(struct idxd_device *idxd);
 void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
 int idxd_device_load_config(struct idxd_device *idxd);
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 4443d23fde5a..9c47a7b9e48e 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -1057,6 +1057,15 @@ static void idxd_reset_done(struct pci_dev *pdev)
 	struct device *dev;
 	int rc, i;
 
+	/*
+	 * A reset ends any command, including one that had timed out. The
+	 * PCI core resets the device even when the preparation failed and
+	 * the device is not rebound, and it calls this after a reset that
+	 * failed as well, which cannot be told apart here. Like the rebind
+	 * below, this assumes that the reset ran.
+	 */
+	idxd_cmd_reset_state(idxd);
+
 	if (!idxd->idxd_saved)
 		return;
 
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 915304ee7099..acb901e59a00 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -35,6 +35,11 @@ static void idxd_device_reinit(struct work_struct *work)
 	struct device *dev = &idxd->pdev->dev;
 	int rc, i;
 
+	/*
+	 * The halt ended whatever command was running, and a command that
+	 * timed out before the halt would otherwise refuse the reset.
+	 */
+	idxd_cmd_reset_state(idxd);
 	idxd_device_reset(idxd);
 	rc = idxd_device_config(idxd);
 	if (rc < 0)
@@ -550,7 +555,25 @@ irqreturn_t idxd_misc_thread(int vec, void *data)
 
 	if (cause & IDXD_INTC_CMD) {
 		val |= IDXD_INTC_CMD;
-		complete(idxd->cmd_done);
+		/*
+		 * cmd_done is cleared under cmd_lock when idxd_cmd_exec()
+		 * gives up on a command: the completion lives on its stack,
+		 * so a late interrupt must not touch it.
+		 */
+		spin_lock(&idxd->cmd_lock);
+		if (idxd->cmd_done) {
+			complete(idxd->cmd_done);
+		} else if (test_bit(IDXD_FLAG_CMD_TIMEDOUT, &idxd->flags)) {
+			/*
+			 * The command its owner gave up on has finished after
+			 * all. The device is usable again, so let the queue go.
+			 */
+			__clear_bit(IDXD_FLAG_CMD_RUNNING, &idxd->flags);
+			clear_bit(IDXD_FLAG_CMD_TIMEDOUT, &idxd->flags);
+			wake_up(&idxd->cmd_waitq);
+			dev_warn(dev, "a timed-out device command completed late\n");
+		}
+		spin_unlock(&idxd->cmd_lock);
 	}
 
 	if (cause & IDXD_INTC_OCCUPY) {
-- 
2.43.0

