Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C069A3FADE2
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 06:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143832; cv=none; b=dhtQbsQlYqk9TkdNCFdud0FsNgieba6CuOrfE19Qji24/etgMbNRwufhbX4JiQvNzX+9My+uASxOuL1zTrfvedKAOyacDMGpykq3NiXp36yYkCoDOj2WPkWm3KdmO7HuoG/jdUF3BS6u6VuDMQWLsvQYXYDStpKxOV/XF8dScjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143832; c=relaxed/simple;
	bh=Up3ZIHSEDaIBrMIFPLazLYKJZ8oSLCIb4EWYTIp3x6A=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Z4CdNAJr6TbTG0TBf+HpVXr1wanWJJZvFyw+6HzUiu/y+WYoXoEZDp1AOQeBxCma10fFdyLg5XfFNaxgcQ/mCGyYI3vKEmOiCybchbP3DAf6ojb/mAAr8a1vNbBI6wsq/vdcXcgJYh52ULOUzqfrJRVyuQF9SE7arAwx/9+CXPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--morbo.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dTSTk06+; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--morbo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dTSTk06+"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2dc7337e2a7so5844155ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 23:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790143830; x=1790748630; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2NJLY26Tlw5C/ujVQMbXtmFKIsHXJJUk04BO2IFW5X4=;
        b=dTSTk06+Mc0arFDngd+N35IEatXimNhfOtZjpoEevvALR5oe+39VylCbruIVNuKEi2
         QKruI4UTu3zvufhlN3IKn8ox81/X0dpl3YgjsLbumz20qFLcb/XaZeXAMdpibpfPaOwQ
         5lflbw1rIrE0WJyGDuZxtBHNDWt44dD0gajme+DRGjibNemqwfp3dtR7K/L6DFPK7srV
         Hv0Mq8QLpZ/K5/DDxrzOitLXN8DCY5LZTdgv1kRnxi60E84aoWorN00QCsgL05oOlQym
         wD63guUpzTVwSueE6WWGjxqM81sS1VN+X1NH4/YV9P8qVfToQutENEiMXd4nPuxsWh7Z
         C33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790143830; x=1790748630;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2NJLY26Tlw5C/ujVQMbXtmFKIsHXJJUk04BO2IFW5X4=;
        b=DGiKCWe4BR16lcJpzzzUEBqaAXLzWPRSr1MHVw+ighIlvUlr9jOGlDiD3mEpULZ3Qm
         R3NGGE/tWOj/88+fGznfXkQOT9rdYncqp6v/C86OigGzKL4ATrGrKILveWTA4LKVHM1h
         U8mBvS9f0O3xcDSWzqk7kh6NaFz+PGvu1+x/EU5Frtudsr1H8el+zV3sDplkQcW/Vqy4
         BPB7adPrv/xXTMSAaPXAUF9xgGLyutEr1DzmRgzqQATJTziE2b0ByEwp49ficH6TWS/a
         GbRsUwUsZHl/EQ35nhjVJ20kfcjFNnA2A1cf/e5liQVWCr91WsgpYYtgmtJTBOb6Ikf1
         ud6A==
X-Forwarded-Encrypted: i=1; AKwUvBzOaYot46YNSkWJAP5LstX88/LNia+uQfmdjsaWGpMTxuof+JxnYbjFPBx36JLcJktASTTz4mPb0knuiU8=@vger.kernel.org
X-Gm-Message-State: AFuF++mWLrHb9OiQ1HII9iC0JpZW9CQJiLC18G5XPaYs2txgNGvRF25S
	b2oOPQhazmcNkddwI+C4r8HyceMdsaGMVlBB9cmMXVmG8I+zlUS+m75GOIp68OsyiRsYid/bBeX
	X
X-Received: from plad20.prod.google.com ([2002:a17:902:e154:b0:2db:7978:1b17])
 (user=morbo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec84:b0:2df:434f:5f50
 with SMTP id d9443c01a7336-2df69de2662mr13543765ad.36.1790143829058; Tue, 22
 Sep 2026 23:10:29 -0700 (PDT)
Date: Wed, 23 Sep 2026 06:10:27 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260923061027.2650324-1-morbo@google.com>
Subject: [PATCH] crypto: hisilicon/qm - add __counted_by_ptr to dfx_diff_registers
From: Bill Wendling <morbo@google.com>
To: Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>
Cc: Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	Bill Wendling <morbo@google.com>, codemender-patching+linux@google.com
Content-Type: text/plain; charset="UTF-8"

Annotate the pointer field 'regs' in 'struct dfx_diff_registers' with
the '__counted_by_ptr' attribute, referencing the 'reg_len' member
which holds the element count of the allocated memory.

In 'drivers/crypto/hisilicon/debugfs.c', the 'dfx_regs_init' function
allocates the 'diff_regs' array and initializes each element's 'regs'
pointer after setting its 'reg_len'.

Since 'reg_len' is set before 'regs' is assigned, the compiler's bounds
sanitizer can correctly associate the pointer with its allocated size.

Cc: codemender-patching+linux@google.com
Assisted-by: LLM
Signed-off-by: Bill Wendling <morbo@google.com>
---
 include/linux/hisi_acc_qm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 8dc49fa2123b..f2885d60b468 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -196,7 +196,7 @@ struct qm_dev_dfx {
 };
 
 struct dfx_diff_registers {
-	u32 *regs;
+	u32 *regs __counted_by_ptr(reg_len);
 	u32 reg_offset;
 	u32 reg_len;
 };
-- 
2.55.0.1082.g2b9226bbc0-goog

