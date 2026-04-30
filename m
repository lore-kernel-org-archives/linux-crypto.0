Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8DA3D6472
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 11:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777546961; cv=none; b=FjKnnjMUl6OYZcovoqh4IjHXgt7UYn634OEdO/AQ2yopS9lZcBgU77qNZE70nKNJbUch8+uc0MRZCaB3e+KASdcxJY5WC8V9d0xEWGbQc5Ump4S/ja6NNjfhXBLc5GXkvwlkuWWnYlvQLWzuVZ4AqaKC6Yg4iM8I53R0yKiB79M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777546961; c=relaxed/simple;
	bh=F7j11NXDr9URInPsM5s3WsuaMFH036j5wJXOZgvIXcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+au0NFmbo/3koiBre/fkO7ocXm9x3yPnqP2uz0ykWrhTQVCsWai6SsCEf5jljx4i/Jj/63XIcsne2aXHqr36/JDVKMjHMD9mqxvmRqp8F7HvypHcvk6aUCNIwnKWkKRzJzs/GDTptiLl3ju/m3SX2y5QuJMn2yUp0El7xBWVq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vW+H8k1k; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vW+H8k1k"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777546947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZO7rFeKttV/3w17QTALbkFi7zUeJjILZuTiYjpS6XYY=;
	b=vW+H8k1kg++QUHSbssE/p1j2S+RWc8NBxacBL6ALJ11V4ZOpL8/oeCawBIhJ8KRg+lMfOm
	HPEliPTLAolzlyhbY151CPb4mELRdiN66jt7cYzfrQeG0F3UNn8lIfO23rT44VFYQMLwyP
	C8N1Bxq89TKifl/PxMwznsCbFSqBq2A=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 3/4] hwrng: core - use MAX to simplify RNG_BUFFER_SIZE
Date: Thu, 30 Apr 2026 13:00:50 +0200
Message-ID: <20260430110047.248825-7-thorsten.blum@linux.dev>
In-Reply-To: <20260430110047.248825-5-thorsten.blum@linux.dev>
References: <20260430110047.248825-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=914; i=thorsten.blum@linux.dev; h=from:subject; bh=F7j11NXDr9URInPsM5s3WsuaMFH036j5wJXOZgvIXcw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJmfzeIfbd5T4hqb+WwmF0/amvgbp5/1ruqbN61lKpuo2 +qvS8oTO0pZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAik90Y/tcVz2P/XmgdblRQ uGF3cs2ZGoatDY4/jLmFXhQ8WcDKH8XIMMuicsMF3hKnkPuf9BluFHny/nf9Em9255kWk2LFYuF dDAA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the open-coded variant with MAX().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/char/hw_random/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 905a63525831..f8f7a2ee73c1 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -17,6 +17,7 @@
 #include <linux/hw_random.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
+#include <linux/minmax.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/random.h>
@@ -30,7 +31,7 @@
 
 #define RNG_MODULE_NAME		"hw_random"
 
-#define RNG_BUFFER_SIZE (SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES)
+#define RNG_BUFFER_SIZE		MAX(32, SMP_CACHE_BYTES)
 
 static struct hwrng __rcu *current_rng;
 /* the current rng has been explicitly chosen by user via sysfs */
