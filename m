Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F201836E5;
	Fri, 14 Jun 2024 03:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718334578; cv=none; b=hPprhsO62TiipWNHeLGZxFu3oq6eS6PLIlOvweNm5js3RSVYcTE8LetSjAn4s0mkDC4jP1AsUY6tuUnLwt1z8hWMPz0tOsz/V3rZpHS4ZqOTKVMR/LEB5+33e1LNyXt6DaKvlnMG/oOzXp/xfTz+LNNxAxVDBIDp+tlYdBO8H9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718334578; c=relaxed/simple;
	bh=079fmPcNrElpCqv3Y6BnAIOUYP4AOMMQoKL0HG/iaIo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pZ/SwOlfMCR+Df1xSl5LW96y0iLEB3UpszpNUHJj040NfG+63llYHy36BlpJw+pb8jfX27yl760OresdXErtsXHigCyE5trqSQOBJEn4tVtXp+Cgw61wmWYX/JQOPv0D0Vy9cdy4sXA2/lpcvaM/e0Wf94uDS0Mafv0SfXFxXoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yfuElC3U; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yfuElC3U"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718334572; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=oW51X77H6y2z8dhDzEhe+nNMSEceLAr8XPtl4dHoY8Y=;
	b=yfuElC3UkSEJOT8Ba4NJ3GDA/MAxVmv9/y9EER6MEf3u4+xIvT9tzx2UUP/T3h2TWa4jaATMivMSQenwj0ZnZYjGqlZtp03vtPN26RR95M4vMLWl6c5ccNl0DjZfeCVzgXJqY6+IjFku000ItOfh52sOYpOJ3/vpMfg3OEX9wzI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033068173054;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W8PpsGW_1718334568;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W8PpsGW_1718334568)
          by smtp.aliyun-inc.com;
          Fri, 14 Jun 2024 11:09:32 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] crypto: lib - Use swap() in mpi_powm()
Date: Fri, 14 Jun 2024 11:09:12 +0800
Message-Id: <20240614030912.10736-2-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
In-Reply-To: <20240614030912.10736-1-jiapeng.chong@linux.alibaba.com>
References: <20240614030912.10736-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use existing swap() function rather than duplicating its implementation.

./lib/crypto/mpi/mpi-pow.c:211:11-12: WARNING opportunity for swap().
./lib/crypto/mpi/mpi-pow.c:239:12-13: WARNING opportunity for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9327
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 lib/crypto/mpi/mpi-pow.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/lib/crypto/mpi/mpi-pow.c b/lib/crypto/mpi/mpi-pow.c
index 2fd7a46d55ec..67fbd4c2503d 100644
--- a/lib/crypto/mpi/mpi-pow.c
+++ b/lib/crypto/mpi/mpi-pow.c
@@ -176,7 +176,6 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 
 		for (;;) {
 			while (c) {
-				mpi_ptr_t tp;
 				mpi_size_t xsize;
 
 				/*if (mpihelp_mul_n(xp, rp, rp, rsize) < 0) goto enomem */
@@ -207,9 +206,7 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 					xsize = msize;
 				}
 
-				tp = rp;
-				rp = xp;
-				xp = tp;
+				swap(rp, xp);
 				rsize = xsize;
 
 				if ((mpi_limb_signed_t) e < 0) {
@@ -235,9 +232,7 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 						xsize = msize;
 					}
 
-					tp = rp;
-					rp = xp;
-					xp = tp;
+					swap(rp, xp);
 					rsize = xsize;
 				}
 				e <<= 1;
-- 
2.20.1.7.g153144c

