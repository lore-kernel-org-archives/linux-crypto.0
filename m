Received: from n169-114.mail.139.com (n169-114.mail.139.com [120.232.169.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40267356A12;
	Mon, 27 Apr 2026 07:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777276110; cv=none; b=tfNhdfubo6zfNmgk0WEgnr5eHBtuRtv3fVdWtspPaBCA53Rmjv6i7670xWzj6zAkqH9KUSQikbhd49mvt8JMO1LE7lc3pgEAL057VXoAFlrHhcUOtBh/BN4v+oQw0tSZxRwQF7Ln3Z6hRu8QKSuz16ZiqljZXFFURm5l42suX+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777276110; c=relaxed/simple;
	bh=At8ZEZXEyl6/MPyg8ioxlqaVNvw99hDz7FkN8u7FKwQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DxT1Sa5pYL3nedMTMImCt1k/j945lS567wXWk9nhMOzDufQJqDEGUa7N77O/N9JZf+IdYQABq2uYaUbIwc8twj7kSE8nxzQ9d7dl1iaMDgWBBVDfOQYo0Phw/S3GJhEnKx/MtpBYf2BA1ufPAm2U0RTMW0AFYpAU8IEdhGejox8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=Kyg/DsYk; arc=none smtp.client-ip=120.232.169.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="Kyg/DsYk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=Kyg/DsYkQEAe6W6VgWAgT7GlZPL0tH9BqiZunsgwIBDyO67o0wr1juP9a0OUALrQFwmRZ/n/Pf2dP
	 AQisMwEHiT+O6bEYtGFldO9ciKbJe/TS/Kda8Ur+Ynpvf5390B/RQZCFweB+J+A/S6vlKsEKhzD63G
	 jyNGdZGv7If7XRho=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from  (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-44-12058 (RichMail) with SMTP id 2f1a69ef14bcfd3-06059;
	Mon, 27 Apr 2026 15:48:21 +0800 (CST)
X-RM-TRANSID:2f1a69ef14bcfd3-06059
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
Subject: [PATCH 6.1.y 2/2] padata: Remove comment for reorder_work
Date: Mon, 27 Apr 2026 15:47:14 +0800
Message-Id: <20260427074714.1569476-3-lanbincn@139.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260427074714.1569476-1-lanbincn@139.com>
References: <20260427074714.1569476-1-lanbincn@139.com>
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


