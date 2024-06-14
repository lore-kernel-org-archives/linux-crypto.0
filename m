Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B466D19D880;
	Fri, 14 Jun 2024 03:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718334575; cv=none; b=c6uqGqtxO5ZePCFFTFBt8ARh/zglaT5jxnHpxVdyJmmWN0xjEESREKibyrjl/Gx4e07dCS2lxL7ogxXRnSbcufnFX9iDrD/NpiVni+otkF3XKh5f56qpvvcZSSVdRtC1Zt24F7Z6WleqypgWrJCxGPLyvIaqej10oSCgbCLP65c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718334575; c=relaxed/simple;
	bh=IYxjgh7/LE5H5j2kwnXPw+yk3TPEBGp/icxY41gHRPc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=heqgJcEbpeJxvwm+IehXZFcxJFTJKJNlHVXUyTVv/thgnUTtRIn9VmzAsGeqQkkNbR6lOrwCjRJwnPRmGxTlKJdlXshHMqxfkbCNyLFCnKeEL5dYm6kBiD/aybHxx+ttNv+OXfYYVTTdOCqXiuIUcV5qKBALxad3SIzudsaP9fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=XnYuqO4s; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="XnYuqO4s"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718334568; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=LCHH8k0Vzj7aV9fD1q+oRGks/zIwhE/GlbzHdKlJQNU=;
	b=XnYuqO4s1bRzzqr22DG3DCU/kP4v0MuTgh+97LHpLZ7eQbKYL078Yw6yehv+d6BDxbGmGRuhiEIlhIpJedGgT//IAmVOVbhV1oCoZouJPHWiYdwfkbw1nc54PB5lPqhoBFNasFuhg+Cb9mvVhBB6XIITbYAcXW2o6WM9dwC7FLQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067110;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W8PpsAh_1718334554;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W8PpsAh_1718334554)
          by smtp.aliyun-inc.com;
          Fri, 14 Jun 2024 11:09:28 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] crypto: lib/mpi - Use swap() in mpi_ec_mul_point()
Date: Fri, 14 Jun 2024 11:09:11 +0800
Message-Id: <20240614030912.10736-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use existing swap() function rather than duplicating its implementation.

./lib/crypto/mpi/ec.c:1291:20-21: WARNING opportunity for swap().
./lib/crypto/mpi/ec.c:1292:20-21: WARNING opportunity for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9328
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 lib/crypto/mpi/ec.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/mpi/ec.c b/lib/crypto/mpi/ec.c
index e16dca1e23d5..4781f00982ef 100644
--- a/lib/crypto/mpi/ec.c
+++ b/lib/crypto/mpi/ec.c
@@ -1285,14 +1285,12 @@ void mpi_ec_mul_point(MPI_POINT result,
 		sum = &p2_;
 
 		for (j = nbits-1; j >= 0; j--) {
-			MPI_POINT t;
-
 			sw = mpi_test_bit(scalar, j);
 			point_swap_cond(q1, q2, sw, ctx);
 			montgomery_ladder(prd, sum, q1, q2, point->x, ctx);
 			point_swap_cond(prd, sum, sw, ctx);
-			t = q1;  q1 = prd;  prd = t;
-			t = q2;  q2 = sum;  sum = t;
+			swap(q1, prd);
+			swap(q2, sum);
 		}
 
 		mpi_clear(result->y);
-- 
2.20.1.7.g153144c

