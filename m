Received: from n169-111.mail.139.com (n169-111.mail.139.com [120.232.169.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334AF31E828;
	Tue, 28 Apr 2026 08:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777366649; cv=none; b=PJz++l+CRCfRAYH0NrmqePeQv0JLXJuapPkD8yAf40pNkoUuf41nO7eAhuUdLH37YgbQEo2Q+DjxeUDXMJ56wQvqE2efX52c69qPORc0VU3tSkv/NPzdFEXWlHW6h3D1htfewBTVVF+vgmx5yQqcZVuT7m0Ja4a7q4CNj6zOO1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777366649; c=relaxed/simple;
	bh=At8ZEZXEyl6/MPyg8ioxlqaVNvw99hDz7FkN8u7FKwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qx01pJ2NYBfsG15U7zqKCavP29oxm2lIzFtHyilAwJrvX7Ssw5Mkb2BpXLGE0RuajVu//Xzr8MDyzzit4eBvADJrYpXma+HfUTkpq6azVQgAzZVfh9IpyoVxvcd+DFpt5za7K8qGYrfczUDEL931G9TbLcUsEucYvfVTqWgCVkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=ApX2LVCs; arc=none smtp.client-ip=120.232.169.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="ApX2LVCs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=ApX2LVCsdOP0Mj8BABzH38fFsK+QXZoXlpJ2EWo0DN2dOb5TTuvUY6W9T3d3oDt8tMZ8F25u07qs1
	 +IpG3dLNrbo4zrZ5ycyYakqZAmAAhQNBHTzoa4buY/2P5YKaPySVgWNy8azGmaaH//7gqB39YlUEoF
	 IZd5bVe4xhAedygE=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from  (unknown[47.95.114.252])
	by rmsmtp-lg-appmail-14-12003 (RichMail) with SMTP id 2ee369f07660cf4-01d24;
	Tue, 28 Apr 2026 16:57:19 +0800 (CST)
X-RM-TRANSID:2ee369f07660cf4-01d24
From: Bin Lan <lanbincn@139.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 5.10.y 2/2] padata: Remove comment for reorder_work
Date: Tue, 28 Apr 2026 16:57:01 +0800
Message-ID: <20260428085701.1480-3-lanbincn@139.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428085701.1480-1-lanbincn@139.com>
References: <20260428085701.1480-1-lanbincn@139.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 82a0302e7167d0b7c6cde56613db3748f8dd806d ]

Remove comment for reorder_work which no longer exists.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 71203f68c774 ("padata: Fix pd UAF once and for all")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Bin Lan <lanbincn@139.com>
---
 include/linux/padata.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 9ca779d7e310..6f07e12a4381 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -90,7 +90,6 @@ struct padata_cpumask {
  * @processed: Number of already processed objects.
  * @cpu: Next CPU to be processed.
  * @cpumask: The cpumasks in use for parallel and serial workers.
- * @reorder_work: work struct for reordering.
  */
 struct parallel_data {
 	struct padata_shell		*ps;
-- 
2.43.0


