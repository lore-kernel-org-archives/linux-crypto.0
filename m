Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793097467;
	b=jemsbqNvGabMhwIXJ5eSCPP+QUfjMnXaSjGMyecXme3v2wQX+qyRKm4bG98tDvDmIn5k
	 P8yyoPvds9BWJIq3uNHBZbHIwv/xYxTiKTJpu4SWSNEENSrFZ57tzLi6OPz8YgFg65MCx
	 xX84ZRD5qEy0ZRTXzCAdOn1H2w6TSbyxBt3R86y65AkE9ObQKiBHcJmq3qeoyz+ZOaFmc
	 w/svhSH7pU8sS/H+p8DG7jVxFeaDKY+GF6ZlojBCc7YFK/MigqsYJ4eAn5Yy+BqvoZzLe
	 qUCcf/ZkT4+GBl9wlalsLPNfSqFSaQufBVklaJvJihO5xkpU3LBYXL+OCtw1NmJkl3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793097467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XCl8iviRK+xYf6qhYiYyI322lQKeAYzckrhKkqKHZhE=;
	b=0fqwcBEl0HcZXQGv/IHPM8m5Zt8ys80SUridSBowk6txGKlpDzpByaYKdDxV+YBxd+e5
	 4X6MIxLikFlLL5VRUngrdzP2Q6kSYms1yg67dSTE6NTsUriszxSTG75bVrWe7qlnhD0B/
	 e1FZiTGMBfsZIWwPZm7ssO759ljNWptiXkuoPmemh2V3JCS00V2ArvaGWGB41hQTCOyaT
	 fh2zmh85SkODPesB3s82J0owAIjIn6s38OU6HENLD6uB5nHVzICL+not6jdDdh6bun2vR
	 M31aC13ctEmT+wQJv05NvsZiq+18xvbBqGfxR9KrM8iMIK+rmTkk0QTYBNUuW7mJhhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cnZGeK32;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F859606A31A;
	Tue, 27 Oct 2026 10:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cnZGeK32
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34441F01825;
	Tue, 27 Oct 2026 10:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097467;
	bh=XCl8iviRK+xYf6qhYiYyI322lQKeAYzckrhKkqKHZhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnZGeK32ADODk0MyCEjnI6Aka2LL3n6piyqaRr+n9XfEhiEEIpe881sAhQz3FiM3J
	 7VVannduowDqkE5QVdtXYNUPw7baklppelB8xopQ9NzDfeVnzlLsjjJbzzZNhpq9gx
	 r+AagwRHb1iKM+jQCmHcsAPkK7NseLZSYKF0Yqu4ia5k6flKNx52QYEgbwMNFFHM0x
	 OHirr/ifB0nygnG3u5+R3FzpkWJyxaTqSXZya24CHgMyXOYgRDuZJ02/x0mtBCsrhk
	 5gyTTSaZzFfJGdXQLMZjyrZugxNHvii0MwE7W316oRyK5qFxMAY0pBqIhhNB4P9RY/
	 5JIEC0BmoL/lA==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 16/27] mfd: loongson-se: Reinitialise completions and wait uninterruptibly for commands
Date: Tue, 27 Oct 2026 09:30:45 +0000
Message-ID: <20261027093306.2812695-17-lee@kernel.org>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261027093306.2812695-1-lee@kernel.org>
References: <20261027093306.2812695-1-lee@kernel.org>
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
Reviewed-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
Tested-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
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
2.56.0.307.g5fe7bd680c-goog

