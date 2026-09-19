Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99C338C427
	for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 19:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789845889; cv=none; b=HgAPvzCPD/7gzMfdGkK7rSGNn0+LX9Fo1FEduHipJjt94OgnPOfYZN8dxvbQJgtUjsW2q0ofIqRgjBu2/lLRg1+vluWj45t67GLwJVhFCqVbUENNmrlhaC37KA+6ejWum0CfYEnSLIPFdUf0y+tRUyf7JwQckexbv2aMZlx95/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789845889; c=relaxed/simple;
	bh=v8aIwwPu+ykUe2DVOsCMtMaDklWrhQYLetu6xwVJq0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eMnaVRbqw6JdfoxbstydgMbcLBUaEq4L70DxWUSjSHFl+KvZ4AqSsjOIAOmvZzNfx41ajEtfvcXC6SypEHUVQrcegTHc+LyM1asTyYLmx3vCWJ4nIgbhERyf+AqN+EprLPQrej9j9PeOPSoC1kVkUUy406jxIk5w6trfa2xtxjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AapVF8P5; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AapVF8P5"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49cd38e0f79so10224445e9.3
        for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 12:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789845886; x=1790450686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gf8kv8NIScq3SH2S6osm1YMVG98TGrAQ704A6bF98Zw=;
        b=AapVF8P5dphgczHfbjROX/KkV/6lvIR/Mguec+Pjl4230fBmMwekjXd+3vobBgaUqZ
         lwe+Avf+DPtj+x4UsJweh5KMA+coDf5QgroOhDNZcDq6Uh4Ss4xF6MRgfIDL8QBaDIMq
         bAXLD6XmDFKgZnSzkg2WhM/oMkqpBrvAa9+DNzqfEtbJIE7M2HSLXK4y8LiIxhn7BGKy
         wQPseBz8wJBe1KeoDXwULSbzUFHrnV8pOux0UgP+uK9l01vbcC5Gi1Ri+EHtLOCqrI9g
         IsS6HM83K6TlF9XHSmv1fLxcAfCtMTlG7xjtX14lbA7XM6CBUjJ9HOeQQ4lI3arNMeTl
         s4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789845886; x=1790450686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gf8kv8NIScq3SH2S6osm1YMVG98TGrAQ704A6bF98Zw=;
        b=h/M8hYKGyPBhkcj+Ttuxgo379CSTzlGnO6oNsM/8cbVxxcHdN9FgoOB3s1BGJxjV3f
         nXFzVEeL2Ir1pdIV0cumBYzy29EZoUBDDG0Yo94W7rPDrO2qYf0bIDr6B4jdOCUQN79A
         FciBk1SxCwhBA7PYem4bK0bVlty49/ET9wWbFtQUbZHYx6Ew7ZI6H7S1i5DCYvSnv+LQ
         XXnZebxIiE7g98ANV5fMV9Czvo4bFRgYFyl570X4Dw0kJTdPzUb4/mCvoryfaQDpCRFt
         n+FEOPzDV0XLJo5QGjm8VZUJhCUj4ftyawZL6HZddY94hoqIZk7xtev8vv2QxWHfKIOQ
         rFIg==
X-Forwarded-Encrypted: i=1; AKwUvByaDqeFuJWfW9Xcb3orlwFy8NPa5ZJ9dvfuWc5YNIzAnl+zATakJ8kOxnb2IiFVxzOnp0gKkCxl7MaTTJo=@vger.kernel.org
X-Gm-Message-State: AFuF++lwbVB0cUeCjRPEevEbuEqGeZZ4BrFZjiWMdv2nGE5k3P3L6MDw
	I5TQZsxn6wbYzkpNRXAakMHXUgufrigfnxyBjOG+8AP4EAztIxKj8VWg
X-Gm-Gg: AYBFou3CsNpiCQmvpOHXL/zm5oYJlzHahtmv9D3BBf35TGaq6JXPz5VyxVZn3AZWcXJ
	CZE5YoO5wvBX2lSoJEMTBGLUQBxARK7ydLm58MrQfGFK6PCM1BbU1PIZ926THpgCooz6pCicb9+
	TPhnPXBDj50NNw3EYZ87rAgWR4cqTzYnz7zSkkVZAGLWoR6PODfFWSHcPFTABnCH5TbTpYVxEQb
	i0ns/DOUgNL6TSlZkg3WDg5rkEU3Qs8TZKcSk3159eryAwRBLuZMKC+TudjOtC74r48KS7CtThb
	+fRO0VKy5yuj9YHwiCNoRvKCVma7WxaLAQJwn3vYJmu4CsUCpMGFWam2DGOdC5juuag4rml8LuA
	ANDOOW4cclWCM7MDELeMcyyoDI0SdJjf4EyL2hw6zkeQTrKRIQ3ST03Af368soYx/8ZpJbMlvVI
	+cw+yEXNoB33DPRXPtpyL0prB2KPyh53oY92/abtbGLp8HPpyAnSSQWcZ/R85oSwH5v5Qo2HYox
	xxruGaEi+amGX7addxyFxdFTWyjDv+xvai6EKz5gYxunNiunq4=
X-Received: by 2002:a05:600c:83cf:b0:49f:ce78:3562 with SMTP id 5b1f17b1804b1-49fce783698mr26147265e9.19.1789845885850;
        Sat, 19 Sep 2026 12:24:45 -0700 (PDT)
Received: from fedora ([202.47.63.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd03fe55sm114499505e9.2.2026.09.19.12.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 12:24:45 -0700 (PDT)
From: Muhammad Bilal <meatuni001@gmail.com>
To: herbert@gondor.apana.org.au
Cc: thomas.lendacky@amd.com,
	john.allen@amd.com,
	davem@davemloft.net,
	bp@alien8.de,
	ashish.kalra@amd.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH] crypto: ccp - fix SFS ioctl race against device teardown
Date: Sun, 20 Sep 2026 00:24:32 +0500
Message-ID: <20260919192432.272680-1-meatuni001@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sfs_ioctl() reads psp_master->sfs_data and caches it in sfs_dev before
taking sfs_ioctl_mutex, while sfs_dev_destroy() frees sfs_dev->page
and sfs_dev->command_buf with no locking at all and only clears
psp->sfs_data afterwards. A call to sfs_ioctl() that reads sfs_data
just before sfs_dev_destroy() runs will still acquire the mutex and
go on to use the now-freed command buffer in send_sfs_cmd().

Have both functions take sfs_ioctl_mutex before touching
psp->sfs_data, so a call that is already using sfs_dev completes
before teardown can free it, and a call arriving after teardown sees
sfs_data cleared and returns -ENODEV instead of racing it.

Fixes: 648dbccc03a0 ("crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
---
 drivers/crypto/ccp/sfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sfs.c b/drivers/crypto/ccp/sfs.c
index a4777839790b..530141f8bc74 100644
--- a/drivers/crypto/ccp/sfs.c
+++ b/drivers/crypto/ccp/sfs.c
@@ -111,13 +111,13 @@ static long sfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	struct sfs_device *sfs_dev;
 	int ret = 0;
 
+	guard(mutex)(&sfs_ioctl_mutex);
+
 	if (!psp_master || !psp_master->sfs_data)
 		return -ENODEV;
 
 	sfs_dev = psp_master->sfs_data;
 
-	guard(mutex)(&sfs_ioctl_mutex);
-
 	switch (cmd) {
 	case SFSIOCFWVERS:
 		dev_dbg(sfs_dev->dev, "in SFSIOCFWVERS\n");
@@ -191,8 +191,11 @@ static void sfs_exit(struct kref *ref)
 
 void sfs_dev_destroy(struct psp_device *psp)
 {
-	struct sfs_device *sfs_dev = psp->sfs_data;
+	struct sfs_device *sfs_dev;
+
+	guard(mutex)(&sfs_ioctl_mutex);
 
+	sfs_dev = psp->sfs_data;
 	if (!sfs_dev)
 		return;
 
-- 
2.55.0

