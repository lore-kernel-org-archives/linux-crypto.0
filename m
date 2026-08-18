Received: from out203-205-221-164.mail.qq.com (out203-205-221-164.mail.qq.com [203.205.221.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FF3148850;
	Tue, 18 Aug 2026 13:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787059551; cv=none; b=R4m3WyuDUn0f781KpO3LsYEbd2Hcop20z+vI+ldJ3GqAJOXOobUfFM4H/L+aYO47btWdDnS/K6pTYP4fK6/hWdRZt2Z1LrZ/j2G2jMW7HVz9Z9X/JVFFqPcEC9ucZRnw6CnJ6v1p5q2qV+hWsiQp1XH6dqqp/YnaNqran5LBG4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787059551; c=relaxed/simple;
	bh=x2Gq6ZO0vbGyepv457ltYLaDwTngzLGa3jp5goV4yMk=;
	h=Message-ID:From:Subject:To:Date; b=Ej9M4FxzvI5duePQIJy47tqOV56drbrZ5gi549HVgyApiw4BjjphWFPNdOQJluZBgtjHNP6y6Iv31irBTWOuepwLn+SxzYrBFwucebW+Rxtr3VQI5oxKRrt+IY4LsHQSZnUdII0/LPonud9D9KSrO1ppWesNTiL8ERm4MrbcuAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=X8UIxL3U; arc=none smtp.client-ip=203.205.221.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="X8UIxL3U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787059546; bh=2F/FCwUhK/xtyrbhv+LkJ2j8JMdVdXutdWJNDSeGu7U=;
	h=From:Subject:To:Date;
	b=X8UIxL3Ubgd34sKHJxQd3Qu43UfTvH8TlpcjCX0VzPGNe/DfsR+hynmxL+dVVLNm7
	 rzfbZvTX8mJ3XOTJdAoeHmwyJb2FVBqFAuvefgLAw+6tphmy89p6LWtoWROmDBu02Z
	 PLWOlvA5BIhE24hxv4XfpuNU6anRg/uWTLKiIIKg=
Received: from [127.0.1.1] ([5.195.0.150])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 1721C6D8; Tue, 18 Aug 2026 21:05:50 +0800
X-QQ-mid: xmsmtpt1787059454tl3aef3y3
Message-ID: <tencent_3C130FE0F8AF7CA544FD44D113E4966E8E06@qq.com>
X-QQ-XMAILINFO: NsBBv6AnqV8O289bjiYpkvYxUeiQz53Cl4bAVSHUX0xfpZ2IVDOQxwA+hzpT8i
	 jb6RKrqXHlFm+surPL00VXJlHzZBJ3xdLqIH2oX1A+k7kjO1nRndzc0SvSx0ivUwSRaG6hXIQ0r7
	 WXrnaos11A2jaJ0py1IYVR4CQ6Sfx44YpxN6gWG86ZEZrcNSjJi5RpcJ2nohNTjxU0WLdSZqtp+V
	 XbN2bvSdXRwrp1eU1Pn+SVam7DDnGO6heo3e/MNGPuNeJXsQP+/eOSH2+AjiyyRgbxGa/1mKgiDl
	 +kk1Z37Vh+6TdNbSbCkCEXvAz9Wlf+OL/Fdd10ls4Zu3rnqU6lOklZ3m8MLSs6S/zWnOgiun19Xs
	 GK8xLKlbb9ZAQlT4X17ifsMSeDse+5ne1rmRlq/TCiUy0ghG/CoE3LBxscy2LdRY3YqkqLc440E7
	 eptUqiSjU9l/UY3rE+2YIKkSWVsHgkkeHdk2e2jD1vwLhbBX7bfWSCjtLbkkz5mZUlVnXBUPtB1I
	 b8ecMKw2VTqMm2uS1Jmp4r9psrcwq3KuqUYv1dVWHIxnRaqz4RwoDFlV6TqOxPaMop4C7BLW08++
	 xyfNaZBw1O5bQs/AgtF8cWKKIBuPFgaerKwDEazbvBVct9iWu+y93j7tDbbg4bUMC6WcSCmWoRbD
	 m0ukGzJujzHxfVEHIhMjMvjI90gApA6eaVbOcytz67XiI6MG6/dU/Ndqi0fykW/9i8+ntC6/jD9s
	 L+oTH7BIDivc67NUrMYV9BleAr60GwT6u1jWqPOFHDtlSCJBK0BzshXG/C4Ifv4zlZ9i5qpAi05H
	 ZturNoYXP4n8oCRiRSGZ9ZCSy76VjTlGTAPv/Hb2ayiqK8j7FjpKeAbkD4Np2BL+OhpettpHRZV/
	 DJZVzPsn4wL1gCdcmEJ3CJnyTnv9aaJz+44V+3hwu6uepym7hL/xcDQjlNmFoFdMONzFQ77vKsz4
	 tZrCqGDx4g2di7HbzKteZMI0kygWSB7eyTv73/FaQzXIcaJpofJgdjakw/38CHJz/4CIOnQvkIdp
	 eXBXzAuAsp2OdfK1rODquwsIUHuzuBTgyZR/NI6I7qYcfavwM4NvVSio82haQ=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: Jiawen Liu <1298662399@qq.com>
Subject: [PATCH] crypto: jh7110-cryp: handle clock enable failures
To: Jia Jie Ho <jiajie.ho@starfivetech.com>,
 William Qiu <william.qiu@starfivetech.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Tue, 18 Aug 2026 17:25:44 +0400
X-OQ-MSGID: <178705954426.291840.1469840571578822725@qq.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Return error from failed clock enable.

starfive_cryp_probe ignores clk_prepare_enable return for hclk/ahb, then
remove/error paths unconditionally clk_disable_unprepare both clocks.

Check consecutive clk_prepare_enable(cryp->hclk)/cryp->ahb returns in
starfive_cryp_probe.

Signed-off-by: jiawen <1298662399@qq.com>
---
diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -120,8 +120,15 @@
 		return dev_err_probe(&pdev->dev, PTR_ERR(cryp->rst),
 				     "Error getting hardware reset line\n");
 
-	clk_prepare_enable(cryp->hclk);
-	clk_prepare_enable(cryp->ahb);
+	ret = clk_prepare_enable(cryp->hclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(cryp->ahb);
+	if (ret) {
+		clk_disable_unprepare(cryp->hclk);
+		return ret;
+	}
 	reset_control_deassert(cryp->rst);
 
 	spin_lock(&dev_list.lock);

