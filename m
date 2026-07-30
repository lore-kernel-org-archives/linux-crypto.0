Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BDD3BB48;
	Thu, 30 Jul 2026 05:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785388636; cv=none; b=MPvVx5XC/V9L9qDOh5Gi5D6T4BaoctJb/ycjQuQsSUAi4AbhVXJubpMMaJqvw1P8rjRqBV8Kcpx1FWjutvHQffXWDx+OXtFUMuKoZhkQzyuPnjkpFknsNOOGGvq3O8szay6h5tECvElSSlRUnAcX+69UA0hdlpBVgyFlZVREmA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785388636; c=relaxed/simple;
	bh=xH+lO4m1/jAidVUcSkvROmhYmNilQBtep+tMK9yT2zY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RmyTMfY/hikGQQVFUCibsENzDqA1oD+xzHjH3Og2sPudYoTY4MDLI9CQUZ0sycn/nO8DPwgc1ybv1xRTO5VBYU71/YZ2XV+QECGT5peKn7hlMn1fUXeYwQN0w0k2L0ImAfuiJPZBHEwlSuuHgT1qEIGtbJmVGOp8YDbMntTzhAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DatcV8eG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DatcV8eG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=2nU1fayUxpKBpDAhWHLkwXY4o3NewCz9mcbe6PgX0J0=; b=DatcV8eGpZvtp+Z9pYt/mOpmof
	H77Ugbfh4Pb4mqdl0vyB8ItR+26IWauXAYFPre3zr/DiPSAEIO9o86MsUSiJFxSn41TgeDvrZBoW3
	jhmDqfPBPgOE8YDeAPiYv0kT+mD4CVVo4nU9kD2mO4e9A6Qj3iajo93sKn6tIcXwiHGqI9SjPfcAl
	INcioqIPSlYabCnSo7+c/97vH2B4XUOJeXT/pcqlLMjH1vF2+o4LfOER6AiWyqnBoijL2p+ZvV1sR
	0dWPCLUJy/7GuoknbRI5hbY4L6q5DXvNw1ubex0VyjBDZZcy3PCDT3LtUSyuoFh0NDXxI+Lv6Ef7b
	CqZG5Vuw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpJ8p-00000009XNt-2NnC;
	Thu, 30 Jul 2026 05:17:11 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: ccp - don't abuse kernel-doc comment format
Date: Wed, 29 Jul 2026 22:17:10 -0700
Message-ID: <20260730051710.1412969-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use plain C "/*" notation for comments that are not in kernel-doc format
to avoid kernel-doc warnings:

Warning: include/uapi/linux/psp-sfs.h:18 expecting prototype for SFS().
 Prototype was for PAYLOAD_NAME_SIZE() instead
Warning: include/uapi/linux/psp-sfs.h:46 This comment starts with '/**',
 but isn't a kernel-doc comment.
 * Seamless Firmware Support (SFS) IOC

Fixes: 648dbccc03a0 ("crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org

 include/uapi/linux/psp-sfs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20260729.orig/include/uapi/linux/psp-sfs.h
+++ linux-next-20260729/include/uapi/linux/psp-sfs.h
@@ -12,7 +12,7 @@
 
 #include <linux/types.h>
 
-/**
+/*
  * SFS: AMD Seamless Firmware Support (SFS) interface
  */
 
@@ -43,7 +43,7 @@ struct sfs_user_update_package {
 	__u32	sfs_extended_status;
 } __packed;
 
-/**
+/*
  * Seamless Firmware Support (SFS) IOC
  *
  * possible return codes for all SFS IOCTLs:
