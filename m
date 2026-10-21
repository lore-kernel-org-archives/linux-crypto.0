Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792584942;
	b=KY9PPGfC4ShlSMfBYpUFwg9GnMVVEkfsmSbD872IJ+p/7lKkvGekERHpjtq4sABi488h
	 wmh6S7X59OMxWADQ7qvOt8Q91inem7caIqF6EmqKTVh2IjE/Xme+AZpQa/VXXYHwbG6/S
	 oxXZRIWgkKYWdSvAltxd1s/+xIyxOp8+VUxBSce3r8m6fumsmZHntgesD4/RlVXi/Yly+
	 9ley3nWVgyKjLv24g3MVW8Ca94p1ZBNCMGqUe61FUJW3mHuRKfxHu10WN4SMzWfnZUMeY
	 /m5gi6+/ygNpWMc5bHv/AvXn5TL5h59/jTPyvXDTbnK0tJOXZnQ4mzl91St/nGZo+iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792584942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=QUsgGgZf6OKiFgye8YnCV2MQ6FxlmV1JYer/VdbmAtE=;
	b=r/viQQQW9YGbRa9Jy9xfCMwfNGO79WhH/m2iBJTsIVT9UPOZR2ZgKzcqpOV7gpHjDg2d
	 +SNMRN9bzrJMIJcwsNTajghgkrWFYb0WUYGQeKXL/T4i0Dwk8vLt/eHj+T423RHR5fV+2
	 EDwgdXRSFuISyuuTi/n3gzmBiDvVxQOnGoDOEDYn9XEJmGoSMW42nStzdexzz29VdfKuq
	 XYWQF0ubzEkYEjkvbvuuPO2yrY8LRJhHxMzFdEAJd1TTaB36OXDb3ABiPOOuVZXfvizC4
	 fl2fr3O/eqttqMkumDmfgYn+7ylO/TO8+TOFJoCeUFy7heu/5K7nHydJw0kzJKYsCww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ALkRgYOS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9825760A382F;
	Wed, 21 Oct 2026 12:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ALkRgYOS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EEE1F000C5;
	Wed, 21 Oct 2026 12:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792584942;
	bh=QUsgGgZf6OKiFgye8YnCV2MQ6FxlmV1JYer/VdbmAtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALkRgYOSOKObTXXyQsuGTQgv+LjV+bcSIidAea6KikNC6myOCM668wlHozP1QIcRX
	 3OGxJG+gE/gp7HQvJwvquMaoEMWQiDwyi4LoQOo9BBVEsfSVEm5l6yVgm0Z+X6KgOU
	 FvLeBwfrzxG1V9wmTHh4o2HXOPn3w6gbivJzTkLGzVTnficzQiMT3P1h+BjyZwSGZ0
	 bLUc6+AF8E26lCDImnoBVg1/+Xg9G+pKp+1EN15unra3K+FLEFj5QUXQ8PYpSSwsK6
	 ANKvj5eSSuMR1l0dfL/LKVN98oWzgjaplYJ5Ed65fkYWpM8knZVVjuWcnbd4Bc8td5
	 1wUkERrtrWDRA==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 17/28] mfd: loongson-se: Reinitialise completions and wait uninterruptibly for commands
Date: Wed, 21 Oct 2026 12:09:39 +0000
Message-ID: <20261021121245.3111563-17-lee@kernel.org>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
In-Reply-To: <20261021121245.3111563-1-lee@kernel.org>
References: <20261021121245.3111563-1-lee@kernel.org>
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

loongson_se_send_controller_cmd() and loongson_se_send_engine_cmd() wait
on se->cmd_completion and engine->completion using
wait_for_completion_interruptible() without reinitialising the
completion before issuing a new command.  Because the hardware has no
mechanism to abort an in-flight command once accepted by
loongson_se_poll(), returning early on a signal leaves the controller or
engine actively processing the shared command registers and DMA buffers
in the background, and its subsequent completion interrupt leaves a
stale completion token that causes the next command to return
prematurely.

Clear any stale pending interrupt status and reinitialise the target
completion inside loongson_se_poll() while holding se->dev_lock
immediately before notifying the controller, and wait uninterruptibly
via wait_for_completion() once loongson_se_poll() confirms the command
has been accepted by the hardware.

Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
Closes: https://sashiko.dev/#/bug/linux-4661fb0d-d936-4168-89cd-2f6dec31a7b5
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/mfd/loongson-se.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 485ee4a6ca5e..9b531e62fb85 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -37,13 +37,17 @@ struct loongson_se_controller_cmd {
 	u32 info[7];
 };
 
-static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
+static int loongson_se_poll(struct loongson_se *se, u32 int_bit,
+			    struct completion *completion)
 {
 	u32 status;
 	int err;
 
 	spin_lock_irq(&se->dev_lock);
 
+	writel(int_bit, se->base + SE_S2LINT_CL);
+	reinit_completion(completion);
+
 	/* Notify the controller that the engine needs to be started */
 	writel(int_bit, se->base + SE_L2SINT_SET);
 
@@ -66,11 +70,13 @@ static int loongson_se_send_controller_cmd(struct loongson_se *se,
 	for (i = 0; i < SE_SEND_CMD_REG_LEN; i++)
 		writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i * 4);
 
-	err = loongson_se_poll(se, SE_INT_CONTROLLER);
+	err = loongson_se_poll(se, SE_INT_CONTROLLER, &se->cmd_completion);
 	if (err)
 		return err;
 
-	return wait_for_completion_interruptible(&se->cmd_completion);
+	wait_for_completion(&se->cmd_completion);
+
+	return 0;
 }
 
 int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
@@ -80,12 +86,15 @@ int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
 	 * where to obtain engine commands from. Now all we need to
 	 * do is notify the controller that the engine needs to be started.
 	 */
-	int err = loongson_se_poll(engine->se, BIT(engine->id));
+	int err = loongson_se_poll(engine->se, BIT(engine->id),
+				   &engine->completion);
 
 	if (err)
 		return err;
 
-	return wait_for_completion_interruptible(&engine->completion);
+	wait_for_completion(&engine->completion);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(loongson_se_send_engine_cmd);
 
-- 
2.56.0.218.g1ec904b173-goog

