Received: from n169-112.mail.139.com (n169-112.mail.139.com [120.232.169.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5792EAB6F;
	Tue, 28 Apr 2026 05:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777352931; cv=none; b=jyCXRgtdt0lWlLamvqRGpTz09CROhdWmT4qoucnl/y+denl2vE04zPCfv6orD7JnRPI83M3qAWyaVIKGHe7KplYhKRW6XOTVCFn9Lp7NOgmenyWnB92JBJYvhxaFsH64gqjKDmYU96rhLR7gplTp9k3CP6coi9vx0B+FhDBZoKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777352931; c=relaxed/simple;
	bh=At8ZEZXEyl6/MPyg8ioxlqaVNvw99hDz7FkN8u7FKwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beGXGmE7URyVQy4ISb0D7dqIu8PnTxrEyyNlbeks1VuplEd5oGkdWYk41aKSnW6pGSTluAg7SxwevDRQkbLQDV36haL9XdXlD65u5QD4oGY6mGnI0M8dVxt+N2pOFS+OKeMj5oN70ob5DM/ZAMeR2cWZiSMjOpUveAn7Nc+WtM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=IJersduD; arc=none smtp.client-ip=120.232.169.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="IJersduD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=IJersduDip7NEoZgwim79Kd4DUPffOpMwPsHy6d6A46GvZTfz1AxKqwP/CYOBio0mhGnFtpnkpn/O
	 D0BUJkcobWqypuxRbRFOKP/zqH87n5Lls8m4YnAVQrWC3yAdk529vMW/7eemPyi9KqTN3D+xr1PUc7
	 gXwMGhE+6INeJA8Q=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from  (unknown[47.95.114.252])
	by rmsmtp-lg-appmail-20-12023 (RichMail) with SMTP id 2ef769f040bbf4e-00f7f;
	Tue, 28 Apr 2026 13:08:45 +0800 (CST)
X-RM-TRANSID:2ef769f040bbf4e-00f7f
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
Subject: [PATCH 5.15.y 2/2] padata: Remove comment for reorder_work
Date: Tue, 28 Apr 2026 13:07:59 +0800
Message-ID: <20260428050800.10488-3-lanbincn@139.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428050800.10488-1-lanbincn@139.com>
References: <20260428050800.10488-1-lanbincn@139.com>
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


