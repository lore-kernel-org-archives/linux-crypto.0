Received: from n169-114.mail.139.com (n169-114.mail.139.com [120.232.169.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F6833688C;
	Sat, 25 Apr 2026 08:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777104897; cv=none; b=XoXJcstnjHZ4BnjjjSKQOq2NuK/wwCKwYOu5+F6NkOFF2jxapMDMMQaRF49jsi5I7a3lRKqjkQ1AYVXatDmhbDJpX8B1M+DIW5Kt8JR3557dj5SzNnn/UqcVd1gKlvWUSOGSCtKr7qH3igJsIw8ASRUqIZ0pDTXFkB20j4ouF00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777104897; c=relaxed/simple;
	bh=p6If8zvaJEZ00arRaPhnO4ks1UrHakJnmj9OMKyc9Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxTUD9R+1Y06yjlz4+p4d+jllGDnSimtqfU9nrnXg055SlEz/PAoFJ49ifqMQf9YJ4lkvIc1sm5rXC3ZhP+XsEXhMsMUbipbKRaq6UZwQx0Wg3Vus6/gEuKcbkJWenfnlLTrTuht4ajfc5UvB/4ZKc38+rS3l00h3aT+Up/VLzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=I1rnyyXH; arc=none smtp.client-ip=120.232.169.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="I1rnyyXH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=I1rnyyXH14QePae4fs7vnNcUDug8MC402MxK5pBFFdIVow/PO7wKSirWW2b2beY8cyYTdlP4mHFRp
	 EsaTcYSp7No9pXGSuuCSTgPz/o9X9JKRRnWOWy/5T9xVfia1F9/Q3ImbdMQc1sI3ddvbAd1kIH/plp
	 hiNhjCDWzx5nfuAw=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from  (unknown[183.241.55.34])
	by rmsmtp-lg-appmail-42-12056 (RichMail) with SMTP id 2f1869ec77eaa3d-00a52;
	Sat, 25 Apr 2026 16:14:45 +0800 (CST)
X-RM-TRANSID:2f1869ec77eaa3d-00a52
From: Bin Lan <lanbincn@139.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.12.y 2/2] padata: Remove comment for reorder_work
Date: Sat, 25 Apr 2026 16:14:30 +0800
Message-ID: <20260425081433.2763-3-lanbincn@139.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260425081433.2763-1-lanbincn@139.com>
References: <20260425081433.2763-1-lanbincn@139.com>
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
index b486c7359de2..765f2778e264 100644
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


