Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5136B3CBE9A
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041214; cv=none; b=HyACKg9IeA/tvIpDTtVFC9ZddmviPFbIipuRJu5aTIUz6qbp2WsZIJ1I+5+dBlT89wy54S8VOFTnhyV/ifPH4EDOqfMNrew+asK1corwiB+YF8g2oFVZLEBhyP320rxsx4uT5NEMD7q5PqyogWG4BrWmHUpRrB55Rc28CtElvec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041214; c=relaxed/simple;
	bh=j9Fz6SSQQDO6DGs+2qB5LjzrCuQ/5ONfciuXWCHJfr8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JTiFapDx6PczhHDQFYZSvJkSz6sKiYvQ8Xyy4WW80IAL2JWwT6Mbfq3QrX0KBqdblx87+3/HfBJ/2GvuR2o3v9e0+QWXbSZ9HLHxWqzzYCF0nBF/iFbVz1b/3MRbr2xWFUzRF0xu4/Q6lO2gpdkNof1iCx8LcUCLf/44fHCodac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g675sOZz; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g675sOZz"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45b030a5696so172305f8f.0
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041210; x=1779646010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KRmMDCcVC/F2MSG/rzMXw5a6Uc3R7sPjQLJ20BsNc6g=;
        b=g675sOZzde5QWqpSDtNqH6BCsa+4+5F94J3AulC5JxN8Ned9wbY/ORna3msT90IDNY
         GCSxQgjgzaPtI/PoEmwudVMGjYQZXFnErC2NcaPrJ0hB3ceTrpoDdGHXql2H2XXSojNx
         UAKlsf1UkPiy7IKvrZCXemcFj+sWunIfd3iX3mIH2E0Cm/VZ8py6dSjsejIjzTU5Y62R
         roH6M6+lH4IR71lh6Xh6Dh7Y1A6sYif3TkKRObZqcV3ei+9ik6jai1dJmvjPbAJBuLBQ
         Npw73/B54K+fKEOjghuw/Hn/OTiao23It3gP/53iO2Qu51voM/DL/zq0tJXeqBKjMXka
         QI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041210; x=1779646010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KRmMDCcVC/F2MSG/rzMXw5a6Uc3R7sPjQLJ20BsNc6g=;
        b=AUsI1hlotbQXy6LMVzOsHo17IVzQ6p4Dn2yWBIGIGzmIrrC+pRpNN0VouIpwb47QjA
         RBCjrKrXkoYtdsS8yjzod3HEBhqwkUirb90Q4tgupgLk4XrYcD7DCFP/aAbEYPTVUS9K
         gKJiHYEff+1ejEyE6V0gbzOi0WiwXBhjWtzYs9zy0r1WU35CpPdiEQ4RmFRnXpnTydYM
         9cllKhHIGsQ2MkkVuRC86LkQmw3X9pefRa3lVQCaO29DpIIsAymkGPFlB0yTkCbh7FvF
         TFR1WuQuyltJKBooY9Uca4i0Y9ESwz+tZRFKgu9HTvCShZSdylrB27PSjacaROtyO4BM
         M0yg==
X-Gm-Message-State: AOJu0YwYNXEUBHZzkEeKCX2u3aaMa9toHgiUhIRnUNel/2a/K9W5URMF
	2x97RRj0T+4wtPsOSYxWSOWb/Tmj44E9qt9hLiIhZjcPV418LjVsaNxW
X-Gm-Gg: Acq92OEU4mWitd6wNGWIN7qdPQfdWdrYtypk+4NmJaNCp8SeagZ3soZ6cn4tE2UE9si
	BOeZFFVmrq/8yyJ9IQacpUL82xV3ezr0aro/qnik/u96lrGxdOz2pJrEecjWo35T9bsz0KI4XSH
	w5lNh8sb7qA6ZOGZ5rhnT6YrXmh+9A7s2hPBIxpGnbi7BBMYd9dYszK+aACwAjvn145GABvMFPa
	rVvyPPo8olGRFlnMZYS5YmC5sXk273IPUGySEAPtF0q2uZXqjbYNNCp3hg1bCrU/8mW0yN0wZG5
	E2cp7YMI2OHw8HPiE1HAqqOgl6zAlasMCn0+tj+u+7PIbkc5flbX1MZ3+JfTsyyPrAaWsxUvFnB
	gorFsrfR167TbqtwrHMhTT/MLWSWrEhZof0YjnI7FKVMubaR0WjjT/bbYRb8VG+s5WN4dLDnQl5
	mQAubJjOmg2FO9T8fqK+tw9PEQYl0Uugfbg6RF7BbXFJQU+gHhpKRtAjp1YjV+MJ8=
X-Received: by 2002:a05:6000:46d8:b0:452:9709:4086 with SMTP id ffacd0b85a97d-45e5c37d127mr4745975f8f.2.1779041209416;
        Sun, 17 May 2026 11:06:49 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:49 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH 02/12] crypto: atmel - rename atmel_ecc_driver_data to atmel_i2c_client_mgmt
Date: Sun, 17 May 2026 18:06:29 +0000
Message-Id: <20260517180639.9657-4-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260517180639.9657-1-l.rubusch@gmail.com>
References: <20260517180639.9657-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename struct atmel_ecc_driver_data to atmel_i2c_client_mgmt to reflect its
generic role in shared I2C client tracking and locking.

A subsequent change will move the client management infrastructure into the
atmel-i2c core driver.

No functional changes intended.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 2 +-
 drivers/crypto/atmel-i2c.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index c9f798ebf44f..9feae468b7ff 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -23,7 +23,7 @@
 #include <crypto/kpp.h>
 #include "atmel-i2c.h"
 
-static struct atmel_ecc_driver_data atmel_i2c_mgmt;
+static struct atmel_i2c_client_mgmt atmel_i2c_mgmt;
 
 /**
  * struct atmel_ecdh_ctx - transformation context
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 72f04c15682f..98a79dcae2b6 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -115,7 +115,7 @@ struct atmel_i2c_cmd {
 #define ECDH_PREFIX_MODE		0x00
 
 /* Used for binding tfm objects to i2c clients. */
-struct atmel_ecc_driver_data {
+struct atmel_i2c_client_mgmt {
 	struct list_head i2c_client_list;
 	spinlock_t i2c_list_lock;
 } ____cacheline_aligned;
-- 
2.53.0

