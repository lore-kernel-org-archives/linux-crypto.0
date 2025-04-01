Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F3B20E711;
	Tue,  1 Apr 2025 19:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743535443; cv=none; b=UWqJu+BVx7XRHmw3pMpXlxNSopt8nmY8qAgWNZu5+ikUy84c3CfiAQ30Y5PGAZqYbbcUaX3TN8RY1IffBl6VBi7nScOegmfsiAke0MUzUYh2PNHP0vuVCrZmmn+ngEjkUpnlIWMevQSPMr2FJ0J6rUPsEjy1/cz+FANBvPSRyyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743535443; c=relaxed/simple;
	bh=ujIPapzlL7mjHgW3aviWBgtecWjNM0nt1PjVn8npb/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ua7pw6aqAw10CdmKPtRfDDA+3xHJTC7POc5NqKZ0IXgwHw5ikxx5jnRoCGRzVk99/DWxUyQZu7tKg/aus1qJRAeMCxCDaWLpWFmqAInkyLCHbPbEt4tw+kAV3uQZaMOrMxqzUzK4WyiQgZ75HvIno6eGsh1wwNnCNzrLGTHBBD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QoJa2WbX; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QoJa2WbX"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39141ffa9fcso5689341f8f.0;
        Tue, 01 Apr 2025 12:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743535440; x=1744140240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I/+iZ7oXBPhE3cNOeJn0BX2fJsfTTe1JAGSbvb0XfLY=;
        b=QoJa2WbXDqIAoHWrux+LY1Tl1WDbLQKigpeYP5fqAwR4rU8D4HgZQInkHiOLWIMLh5
         moAd31EO/a+Ixx01EsJBfbRfyjkgIimR6nVzuxaDGe+uti8vfzr7yEG6Oz36JcZGYhgR
         GcVYzHnVlzLoszC4KKawPVPhWocItuxXotUM0WuiIYBEg+jrVOBov2mNh2nZLwnPMdFD
         lZzv/Eo1E6GIdcjb38TN3VGMVtWLhSddIn5wA0pmnSvcDIcBWzICZItM81xSgaSqMgHd
         IUV0DzmVs89bRWSKHcLsK8DtbcDYNrPhivlO8/qS6A7KUAaPp+j2jKt0D6bCHDNpQ9F5
         UM0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743535440; x=1744140240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I/+iZ7oXBPhE3cNOeJn0BX2fJsfTTe1JAGSbvb0XfLY=;
        b=NnPF9XtdtSdgJYHUdvD+VdTskUVfvCEz/2vdYyieMpOOYndh3dZsFIuqhV+FCYjo25
         psMhc/aZgCqDP8JjJS547U0IRgiowF0RHOp5ybrbKjFby/0M3CESOcyi90JdqbHgEF0p
         NupSS4EypDOOupK53x282P8jbje7W8B3RsQV5NkutNo5b9tYBrT4wlebDMU+vVvSz//Y
         qsHyMcDmUVIOgiEPz+jxIN+ehh1Oz/DF6/5JafOGBf3J+S5u4weYLQ4UoRIAqfH9E3ok
         1xXP9WFpZ+ISwGs7oE0pxBqibvSOO9/RkZg1WlCgGM6Yz1wpF93dRKNskjWY0S9HI0r1
         RSnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkb8YkIzhC9bikM6S7mXHnVsa+EMvx62+hD2wlO+i9+j5ylmTK5aRFZ5etQIRCec/nOnnrxHdxVQinJCeM@vger.kernel.org, AJvYcCVD9RA25rH/EVnNWBbUCsN2nfVBspM8wPMTrdV/ntzsxG1hO8BEj5A9xzBq5DVXmnyUAOqLXwiGAOehCvY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtMtU3PtqwV8gKnG39UqDXlcCCJKtYcAU6VR+oj4gne6KL0GEs
	TjLw3iJzLi33MbuSpT9tGW8HPCyxF9J3y1ZPohJtQjRvlettPek2
X-Gm-Gg: ASbGncutRJJLRzQCF+myWwOnMWpM25fYRHKr7fCUVaw0cTs8/Qqbj3UTa2I/UFm/o5K
	CCL27v2EKtlmzkOd3DVoEn3OPIgtgXI/R+m5MlBQEKeJ5nWLYi3xY6GYh3/MiGZmjPYfeLfPSTX
	/aNqQDNjrz0Ali4ylkKlJxfRKc/0Go7fxjtub1Ni7FyDT61VZM7cpC6LjCv/fKYryGey2SIp7k8
	bktFmMHeimZ3AMecdErXKyTpPNAG7f2jF2Op2HlOxFQ+Gl1jIv0C+u8dqDji9fo7XEkzRPoiyHm
	Ngi5fzvbIul13bNX9Fsm3c0Z/+eThrj9+AxDXZ4y/JgMjoXLHjoO11p8shMtLzsiRn5JGI1V
X-Google-Smtp-Source: AGHT+IEroLhlH55Nn0a2Cu0BMYw27BSdC4OLp0dlkWXs82H+dhWwczs/WCChC+qm41GDorZgNFvJwA==
X-Received: by 2002:a05:6000:40ce:b0:399:6ad6:34 with SMTP id ffacd0b85a97d-39c12118e33mr11160301f8f.35.1743535440077;
        Tue, 01 Apr 2025 12:24:00 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b66aa32sm15353438f8f.50.2025.04.01.12.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 12:23:59 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 4/6] crypto: sun8i-ce-hash - drop CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG ifdefs
Date: Tue,  1 Apr 2025 22:23:19 +0300
Message-ID: <20250401192321.3370188-4-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>
References: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct sun8i_ce_alg_template' is always defined, even with
CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG disabled, so the ifdef guards
are not needed.

Make sure the statistics have IS_ENABLED() checks instead.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index b0959d8218cb..530c5181d73c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -31,9 +31,7 @@ static void sun8i_ce_hash_stat_fb_inc(struct crypto_ahash *tfm)
 
 		algt = container_of(alg, struct sun8i_ce_alg_template,
 				    alg.hash.base);
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 		algt->stat_fb++;
-#endif
 	}
 }
 
@@ -354,9 +352,9 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	flow = rctx->flow;
 	chan = &ce->chanlist[flow];
 
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
-	algt->stat_req++;
-#endif
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+		algt->stat_req++;
+
 	dev_dbg(ce->dev, "%s %s len=%d\n", __func__, crypto_tfm_alg_name(areq->base.tfm), areq->nbytes);
 
 	cet = chan->tl;
-- 
2.48.1

