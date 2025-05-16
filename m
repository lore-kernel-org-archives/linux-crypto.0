Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099B7238C1D;
	Fri, 16 May 2025 12:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747397308; cv=none; b=hzJkMYJ8PfhA4hLmorSo1nuGBzoAwWNUxzZZR5f4GWYuR2rLYjmHBIRqxZOd7BS0cLVstPQnc0FXTbS3GCDKwnhd7vy79VVq0Mzxcxb0ZXw5gqKHtktxeDYntDz97h3VHiy/tm1j+aEpn/xm453XLFDLyISZcruO5MYH82uI82Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747397308; c=relaxed/simple;
	bh=LLFTaXnhleq34jL/n5gBjVlQjNQtKROkYDnqUvpqa5U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FPtK4UGFLx06E2jj8iJ8lgKMgBiPAInYPBvUC/Ex73QbD+gnYhNt8bJHPI/VXE6a6S++LXzUygugZzamXRWZ+9VhZbZ8lLJxdmOEouiAUuNSIvEDCl6J46n00pex3DwPeA1aok+25sT7jyh+/NkG08dpsavQaPi3lJccuqVMao4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i+9LraLU; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i+9LraLU"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so15204145e9.1;
        Fri, 16 May 2025 05:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747397305; x=1748002105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l7S/vG1lp5geqRglunYVLNLd5lLTAffxPlQ/qp918/4=;
        b=i+9LraLU+vxLQtPtNgarbmStQYEmWuOTuoxvpQRl/yiPpQhDXn9PdfgWT92Sje4+B5
         Egfat00fnh33qd0tgDLhT2OtlOvX0QI9KIrzkkmBc73Dx4Tm5i82EFOZ0hY1MaGdeOQD
         0vF7zUVYOle4JK6MUxY+CZZdZ2R7rIoD3wV15c5e6t2gDg9AxpNmdeG4WcfBKSvZCgm3
         R3AUdggWy1YcHppL5+KhmUmMQAECkR0qVTwWXJOITFbZ5WcBmWCxN8RWoKL2zSlDw6XL
         SW8W1hrw5IJkhvrM5JhirC9fRU0ZAFBSKFudSxAaDuc8NyrNmrJbo8lA6f6YzzThnDpK
         YRbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747397305; x=1748002105;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l7S/vG1lp5geqRglunYVLNLd5lLTAffxPlQ/qp918/4=;
        b=uQsZtH0ewakaqNDN4dpedQgMlyHc7QMZ06vYk5hA6UQsVawhgH7cZLUzskNpajw7AZ
         +KJVP6w+oAGlb0yPaea0NxOBDneWZyI4FvRLcZEf/5/4t0YuoYbFVrGrRoP26hBACK2o
         FdP2X0dg8X3qqQ3FCFTssal6stFEMHjnlYLVdWMUC0uLhhI/2Th8f6HeYvzU50gWKikb
         iSI4wNdWQlx7v9fHD2Qv9Y7JiGuNFYFEmI6Z9ioF1oH+gCxELckm3GF87EQMzYuc+Wyk
         xWjBJuriSfhq2P9Zimys7mH4G7RJBZ8SF5MPmGSx0EyCNKUz0TVrpERt8BvI7axEtJx2
         BUeA==
X-Forwarded-Encrypted: i=1; AJvYcCVKa9dtH638AxQ/baUR2FPCyxwnLtsDHIGAt65tzm9pvOQR5PmrQlquyLgc3Hj3zVJ/EKRgGK8YSR//NFN8@vger.kernel.org, AJvYcCWJLl9JZv8U+zvjtJe0bF73Qu0BRspPqcKL8Dyh+oofgl80wbDKjBl+uNlaxNNy4CWbiVjVqQhjYluxq3c=@vger.kernel.org
X-Gm-Message-State: AOJu0YypjvX3jFeQYMjx3ew1OLu6c2Y7lxWTs9uO4aKmGlMTWIuyatax
	YTFSG/O6dgIyefzcgdDacTXfNSUvM3oa+v9+ipFxx2jUPU0UM2pzSAWH
X-Gm-Gg: ASbGncvLoFBJZiUuHAA070ACAIDMkAY3Xb2hXmkR0o0H8OU6vYK7W2BwE16NmcRyuee
	MhnXcGuxBg6EHSRxNh5HG6TqDYy7Xxedkssm5OoERN72c6zmzmd+5pCHBklqsNHVadzzAfOYlgq
	T/LijH6Ffr53HMaXUiAQlKgHPSz0saVajmvNT6ND87qQu5Y5/ovGLFVXVNC/0G1Nfrdd2fWRa77
	TXSl8i1UO9tOoYqqamtKF60/nowI569Br/bRhygcohrnOVfh4O3sVDhcnExMfyv4YUaAdinCLCr
	ju3YGr6hckDpZyXUdPC/WeznEO6tGkaXmIOgDVhbp6a10xyP50q0WaY8ZnpQd9DfORZIf/cQfnO
	2fUY=
X-Google-Smtp-Source: AGHT+IETHNO4PZaxAV5fQzFYG7nB1lHUisZaUbqvlKR7l0R0thhXbB9LDnls9f0950ZGMS0nNFwq9w==
X-Received: by 2002:a05:600c:821b:b0:43b:bfa7:c7d with SMTP id 5b1f17b1804b1-442f84c2008mr72290655e9.2.1747397304833;
        Fri, 16 May 2025 05:08:24 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f07:610b:a400:6472:d2f9:d536:4c30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f338050csm102275725e9.10.2025.05.16.05.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 05:08:24 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH] crypto: sun8i-ce - move fallback ahash_request to the end of the struct
Date: Fri, 16 May 2025 15:06:56 +0300
Message-ID: <20250516120656.3610623-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct ahash_request' has a flexible array at the end, so it must be the
last member in a struct, to avoid overwriting other struct members.

Therefore, move 'fallback_req' to the end of the 'sun8i_ce_hash_reqctx'
struct.

Fixes: 56f6d5aee88d ("crypto: sun8i-ce - support hash algorithms")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 3b5c2af013d0..83df4d719053 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -308,8 +308,8 @@ struct sun8i_ce_hash_tfm_ctx {
  * @flow:	the flow to use for this request
  */
 struct sun8i_ce_hash_reqctx {
-	struct ahash_request fallback_req;
 	int flow;
+	struct ahash_request fallback_req; // keep at the end
 };
 
 /*
-- 
2.48.1

