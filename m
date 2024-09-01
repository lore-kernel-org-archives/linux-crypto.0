Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD142C1B4;
	Sun,  1 Sep 2024 16:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725206676; cv=none; b=XP6X1D2DXcgNBoti5ClnpGOdxxayERMql1t35q26oHcIHIiZCW2Dd2Qk312EWZuqagCah+dscIrMZZkLOtiPnJXWqyGDTp/3B//hIvud7DO4hdL0uKehdn9nkNj5iZwvC68hR4wu5iRKU0ZRCR4we2K5VOopyzs2+lnexQMbSCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725206676; c=relaxed/simple;
	bh=0wHaGQwAQVzop4AHjrvcO+GoPre7DRSVSnLLN/CQhh8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=fskCCLf1V+PlulLLwYpSA5jMytYzD72SwKGbgtC7smyAmTnY3abaeKHO0hSFyZGVrEeEPgLh2usmgYhulTy4We+CvQ00WrrCjgB7o8WDZdbYJ1s+4WZ2MI4b1r+mWeVueZWZgkFKEew9VEnSKDviTs8/HkmPWADGsJmP4mgqSfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jfLasjar; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jfLasjar"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a86859e2fc0so384170766b.3;
        Sun, 01 Sep 2024 09:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725206673; x=1725811473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nauj2mG6gKwEyNeEAZXfjLbnZFfMboy1bsezWI6FQEE=;
        b=jfLasjarXHrANWAljtPM2odyVI4zEcpnzrKfWiEHt8qqhzvRwAqLmHj+eOcNY+JLaP
         Js8LcezsvvMSN9mVrWmW7yj+XX7bqdV+Po50+D7MFNyqLQVYVJE6MojWgmUUi6B4+6EJ
         aDxNKJ/H55cY6tv4UvL6fW0bkJsXF56/SxX3+DBSN5yEQx6/O4bjqSLNEZjm/jPvBWB6
         MPI1CbkLn/Yc56bfJAJVP4gZJ+ioCjTb5UuQgt/aaT6a4uWxlwvTJ3l9vFbgrX+aQtnE
         eH1dRT/gesx9lp1kjLtLGcKQP+sqE42sRT3QXkJGytOYQCMKJlA5dHIY6LqIykqWwtYI
         rTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725206673; x=1725811473;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nauj2mG6gKwEyNeEAZXfjLbnZFfMboy1bsezWI6FQEE=;
        b=mAre3Wpz8MTrcbuy9TTT9IyJLaqkX5jaZ9t/c2xjtlyKjTaIdB1bACUs+wryesPp3P
         beoVGBHUz5KHfDWok+LmGp0yiPKKpTbx+gHIRvem8liWrQeLTgr8AVWRBxAIAuIktsJA
         kGmgeWYvPnzpQPiN/KZ8Pq2Ur4KEIjEkaZ+IqmS5sSQKrJm3PgiOugtFabhDF6c29Ez0
         hnONO3qvLvKfk6dfxXHQpHJCQJ93K8n2+3+UT5k1ovr47YZiUf7kZ8Z3xqxSEHr+A9YK
         emDejAAOT2vmjPTwdGitH8lTc3jMqwsmrgIH8e1oDc1uRPlmPU+83CbkV7LWrtlvj/A1
         Y9Vg==
X-Forwarded-Encrypted: i=1; AJvYcCUd8AzwOPGR6UgoR66W8nMQom23LWEISXHwkTXcNc/iRiROojxDfnRUmpKeQPZRcio8cfH2Huz5wEoitHc=@vger.kernel.org, AJvYcCXkIqHUF8uDtrJnqBBHvvXukp7fy2jSSyfyJfT4QM37fWpyw7UiQpJHvsbkTV984WrQLmaxxxgeAO9joiq6@vger.kernel.org
X-Gm-Message-State: AOJu0YzjVi/hFlie0H8OLpYIDk9oBpQc4tf30qkZ5MJOOVZEQjcY2mc6
	dBs/jGtHPCmeXKWlX6ateH7/Ubp4WUmHTSMz3QzyqKpt6U6z1hR6
X-Google-Smtp-Source: AGHT+IGx9l9mdFxurzW/iqewnjXX4YICQlO9eBNMQFkLfh++SbGivPgkyiMHQuMbhAZcQC/s2yvCww==
X-Received: by 2002:a17:906:c106:b0:a86:a1cd:5a8c with SMTP id a640c23a62f3a-a897f8614a2mr858304366b.22.1725206672484;
        Sun, 01 Sep 2024 09:04:32 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8988feacbfsm450328166b.27.2024.09.01.09.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 09:04:31 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-crypto@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] crypto: hisilicon/sec - Remove trailing space after \n newline
Date: Sun,  1 Sep 2024 17:04:30 +0100
Message-Id: <20240901160430.143143-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a extraneous space after a newline in a dev_err message.
Remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/crypto/hisilicon/sec/sec_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
index afdddf87cc34..9bafcc5aa404 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.c
+++ b/drivers/crypto/hisilicon/sec/sec_drv.c
@@ -458,7 +458,7 @@ static void sec_ipv6_hashmask(struct sec_dev_info *info, u32 hash_mask[])
 static int sec_ipv4_hashmask(struct sec_dev_info *info, u32 hash_mask)
 {
 	if (hash_mask & SEC_HASH_IPV4_MASK) {
-		dev_err(info->dev, "Sec Ipv4 Hash Mask Input Error!\n ");
+		dev_err(info->dev, "Sec Ipv4 Hash Mask Input Error!\n");
 		return -EINVAL;
 	}
 
-- 
2.39.2

