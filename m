Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0121CE084;
	Tue,  2 Jul 2024 18:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719946615; cv=none; b=MNrQXa9ZLQTEP05eIt5cZsxVt1nogF/FEW5pBbTzmafXxL2pPFxJG89ktHmHxyz37F6pX4EqSrnFEI45YS+OcgxmoaxgjYRRKGey9oNrh8x0kdZdWzC7dibVPIzvVefvXIHF+6ryLiWhxUtcT9b6IyGYrYN395Gq+YSaAQTbTIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719946615; c=relaxed/simple;
	bh=Tq6BeA1w1NTkooeocTh0TfPApScW5WuthP1LYm80wmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTA0+xRq3Ju6f3hquJWB0f0fgjLtGHWEz7enJO3NtVGEnaKFYmVN5eglO+Dtyovkd9hBtitRydM8fyYW54E6BsBFGV2rJwS/q7lz6BjatiHAvJV/tnDy4LzvMTZWGXwi8xSH95J9r0y8KDXuF9hGTcZHTht/wvAWsyNYEhP2N3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-57cb9a370ddso2610050a12.1;
        Tue, 02 Jul 2024 11:56:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719946612; x=1720551412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ip/QRkyatcVO8eC7phQqenDI9TdZRtsHzlRKFfbcrzA=;
        b=VCc3e12YJ2ecE6N+f6bbsltlMLHshtocB7lD/rf7Ms5H9NFBfYwKOK8UVKIxj9ib2a
         V4uklJPmqaadzMdtbbj+yneyovZoCj4z9HQ7IUZOfWLhRwiPZobzXHZ+H1yGawPdLfCi
         9Or5mSKct4EhjTlf2NOo7W7jPQdkKJHkcbbiABN9BPeuXTAF0db0tA7pxfd5uypG0mEE
         VJTSfdNNOmHn/AAuSYqS4fcIWLGrfhHHd+JwLwhq+jQyNpz3KAhcbkn2TqZyWrHGxzZ9
         N3m+A5Ipszy5ycN8uiYemgb54/gk51t/vgjA75MnfWEJb+1LryrNGH+i3dDMcVJKM5XW
         YyTw==
X-Forwarded-Encrypted: i=1; AJvYcCWZZlTpcDGCBivAwwoN07LPRZ2l5rIr9Gy2TFg9Y8uX2MfBSftG5502y03W2ZWF9GRdvE22GHQVZ4Jv2y9vWQHmrbI8a8kT3Ne2Mqe9+1Hcn0kZ4gwSy39r9eg3cSVisJZuGVw6GJB4cj9lwTLYTPIJCSM5BBSoY8+VGvZ/3BCHJG9H
X-Gm-Message-State: AOJu0Yx1d3wWLt1CBrxmgp4hLdDepEW/ih8yc/77B0A3xiJiHUji84GR
	bSXZmoc42og9dS4D43RJ+k3RO41j1pPa8YZQb02htTBvXNmU7rLc
X-Google-Smtp-Source: AGHT+IFVGEuTqBHQWwZ3xfvjSxpJO86F1S10Bdm6VwIjobxlgC6PqqFmKGSZQEEo+L2eUFVJp179mA==
X-Received: by 2002:a17:907:60d0:b0:a77:9bf3:f2f0 with SMTP id a640c23a62f3a-a779bf3f42cmr56778766b.65.1719946612128;
        Tue, 02 Jul 2024 11:56:52 -0700 (PDT)
Received: from localhost (fwdproxy-lla-112.fbsv.net. [2a03:2880:30ff:70::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72ab08cfc1sm442036166b.163.2024.07.02.11.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 11:56:51 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: kuba@kernel.org,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: horms@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v3 1/4] crypto: caam: Avoid unused imx8m_machine_match variable
Date: Tue,  2 Jul 2024 11:55:51 -0700
Message-ID: <20240702185557.3699991-2-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240702185557.3699991-1-leitao@debian.org>
References: <20240702185557.3699991-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If caam module is built without OF support, the compiler returns the
following warning:

	drivers/crypto/caam/ctrl.c:83:34: warning: 'imx8m_machine_match' defined but not used [-Wunused-const-variable=]

imx8m_machine_match is only referenced by of_match_node(), which is set
to NULL if CONFIG_OF is not set, as of commit 5762c20593b6b ("dt: Add
empty of_match_node() macro"):

	#define of_match_node(_matches, _node)  NULL

Do not create imx8m_machine_match if CONFIG_OF is not set.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407011309.cpTuOGdg-lkp@intel.com/
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/crypto/caam/ctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index bd418dea586d..d4b39184dbdb 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -80,6 +80,7 @@ static void build_deinstantiation_desc(u32 *desc, int handle)
 	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
 }
 
+#ifdef CONFIG_OF
 static const struct of_device_id imx8m_machine_match[] = {
 	{ .compatible = "fsl,imx8mm", },
 	{ .compatible = "fsl,imx8mn", },
@@ -88,6 +89,7 @@ static const struct of_device_id imx8m_machine_match[] = {
 	{ .compatible = "fsl,imx8ulp", },
 	{ }
 };
+#endif
 
 /*
  * run_descriptor_deco0 - runs a descriptor on DECO0, under direct control of
-- 
2.43.0

