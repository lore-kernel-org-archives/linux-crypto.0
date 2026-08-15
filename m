Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B26331ECC
	for <linux-crypto@vger.kernel.org>; Sat, 15 Aug 2026 17:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786813806; cv=none; b=aWBY9FpKglolg6my/3e86yf7Qx6SC8YL7dDfUcFNrMGUUIn975K7E9HsSuKKzgI6pgqRkETh1FMjskdp420ZosLepX3h60JYjFQyr/IyquvFK4vh+M+KyrF6EZAS0DoGA6sKYTGtlFdywmzyuwXOwmd5yzDTO410IaI4pbmS6D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786813806; c=relaxed/simple;
	bh=A5cMqtx4OcUeiHcl+Ll5ywa/XhjXm6ZgG6SDd8eXoBg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GsZ4ckSJ7dh8s1zgXoQBvOocaAMAysdsqpBQ02RoVB4hcCNSNGV8u5F2BUFjI8ufCsLT4FyZpYy2oz6V+p6JkrE/+Lub5XEXYdaMfkUaBA91QbZSgYp15yojLxOFgkGW2QUYBGsZ0mIlh+qVBDMSSIt+Wi59gypkIR5wdwj9ZCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RgiUkYLL; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RgiUkYLL"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15f020a223so289166366b.1
        for <linux-crypto@vger.kernel.org>; Sat, 15 Aug 2026 10:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786813803; x=1787418603; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f8FtYQNvh07cjnyWUEvGsLzktiNV3stpCYLWKZzqamA=;
        b=RgiUkYLLL0EjcGgBg2tMAXCZe55pmJr+QB8dqX6s9ji/KL/6l8+PyyCNySWlIUhmT7
         ds16OH1Kh89BdtdcSnNyePO72tyz1ZBzS1NBAlqLVlhx6zQuUeGOpz9tIfqvpTY0H9uA
         aoJebSEZ8GCPB/Cglmv6BZV/xziGYRW8bV1tSkGjrfoU54lk+B75wykkIBmZoUlbExWe
         iYDFsWCyjEHhJ7FoZDParrg12XzbX0eU0pR7IcuiS70/V1HkZAo8clTc1a/WCWPnuxAZ
         bBDovJmNPQeUzbalp41jV9Y99L09ZRcWJMvRfKYsMYkfyKBXOXlM0SoX3HGYcNJNtAcq
         ETpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786813803; x=1787418603;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f8FtYQNvh07cjnyWUEvGsLzktiNV3stpCYLWKZzqamA=;
        b=VkY3p+OFGJsu1xwct0iP9E6JC1E7t/D0Mu39q8+OnTRskg+2UCSsmsjOWIPBadqsJx
         swtXyOdrVjyzt7DcKx8IrN5dvKK9TdyBNnKKJGTtDEW51W1N0WCfsjy405ceB67WlslI
         rxsIt7+eS0KghYiuX4wtzZBgr65fK/V2DGuy91FQJI2QLrO5H1aL6wBT0QvStujZhjLa
         ugh7tHBu4vPq86m/isPVM8n5h/6pQv20zAGd+yRz1zRBvebRvkeTwnOcH2aLKcBF5fs3
         vmO822OffivqSLzy58wuFRvIscltbOmZIbLGTy0eClutFDY3XLJLr7WObNXRdYXG6qun
         Lrkw==
X-Forwarded-Encrypted: i=1; AHgh+RqEVyz1I4IHppF/4wYNpdqD671f7B8Qz56uK1Z/zRJMt7a0ERrBcQeyowSRJ+CIsp7s43VGnHvA6/Si1Qc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMFmNnZUB6+Rl57PrcPitXH4fsawl5AOLfNgXVemZoTWUJY9Ar
	uTtbl1VPXGvkh4aIRisxe8mQiWU5riwyJeIeKaWrc2/UP/34+BHAXnsU87FiC5OaBz0=
X-Gm-Gg: AR+sD10SgOlkxVt9RyjlL+5+//M6ZZ/is8MlcTAbZYZZuhkb2qgzyQHtY04AQOT4yKf
	AhYRfUIdM2rPKwkv13pKWt4Mt0etwWoe9+cXjRBsxhE+k37Y0cdwjASUujxrw/HizsZXAihw4lx
	WE1jAnDWJ+75gXkweCpeeZDjlpBOVv/uzXqY1F40+z+WxSOBMZ5guzNsCmw0enbADDm1hBiR40H
	Q3HnIzP4on/1YKmvdgEGqv8INkiPVyqew/Q6FQrC/UHQTQcnQjBg6w5msWrn4YPmfhHSmToOw+l
	1YXLI4oX46xkr3fr1v3AZ1iFNv5J0Zu/UCyZkelDoP9yR5V+dvjUJL2dIEVLSitgzJSCOHlZP+E
	//hAZTSxHPUEim2nU3J1DLbSUqdT4+IMiLX1o/ARJzylimBfuvVMjevc7nKnwPNbUMx60UjqhA3
	FSSUvywsmY+ZNeL9JuZFRnv4dabse/LUk/KxKH2DWu9IdEP1Tw0Lt86gMC2P0OoEtFmjZ3jZk8Q
	ydzo5KhPWv74Dh4fN4=
X-Received: by 2002:a17:907:fdca:b0:c08:417e:3696 with SMTP id a640c23a62f3a-c212a0f2e5fmr569257866b.20.1786813803080;
        Sat, 15 Aug 2026 10:10:03 -0700 (PDT)
Received: from david.gall (k10193.upc-k.chello.nl. [62.108.10.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2140a8d4a1sm155920866b.26.2026.08.15.10.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 10:10:01 -0700 (PDT)
Date: Sat, 15 Aug 2026 19:09:58 +0200
From: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH] crypto: ccree - use crypto_memneq() to compare AEAD tag
Message-ID: <aoCdZiqJjb5XDHHz@david.gall>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

cc_aead_complete() compares the computed MAC against the received ICV
with memcmp(), which short-circuits on the first differing byte and
leaks tag-match length via timing. Use crypto_memneq() instead.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
---
 drivers/crypto/ccree/cc_aead.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 088c4603047f..d57a98f89e53 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -226,8 +226,8 @@ static void cc_aead_complete(struct device *dev, void *cc_req, int err)
 		goto done;
 
 	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
-		if (memcmp(areq_ctx->mac_buf, areq_ctx->icv_virt_addr,
-			   ctx->authsize) != 0) {
+		if (crypto_memneq(areq_ctx->mac_buf, areq_ctx->icv_virt_addr,
+				  ctx->authsize)) {
 			dev_dbg(dev, "Payload authentication failure, (auth-size=%d, cipher=%d)\n",
 				ctx->authsize, ctx->cipher_mode);
 			/* In case of payload authentication failure, MUST NOT
-- 
2.43.0

