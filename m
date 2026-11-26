Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721591;
	b=kBdAE5nVwN7rzzjM2akUTElIlWKiFKiZiDAWXjj7CCFgUDJkI/rmkhruaXIlvgh/EYhS
	 kZFH7H++5b01cdTqnVaNxX+8BJSBLoIDa6SCwnqvK0h9cPPCeqUHuyL+wc4n3uP51FOmP
	 l0fBE5lLSR2CPutOX57k3A3ZEXUvnSW5blxnQmTN++UJkoen05Al6RqubLE3CL7w3D13Y
	 iFB+Y6sC6f+ckxb5VNoDdpOEDKridjOOHcTS97sGa0I05J4n4z18Aqf0qG8MCAnNXZr95
	 p1/DCPS71ePAoVDbMqBeggcmkWjae9BTvpb4snzOFm1FlpDSQvlvRT+wWKeasy8EHYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721591;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4dPCbEZZdSDry+u4vUWC6GFpLLhoS8x3SOrFseRsQ00=;
	b=YV7hlRcJ/5iQnPEGHLE+tNSXmxSoA96QyavlkeSmzUv262AUd2n+MS70dRM83vZTbbKf
	 Mx0+tmVfFeLBFL5tOhzQ1kEqmQ8ZJ/ofoJb7yF2h65Q6A7TkvxtJ9vExruXgOH6Vvom1X
	 DwriLqszAK+gQdt3HFzq9wlW/EicNhebTWhw0t1nwCLsUj5JqftF5UCKZEstqQjOzLgHJ
	 l8NIkGavVYn22DqUfQFJjUhzIEQNVUxs+/nVrkLlQHA15ugSrhW95MdO80UVnWGK4taM0
	 Bz7Xb+lsPvxJMsRGK3BWY0FDLZ69utThwMuwidSh2uI/s/UQw132z1/83RqxAIJ7XNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mkpaz6UC;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A24606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4A24606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mkpaz6UC
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso52981605e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721589; x=1796326389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4dPCbEZZdSDry+u4vUWC6GFpLLhoS8x3SOrFseRsQ00=;
        b=Mkpaz6UCHOtGL6iPPYjQft730v22C3IhBySgtpMEtHkU5PkET0CEmjjITJvr2NTbuf
         Oyt1Vvb5LpjB9jrXbOtiHWOYBeaMXDESimUxWYA98si+fIorcMm/6hcRBVIbGkLZwq6O
         PYtMnmhb4zrXPRzmV5yjvGhkf2rtUn2gsqrTiRUrtrSvcKP6+1oTtwLz3yGPIu7VRuxw
         GPVozBl3QlumNvA2C+ZmCvw3AYWHXUNiS4yPraiX/aKUbdIAgBJOtv6vSzXECMeNTvvo
         XLIP6nx5VOXaSAyFOlCG4BbMbEtzT91si2co/MZyCSKHP8L5VZLf87ZVBDoDGAm1SWV3
         WjOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721589; x=1796326389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4dPCbEZZdSDry+u4vUWC6GFpLLhoS8x3SOrFseRsQ00=;
        b=lKc8X4ek8dEGJlewOBprlLDDX72KOWAYefuzhn+OjnfFbfxDkETyoSrA0lFoKNy5GF
         UY80VO2DzXANeYTBGK2b5069icMmbS3z6iOGrtB+e6ZPlCRe5Iy3Xsg0ZFdFpnvgw/Gk
         BoNMeCYXpwjN4bloipg8bBSaEA36bnX6lAwcsW42CdVXE/N1djeoqBxtuP/zN/5Zknpo
         s/VTZI82A8HJB8hcI1dUT4c7l/ezt+B0RohrkUNysF5w8cPUhlqx3m3Pkbtr9h8XE1tK
         I8ugr4glaW96KfBjQWMdP4fF6tM3NWF/vH97TMKwRiCY+XjO77oxcx283iBxB5E9uNkc
         nRbg==
X-Gm-Message-State: APuU4Z+sxXtBrS50IqqikzlmGwMwqRHa9Um5jdluLrRkV9HSbR+3eZTS
	xxDTJTDhJ8THBSebix8MP90U9NkxLkXK2dDsj4OX3fTBeiKd0yRbH97W
X-Gm-Gg: AZFdTZcMNxWymT1xm6H59fgIe7K+6zxUpUKHxgn81zb4T5R3sdRjeU21xZCIYo+tUt2
	XMo7qMFnNsd2aOS24zFd7kCr+di+N4EG4qdWmc3ikwNi3j9Dg90d0urt/zg2ld9z8MaPmAOL1SF
	pw/hMuWW+kpP0ygo9IvdYN6O3bXHRz4iiFBIe0fIQLUGGyG/nkwMR5TCdoRJ0spit+zWI+NdQ81
	hkbac1wqR+bPVifaR9PAgHTbZiHaR8dlxyS6awZrOE1COW6FGusxcgwoNuFZOEt7RJeGkdlVn9G
	bhVqDQ5rCrtxmOoVqlRJyJs0H1+3vbXI/4aDS0JPR6J21kDMO9RsM082D9jNvBiWXQMGww8V75V
	LLxdUuZ5K+aO6rGMbU6Xcag9e3cYYp79izVqEDeSPV7byA2EANslK31f/Tmq1C2qljurVPvi/j9
	4Nfp41U6gH6DxAoJ7aeVdPwfEXctImztKYJQ9YyL8S+U654mlEASYjRrxCpnPLQtXfM28KSD0Iw
	Op/RiaKKFr9c6IyWc+7H6YmR7kfIofsaSzybyxqBu/8C348dQonJSVwioeet7myyTCJ+bsBmMcN
	UVzAjjBSH7a5XlzzzKNi6z2DQLHOcIo9HqDt8SvPCqZQhg==
X-Received: by 2002:a05:600c:6219:b0:4bb:60b1:4409 with SMTP id 5b1f17b1804b1-4bb88816525mr432560755e9.19.1795721589007;
        Thu, 26 Nov 2026 11:33:09 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:08 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v13 06/25] crypto: amlogic - Add MMIO helpers
Date: Thu, 26 Nov 2026 20:32:22 +0100
Message-ID: <20261126193241.1471372-7-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
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

From: Alexey Romanov <romanov.alexey2000@gmail.com>

Add MMIO access helpers: meson_dma_start() and meson_dma_ready().

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c |  2 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c   | 24 ++++++++++++++++-----
 drivers/crypto/amlogic/amlogic-gxl.h        |  2 ++
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index c458548f29b2..62aa82e1cb5d 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -234,7 +234,7 @@ static int meson_cipher(struct skcipher_request *areq)
 
 	reinit_completion(&mc->chanlist[flow].complete);
 	mc->chanlist[flow].status = 0;
-	writel(mc->chanlist[flow].t_phy | 2, mc->base + ((mc->pdata->descs_reg + flow) << 2));
+	meson_dma_start(mc, flow);
 	wait_for_completion_interruptible_timeout(&mc->chanlist[flow].complete,
 						  msecs_to_jiffies(500));
 	if (mc->chanlist[flow].status == 0) {
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 37224d75edfb..b972df44e8b5 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -22,18 +22,32 @@
 
 #include "amlogic-gxl.h"
 
+void meson_dma_start(struct meson_dev *mc, int flow)
+{
+	u32 offset = (mc->pdata->descs_reg + flow) << 2;
+
+	writel(mc->chanlist[flow].t_phy | 2, mc->base + offset);
+}
+
+static bool meson_dma_ready(struct meson_dev *mc, int flow)
+{
+	u32 offset = (mc->pdata->status_reg + flow) << 2;
+	u32 data = readl(mc->base + offset);
+
+	if (data)
+		writel_relaxed(0xF, mc->base + offset);
+
+	return data;
+}
+
 static irqreturn_t meson_irq_handler(int irq, void *data)
 {
 	struct meson_dev *mc = (struct meson_dev *)data;
 	int flow;
-	u32 p;
 
 	for (flow = 0; flow < mc->flow_cnt; flow++) {
 		if (mc->chanlist[flow].irq == irq) {
-			p = readl(mc->base + ((mc->pdata->status_reg + flow) << 2));
-			if (p) {
-				writel_relaxed(0xF, mc->base +
-					      ((mc->pdata->status_reg + flow) << 2));
+			if (meson_dma_ready(mc, flow)) {
 				mc->chanlist[flow].status = 1;
 				complete(&mc->chanlist[flow].complete);
 				return IRQ_HANDLED;
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index 5149dc6e9f60..64f2f0e63f12 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -159,6 +159,8 @@ struct meson_alg_template {
 #endif
 };
 
+void meson_dma_start(struct meson_dev *mc, int flow);
+
 int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		     unsigned int keylen);
 int meson_cipher_init(struct crypto_tfm *tfm);
-- 
2.47.3

