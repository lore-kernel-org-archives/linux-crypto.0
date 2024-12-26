Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEC818E1F;
	Thu, 26 Dec 2024 13:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735220938; cv=none; b=s4J0Ldm9HgowtFQ4ioot91DJOJ/K/rzIoEII0KlKqIF6GVqJdZP9UhYtz28eDX1TPjuF0uDmydfe/ixJT8dJohE+I9X86/2xQN7lt+CpdWnXuX62kqFcU0XzA1/aQIzQOhDlL2LT2p30fnfVWN9vVBkvv6rTAZRzZPx535kahRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735220938; c=relaxed/simple;
	bh=1wKchWw6LldoRjWm3Xdww5mRqo9p6HyDFwtJ4yR9CLA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a/fLLKQ16N6Gea3lXOIG5wLsNGsOR9NBMfsMofgIFs57mxD8d1gkgiPCmHX+fLGf0y0MxWbiq4kP3pYm9RNA0Q59r8aSYHA+4SMmMOQ1KxotAYp9OXTv7QhrurBIzlwXvTHrI3rQ803/O50mdXm3ntaYFOkHJzf1oOMvYtDF748=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ewxTrnX1; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ewxTrnX1"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2eec9b3a1bbso5853968a91.3;
        Thu, 26 Dec 2024 05:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735220936; x=1735825736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NOWT3xFqVkiMDk5iWxvQCmp0gp9TY2oUTa68nDDoZ9U=;
        b=ewxTrnX1TbNd9Mcr/0ly0k8h6LTlGQl9tNjXUtaDyUQJb3Wvzmd2Z2SbSxV7/FKWTV
         CWumOe1eUcfHoR1ubse1L4U79V+RBOCbZBXfBAkONVKnlen/r1z7SN2liuHb92Phyl4Y
         9ZLGvKcqwEvIj9v0SPFkEwtT7KWRl0otiXd6p05lKS1Q7WM5CEbx2zu6EBADZo429up6
         iF3kIc/1gezKBEGcJJzWOjOerOs5nY9Fj3L/lsSARDC8tkftwIxf/8QYS7NUK5xvMhSC
         gVZcwI49IMLT5AGf8Ee4px+FZgLkrCaP+2QuQJh5vsMAKCdmW1Cfp54YKPE44UyCEUfK
         IseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735220936; x=1735825736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NOWT3xFqVkiMDk5iWxvQCmp0gp9TY2oUTa68nDDoZ9U=;
        b=OceANnJ67iT5JRxsUVzmTm8aufoP9mQWTi6yrNSWB2GR9sqk6iTItILJie8lh2Ebzm
         69CZOOeXXvG0Jnp0Lxw2hU1eDwHi0eZMSlsJZ6zLmg9dvwjLJSuxYSlgxg5d/J3+rVlH
         9OrFVC1GzOS86847el5hPP/NCJk2s8zSGZuMtVwgr4yztlnaetmFargsfDXosQKTyqL/
         mWmJ9H9oc0tfjZVr++wyPrxu/fKNA9dEdGQJ/WViJIjoXHZODCkjKgHT8O56igtvi2ry
         awmOdDFpq5Wc3PoVPC7viwq8whEAytMVsiamesY1XvcOwXXJLoiCs/3X1VtT6N5oyzA2
         s8+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWOGingTD97RIt37qXOliZxcEJK4P1m4Za0c4w59Kd94QoczOIwZcd5644bI+1jjJd6+0n3o1va+HuMZ5A1@vger.kernel.org, AJvYcCXx0QvbaKCyBv/QsgUUgdeTjo7pOxqP/PLhWcJ2XpxLrc69L0lo8RuWeLKE0xraleTFDpVskYLIE3Yu2g0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXO5+NxckkuyEDJ70hmM/L2cAxjhd2nVx6Z4r+qcTrrExrPLh9
	MuUI1booLnHpKlOwoFxBTznJoc+aUwFLek9nlXYLQOi2uxfvjDdazvflPk4S
X-Gm-Gg: ASbGnct2T5TBiTLe26Gv0+RpDHgYZLzkb9O98t15TN8ULSACYd1eK2JQp6/65SaGaVG
	ZF1M/kaMQrybQ848CfDv56+kJOu3LfvMgw0QAK5G8duuyGbliBK8R7Jw+mZ1lAZuZq6bl2B1DJD
	yTju04DoNomkv1dUf/8zOo15etNPkyFRp4yi9baaCPVyU4oDniSjQNNEnnW4ebvR0NoUOHm38mO
	ofsYB0Smaj07hecxSOjT2dsnjDjPTJrsr3GdfZXCeAzm7oxad++BDv6G8t2MeJb/aQt9tHC
X-Google-Smtp-Source: AGHT+IH5pgsm3LOLUwiX+FuunBWLtQu+y57Sq+wtmMHzeJlvGJTeOHs0aoWoJB1Na+9K4hvSOHS/rg==
X-Received: by 2002:a17:90b:3a05:b0:2ef:e0bb:1ef2 with SMTP id 98e67ed59e1d1-2f452e3a8edmr35652647a91.19.1735220936347;
        Thu, 26 Dec 2024 05:48:56 -0800 (PST)
Received: from localhost.localdomain ([2401:4900:5ace:1ff:91c9:9eac:6745:3e6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f46fabe958sm8059336a91.26.2024.12.26.05.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2024 05:48:55 -0800 (PST)
From: Atharva Tiwari <evepolonium@gmail.com>
To: 
Cc: evepolonium@gmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: vmac: fix misaligned pointer handling in vmac_update
Date: Thu, 26 Dec 2024 19:18:47 +0530
Message-Id: <20241226134847.6690-1-evepolonium@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Handle pontential misalignment of the input pointer(p) in vmac_update
by copying the data to a temp buffer before processing.

Signed-off-by: Atharva Tiwari <evepolonium@gmail.com>
---
 crypto/vmac.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/crypto/vmac.c b/crypto/vmac.c
index 2ea384645ecf..8383a98ad778 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -518,9 +518,19 @@ static int vmac_update(struct shash_desc *desc, const u8 *p, unsigned int len)
 
 	if (len >= VMAC_NHBYTES) {
 		n = round_down(len, VMAC_NHBYTES);
-		/* TODO: 'p' may be misaligned here */
-		vhash_blocks(tctx, dctx, (const __le64 *)p, n / VMAC_NHBYTES);
-		p += n;
+		if (!IS_ALIGNED((unsigned long)p, sizeof(__le64))) {
+			/* handle misallignment by copying data to ta temporary buffer */
+			u8 temp_buf[VMAC_NHBYTES];
+			const u8 *end = p + n;
+			while (p < end) {
+				memcpy(temp_buf, p, VMAC_NHBYTES);
+				vhash_blocks(tctx, dctx, (const __le64 *)temp_buf, 1);
+				p += VMAC_NHBYTES;
+			}
+		} else {
+			vhash_blocks(tctx, dctx, (const __le64 *)p, n / VMAC_NHBYTES);
+			p += n;
+		}
 		len -= n;
 	}
 
-- 
2.39.5

