Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C049C3F99CC
	for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2026 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773338432; cv=none; b=IPn8ZmCp7UcjBu9pR6dXz5ORXLVpD1rNxoPePnuMRj5/kC+dEpmu11Dykrc2KTfrQm765Ba5k4UbLgph/IT29MXWftPV7ftEAQ0Q1yg+ZcN1urhVzlFOOyz+eCqe0ZxYYiOaao7VI3f/xzdMy8Q1Lyn+Y7wkavzSHRpY3T2ZOGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773338432; c=relaxed/simple;
	bh=nwd9TGE0ArumQDMwtlbSIeCeLPeEL2dHq0lKDmi8GKk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u44E7SjM1p6ymOW/L//48/1nZtrM8dWlK01xztDj3hP4mYEYN81TxiBk6UJTBkeBTyuJXd4VH7LtDsVIOxSSE73OzKjgc+fviydnhVXJDH1X1a0rZnWo5D1Tif+ffV02RKyuvNmh786TTr3XmquJCOxKRkBTAP4GbIrfDYWu6qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W/bw6aTn; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W/bw6aTn"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so14717555e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2026 11:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773338428; x=1773943228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GypZEyYWo72t7EHxUAotFf93/MQFLWWHVdEAGChBSyM=;
        b=W/bw6aTnpuOKPmzqzJPdPbKv+M5E2P/zFS+7LmGuWK5NKhdu2eZPQbfXrkEVMfK9J6
         a5bsa0lr2coJS8/Rz4PyLIiKDWR/AaDwnf1IcJEm3MYp1gIsaUDOo8aG4NbZyURgHBIY
         zDBytzQq6iP2UWSDDYDVK6rFs6X7OXb+jDUdFZ5B8NLMb6CRh9VPXFhwZ3WMnynXAjT4
         XTLls4rTa3c+PG5jQOCDssvodicDvRTlSpp9pOFHHiwJoZaQ8xPU7G5klROnyuyE8dAC
         9yl6W8yD4S9FlVYkYheCteKa09vS+fIQ4FsXmBa4gqj9O/aPO/CpwoV689ihTwDLeXgT
         mE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773338428; x=1773943228;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GypZEyYWo72t7EHxUAotFf93/MQFLWWHVdEAGChBSyM=;
        b=esASk3WgxZtcoQOlDHvCaPzlZu9xapr2v985r19mgKKuRmNBc0/EGsdaRnPtrQ0ezF
         ViffJjqNWOLPuU6Lt3fnqdGBB7KDtyvWs5Lb3BnQDFuGnPLh+4EY2LjeAX61Wv7yxZ3A
         rocxf2PwLzUn9Us3PKLYy46UZtUidSvI7FgD0vgWBvKpVmdZMaZ4oKkr4G1BA+gWKQHN
         ARR2ccauuteQ1GRolPJJZHt9T/d+94bv4h8PgyPeZTk89xFE81qCn16deiHaeWX+eSbd
         U/obCH+kJdKbGzS1Pc3kFL3l4z7xdSKjBQtZlcA1jAbbPENxZ+QhTm9xo4u23LI4HMs3
         XDEg==
X-Gm-Message-State: AOJu0YxnvTrp2voFRzOn4+BePbAygRen/uTB3hUaMPT3ifLN+V2fFIuH
	2Co/RGWvvTZ3e3+1NeWfbGsfuqdBqHydI2g9wBtHtWSDr89ci30/5+J3
X-Gm-Gg: ATEYQzxMYtM0gwDJyZh81cdJDlWDCDpNC9gPpsRGPzBUR+rEN2HmuLn8LWbVM4Z9dOI
	HNtPKVEDhTiYxGH9pboqAjIuU0v7ybWg/uehGU/zpbrok7dbJ6WfNDTfJIZBJ1BaTqtgqz/8G9Y
	ildWyAsvnQZd9GWSY15mLLgGy7Gmw/Qgv3w9bYS8P+zNiHsETc/ePjvRLrNg/1UAqkmv8TeYWvu
	mflipX5G15w7ecjP83b1FHX/oHr6fvXxG3ioC9p51Pa7bEzX8MO51inHNFm8HWe6pPFEFfqDBc1
	EKThMD9FPaeHhLgrSoiLPB82RftdKyDTCI1QVp56CoT/nTmgy7JSuAkbvkwgj0OYQgWdTfvUfvx
	bqAJz03o7NmguBMKVn+cJJ4E6OUN4kfLIQdMjwIaOP2cw39W0Co94bC6hBgXfEc2YrGTNUyTyNj
	iBp1L8ob2z3BP/zUVl3Wr9E3G5PlU=
X-Received: by 2002:a05:600c:a46:b0:485:358b:e80c with SMTP id 5b1f17b1804b1-4855649971bmr4883105e9.0.1773338427938;
        Thu, 12 Mar 2026 11:00:27 -0700 (PDT)
Received: from kali ([160.179.83.160])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485563f8c2fsm4918735e9.4.2026.03.12.11.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 11:00:27 -0700 (PDT)
From: Abdellah Ouhbi <abdououhbi1@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	Abdellah Ouhbi <abdououhbi1@gmail.com>
Subject: [PATCH] crypto:scompress: fix kernel-doc warning and spelling error
Date: Thu, 12 Mar 2026 18:00:23 +0000
Message-ID: <20260312180023.53914-1-abdououhbi1@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix htmldocs build warning:
./include/crypto/internal/scompress.h:39 struct member
'COMP_ALG_COMMON' not described in 'scomp_alg'

The struct scomp_alg contains an anonymous union member defined by
macro COMP_ALG_COMMON that was not documented. Add documentation
following the pattern used in other crypto headers for similar
anonymous members.

Also fix spelling error in existing comment: "Cmonn" to "Common".

Signed-off-by: Abdellah Ouhbi <abdououhbi1@gmail.com>
---
 include/crypto/internal/scompress.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 6a2c5f2e90f9..f91a2c3487ef 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -21,7 +21,8 @@ struct crypto_scomp {
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
  * @streams:	Per-cpu memory for algorithm
- * @calg:	Cmonn algorithm data structure shared with acomp
+ * @calg:	Common algorithm data structure shared with acomp
+ * @COMP_ALG_COMMON: see struct comp_alg_common in crypto/acompress.h
  */
 struct scomp_alg {
 	int (*compress)(struct crypto_scomp *tfm, const u8 *src,
-- 
2.51.0

