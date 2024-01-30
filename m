Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A456D66B24
	for <linux-crypto@vger.kernel.org>; Tue, 30 Jan 2024 11:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706614078; cv=none; b=jDHSMSlOzD6eYQzKBmPsjWs6kB+LqCcbu21RPY1Sq2bDXk+M7IAWg5ujONi/TeSlPaQooN2OTUwVUbBsmaJ+wJYXFIPwNaxkNcxsrxJaQrkKSyIYvRnHhnnAgOOPjoh9wBtnikETbA3VZ4wBWI93V8nMn7o6cU5LvL+fjCn/HPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706614078; c=relaxed/simple;
	bh=VJ3WxFyUH1QX/R2FezaIZrc9SHd0VxU+WMrUCCCzWbA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Miy1b7Ehw9OeqMWfa9IIpLpa1TDboLyfFLnZ4GSuhFWYlpX6n5BUMNICH8Q9/WRNuHeXG+XX8KiW27fPLaj9IuFQg82z1OGWhdeAqF7h2fSTEDtke9EjiVtf6be7CliL8BchV+G6WK6pVN8zPUnfY1gqjqQO+tm0duLDfFranfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Zhe7aujY; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Zhe7aujY"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d8cea8bb3bso10126795ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jan 2024 03:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1706614076; x=1707218876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NFz/ioS5pMtmsywy9UOLGQH2uroA4Qw/qVk4L7fINX0=;
        b=Zhe7aujYvlLHVtXJZ3kv02iCcmFKPV5YO9MbmC0Mk12po2UQlDHCIGXR+EjbhYwQLU
         Wa6IatPOH2E73/nhTv8SCStzr8X58TvEgcnKDd9kOn4uVIIDtbH8NTdtR9Jg1WSEOhMh
         rmJZuCyJ+qS9UDHBu/miZ/kDCu1+7+xbK8PwDsK5RqzJi1Jgb+ObXi8T9KnpdSewo0Uq
         4eFeSd348K4Q3lRNCH9aQmZLwREmG6G534N/sQNvbyf7LgXMHkw/uhhHuKLErvmre5yg
         /5WvLUMAgIZUhLxgmOf1gHazivLfcDnCp6wXI51bKvcgPiG8ons+6yNYHmK6VbAMQ7JL
         bQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706614076; x=1707218876;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NFz/ioS5pMtmsywy9UOLGQH2uroA4Qw/qVk4L7fINX0=;
        b=VxMt3aVFceNMCsBj2Rh3r1dLfmDeszr8vPax3Lsy643Ie+f2csNCYEuJZawFBBvAI/
         ei0rFIs/WFk75trY/OH84S+SD45JSqv9dGFH24eq3KhfmB5gajKxh66CcIxAmFa0ioSx
         3KnppzsSxf8jYhYfZ9N9NE/aTNuM1q2fNIs3svJxCj1rVUUfkrqpK9GFaPvyRYu/dY6P
         rfOzuSy4BHSs6Y8ZH98hfD+W3cE6+8HkjC3epFW+MGq+65yvb5ZTkxMb8fOkQx8gTpao
         VP5GqNmxVHDZFdbZNFmtsgL2a7T7mDg0y6mFLgmCoR39cC09bTu1LaRLAXdA0ZLQASjX
         /Zjw==
X-Gm-Message-State: AOJu0Ywlu66qP/WRFDaXJC8jWJ13hB0RJLy1ivZLBEleMM+Zm3EkDxjU
	ovwUeHglO5nZ3gwOAXkHGTaH4vExrbxdyVTvR1SWZ9Tow3G6bRD03Co04ffYjrQ=
X-Google-Smtp-Source: AGHT+IFxYQYsZlp0TH8j7NTAhzYbg+/UE/MPq1RYMFL1zOTZBo9xa9ES0Z1wEP85nypj79LLuQ20dw==
X-Received: by 2002:a17:903:2692:b0:1d4:4e13:6b59 with SMTP id jf18-20020a170903269200b001d44e136b59mr4044993plb.45.1706614075892;
        Tue, 30 Jan 2024 03:27:55 -0800 (PST)
Received: from always-x1.bytedance.net ([139.177.225.226])
        by smtp.gmail.com with ESMTPSA id jz6-20020a170903430600b001d74502d261sm7002041plb.115.2024.01.30.03.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 03:27:55 -0800 (PST)
From: zhenwei pi <pizhenwei@bytedance.com>
To: arei.gonglei@huawei.com,
	mst@redhat.com,
	jasowang@redhat.com,
	herbert@gondor.apana.org.au
Cc: xuanzhuo@linux.alibaba.com,
	virtualization@lists.linux.dev,
	nathan@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	davem@davemloft.net,
	zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH] crypto: virtio/akcipher - Fix stack overflow on memcpy
Date: Tue, 30 Jan 2024 19:27:40 +0800
Message-Id: <20240130112740.882183-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sizeof(struct virtio_crypto_akcipher_session_para) is less than
sizeof(struct virtio_crypto_op_ctrl_req::u), copying more bytes from
stack variable leads stack overflow. Clang reports this issue by
commands:
make -j CC=clang-14 mrproper >/dev/null 2>&1
make -j O=/tmp/crypto-build CC=clang-14 allmodconfig >/dev/null 2>&1
make -j O=/tmp/crypto-build W=1 CC=clang-14 drivers/crypto/virtio/
  virtio_crypto_akcipher_algs.o

Fixes: 59ca6c93387d ("virtio-crypto: implement RSA algorithm")
Link: https://lore.kernel.org/all/0a194a79-e3a3-45e7-be98-83abd3e1cb7e@roeck-us.net/
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index 2621ff8a9376..de53eddf6796 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -104,7 +104,8 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
 }
 
 static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher_ctx *ctx,
-		struct virtio_crypto_ctrl_header *header, void *para,
+		struct virtio_crypto_ctrl_header *header,
+		struct virtio_crypto_akcipher_session_para *para,
 		const uint8_t *key, unsigned int keylen)
 {
 	struct scatterlist outhdr_sg, key_sg, inhdr_sg, *sgs[3];
@@ -128,7 +129,7 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
 
 	ctrl = &vc_ctrl_req->ctrl;
 	memcpy(&ctrl->header, header, sizeof(ctrl->header));
-	memcpy(&ctrl->u, para, sizeof(ctrl->u));
+	memcpy(&ctrl->u.akcipher_create_session.para, para, sizeof(*para));
 	input = &vc_ctrl_req->input;
 	input->status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
 
-- 
2.34.1

