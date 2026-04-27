Received: from n169-113.mail.139.com (n169-113.mail.139.com [120.232.169.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C352DECDF;
	Mon, 27 Apr 2026 05:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777268926; cv=none; b=dkbsou/NhwZKjWW3sWV5hh8nBatfNHTRZScetoozKsKiSuBiha8oztM10/wDH2S1rK9PbyLhq1J4j2YQe71Lhe9WxTIVxB8pQ945YhZBN8v53YTTGXvWsdlFk2Ems088uY/y6zXBsEi5QK7EmJXNok1VsAGcpiiZ2k0KJYzVA10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777268926; c=relaxed/simple;
	bh=At8ZEZXEyl6/MPyg8ioxlqaVNvw99hDz7FkN8u7FKwQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g7AeF/xjLqZiXnzqor6WL7GQAAGxV4MwDH0RPdJSsjEl+Oq9jfrdoJqARR7SP0D0VsK2O+rslWD5b5eN+8wyXbtoJsVtqn/im/ZAI0XoPSd9n+Myf7EzOsVLHv2WPFFmYweQfqQiTtoFQI/5VAeeLxRvcxWkER3fn/Utpewo8FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=btDgfBXi; arc=none smtp.client-ip=120.232.169.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="btDgfBXi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=btDgfBXioLA3bAwG9na4htuR3ZtSosGLhROpu21dfkFYOfVh3C38ScRLReET87KrdW5XiEDDx/CQt
	 EEi66FVXSoPJds6XMgWg+CMbTKEXMQ0uG2iVY+GRjBNCf/a8jz7J6vPjQZ0gCSWT7dP4ejQ6/hv0U8
	 JC/kJ39/mj9XSL6k=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from  (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-33-12047 (RichMail) with SMTP id 2f0f69eef8a4fca-0705a;
	Mon, 27 Apr 2026 13:48:29 +0800 (CST)
X-RM-TRANSID:2f0f69eef8a4fca-0705a
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
Subject: [PATCH 6.6.y 2/2] padata: Remove comment for reorder_work
Date: Mon, 27 Apr 2026 13:46:43 +0800
Message-Id: <20260427054643.4121360-3-lanbincn@139.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260427054643.4121360-1-lanbincn@139.com>
References: <20260427054643.4121360-1-lanbincn@139.com>
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


