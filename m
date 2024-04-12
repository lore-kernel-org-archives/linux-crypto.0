Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE49610B
	for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 21:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712957435; cv=none; b=nMk54s+Pz722Il/7y1p43psRJHFs2Ur7zzNny8e1vdqE6ifkatNsj+276iIK9vdkeMBSsUwdbB7ezgrwdFU6HURPQZirRBM6nHBCPDt4eLaO+WH6v2ZAVRZohC06G8JNC22Q9MrlUJ9INJzXbrTt3TENKZbRggOYh9O5QJX2AuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712957435; c=relaxed/simple;
	bh=urpF+uhnagsRIlmCvAoqVf0cSl1JhJfWoktomJ+ip1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzJCFUdBGjRdy4B4LBbOfjM9qXY6+80mndtmASFylo6pGw0MfdO4xxXc++y30iakxUocltUjR4P75CPuUMAVWU2A5dznd0qBUop6xtACsxRHe1FOJdsQJDIzDLzdWNwhuzH3g4wL6q6R68uubKHwLcV3fyO70DcFKLDSnwbTtsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=bI4v0Zah; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="bI4v0Zah"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-417f5268b12so12336155e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 14:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1712957431; x=1713562231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxzVOZoRlwbh3BCja72w8JfT19aYOorMwhFDDTCvDh0=;
        b=bI4v0Zah4boCHWG6A4aSzMr20nJi3Dsbj6+Dn6RKBVt7zAvkX6RF6MtSiobxe6Ug9q
         YB1vDiHSn7xKsWTCMRIXQNbAnrrse4jpfVRBVjmbSVBinutc0spid/vGTJc0Slads/da
         gFPG0Q6Tj5bAvc96uPCStpYP2WHnGh0h99dDxTk5IRqULMMzyb4P6ab+6hIyJX3Rp0b5
         p+UxDR107+WTXxEdqRohyL/mUPoNdUU4PtfElwzi2j4KimUDRry2bdlw6k7FB5Gaa8yx
         DoMhVScHuObGsshwjr0G5/nXookWTdwbe0d5gTzlg1fCS0eD2Ffqid15P6sxZjVrtmPf
         g8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712957431; x=1713562231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GxzVOZoRlwbh3BCja72w8JfT19aYOorMwhFDDTCvDh0=;
        b=wiQ8ouzmwvE6VheKGB3vTRHx1ikDPxRNFEPCZCF1OArhYDqOqJXbdzsVqQTkzLnTxp
         ld69LJtUCtmDoE1cu/BlJlWoCfR6Q8DbuSEUE6/26YVa5msjYXpO5h8K6YoaC4iRZfgw
         s1aTEqtp0pc3L9hTy3A0uuL4XnKHsC7sVaiu5gemVnoYCYZTNnZ0D83NFkA9V5/92ByP
         OGsbQ/4o3UUhct47n8s8JJ5PHJe7ehY63mXzQhN/TNU3dNjJMX9Z87j6n8eM+kzfhWhi
         3jA6wRLdxEyIXf1TBUMRpYpHWxjVIgkosuJYhtMh6bbR/yHwUKrY0Gpn6HTpJSbXey6f
         3kgw==
X-Forwarded-Encrypted: i=1; AJvYcCUL2TrxY84tl8fnB8T1YyphQpFlSeiLpaOg5DZoCSftbg29kpQAQw600+rPajOOKUjAnZ9r6kYEba+ibR9W8UInRje/tZ2AasnmiRNs
X-Gm-Message-State: AOJu0YwvPRQD29YAZoNtpXCV7/cmaIAmSFCtFe3fn3WfD7o4xtfkKDHH
	37sofXbKqdyoYfrYXbQ11JiQEV9cYsQ4e5isqbcsmeEiZvXpDeflYYd/IsdLs+MI3fEPV1f13Cb
	nXnY=
X-Google-Smtp-Source: AGHT+IHUhdZJLdLX0HFsI9u9Pjbp9G8qIzufUAqtkGmv95NbpQTbtI+7HQ+bCAtx5aoCZH0BcgtDhw==
X-Received: by 2002:a05:6000:1952:b0:347:2b42:a397 with SMTP id e18-20020a056000195200b003472b42a397mr1533340wry.4.1712957430500;
        Fri, 12 Apr 2024 14:30:30 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-212.dynamic.mnet-online.de. [82.135.80.212])
        by smtp.gmail.com with ESMTPSA id di7-20020a0560000ac700b003439d2a5f99sm5046076wrb.55.2024.04.12.14.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 14:30:29 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: thorsten.blum@toblux.com
Cc: dan.j.williams@intel.com,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] raid6test: Use str_plural() to fix Coccinelle warning
Date: Fri, 12 Apr 2024 23:29:45 +0200
Message-ID: <20240412212944.147286-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328131519.372381-4-thorsten.blum@toblux.com>
References: <20240328131519.372381-4-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes the following Coccinelle/coccicheck warning reported by
string_choices.cocci:

	opportunity for str_plural(err)

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 crypto/async_tx/raid6test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index d3fbee1e03e5..3826ccf0b9cc 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 #include <linux/random.h>
 #include <linux/module.h>
+#include <linux/string_choices.h>
 
 #undef pr
 #define pr(fmt, args...) pr_info("raid6test: " fmt, ##args)
@@ -228,7 +229,7 @@ static int __init raid6_test(void)
 
 	pr("\n");
 	pr("complete (%d tests, %d failure%s)\n",
-	   tests, err, err == 1 ? "" : "s");
+	   tests, err, str_plural(err));
 
 	for (i = 0; i < NDISKS+3; i++)
 		put_page(data[i]);
-- 
2.44.0

