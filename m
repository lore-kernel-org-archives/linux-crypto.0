Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850561CD1E4
	for <linux-crypto@vger.kernel.org>; Sun,  1 Mar 2026 00:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772325537; cv=none; b=FY+VsqGqncwRVzCc3CA7U00mEVYZTAse7zy18OCcA2yfEeS0c+wJEBLCp/PQr4N+RD+h1e0cneKTfD6SgiGleFriV372UKEZ8kEYVqAEValIWfu6s/YHKXhXSWj8keNerYwh4hT/QcA3NVMSvTnDnqXA91rmUwo2InQEfO/3Q0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772325537; c=relaxed/simple;
	bh=OHmVo15TSdmcb0W/CxHM4xD590wZw3GmFQzxGhO6Ggo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HyRGGQD5ovWZSBOZnrLZODph4LYmWSbyqPT7sRhaJ31AW6PR9gSWp9T7YFJPXtQB27cNdND0MyUn9O5iaLCaXZKis5F5h50nIjEme3+sRz1CYS+OBeHVWEhjxAkXJYKY9Khepc1+So6s3Fnp8/Wb7+h6lbCSwH60KeQtUPfT13I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iw0uEmv/; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iw0uEmv/"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-896fd2c5337so35632426d6.2
        for <linux-crypto@vger.kernel.org>; Sat, 28 Feb 2026 16:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772325535; x=1772930335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oodNt4bgrCfYwZH+9SQGVgA9ysM9wAmRvH33or2azLc=;
        b=iw0uEmv/3fUZXVauV+YsQwC0JMWmLmEDvR7BGejB1LpJCcVriAj1iD5i1yQ2DoWfjA
         N38/Bj3wNCBOQTrtCo7Je/jNekFWbTjaVY4gWygMw/JrnOsRBbVWwgM3+HCdn7luFNRz
         QCbLz0lREWUnlYUhcT509QG6b/d3ildUbtrladRiTsDYu3TXEaDkJIcKHwaljvfmCS1s
         xR/yH0pL0bp9w0KY8neveGV5Qd5eJLt4hibvPaD9AzTa02wmuBhOIPI9RehURfwEL+cK
         +V6Z5a1R76FMNrhoD2NYORpgrjLHIGaouUmKWvbQpy7vk1XlNKWaJbGqzr2Vww+vi2vE
         mMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772325535; x=1772930335;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oodNt4bgrCfYwZH+9SQGVgA9ysM9wAmRvH33or2azLc=;
        b=UU4w0Akr62kda9UGzFomRMm4LqpIJdFWgjsgcNPgwipt/luaUshU2jqgL4PhyIjIjy
         /i7v6zx0SHEFgGeD4I5MXMezEg0hecohTOxey50x8Rr3iumuy3hI5oRRvFudZo77Ejo5
         AM9QJZm+iT/JgoboD6ZzpOpCTkxqMoxRZ7UtCrWMeyVq50Ytskh1rylS3aj3cLhlDoW+
         e3aF1fnIHd0uGW0TV8GCfJLxY3d7/0iWzOBgJx+5v3cgsgOzBmScyYHiHPXCpu+rQI+W
         oDrjvFJDfELLvDpT8C1KXDdhhJxnmmRDdj43xzTjGNlUFoMSo6Z8JI3fFVqG9xDAdSCe
         ccHA==
X-Gm-Message-State: AOJu0YxoGPRR0wlMYhZP49GcfkavqhzlEuoqf+nYXujbXh/HdQknuvBu
	lTrsmf8tUyJl4BLbQNe8Fg5A2XmDZF4HVRco+Yn9+sTqVRV6XEGMTAqQ
X-Gm-Gg: ATEYQzzjZh6EhnNgwPKx9vWVviv8jE0XHR7GOXiXwECmgBTcaGIth2wT1Hloo+eWku+
	pCPzfDe9A9Cm2NWuffd/V51oQAqgLUImOoj/vkhOzzOEX4f/45qBcglPgdfyOtbSfhH3GW+cXka
	q5qQsavmu9bEHSNAoeolofV5qEd8AjPtSy2ILoSCPkkS9k+LXJ3tpdBHqBFb7jRNxSM8kJ4B/Mr
	lIzjVOgC2iXIEQqBLtXhGzeaIGp3R3kQhIIeWmEnJCW3qngMlA6Z/RdzwbOuu626IbN7JnLNR17
	SgQNRARopvdoqkmq7DAFVFtrYB1w5IDalaJFCycYQ3b1gzMSndzd2KbPCzLX+FTFUCwBwzEuzTg
	yyFC1UK+FckhEw91xiFA/F9Fd81sVW5SAqjoCVlZ3iIVR4wr+c1UpYstL88QiGWT52SnxAn7s5r
	UnTbJq0T/3P1YVqIwrmjgZPOwqo3AKyS+xR0VcjM/wr/nXQD25wqb84Z0T+y8bJv8QaPArEI7RK
	iLN
X-Received: by 2002:ad4:4c0b:0:b0:899:e9bf:3744 with SMTP id 6a1803df08f44-899e9bf3929mr23294736d6.63.1772325535538;
        Sat, 28 Feb 2026 16:38:55 -0800 (PST)
Received: from instance-20260207-1316.vcn12250046.oraclevcn.com ([150.136.248.187])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c7159b72sm76227096d6.7.2026.02.28.16.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Feb 2026 16:38:55 -0800 (PST)
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
Subject: [PATCH 2/4] arm64: crypto: fix SPDX comment style in sm4-ce-cipher-core.S
Date: Sun,  1 Mar 2026 00:38:54 +0000
Message-ID: <20260301003854.2504462-1-objecting@objecting.org>
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
 arch/arm64/crypto/sm4-ce-cipher-core.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/sm4-ce-cipher-core.S b/arch/arm64/crypto/sm4-ce-cipher-core.S
index 4ac6cfbc5797..32b93d542471 100644
--- a/arch/arm64/crypto/sm4-ce-cipher-core.S
+++ b/arch/arm64/crypto/sm4-ce-cipher-core.S
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 
 #include <linux/linkage.h>
 #include <asm/assembler.h>
-- 
2.43.0

