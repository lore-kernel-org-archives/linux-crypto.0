Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BFD36F908;
	Fri, 16 Oct 2026 08:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792139466; cv=none; b=BWP0V6FvFEMFBnQIpiXeMHuiElLA+R7xlrXh3UATOz+dOCllsjXp91M8iIVsuXTS1h6IQN12y7Rbhsir5zyGFe8cfn9gOePlsPbFzs2EX489zyALaWTAmBu6mALMGmea0nSWd0XR8chIVkL7IUdwjnWo/ciuS6Vn9Yiyw3N0k24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792139466; c=relaxed/simple;
	bh=IlSuneC1Cft/iB5s9rOSqN+4WSgzm1GEv54QLb5xytY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=PPiKOOS+DR2lTYbjILqtS2ChSLZfy1qKqDOHDFV5DQiRncQNhRSkHVKkCk+whNvYM7ufxkBZ5gbUOgtxTvRCf8PISEs6mQfhQ6EN/TuV5uyf1uZENLgzqvZ++LR0eiXWfuhpfqELFefTmd9uOACQr0DeWRcnO7b0pOYwFGmaNN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=bsNvDAhJ; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="bsNvDAhJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1792139428;
	bh=ppMqsg8mOhqDajSuDUyLaA9LHQl2I4uoxhDr7vbDmFg=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=bsNvDAhJ0AGPT3sfnSseMcJWPvMjlbEcFL+y1lssPY/En7TTJt/ZtXeXx9Ca95vzY
	 kwLdD67LmoI5xCdJTlATX+acyiQXBKPtEuAADpqI38ZlHKnsyEA/D3nM4M21bu5Ngr
	 WnFHKXs2T6rzeMhROVS2nNwMibvhb/z3O4YV4xD4=
X-QQ-mid: esmtpgz10t1792139423teed96f79
X-QQ-Originating-IP: wZfX1lGB1Z8NTcK/WIg5W0MDwDDO+bHI93LwMgLMDYY=
Received: from [10.10.7.69] ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 16 Oct 2026 16:30:04 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12796268041263047358
EX-QQ-RecipientCnt: 9
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Fri, 16 Oct 2026 16:30:04 +0800
Subject: [PATCH] crypto: omap-aes - fix NULL pointer dereference in
 omap_aes_remove()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-omap-aes-remove-null-deref-v1-1-195d36295ed4@uniontech.com>
X-B4-Tracking: v=1; b=H4sIAIvg0WoC/yXMQQqDMBBG4avIrDtgbFDoVUoXiflbRzSRjEpBv
 HvTdvm9xTtIkQVKt+qgjF1UUiwwl4r6wcUXWEIxNXXTmtq0nGa3sINyxpx2cNymiQMynuyu1lr
 feW+6QGWwlCjv3/z++Fs3P6Jfv0c6zw+wING7fgAAAA==
X-Change-ID: 20261016-omap-aes-remove-null-deref-a3444b7bb17d
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Lokesh Vutla <lokeshvutla@ti.com>, 
 Tero Kristo <t-kristo@ti.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-omap@vger.kernel.org, stable@vger.kernel.org, 
 ZhaoJinming <zhaojinming@uniontech.com>
X-Mailer: b4 0.15.2
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: N3l5ASPewLWqgu8AT+ZV3VEidr1DX6qYII6LAxobg2AR5fr8alElaSEj
	aqkyEd4A8tzTU2S69atPF9PqIRR/VkQhLK9KHv73xCMjQyEwRjFmBrSwuJdOBIrn+qcLQuP
	mvHPC+mVbcAzGVQqo4iQU8Yb+A+FhXwsktGo/7nn9tZu4QsqQEeBag6deGHAErN15ycGkq7
	0dn1uZ8GKbrb6QdHZzDqmxIfiR6YwTpwwQ/9+836ytzZC7rrvBDNkPNe27CSMyw4jQD08Cp
	DaxNUAKah6RMHeySDTVG8Se8atbSRkLYQgh6hW4KCM+GUJzr4R/FEWNXzZ7tOTY4g+g18AM
	1LfkVMYMEqRVdOGgA1PwSduBY/t6qG5FeZ6kWSL+KDggvgJE8l0rW31+PaLx3u7kLUzDSPJ
	58XGv8YprnvfCSdgxWdGKLvFLOzNzTwhCCx//6binHUKasCDk1Pu3WdaZZHdrhEQYNPvsjb
	TGtB1wdqyO8SYPkFB7iI/sRfvdC5l4dkQZ6JbFgZ4fLtVveEL2cTIvzIuUgWHBpsVMhFhiR
	QNXP5PN6cdl2cAGhxBS6mvqpPyrsR/mzpmsyfQEeFewFv1LhRR8FTku1HZ+q9xk+0K7rRos
	0vPYa3NsT6N+A5HK4U1yFxd7hlFdSKoDAm0msWy/f+EWcl9KBCASfTSMmEXnzpt7yp/CUZA
	9sbVihQpk3ci7fX2bYBpYHkFZ0B6QM+4IHKrA74PlayDvsO0V7ygBiBGAkeMlEDGW7p3Knp
	0jAoKi9Hlfgm95mtJO8YzjQXJ/egZSrsuEy/sRJNEfJBzJUKhQ3i4v6gltPHtk88goWasq6
	RCk9hlYFnbTlJVLpku+uQqxFcYKBdfJDENQywtKz3w1LBDf9HxoPcLkz+VUJe4Xf95NqRWg
	GyT45tpMn0azb30nOF99xpn5zVxZuDRMKqPzTjlg6AHsAKvJ6xEjdYSZQb6rInIewo+GtG8
	P788ANuoT77Z46cufe9XZZvOby11L4Kju1+TIoZs/bpJpPYtjOIsC8lXdAhXBi+Qmr781I/
	WjDykG0Yzrax3wBADX2Y/qxZZhxIop/f/Ypym5Qg==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

omap_aes_remove() unconditionally dereferences dd->pdata->aead_algs_info,
but only omap_aes_pdata_omap4 initializes that field:

	static const struct omap_aes_pdata omap_aes_pdata_omap2 = {
		.algs_info	= omap_aes_algs_info_ecb_cbc,
		...
	};

	static const struct omap_aes_pdata omap_aes_pdata_omap3 = {
		.algs_info	= omap_aes_algs_info_ecb_cbc_ctr,
		...
	};

	static const struct omap_aes_pdata omap_aes_pdata_omap4 = {
		...
		.aead_algs_info	= &omap_aes_aead_info,
		...
	};

For omap2 and omap3 the field stays NULL, so on those SoCs unbinding
the bound device (e.g. via sysfs unbind) or unloading the module (rmmod)
dereferences a NULL pointer:

	crypto_engine_unregister_aeads(dd->pdata->aead_algs_info->algs_list,
				       dd->pdata->aead_algs_info->registered);
	dd->pdata->aead_algs_info->registered = 0;

This is a hard crash, reachable from the teardown path only; probe
errors do not get here.  The asymmetry dates back to the commit that
introduced GCM support, which guarded the registration of the AEAD
algorithms but not their unregistration.  The registration path in
omap_aes_probe() already guards the same access with
"if (dd->pdata->aead_algs_info && ...)", so add the matching check to
the remove path.

Fixes: ad18cc9d0f91 ("crypto: omap-aes - Add support for GCM mode")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
 drivers/crypto/omap-aes.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index d40074e5a142..8a932451ccf9 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1199,9 +1199,11 @@ static void omap_aes_remove(struct platform_device *pdev)
 
 	omap_aes_unregister_algs(dd->pdata);
 
-	crypto_engine_unregister_aeads(dd->pdata->aead_algs_info->algs_list,
-				       dd->pdata->aead_algs_info->registered);
-	dd->pdata->aead_algs_info->registered = 0;
+	if (dd->pdata->aead_algs_info) {
+		crypto_engine_unregister_aeads(dd->pdata->aead_algs_info->algs_list,
+					       dd->pdata->aead_algs_info->registered);
+		dd->pdata->aead_algs_info->registered = 0;
+	}
 
 	crypto_engine_exit(dd->engine);
 

---
base-commit: 2f2f7eeef8b0a1a9b9ca998231419873ccae8d4e
change-id: 20261016-omap-aes-remove-null-deref-a3444b7bb17d

Best regards,
--  
ZhaoJinming <zhaojinming@uniontech.com>

