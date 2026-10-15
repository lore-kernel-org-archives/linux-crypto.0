Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8196D2F39B5
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 02:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792032118; cv=none; b=jUGzYIw8iZMK7EPtuzhDzGVLlvBSjybIwzY670JBX+fgxjAKLBc0I31NitS4l73g8ZqGjaSbK2xxtGy8xxcs/BBGadCkOCsYzd2qf2eNW1YMJ7mIuLKjnQ1zGu9RB6TgBgd5fbdoyeNRVU8bULQKS1GoI74EvjTn/2J2QhD2ZBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792032118; c=relaxed/simple;
	bh=oyq+VdzzYbQeA1Lm/IgIDce3G05vQ/QM3uthVUVYaqs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iCXQdQm5wexp9XduZYntmfkIpfBNdmPU4IqP/QX3s00u6niPYvB1+B3zMfXFS75FUETctnPmZrFIw/NAgi4sFH/qaQgGEcmMhX/jqAMwJkns9vXSXrfssekDkzYhfA9PNEEC8eqsl8MXjT6sthbpUhrBRodAPalmq1h/Nke9JqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lHR8H5cg; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lHR8H5cg"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5350c1b9e0dso11631191cf.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 19:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792032114; x=1792636914; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YTqPyeSiS9COwId/RRKFhimUZVSM+7caPHhUGbIiHuM=;
        b=lHR8H5cgljq4mP8UTaPi0MtV+UiQIUVZDngPYVqdwgdgp0KppmXRKZubJE2NHt818v
         VuhMY+FpBwWg1A9tiTWuPpOf0g3z54c3z+R52YnVUn4FnczEBJI++W58gsQzfX+P/efU
         MbePUR5X7JyrDJVzB0TcYCMo35me6VUHlMBHsIEQFKuCCEC/US76zIYE81U/GSANBg7M
         JixhjzTsTmmmPmfrxRAMa8V4knaUs2oU+gjXeQNpfevQ5RSvJzS7SPb8SyX2A58hfne7
         MB4qp6aY8R7yL+5FvoVl94FoQtyC2aR4utI/xowFK7kg8FV3zYPzuDcJV0tBzdwrqPVf
         OvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792032114; x=1792636914;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YTqPyeSiS9COwId/RRKFhimUZVSM+7caPHhUGbIiHuM=;
        b=osL/lEO1zNtBH+DWBCqHCU87XlSxvL5Fj5MFlmRfpkiZF5J8vwzyzwFdCP18eUduT9
         CAoNW1Le1Dt8dvwUoUFiGC7Wa/83vxkquZm/qkBflvG8bDkI0qpW1dfBcJdrEn6z4mVm
         B/0/UNXeu1OuW81LRnrTBBZ707+TbMjC46gXgea2xhgndGDqP4fRY8ZuQ4FPJn4gclRO
         Cz3B3fJ+DOyPK9bhiv0tQEPlBZmSuJkpNGKGrpyuhzVgFSzK7rikU8TquTBQKW64ve8a
         R+tS+2GbrVEdTNwgJ/zhCzIBisexm5RLdPpXBJhpQFi+1Zp2EshIX5hWNBIqlefxoa9U
         ZRsg==
X-Gm-Message-State: AFq9FYLMekgh6oWxpExKTOLsDyIKzO7GLrG825dg8wWNIz+2HMjJUZQ5
	AhMvI1OOTr+iqyTac/PoJyC0anZrQAv4IZGE+EggsqXbOwXuI7dMhZE=
X-Gm-Gg: AYBFou0LDrdUDaO0Ek1xzS22N+FN0teGtvJ0anwT7PA9wDBZfx5ueH09HsIx6q3H9E0
	0KLK6RxcaM6IX9zCuxQ6I4kquXjUWJOjblYypjNgO6fthNCgCX+W0I/LpUTPN1vzOWcSHB17P2J
	o6kwi1s66yOiWtaMBWPbNrzB2x4cVAeBb6rQ4mdAm0ZtwTT0KjsrwXiEoRyvYGCR20Db9EUC1lD
	gNTX7hxKoJviUUIVv4bPC2zh0p7oqLnEqzXQDiGobFeOXaURTGhZgU3AqSl6JXheOZZj/BUkyaY
	x5VgUKP5Zv8USJWq6s4mDHBUlu6OzmpAZeE2dymBqGZD+4qRXUCp2r6MyjU9qYpayp7G71sXkfJ
	RnTW7ar/lsklp0NMTzlaOwp1bnOsG8Z2vbw8ctbWB+Io4KbFl5mDjP+rIk8d0/HeWAbnaTdh4I9
	Er+Nm/UT6VzOa0LSx7wiy5HRBCpp69z3H49Hoj/H+0nvmlMWr3HxzFk7ZwOn04uEMqgf7JXQ2Od
	6C/aOrse+oLBoSQ1wsKZTplCTNwGNL/+4odsBo3SUN3Axy/zy2qg4sezXat1zyZuMWFn95uBWvE
	r5WDZy4SRt+3XazmUdvRGKemw5gT
X-Received: by 2002:a05:620a:28d4:b0:93e:f5bd:7e13 with SMTP id af79cd13be357-93ef5bd7f23mr1294170685a.64.1792032114246;
        Wed, 14 Oct 2026 19:41:54 -0700 (PDT)
Received: from i4-gl-tmk5904-1.ad.psu.edu ([130.203.156.90])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50b6c4fsm644965685a.47.2026.10.14.19.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:41:53 -0700 (PDT)
From: Myeonghun Pak <mhun512@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ijae Kim <ae878000@gmail.com>
Subject: [PATCH] crypto: amlogic - Free channel IRQs before disabling the clock
Date: Wed, 14 Oct 2026 22:41:48 -0400
Message-ID: <179203206852.2659709.13834828335447558448.G3@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

The channel IRQs are requested before the managed channel array is
allocated. Automatic cleanup consequently frees that array before
releasing the IRQs. An interrupt handler that has already read a channel
completion status can still write chanlist[flow].status and complete the
channel completion after the array is released. A cipher timeout allows
such a late handler even after its crypto engine becomes idle.

Release the IRQs explicitly before disabling the bus clock and before
devres can release the channel array. Do this after crypto_engine_exit()
so normal requests retain their interrupt-driven completion while the
engines drain. Use the same cleanup on probe failures after the clock
has been enabled, preserving the channel allocator's existing unwind.

This issue was identified as part of our ongoing research while
reviewing kernel code.

Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
---
Compile-tested with GCC, W=1 (arm). No runtime testing.

This bounds IRQ access to completion state and registers; hardware DMA
handling after a cipher timeout is unchanged.

 drivers/crypto/amlogic/amlogic-gxl-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 169c6ee..333db2e 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -136,6 +136,14 @@ static int meson_debugfs_show(struct seq_file *seq, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(meson_debugfs);
 
+static void meson_free_irqs(struct meson_dev *mc)
+{
+	int i;
+
+	for (i = 0; i < MAXFLOW; i++)
+		devm_free_irq(mc->dev, mc->irqs[i], mc);
+}
+
 static void meson_free_chanlist(struct meson_dev *mc, int i)
 {
 	while (i >= 0) {
@@ -291,6 +299,7 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	meson_unregister_algs(mc);
 	meson_free_chanlist(mc, MAXFLOW - 1);
 error_flow:
+	meson_free_irqs(mc);
 	clk_disable_unprepare(mc->busclk);
 	return err;
 }
@@ -306,6 +315,7 @@ static void meson_crypto_remove(struct platform_device *pdev)
 	meson_unregister_algs(mc);
 
 	meson_free_chanlist(mc, MAXFLOW - 1);
+	meson_free_irqs(mc);
 
 	clk_disable_unprepare(mc->busclk);
 }
