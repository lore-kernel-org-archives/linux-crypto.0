Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19102657CD
	for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 13:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711633660; cv=none; b=OZr3rpy/0UKRmUvNrYlZ7azOgcheMNf7cLbBNpEOgYPYDSF44KbU0MhRUj/Q9FXXAqBCusVd3EoDi1r2dhuqeYp10wEn8aaWe+e+BjkrVVyFvfafGgA3ty5vF2n2Gaa4XqgACXAazW5H8zdaWhfiHoz4Na8XW3W17rBdOKsI+IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711633660; c=relaxed/simple;
	bh=urpF+uhnagsRIlmCvAoqVf0cSl1JhJfWoktomJ+ip1k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ohWnZaN6zSyNOdgHi6GDrX7JXMzoCz3M6VDG085xVMBwwiQpP64LVqZocK5LBNnK2Dk9Tk7na87Izz7QGVlTJn9cs+3UVcHK90QGnqB4hthSYec9ON294VNM7PbEnUygIYR0ag42EU6mcYUJrkLzAY5erOstVGOQTMJJ1ajR4TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=Fzrq1x3N; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="Fzrq1x3N"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a4a387ff7acso121484966b.2
        for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 06:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1711633657; x=1712238457; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GxzVOZoRlwbh3BCja72w8JfT19aYOorMwhFDDTCvDh0=;
        b=Fzrq1x3N2q/eu7jyvo5orUU6iNcfIjp9NlWREakYVLy1qIQOdQ1KOLUwAlLTw8iUSS
         Qqv2VzYmgTupchTiG0nfFPsvDTMMrdg6xEpqL0ZgnC8JVZGl559X/+PyleRlP45XdZZ9
         CkraUi8hNO5np1RAJVXfRQuNkUwZt/9FxGro3qOepFQ4YOFlFACF2PdBLifj48lqi2cT
         h9e9sTMeweB+AabLRGi+tRFT+yAqTBuC1vfIhA982l1xnb1hOSHCnNd1/ma2lGoRnixc
         nihDBWPU+nOCeT1ewZGwuHTC61cZ2YJE98LscYtlzLdc1w+4u9YER62Gi+uupXuFLbo2
         NeIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711633657; x=1712238457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GxzVOZoRlwbh3BCja72w8JfT19aYOorMwhFDDTCvDh0=;
        b=VNfcgmY3nPU8p4SA2iIPbnC1My+pJam9UT0lmxw7rqkX+ODND8qkMIBD85RzIxD8CD
         8VvTSw9ulqiPGeBudAPbaQDtfaBiFmpmNpm16XwjD7EnF42K8bmJwWmgFwwOoNp9KjGi
         e+nzu3q8kpU/hb7mG4n6/Bbc1tEa6YuxF0ymBTiFELV7boiJHE2Tgl7c6IB6hAsGXdqG
         koRF8XlHjNJAyxfyiNaBQIkbQFOWmn1rSMS5zrgYQoStZIFft9BuM5TLUquB5jkjzdBx
         /pWZB1APoVCCzZV+SfEJHXhbTh/rmKjsHhrhrar7HbNV51dXQoAQTp4EVNXTIz3+EQiZ
         zm8g==
X-Gm-Message-State: AOJu0YyEY7+Rsj8bnB6JjrcUulsH7jkU9XcKa7++IElaFh4BPN1D+Z7K
	irdg27nPLeeW+3Kj8HHHV+f9NNmOppQzTe95MyTgQdjqEl0GKQVc9MmfzTEONgI=
X-Google-Smtp-Source: AGHT+IGpawLg28p3E5615Qyo+gXkEKgAfaMlSgEerS9cHHYKKRGks+Jt2ipv8BUlRar8DJhPLu6AUg==
X-Received: by 2002:a17:906:c14c:b0:a4e:19f4:8452 with SMTP id dp12-20020a170906c14c00b00a4e19f48452mr1831832ejc.11.1711633657415;
        Thu, 28 Mar 2024 06:47:37 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-212.dynamic.mnet-online.de. [82.135.80.212])
        by smtp.gmail.com with ESMTPSA id gy16-20020a170906f25000b00a45f2dc6795sm765908ejb.137.2024.03.28.06.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 06:47:37 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] raid6test: Use str_plural() to fix Coccinelle warning
Date: Thu, 28 Mar 2024 14:15:22 +0100
Message-ID: <20240328131519.372381-4-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
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

