Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.204.27.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592799;
	b=YXg3D/r84kOr6dJJB0m4dKDt07Uk+UekkdhDNCk0K45R9g7ltJUX20bMdRJT9CiSsjwP
	 3dt+LxlBHRJdORgTk+TmvJ4WDSlNOzmzrDVksTXdDfJZ0sEbVeNQU5ilL27W1pzw6+M+a
	 IGNm5lGS5q4fh42Kp8v6QXmfyoQNKH52J9V9wmR8ePxzQVnZV2ko7lFl9GfWxGUOzCVUv
	 2VK4q6Gf86Skhd+wgITgz4Ylt4P76dnpLl7tXzn3I884g40wz2JROliumnPRZ72KD4TUK
	 NuHVF9CA2x2GkwodRbQlTXNrMsiln+MI6+9imV3rAnebS/P3HA9ZW1rMMcqXUJ67udg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592799;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=EK4p4LMf18EOkIJI/axzmeCgFKsTmYxTizFC1QgWRhM=;
	b=Q9yn4NuPUHflsnuta6tmlhaL5QHpFOB5Ve/fdl3PwWdzyCup5v6jBU/qfk7D2AD0zTPF
	 DMYvdOzpLjb8ensFlNwcreY48tKnVP2+es3u7OjRTEhcR8zmBVoSu9FK5roxBlsQrZvF9
	 xlzegzxOVqrisTQk/PdCfQ27rz1Ajj5X9plsGPJQuc+zLkQnnXmQbL6BdL5AqFh/QndUM
	 lTBOkDQVPAvBArNdD541KOn8eR84oHn1oGecILK1yZlzBOoHgFllMYP9kta11vz05nb/4
	 SAxqzK8MAtNRbOtfHFVWZHcVNQn5jIxLi/2Pqbl0Az0EI31ixxdsDBfoS+kAm/+1r9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hygon.cn;
	spf=pass smtp.mailfrom=hygon.cn;
	arc=none smtp.remote-ip=101.204.27.37
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289A9606A33C;
	Wed, 25 Nov 2026 07:46:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 289A9606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZg6F4VzVcB7;
	Wed, 25 Nov 2026 15:46:35 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZg4rfdzVcB7;
	Wed, 25 Nov 2026 15:46:35 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 1215C157D;
	Wed, 25 Nov 2026 15:46:29 +0800 (CST)
Received: from hygon.hygon.cn (172.25.24.133) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Nov
 2026 15:46:35 +0800
From: Depei Yang <yangdepei@hygon.cn>
To: <linux-crypto@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Gary
 R Hook <gary.hook@amd.com>, <linux-kernel@vger.kernel.org>, Depei Yang
	<yangdepei@hygon.cn>, Shan Chen <chenshan@hygon.cn>, Yongwei Xu
	<xuyongwei@hygon.cn>, Xiaochen Shen <shenxiaochen@hygon.cn>
Subject: [PATCH 05/11] crypto: ccp - split v5 command submission from queue run
Date: Wed, 25 Nov 2026 15:46:03 +0800
Message-ID: <c2a7b7a4303dfd79e95a61658b33706a20bc58ad.1795588986.git.yangdepei@hygon.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1795588986.git.yangdepei@hygon.cn>
References: <cover.1795588986.git.yangdepei@hygon.cn>
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
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)

ccp5_do_cmd() copies one descriptor into the ring and immediately runs
the queue and waits for the completion.  Some engines prepare several
descriptors for a single operation and only need the queue run once.

Split the descriptor copy from running the queue.  ccp5_do_cmd() keeps
its behaviour by calling both helpers back to back; the SM engines will
run the queue through the new ->run action once a whole batch has been
submitted.

Reviewed-by: Shan Chen <chenshan@hygon.cn>
Tested-by: Yongwei Xu <xuyongwei@hygon.cn>
Signed-off-by: Depei Yang <yangdepei@hygon.cn>
---
 drivers/crypto/ccp/ccp-dev-v5.c | 38 ++++++++++++++++++++++++++-------
 drivers/crypto/ccp/ccp-dev.h    |  1 +
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 372ccf7d1c8b..f7c107b93ccc 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -218,14 +218,12 @@ static unsigned int ccp5_get_free_slots(struct ccp_cmd_queue *cmd_q)
 	return n % COMMANDS_PER_QUEUE; /* Always one unused spot */
 }
 
-static int ccp5_do_cmd(struct ccp5_desc *desc,
-		       struct ccp_cmd_queue *cmd_q)
+static void ccp5_submit_cmd(struct ccp5_desc *desc,
+			    struct ccp_cmd_queue *cmd_q)
 {
 	__le32 *mP;
 	u32 *dP;
-	u32 tail;
-	int	i;
-	int ret = 0;
+	int i;
 
 	cmd_q->total_ops++;
 
@@ -233,6 +231,7 @@ static int ccp5_do_cmd(struct ccp5_desc *desc,
 		CCP5_CMD_IOC(desc) = 1;
 		CCP5_CMD_SOC(desc) = 0;
 	}
+
 	mutex_lock(&cmd_q->q_mutex);
 
 	mP = (__le32 *)&cmd_q->qbase[cmd_q->qidx];
@@ -242,6 +241,16 @@ static int ccp5_do_cmd(struct ccp5_desc *desc,
 
 	cmd_q->qidx = (cmd_q->qidx + 1) % COMMANDS_PER_QUEUE;
 
+	mutex_unlock(&cmd_q->q_mutex);
+}
+
+static int ccp5_run_queue(struct ccp_cmd_queue *cmd_q, bool wait)
+{
+	u32 tail;
+	int ret = 0;
+
+	mutex_lock(&cmd_q->q_mutex);
+
 	/* The data used by this command must be flushed to memory */
 	wmb();
 
@@ -253,7 +262,7 @@ static int ccp5_do_cmd(struct ccp5_desc *desc,
 	iowrite32(cmd_q->qcontrol | CMD5_Q_RUN, cmd_q->reg_control);
 	mutex_unlock(&cmd_q->q_mutex);
 
-	if (CCP5_CMD_IOC(desc)) {
+	if (wait) {
 		/* Wait for the job to complete */
 		ret = wait_event_interruptible(cmd_q->int_queue,
 					       cmd_q->int_rcvd);
@@ -262,8 +271,7 @@ static int ccp5_do_cmd(struct ccp5_desc *desc,
 			 * moving the head pointer
 			 */
 			if (cmd_q->cmd_error)
-				ccp_log_error(cmd_q->ccp,
-					      cmd_q->cmd_error);
+				ccp_log_error(cmd_q->ccp, cmd_q->cmd_error);
 			iowrite32(tail, cmd_q->reg_head_lo);
 			if (!ret)
 				ret = -EIO;
@@ -274,6 +282,19 @@ static int ccp5_do_cmd(struct ccp5_desc *desc,
 	return ret;
 }
 
+static int ccp5_run_cmd(struct ccp_op *op)
+{
+	return ccp5_run_queue(op->cmd_q, op->ioc);
+}
+
+static int ccp5_do_cmd(struct ccp5_desc *desc,
+		       struct ccp_cmd_queue *cmd_q)
+{
+	ccp5_submit_cmd(desc, cmd_q);
+
+	return ccp5_run_queue(cmd_q, CCP5_CMD_IOC(desc));
+}
+
 static int ccp5_perform_aes(struct ccp_op *op)
 {
 	struct ccp5_desc desc;
@@ -1111,6 +1132,7 @@ static const struct ccp_actions ccp5_actions = {
 	.rsa = ccp5_perform_rsa,
 	.passthru = ccp5_perform_passthru,
 	.ecc = ccp5_perform_ecc,
+	.run = ccp5_run_cmd,
 	.sballoc = ccp_lsb_alloc,
 	.sbfree = ccp_lsb_free,
 	.init = ccp5_init,
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index ef88962ff6e6..16d5ea7773e2 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -659,6 +659,7 @@ struct ccp_actions {
 	int (*rsa)(struct ccp_op *);
 	int (*passthru)(struct ccp_op *);
 	int (*ecc)(struct ccp_op *);
+	int (*run)(struct ccp_op *op);
 	u32 (*sballoc)(struct ccp_cmd_queue *, unsigned int);
 	void (*sbfree)(struct ccp_cmd_queue *, unsigned int, unsigned int);
 	unsigned int (*get_free_slots)(struct ccp_cmd_queue *);
-- 
2.34.1


