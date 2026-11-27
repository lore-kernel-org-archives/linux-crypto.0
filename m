Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795752280;
	b=bx13MXZgIkqmuaeXcGhwnfs3s3nwImZB9T7gqrN34G8O3RdXy2HNyK1HVI9qe+M9etv7
	 yCioZII7po5hdg0GTBGPNrWWXkKfQjFFMaMbzbazBYqszSIKn+Lw1C+edYvrLaOzUNvzY
	 E5Z/QIoptiKBVhQqki3URUcFrD53SVkNrP4GZwwgnWVopBu2+UqWUX65KGk+LFkD3vxGp
	 lrGDlLAVgCkHLtCkgb7KVZxbOokZxhpu4cXO6+11h2UGvQsmMaPvHdfJO2urUjvU2dxVR
	 qremLdzcXCNyR6t6V/gHIHHLULygVeEIzMnAaMqqHlYH1KIIucQuHkYPbb8N4ZCrIcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795752280;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0YWmiWhjNHjpD3tirbV+FoDaUJT2r9bLvjlZdG98TSc=;
	b=LM29lBaD6qMInU8/Td/+mVuzSqdRiF8AsyHsDF3aWuV88515fEY/g8pTgMHmj81oBLOs
	 Bl73MD0HA9hVfdUMk7Lq3hdNjdoB9ZoxZWm0BHmlSVzoF4R/zhrWyv4JDCpqxiBFTtAme
	 DziOse6u9u67g3gg49Vf7ZQsZ9EfRgkaQzf8ybLR0876DboRXy2T8VQ7qm5ANDGBulSLN
	 4MspXIt4oUQXuhcpUlztlOQvBNE474ZbkHy/v9ITBOduW1YVjrvUtYIUUmT7uqtvT494x
	 NruXlMl+U0qYEBBH8/cJSkkwq4P8EGQpLMQ15/3vHiohjlKLTQzk9+qIYtEhcndY13w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CpzL3puJ;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC3D606A31E
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:04:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEC3D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CpzL3puJ
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3b43d30822fso4049523a91.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 20:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795752279; x=1796357079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0YWmiWhjNHjpD3tirbV+FoDaUJT2r9bLvjlZdG98TSc=;
        b=CpzL3puJ5Wc58dYfpNNFmFFLSQFHgs7BPrzV/GoQLbwKa8HDq8HJC//w97UMP7LTw3
         4p/E0p/3huKzgFd/vYlm4XiIKLlkIhwTfq+P7//XNSUCJ68OkWSFeZiqUykMgLR5jbHW
         ubo87BCMpbLzCgy0fGv9fwXOrwTpiHTmYy0vHMIfGXUUv2TvC7oDagRyMck34XPVXToI
         aouzA5F96M52dxSqOqMb6MzV9PX0N7LEi9dNleNxSIbBpNWrCgPbPbXJIAysJNrdPK3R
         UvzoQNDW+DmtdJxqLOyAmpbYoHXIjG2Svr73n9o7Aqxk8/PE38KeRhBejPeZL12KAo4W
         XLVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752279; x=1796357079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0YWmiWhjNHjpD3tirbV+FoDaUJT2r9bLvjlZdG98TSc=;
        b=I3paAkOLYgg2aKHnHz3EKioxQQCgk6EJS3EfaCf8qUnL0B9JaMhVNmu0h+41q+wXhV
         6SsCAUAZfxQ32EBQP5iZI4gTFSlO0dkgGUcICfAnQqVEAV+Tsn7bjZDtW/W66UvRCmE5
         8wbCBgYrT8/cx7JKdsKl6vXXthA3F1B2CQpCxJ5PMAPrjRF4dlWn5zIsCPWmwSttt79Q
         vCMP6ZN+L/gkmX5TV4ALTi5r+UUJLWO99n5TrovkAyxdaUcouxf9RoXiLjZHjlNaJMUD
         Mz8zIvwDuJOcdSw3Yus8ugv9/eQnn1Vi/yd2hqoUYb6yT8tkC8Qkkia37FmNafp2Z/l4
         Rv7g==
X-Gm-Message-State: APuU4Z+p6/rz1fcaHTvKCvcIXy3MF/6QYGt0kLOubbf8M0DrCmzgS9Qk
	uI8r6yZ6nOLxvVa+l4GRFivnYgJJ3d3YlvKjZh2YRCVpWRJBqxmKGhzRDoXrNA==
X-Gm-Gg: AZFdTZcEnU5nh11YRk2rXVYUh7zQNanspmOhjaMTuTsfnFYoM4NnnRjurJugwH5q9NM
	FNtlMZn4bonw7Fs3kuwVY2zgjdMMOH1EhxJu352JZyuUYw5wYpuFM3Ugk2bHMpSBhRfT0pFCiBi
	9QhGfeWdgNeJZh80SWYgXpOV0Jq151XBjn/6lnQWTtstrKWmAaPZJyStsYj2+M7qn3DHP+5Rte6
	2HIPuMFsdB5Px8b2+rgrgzeJsW9AooBthAyeC45xOfhGEVDjQjhcNhiyRHnDNx9rvLGJL6YSC2A
	yti3ODdI6dfjS3nVIvkWR7ahHEqJ63fsS+17dHxw1BuDl78fzVH9BnLncZRwRuZhlmndZo2EoAU
	R8p2JVI+7CKhID2C25GMI1n/dSh+MxI4FD91UfsLlYnEkUQtoGTWIN0ce/g2K8IV0w6L2HX1h9/
	2W4BISYq1TFkoXAc1w468DZ4qZ0thVYzmLQye/ChyZPz55MERnc1FeatEWdPeHl15klBmyXE8oQ
	gyNZ9QVJIllUI9CpbmuZ/ivOa5+L7vPA7zgAF1CvQM3LEUJSfKJX9PY3XRgBnTwjwtP+KlGfxYq
	I8n/pCLAb4yssZ8ewuZDR7lZ3T+hmbRjPX3r5ql3k1kwaChvjblJ+CEZyy0ubWIg5zZgecx3s5P
	ZLq7wyR/Sz0qRY7qXYKLE0EFMyjuOomTeebys0jeSoQwu/BzkO/nCp+G+Lz2380wgS9EC582Abg
	bkKQ==
X-Received: by 2002:a17:90b:3d4d:b0:3b0:a511:fb75 with SMTP id 98e67ed59e1d1-3b41c95b149mr22273912a91.40.1795752279171;
        Thu, 26 Nov 2026 20:04:39 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b457a58d04sm15090652a91.0.2026.11.26.20.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:04:37 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Hsiao <jhsiao@amcc.com>,
	Rosen Penev <rosenp@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 7/8] crypto: amcc - fix the inverted AEAD error ratelimit
Date: Thu, 26 Nov 2026 20:04:22 -0800
Message-ID: <20261127040423.1023233-8-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127040423.1023233-1-rosenp@gmail.com>
References: <20261127040423.1023233-1-rosenp@gmail.com>
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

crypto4xx_aead_done() prints the engine's error status only when
!__ratelimit() is true, but __ratelimit() returns non-zero when a
message may be printed. The errors are therefore dropped while the
rate is low and printed only once messages are being suppressed.

Report the status with one dev_err_ratelimited() call instead, which
also names the device, and drop the driver's own ratelimit state.

Fixes: a0aae821ba3d ("crypto: crypto4xx - prepare for AEAD support")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 20 +++++++-------------
 drivers/crypto/amcc/crypto4xx_core.h |  2 --
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 4c1b76f28de0..8b070b7edcb6 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -588,18 +588,13 @@ static void crypto4xx_aead_done(struct crypto4xx_device *dev,
 	crypto4xx_ret_sg_desc(dev, pd_uinfo);
 
 	if (pd->pd_ctl.bf.status & 0xff) {
-		if (!__ratelimit(&dev->aead_ratelimit)) {
-			if (pd->pd_ctl.bf.status & 2)
-				pr_err("pad fail error\n");
-			if (pd->pd_ctl.bf.status & 4)
-				pr_err("seqnum fail\n");
-			if (pd->pd_ctl.bf.status & 8)
-				pr_err("error _notify\n");
-			pr_err("aead return err status = 0x%02x\n",
-				pd->pd_ctl.bf.status & 0xff);
-			pr_err("pd pad_ctl = 0x%08x\n",
-				pd->pd_ctl.bf.pd_pad_ctl);
-		}
+		dev_err_ratelimited(dev->core_dev->device,
+				    "aead error status 0x%02x%s%s%s, pad_ctl 0x%08x\n",
+				    pd->pd_ctl.bf.status & 0xff,
+				    pd->pd_ctl.bf.status & 2 ? " (pad fail)" : "",
+				    pd->pd_ctl.bf.status & 4 ? " (seqnum fail)" : "",
+				    pd->pd_ctl.bf.status & 8 ? " (error notify)" : "",
+				    pd->pd_ctl.bf.pd_pad_ctl);
 		err = -EINVAL;
 	}
 
@@ -1352,7 +1347,6 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	core_dev->device = dev;
 	spin_lock_init(&core_dev->lock);
 	INIT_LIST_HEAD(&core_dev->dev->alg_list);
-	ratelimit_default_init(&core_dev->dev->aead_ratelimit);
 	rc = crypto4xx_build_sdr(core_dev->dev);
 	if (rc)
 		goto err_build_sdr;
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index cdd40bb7d254..a8da46f5a44f 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -13,7 +13,6 @@
 #ifndef __CRYPTO4XX_CORE_H__
 #define __CRYPTO4XX_CORE_H__
 
-#include <linux/ratelimit.h>
 #include <linux/scatterlist.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
@@ -100,7 +99,6 @@ struct crypto4xx_device {
 	struct pd_uinfo *pdr_uinfo;
 	struct list_head alg_list;	/* List of algorithm supported
 					by this device */
-	struct ratelimit_state aead_ratelimit;
 	bool is_revb;
 };
 
-- 
2.56.1

