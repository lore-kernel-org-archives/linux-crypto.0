Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC03520D4FF
	for <linux-crypto@vger.kernel.org>; Sun,  1 Mar 2026 00:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772325540; cv=none; b=fMFZRUAF1x4v7kR3HE7ymrMicMoctQp3wZ8H7dTOScHFlMvA/uiWtGPys3XxEheD2h7Es/dcR1KhTD6UTw6616FxfXeleU22+6JbDdbbHbcI8mF2yzE3+4MNrcQrpTHgOjMi5BbvpyuhQVXMmXVvRbwlSP1AJReae2BOfZ88TIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772325540; c=relaxed/simple;
	bh=YCcnbLV5Jw5wg7EJAPJFJ2ZH2B+63eL1PA3MEXUUTNs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hX2K8e8CYWLg6QJBBv1593SZ20JlPdT4LwcSm6s7XUd2sKePP7HA8ri9ZbVkuIeXRypHjvdhLaRf2PeVj05LR03p8SPy1QfoIAcTfH5AoUg2oWIFKnMlUEbZqSgbmmxpKZkxNSFzU/5WRjsT71XwdQjVDasMFFQc0YnGqic6g3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cHsaTmsS; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cHsaTmsS"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5069df1de6fso28999181cf.3
        for <linux-crypto@vger.kernel.org>; Sat, 28 Feb 2026 16:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772325538; x=1772930338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9CY9S+XfcmJA4+ujnIwwclN0Srt+SqHl5c79qw+b3VA=;
        b=cHsaTmsSrWIwL7FYCJ+lCWst1zzNN7kjPEQHQJvIL2fN0phXt2YqabODpOa3qcu+AD
         eQ3KfM68Fc2brVHP6gZ+OS27/EV2uI764IoU2nbSDaFhO69UiwBWEB+gBcm1qjAdvIxM
         vOG110fgwhV0SbjDu2A6bUiisrN0k+Q2rtSQuyFvV6kUTanJbOb4yNjsu5EZq0tECyfT
         3zzPcmm3t9F2Mea5njeVeipT3La0jAgcVyNRs8JsKRPx7iF9DlFpi5e4xJASHY2PE0cN
         BrSL9ftvwpSbcP2QmevBENbhV+PglZlVvRzUvscPisXsknyrdDMo093g0MkE1338w5Lh
         9JvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772325538; x=1772930338;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9CY9S+XfcmJA4+ujnIwwclN0Srt+SqHl5c79qw+b3VA=;
        b=ZMK1TJTlfXKdxqc4bO53mbFs7PlTI+nlF9R0ol777NN0YRhpeZnbM1SZzCK2jp2C0i
         KHbskw7mr2VXOBuKAk2G7JhjO6lLkTxmH30W6Q4v633xH2ka3ujANLNVHJ1xf0XXfgA+
         qQ9d5p9YoGciUO9H/H/f4UA4oGAvKBruwkGr8MWdqbD1muhoAznGjBI/QRg5g3VG6GUL
         UC4+JMkqvPOFq5mKilGTCTSEcSDR7Ase0iiksRXiysEPa3MqE3vuok4t3Vf9Yu71Y0/k
         Aat+7DE/zaRXE7lIuiOkRl8m7SGIcwoBmpXrSf+71zAEiwf2hnKU6BFsaVsCA93D2Eh6
         aUeg==
X-Gm-Message-State: AOJu0Yw8qp0jl3NRWAHSWdeYyrGLLpdXtF8OAAH1e8SMayXV+kzRx2ii
	ZmwZ57TOj/nZjINFOISWgWI1KkklNKenl/oanC1yfDIScklTSioGiyzi
X-Gm-Gg: ATEYQzzWWgYuPk2x3o/yWOvw64aNgTQ68KKxPGL77UJxwTPBOSWHyqlPCtdixmJMEjx
	KnRC1i0pRVEDufh9M1VcHH2RdG/wbLXjZpf4XDI0y2PLPng5wEAkTls8RZCNqVUobKLOO1igZq6
	sOnGupp7wvF7CVhIJ6V8f8S9mgziaRxtpI6C4U+R5SGaEzkhb2gqBqP5g40NaTqJcJJvcSLpP1i
	EFwt90hhQwYXPNfr/Yq20X2FPWNOih1BLee6jXqKi/Buu3hy3GICz+28bE05ZTpwF8vDPwpr8Sv
	+AXpaCkSstTrZwwlkesf4AQvjbTPjLu0D3e6PNrpvYVEpHErJIYhT7zBpQlXG97fHiKetCKQWXp
	IAznBppG+xy8mlWxEUOi9GkLkuMK8zG5N9FE32VTZn4Syxr3EX0nF83QLa/Y/JiGPpOIy0GB0E/
	BVhSkaYi0gaTyzIoHIeG68fjGLJ0LBCc3MdVTbRA617kPnP+4Zrp2ze0YIkURo5d+qE0sJF5iH0
	b4R1rGw3fTbXvc=
X-Received: by 2002:a05:622a:1651:b0:501:17b4:d559 with SMTP id d75a77b69052e-50752760149mr98477021cf.20.1772325537675;
        Sat, 28 Feb 2026 16:38:57 -0800 (PST)
Received: from instance-20260207-1316.vcn12250046.oraclevcn.com ([150.136.248.187])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5075feb4db9sm26610121cf.22.2026.02.28.16.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Feb 2026 16:38:56 -0800 (PST)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 3/4] arm64: crypto: fix SPDX comment style in sm3-neon-core.S
Date: Sun,  1 Mar 2026 00:38:55 +0000
Message-ID: <20260301003855.2504477-1-objecting@objecting.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Josh Law <objecting@objecting.org>
---
 arch/arm64/crypto/sm3-neon-core.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/sm3-neon-core.S b/arch/arm64/crypto/sm3-neon-core.S
index 4357e0e51be3..c232b716cedd 100644
--- a/arch/arm64/crypto/sm3-neon-core.S
+++ b/arch/arm64/crypto/sm3-neon-core.S
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * sm3-neon-core.S - SM3 secure hash using NEON instructions
  *
-- 
2.43.0

