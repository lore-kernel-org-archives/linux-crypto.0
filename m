Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D2121D3C9;
	Thu,  8 May 2025 19:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746734399; cv=none; b=kiGqzU40i36Er8o/J3+QiFOeKOTjulgdJBApcwy1dT+jJjGGyPxGreml5znzPm0z09ZcmHvpN7re5rA0JXrDlaAiSSfeqYI1XVG7mkuWWX3UBDcd65Lg+X5Ft7S8oV1+qXEr9H4SxrSr/4wtPwWCFHjSTbWO8eEHcFFQgANq+c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746734399; c=relaxed/simple;
	bh=nK/hQkP4ncaVLn+85OwpuQUElYHJ9Kq+z9dMsqR8V/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YJLoWExmp8vK/JalHsoB5sWS5fZ9eCiH0Zr21hVYiTwoTzXUx/Q/CdRJm3x4zm3WP9HHf8tdQ0hA7Hjrw4hCOIATETLc2mpMDf1coEVnCvKqkjkHOLaSB5V1adDfeYaBzr0jhgXT8PBn0Ynwq0yJhrlUT0uiCYcAUoIgvdp0ZRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kSqQ4IyZ; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kSqQ4IyZ"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso1939308b3a.2;
        Thu, 08 May 2025 12:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746734397; x=1747339197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sJ95+thIJu2pTdyqF3qLY2WS+CqBDgNhqB1f0/bL+nM=;
        b=kSqQ4IyZD2WXpmJsN+R0gWB/K11AOsKpffu896MVNQs/SwK0o0HNxXTclfDdRqkheW
         m5RiidvsjFn/PPLM6HSuVcKsQ2tcxUYDtuxig93LuHTqKKIg+11JqwEaJB/VODLlaud/
         hbviFi0CMc3TqfBKBIjtA1u4IBun1QYPh9ZV1HuuIrLgOURwyfiQaohr6arr+39A3tKp
         p/5eub23/JNdp/EKFovGJTQN+rQZG9auTqRDDVPN8KOl6WdKJyE61M0scQ2aROIMd5vU
         lu5U6FYRkZWe9BrVa4F3zPu1Wrmr7+NKi7TfpRQYez6HcmtadQe0WJEkNnM4XYLttmQx
         7Veg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746734397; x=1747339197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sJ95+thIJu2pTdyqF3qLY2WS+CqBDgNhqB1f0/bL+nM=;
        b=QSueERmx5d8Guqh/ld/2UWINckszSYmXfMl/6AwKKsIAths7dDA8NDnJk6KH/ga52N
         ngrfITYEpqGCsgTjsKWWpJivbkfP+wui/MQB/zNwVUpLNrgEUckVJGrPMSZBdo9o29pR
         vweuX7DLcLeJc5V5f85Z7CaIwhTrpUA5vQ8K7XNorJnXj5f8/v8iQJ9Y1qqPFHoY9ydH
         ENGTpoHNODpyzlp3TexcyeE3Z6s7vnpUcSYkZDeuqRftBbMWATwp9Eh00s3QZWXA2+vp
         HQ1fhWltiHsbrpAWPw86d5lgk1O0rkaNXJMJwRTIvb0qL2zxMxbbrA5Ck3g4Xtckd22T
         Q/tw==
X-Forwarded-Encrypted: i=1; AJvYcCUvG9pt20jh9ek8pKOThXO5Ov2Wb3G51m87XE0pDDjTTANQcepicPIai/E6xxDtRylV33M1TnMBmzOEjz0y@vger.kernel.org, AJvYcCVDbMPYsoe+BXp7PBGEzZALTSRYFpNo2rqbdQFLRr1/GndZn7EIPP62TKPZhvZnqIVXYm5arngX1Oq8xhk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK7+3QfYoKm0Nt4PtMKeToQkfWMYSpe3TtGwBV3Y2WOCjwdjXv
	7ZvtrCDoNyGVJEmkmsSH9N9LUo4e98U6CvMluSq1sAXlEPWxRF5xomsSSJ0c
X-Gm-Gg: ASbGncv3+cT79Ui2cyaSXhlOxllZ/Ku6MIgVowJIy4Hg52W4j9QDYpXM3Z6CSzYuIQs
	ZdMeHakl7ulbgoSIjkdt+PYrPi8TxPzRoVEDGTEm6JMdmU4sVH+Ix91tISi2p35+PGziwjKc4G0
	LxBAK1GaFOnR0ZuGoKjuas0re3OdB/aJ8/F8pLh4hulaGYFM/F7EpNgVFXWPn8lBVWjY/Ag1Dm9
	0dUdqb0uKP7y2TPilPEqEjeGdgiaE+tGojYJaDpy5BiN/hC03M1mWCwoioG7GRDsFqv2/btCHyH
	Y7ioIJt0W82H1ToagZPc0MNEjfZBiwUn+nCjHpQ3
X-Google-Smtp-Source: AGHT+IEGgI28/7p85CyStV87N9oWy/yKnk4eLXwQuczXV5gnhxNFc8FeVEafcH9ra1E5FD3WGyASBA==
X-Received: by 2002:a05:6a21:e86:b0:1f5:7280:1cdb with SMTP id adf61e73a8af0-215abb0b6a7mr606627637.16.1746734397008;
        Thu, 08 May 2025 12:59:57 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237704619sm423061b3a.20.2025.05.08.12.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 12:59:55 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH] crypto: iaa - Optimize rebalance_wq_table()
Date: Thu,  8 May 2025 15:59:50 -0400
Message-ID: <20250508195952.391587-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function opencodes for_each_cpu() by using a plain for-loop. The
loop calls cpumask_weight() inside the conditional section. Because
cpumask_weight() is O(1), the overall complexity of the function is
O(node * node_cpus^2). Also, cpumask_nth() internally calls hweight(),
which, if not hardware accelerated, is slower than cpumask_next() in
for_each_cpu().

If switched to the dedicated for_each_cpu(), the rebalance_wq_table()
can drop calling cpumask_weight(), together with some housekeeping code.
This makes the overall complexity O(node * node_cpus), or simply speaking
O(nr_cpu_ids).

While there, fix opencoded for_each_possible_cpu() too.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 35 +++++++++-------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 09d9589f2d68..0c5ff1c6e335 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -894,7 +894,7 @@ static int wq_table_add_wqs(int iaa, int cpu)
 static void rebalance_wq_table(void)
 {
 	const struct cpumask *node_cpus;
-	int node, cpu, iaa = -1;
+	int node_cpu, node, cpu, iaa = 0;
 
 	if (nr_iaa == 0)
 		return;
@@ -905,36 +905,29 @@ static void rebalance_wq_table(void)
 	clear_wq_table();
 
 	if (nr_iaa == 1) {
-		for (cpu = 0; cpu < nr_cpus; cpu++) {
-			if (WARN_ON(wq_table_add_wqs(0, cpu))) {
-				pr_debug("could not add any wqs for iaa 0 to cpu %d!\n", cpu);
-				return;
-			}
+		for_each_possible_cpu(cpu) {
+			if (WARN_ON(wq_table_add_wqs(0, cpu)))
+				goto err;
 		}
 
 		return;
 	}
 
 	for_each_node_with_cpus(node) {
+		cpu = 0;
 		node_cpus = cpumask_of_node(node);
 
-		for (cpu = 0; cpu <  cpumask_weight(node_cpus); cpu++) {
-			int node_cpu = cpumask_nth(cpu, node_cpus);
-
-			if (WARN_ON(node_cpu >= nr_cpu_ids)) {
-				pr_debug("node_cpu %d doesn't exist!\n", node_cpu);
-				return;
-			}
-
-			if ((cpu % cpus_per_iaa) == 0)
-				iaa++;
-
-			if (WARN_ON(wq_table_add_wqs(iaa, node_cpu))) {
-				pr_debug("could not add any wqs for iaa %d to cpu %d!\n", iaa, cpu);
-				return;
-			}
+		for_each_cpu(node_cpu, node_cpus) {
+			iaa = cpu / cpus_per_iaa;
+			if (WARN_ON(wq_table_add_wqs(iaa, node_cpu)))
+				goto err;
+			cpu++;
 		}
 	}
+
+	return;
+err:
+	pr_debug("could not add any wqs for iaa %d to cpu %d!\n", iaa, cpu);
 }
 
 static inline int check_completion(struct device *dev,
-- 
2.43.0

