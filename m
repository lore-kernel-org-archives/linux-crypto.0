Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F0827B352
	for <linux-crypto@vger.kernel.org>; Fri,  6 Feb 2026 21:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770412190; cv=none; b=eMp/Z3BBPv1P7jD1Ga6rTnRbmh6PRYHU+q/nauv18S0EuDFFK/pKcbOxhTTCCbfd5c4Qb5i/IWwokVtqEG0xkVWws10CckSPa7FWZ6hw7P7DmpXr1Nnk6fNa0kEK8asve+ihT3mEekE7CWlvUhFYwdymemhSZOhhXapmlYqMi0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770412190; c=relaxed/simple;
	bh=uQW0hDq304V6H9OiddeiltQWnd2evSXrQFoWu7l0hxM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Pv/rOdL1alUgszZJZ4Qmd0uHNiqQpBzab5tqrnZxDZ684KFp83Rbzr51R/m0Xda00GDIEX2hQlaUtHcD2wLf4uhcqFYj+TkVDVoUjusAysf79eU+UGQxGqYspQbJR2ABOb5HzW3/rOnELKqNZzTYvIe2pXQ/hLHx+k+X6w4YG4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dTuy/aFr; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dTuy/aFr"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47ee3a63300so26949935e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 06 Feb 2026 13:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770412188; x=1771016988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GSQFCK7yDJc10r3FKl/3EZjeALk58Amm1GWLHWektGQ=;
        b=dTuy/aFrLHqDCGP+Z9w8YjUiGwRdT3v4U+CivYDgX18vrBra7VmMP5OalZy9xpgjiy
         BsAjykmDcZ/4hQ/W4E2Ib/981S2J5UvN5Ag6FjhkNsjTpexNvlxGoSIw0nmdTcHKKvzM
         i0ZEPGX42Eebo7O7+cAY9U5yZiwyKG+5huS+tyXufgQzZC+IvDlKh/4AJ1uxjhNIGyT/
         /i6SbFY1C48WAFiGBmWI25LTIgWBR/BQUDjv8+6WV/OQnsMjWX79y17gaIyHXMfDSuin
         6B3Kj+qvVm1YIbc+aoBz/xvNypzaFsrldHF7/YAAiUAtDY1awBmFkpuqIjJjsoHQD1Dk
         acCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770412188; x=1771016988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GSQFCK7yDJc10r3FKl/3EZjeALk58Amm1GWLHWektGQ=;
        b=JdY13aRTxVfQzodi4X/NxqGzj4/aA6JMzj+GHudhVywdQ3Luz1JQzYhcGcuxOrPEJD
         Qz5vj26DOBXwB/mjuYk+70um6sBN4Cg+0CHrsBvRNWRC8H2sjxRiIBPBnlelm/oanmFp
         F1FWVONAhQz96FP/0WSqXdpRmjtfBEaVtl1gAATSE68GYyxk+2dvhtmWIN0xmBcjgRdu
         pES3ohEZ/MvoMsu3ME29lwkmNX9QUSPBKa4MUw3bvA0L3lnlUmtNb4+yiblXZG48NEaU
         2Vhlty8weORmE1ViaEBfWltOfKZQ2NsJnYl0OyFUKq51DDHArSzPIUuJSLzOcHmORoOm
         S9rw==
X-Forwarded-Encrypted: i=1; AJvYcCXwdo9tNF4Q/nI9hBGVcmuANWn4dCraf6qaRXuxsv6QJSzJg7409TGIH5HZb6x+L+Wbtd6G+UWN30avKxQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8Ljs0Dkw3tF5B93hkVEuYz75Oswr5gk3JiaH10TG92ji2jQXf
	5t93mpOWZimjyBFT2oviSdMluOfXoghsMZb6Ab6t7lHOCLwu7/u0Nqh6
X-Gm-Gg: AZuq6aKC/5ed2KaEnlUNu8trYL2dsqbFhknvR62JBnbJm7/aKsQOTdFWl7OJCmaR1xX
	mqmTgXy3GWXm7rvegPRRxbQV6rk/gMzGnSqj3rrKGhcsSy6s61y7sDdtTknrZkiXThcUCWuvyxI
	sI99Jb6p8sgdmF5yxZeCUDW1M3dyrybKapPx71hfGTuZrNxLvyhuey7mJ7J9RryrOhlbjmSPDjQ
	DHQ/FVf1y5CmzDTVlL5Hc7+LgGUtbDeSZAQ2n8N4GcMG3NoF4g0MrK3LN0Wi5kTp6oT7WsZtVxS
	M6VDACQJ9wjfQF3JyoZh9K8N7VNUNouNPiqSqpP/KP+jnigIGfGM3HTWFRkqhVx2/BjhxkOSGCb
	/53yhEMShJesCIDRKWTwCFVl7om6+A7pbIskKBNmNPh4C/Mo5FeBwge9zmEctItq4iZhfIzVQ1X
	6+31KFiGXOMar3R+uM+Us56dtIkUsdcNG40L8Us7+uSZ03gWx9oFNSjehqQbunStiZl+MZPWgo
X-Received: by 2002:a05:600c:5290:b0:477:6d96:b3e5 with SMTP id 5b1f17b1804b1-4832020023cmr57675045e9.7.1770412187832;
        Fri, 06 Feb 2026 13:09:47 -0800 (PST)
Received: from snowdrop.snailnet.com (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4831d0b5b31sm125177815e9.4.2026.02.06.13.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 13:09:47 -0800 (PST)
From: david.laight.linux@gmail.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>,
	George Abraham P <george.abraham.p@intel.com>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] crypto: qat - replace avg_array() with a better function
Date: Fri,  6 Feb 2026 21:09:40 +0000
Message-Id: <20260206210940.315817-1-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

avg_array() is defined as a 'type independant' #define.
However the algorithm is only valid for unsigned types and the
implementation is only valid for u64.
All the callers pass temporary kmalloc() allocated arrays of u64.

Replace with a function that takes a pointer to a u64 array.

Change the implementation to sum the low and high 32bits of each
value separately and then compute the average.
This will be massively faster as it does two divisions rather than
one for each element.

Also removes some very pointless __unqual_scalar_typeof().
They could be 'auto _x = 0 ? x + 0 : 0;' even if the types weren't fixed.

Only compile tested.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 .../intel/qat/qat_common/adf_tl_debugfs.c     | 38 ++++++++-----------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
index b81f70576683..a084437a2631 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
@@ -77,32 +77,24 @@ static int tl_collect_values_u64(struct adf_telemetry *telemetry,
  * @len: Number of elements.
  *
  * This algorithm computes average of an array without running into overflow.
+ * (Provided len is less than 2 << 31.)
  *
  * Return: average of values.
  */
-#define avg_array(array, len) (				\
-{							\
-	typeof(&(array)[0]) _array = (array);		\
-	__unqual_scalar_typeof(_array[0]) _x = 0;	\
-	__unqual_scalar_typeof(_array[0]) _y = 0;	\
-	__unqual_scalar_typeof(_array[0]) _a, _b;	\
-	typeof(len) _len = (len);			\
-	size_t _i;					\
-							\
-	for (_i = 0; _i < _len; _i++) {			\
-		_a = _array[_i];			\
-		_b = do_div(_a, _len);			\
-		_x += _a;				\
-		if (_y >= _len - _b) {			\
-			_x++;				\
-			_y -= _len - _b;		\
-		} else {				\
-			_y += _b;			\
-		}					\
-	}						\
-	do_div(_y, _len);				\
-	(_x + _y);					\
-})
+static u64 avg_array(const u64 *array, size_t len)
+{
+	u64 sum_hi = 0, sum_lo = 0;
+	size_t i;
+
+	for (i = 0; i < len; i++) {
+		sum_hi += array[i] >> 32;
+		sum_lo += (u32)array[i];
+	}
+
+	sum_lo += (u64)do_div(sum_hi, len) << 32;
+
+	return (sum_hi << 32) + div_u64(sum_lo, len);
+}
 
 /* Calculation function for simple counter. */
 static int tl_calc_count(struct adf_telemetry *telemetry,
-- 
2.39.5

