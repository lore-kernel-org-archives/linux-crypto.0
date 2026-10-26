Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015815;
	b=Zmvpb14EpjUAo4AkY79vwDRa4/lEc9lqkSdFEtezYVrztNvhYrEMkX4W//MHTyXC7TLw
	 7emS1MGk/xRGgU2DG0vlmBRmwUkxVAhs9hvnZdiya6lGiAt4jbP2bQYZCJxX0WN1ITNTH
	 cwoX6ngNkPal7lQp9heimQ1tqVENFGq1F6c3NOkQ6Au3Fj3T+bmRBcKiqtoxSglCt7QSb
	 IPCd+eoz7gKAIHeP969P2ozJZJVV/yCg+FzsYnHnd9BtYlJf7kX0ZXTcOF9Fphowar5DG
	 6m6NUM4l7KrV8XC4IsQmzK6pIyBEd+Fa9dm4pZyUauixtjZuJDdIt6lM0Xo9RqGA4tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015815;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=p863F7yqUAlNIjnSjn9uwuB2MTfwUOc9FZgewPikWBY=;
	b=t6D5luumcA1ck4HCxuFY+SzNG6IuznnVZy2ZD373wD4Rz9cGEbR1tpwZzF5XV7kpc/3k
	 UyKQhwOycAt/Aff4+pz9pDSPWhveTqpdoyoOPUBMZIhRrYhHzjc9K5kgHu37YHGWyc+Rt
	 yjCS4WqcbswO6WhTqp+qeAbDo+W6W2x+yqb+/AfzrOg4Byy9aroTS/TjR/PIDt0lkP2TM
	 p5rozymSts32lAHs4RTm96Qj+OkLMYxmaVOPEOJqXEbH1XPRVSUGarMFJHV0OD/+VqMEb
	 EYnwhWfIAjtJnmlMMD61N+RLOm06leC48MSL+yKXdPKoy4Zl+210qwhlTm+piY18ILQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="Xcha/J6y";
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C23606A31E
	for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2026 11:56:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26C23606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Xcha/J6y
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3adc4590de4so1965388a91.2
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2026 04:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793015814; x=1793620614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p863F7yqUAlNIjnSjn9uwuB2MTfwUOc9FZgewPikWBY=;
        b=Xcha/J6ytYLVg9qc21z4jUCiIqfAiSjlASvyzHU4ZWtwmRnrQhThSfgiCLNpMR+M6v
         PLb8Sgvl66WTH39KuCs9A4RNs4NAqPH3U3YUreb8/34f7dUEQAouqhNnlOTe/b7Qnpu4
         9M4TtT62O6HXUU4/Cfk6Atj1zq4YsKpoaPXwSvaLBmaHmrILZ+winxDCnxY+fkSsHJB7
         O4fhN0HiPy0WEZZ+YS6IkZ032+q7Jn3NleSBB3yYnGCb1HUAFhvYn+sGomYSKxPbEsha
         coaKkKhw1KtilP5QfRzt7VSnDEA6BfoVr4YFVrRBx3yncAwWJbaWMCzTJaHfwxXLZt31
         7j4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793015814; x=1793620614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p863F7yqUAlNIjnSjn9uwuB2MTfwUOc9FZgewPikWBY=;
        b=oazrlXv7+BrVrSgSj/HpbIPaqErLM+jDdhO1gPIE3OxQ0JknIGKYic3bx74sYXL7nW
         5X8QLsic0egFE6V36ArO8BZUSolXkDpfkjuhrMaaxlyeIjblw+iKUS9zny1Um8ablP89
         +MG+Fw6ig2A9/O5NT+wuU1D22gs4lHDF2UMqlmOOD86Wjg90AfCb8n0rulND/VdHWcjc
         bHwLWKKPZDWRaxPim78Tdavd7Nk3GylGxfAivEa75agbaPSrdwPo/aNIrbrRoHooVs/f
         D1D7iHwqv8j5YBPxUXemo+Hln2kHtMjBOFUZlDuxgjxDrvUxFurWDMltqKrv7dCIvf6q
         924A==
X-Gm-Message-State: AFq9FYLSMBfrGMrDbxBq4Tsf7FzxsAXEabRJgijNqNDbm+JYj5O16Apy
	g6yzY78NSWeT3qhWQ3Rv6xaUtBfad7hZ8wk5peIPitRSU6CadOwDvzJD
X-Gm-Gg: AYBFou1gjnpXGlBWxv9recn3EXlNE3SA800bv1escY6gCVh7hd2BPZKnq5kbAeemXBH
	g0drSdQQEt6pdm3bl8tcteNh7lOB/Mb/tV9LWq92z0/+Vzzytvbma56Jt8atGretspLyCOZGlGO
	nzER0yg6Q7R2abbC0s/szvfXiWJg3ExFqSrdCRcECUZtM6+OMbkL60y6Hj3evkzw8TpYa2o0jOx
	8nmlWUZ88ipPCmq10rXiLdtszwouxDz5g2L3ra41xPnC68momzBFZylOAEgVO9D+T1C/5W4JbQZ
	6uf9lwZ+9M9PyT3QO6AXQVt81SSFFuOwu/4WUXKFIZnS89oOicvlScMSkokeqxk+p6WwqIciY7w
	yJoPTUXD5RIwkQBR8vRaMWonvlRCXm00F1txBPIhTesUvQPZ0b84TvEESuBl6LYJHpDCsoDoZqu
	wE0/VVubFAJlIW+8MdxwAQskAvz/GIbOyetkTsq6wMeobe1EIwWbYBOi43kgOUM/2kqN23bCgxf
	U1IYq+QFgIHAoiztNCUjdLBxui5fCu66hVQRheBMqBc9/qDMBe0jtW7quvOcip/dKT2bdZXqrw=
X-Received: by 2002:a17:90b:1812:b0:3ad:b7d1:8631 with SMTP id 98e67ed59e1d1-3adeac04901mr5445526a91.17.1793015813956;
        Mon, 26 Oct 2026 04:56:53 -0700 (PDT)
Received: from spiderman.taila3fd8c.ts.net ([202.112.47.77])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebaddd45sm5684433a91.2.2026.10.26.04.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:56:53 -0700 (PDT)
From: Li Ximo <lixicaicai@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Prabhjot Khurana <prabhjot.khurana@intel.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wang Haoran <haoranwangsec@gmail.com>,
	Li Ximo <lixicaicai@gmail.com>
Subject: [PATCH] crypto: keembay - fix list_first_entry() on empty dev_list in find_dev helpers
Date: Mon, 26 Oct 2026 19:56:46 +0800
Message-Id: <20261026115646.4137906-1-lixicaicai@gmail.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wang Haoran <haoranwangsec@gmail.com>

list_first_entry() does not return NULL on an empty list; it returns a
bogus pointer computed by container_of() from the list head. Both
kmb_ocs_aes_find_dev() and kmb_ocs_ecc_find_dev() call list_first_entry()
on their global dev_list without checking list_empty() first. The list
becomes empty after the single OCS device is removed (kmb_ocs_aes_remove()
/ kmb_ocs_ecc_remove() do list_del()), while existing tfm instances may
still invoke find_dev afterwards: for AES the device lookup is deferred
until the first encrypt/decrypt operation (setkey only stores the key),
and for ECC init_tfm of a new tfm can run after the device was unbound.
In both cases the bogus pointer passes the callers' validity checks
(the AES callers test for NULL, the ECC caller tests with IS_ERR(); a
container_of() address inside a static struct satisfies neither) and is
later dereferenced via ->engine or used for MMIO through ->base_reg,
causing memory corruption or a kernel crash. This was found by code
audit; we do not have Keem Bay hardware to reproduce it.

Fix both helpers to use list_first_entry_or_null(). The AES helper now
returns NULL on an empty list, matching the existing NULL checks in its
callers. The ECC helper converts NULL to ERR_PTR(-ENODEV), matching the
existing IS_ERR() check in kmb_ecc_tctx_init().

Reported-by: Wang Haoran <haoranwangsec@gmail.com>
Reported-by: Li Ximo <lixicaicai@gmail.com>
Signed-off-by: Wang Haoran <haoranwangsec@gmail.com>
---
 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 3 ++-
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c      | 7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 660830c36..268a15886 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -129,7 +129,8 @@ static struct ocs_aes_dev *kmb_ocs_aes_find_dev(struct ocs_aes_tctx *tctx)
 	}
 
 	/* Only a single OCS device available */
-	aes_dev = list_first_entry(&ocs_aes.dev_list, struct ocs_aes_dev, list);
+	aes_dev = list_first_entry_or_null(&ocs_aes.dev_list,
+					   struct ocs_aes_dev, list);
 	tctx->aes_dev = aes_dev;
 
 exit:
diff --git a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
index 9bdee39dc..67a69a205 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
@@ -208,11 +208,14 @@ static struct ocs_ecc_dev *kmb_ocs_ecc_find_dev(struct ocs_ecc_ctx *tctx)
 	spin_lock(&ocs_ecc.lock);
 
 	/* Only a single OCS device available. */
-	tctx->ecc_dev = list_first_entry(&ocs_ecc.dev_list, struct ocs_ecc_dev,
-					 list);
+	tctx->ecc_dev = list_first_entry_or_null(&ocs_ecc.dev_list,
+						 struct ocs_ecc_dev, list);
 
 	spin_unlock(&ocs_ecc.lock);
 
+	if (!tctx->ecc_dev)
+		return ERR_PTR(-ENODEV);
+
 	return tctx->ecc_dev;
 }
 
-- 
2.30.2

