Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54254455622;
	Mon, 19 Oct 2026 05:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792389222; cv=none; b=oT2L+T3OV61uBIp6juhZ7NvpXeXatxSDplchW6XHNJcMWwLIeoK75wo5UowWDUMfRmNK5u40csEAZe4of2cKLSlYhGVPTWp3uydZPnh0n9raUf7OcaeNWIUT5QOwlOUtfljwsj38T44gkfUZTDTSIdcTXlIK80GYxYNUckkww2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792389222; c=relaxed/simple;
	bh=WYFEvlxnaDvN4MzAi/YDr1Qa2sSXoF9Ai7cFPNDTzCI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Wb22t5UCS6B5CtOnbyaxDcmD+N5+JyI3iDYZ8TVpPYma2XZf7Ad0ZkBZIxgmtUyaftvp5cAsgvKMBq9KKBiOm0HnkiQs7LUE37Jc/WZQcBYB9lTU6xg8dWByGXR1EV9PKfkjo5DfNW2VU+lJ/Tpai99A2X+A7szMh1Ts5KPP8Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=UmVcL8PE; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="UmVcL8PE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1792389112;
	bh=eBfP4vMFyFIt+cEqwAv4OaTgDbIBAQ84OMUoemJZ+yU=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=UmVcL8PEtfx7Xt/SL7+J/aK8bHp8JdqXhxIAeu8O3cawJQqypse5P1ap6EDWc/XjM
	 iMLEixYn2naRqO5/3m3nOq3YBfu8eMzv877zqvpJXzRc+fMmBz+bQVTVigs10Lj6WL
	 wCpOdvaj2QZ1S14J2+hLsGM1BE/Gm17cXQwtosDw=
X-QQ-mid: esmtpgz11t1792389107te54f5155
X-QQ-Originating-IP: HQnkKdP79OLHD1O9bQYe6PxKmBnaALzKQUbiK5Si6sw=
Received: from [10.10.7.69] ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 19 Oct 2026 13:51:34 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5963191017211804846
EX-QQ-RecipientCnt: 11
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Mon, 19 Oct 2026 13:51:32 +0800
Subject: [PATCH] crypto: qat - free dc_data with kfree() in the error path
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-qat-dc-data-kfree-v1-1-b294cb951a77@uniontech.com>
X-B4-Tracking: v=1; b=H4sIAOOv1WoC/x3MPQqAMAxA4atIZgNtB4teRRxCEzUI/rQiQundL
 Y7f8F6GJFElwdBkiPJo0mOvsG0DYaV9EVSuBmdcZ43t8aIbOSDTTbjNUQR9F7xY5uDIQ+3OKLO
 +/3OcSvkAuS6cCWMAAAA=
X-Change-ID: 20261019-qat-dc-data-kfree-76c7e1ddc2a7
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com, 
 linux-kernel@vger.kernel.org, Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, 
 Laurent M Coquerel <laurent.m.coquerel@intel.com>, 
 Thorsten Blum <blum@kernel.org>, stable@vger.kernel.org, 
 ZhaoJinming <zhaojinming@uniontech.com>
X-Mailer: b4 0.15.2
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: MT22RekSGZMxgJNxGkzfOHPuAVQRPrGG3KI9LZLCl9xuSa8QYGZLf84F
	roeUogpCfCFsGWCgeVqYLG+N8iVZg6/bh6H/Nwi/XP9QzHMsTfUtO6+Jc+Q2/J/FiNw1V/S
	mi9U7bzU/9hRr1NuNZJPSDZPCffwafFV61taltNZf2FPF55CcYWoGKw2w8DoUIJET4E+FgW
	qP39GsHqZCsDfn3qdDBIdygiPYsTre7gkScCwtEmh4/iSo+gl+TPjSn2+9C2XrmeAxGFxxE
	r5xndIJz3rQN6y1Uu0Veo6+Ex3bfHKBx6iNXPjzbucgTOd11mKY28mR8SsyeaZGHbXjnU0+
	aIUYjujXQaPFfQxDs4LmLTpxnzy4OCW6PkaXhz/8ORXkcDMjqPTFLFbMvrjUpWdpPwwlKBa
	iqnfUO9Y92ldDudLkF+pbvSLw6USf/GWVcgYpt2l7ErMxfQERFv0tS/+w0qiwwJ1PgED7bG
	oO8joJ3pLRJxyQ7VU8JSMdIpMXNxaOUQSRYCUBWy3g6DRSrlheXdRbRDLg4Icz27w4Oiy0T
	sdLHvUWHNN1uBv9ebZOtqWv7UztGaU+Et+dsnDJFALCJvXgHLSlS2e0oMfAXuzyUoKL2Z4P
	Ji7RCxhGB4R9krdoJQv7SoAh9yNQQrFT4JXcnUm604PpzWxCYBJBXeol0SWuI/11iRHzH2V
	2yV1e+GOx1rks9GUu5HyGcXAmBjVqyp7GT5WeM9Eu10bRoZq0dofgv+3U+DvY+nsOoukAj5
	lpflvHcyZx2wsjE3kCNF8INIwz8Gl6HqXOeXesRSNYELmZaYK/35Q9d9Thd9jlAEvJ9RajO
	kNQgMRcslTTDksMgTWUMQhkgmSgz6cFLywE78r5/PyW7ARCuyAHH4ckFjrwpiGGorXsLpj1
	ZnuclpK0QagpipDTzJqEK/tfSuUeql/GI77edgZXyoHevTHUWRDWfGHgkg/7nQRqkqDfUqw
	mmPQkV8FQkG9CkiGeNMl8eG906cfNGFd8zrX+buYy0Hb6l3ubieERdRjjvj/i2eDwKaOnJh
	6JhLFXFSVAktbntGJivEcKUVIcrJb4V+7EWVmJyAxiLouV6fOvgm6FDnt97rQ=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

qat_compression_alloc_dc_data() allocates dc_data with kzalloc_node(), but
its error path releases it with devm_kfree():

	dc_data = kzalloc_node(sizeof(*dc_data), GFP_KERNEL,
			       dev_to_node(dev));
	...
err:
	accel_dev->dc_data = NULL;
	kfree(obuff);
	devm_kfree(dev, dc_data);

devm_kfree() only frees memory that was allocated with devm_kmalloc() and
registered with the device resource manager.  dc_data is a plain kmalloc
allocation that was never registered, so devres_destroy() does not find it,
returns -ENOENT and devm_kfree() ends up in WARN_ON() without freeing
anything.  The dc_data structure is leaked.

Commit 4cc871ad0173 ("crypto: qat - use unmanaged allocation for dc_data")
switched dc_data to unmanaged allocation and replaced the devm_kfree() in
qat_free_dc_data(), but missed the identical call in the error path of
qat_compression_alloc_dc_data().  That path is taken when the overflow
buffer allocation or its DMA mapping fails.

Free dc_data with kfree() here as well, matching the allocation and the
other release path.

Fixes: 4cc871ad0173 ("crypto: qat - use unmanaged allocation for dc_data")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
 drivers/crypto/intel/qat/qat_common/qat_compression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_compression.c b/drivers/crypto/intel/qat/qat_common/qat_compression.c
index 8129ad0c32d8..7a5b648302a0 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
@@ -241,7 +241,7 @@ static int qat_compression_alloc_dc_data(struct adf_accel_dev *accel_dev)
 err:
 	accel_dev->dc_data = NULL;
 	kfree(obuff);
-	devm_kfree(dev, dc_data);
+	kfree(dc_data);
 	return -ENOMEM;
 }
 

---
base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
change-id: 20261019-qat-dc-data-kfree-76c7e1ddc2a7

Best regards,
--  
ZhaoJinming <zhaojinming@uniontech.com>

