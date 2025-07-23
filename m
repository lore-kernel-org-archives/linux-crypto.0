Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E03F1A9B46;
	Wed, 23 Jul 2025 02:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753239068; cv=none; b=gHKdeeEBYFynuwUNFnkWG+aCX8L89kUVX+534SlCboze567nfVhlxqZz6RLPwYGzibdPy59fhVal/2Cw5XzhUL1Zm6SwaparDHreNaTHq9kUEHx8s6JSDu4LryELuTQPZiZQT6wPfQxXQ638udy+hCKQwT1wFV+iT8zC+R//evM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753239068; c=relaxed/simple;
	bh=W7regQMFM7V9N05VQIC9KKSQsVpg98Qy0R0QwOs7kLY=;
	h=Date:Message-ID:Mime-Version:From:To:Cc:Subject:Content-Type; b=PtVIB/GpLXsW9BWgYnJ1kDq7yQzsFMryJCJXWjKP9MVC36DCujLx6UeUXd9MVAcCbBAXXJnVqsdctpeooaMaeu45DIchk8ow3KUo273ol7itULe04k2MLV8JrzLxQL7vWDlGE50TsZIV+Rv4wzi7yiHEBfYq234f8pMAOK2hcwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4bmzCn6yMmz6Fy6D;
	Wed, 23 Jul 2025 10:51:01 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 56N2oQGx026563;
	Wed, 23 Jul 2025 10:50:26 +0800 (+08)
	(envelope-from zhang.enpei@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 23 Jul 2025 10:50:27 +0800 (CST)
Date: Wed, 23 Jul 2025 10:50:27 +0800 (CST)
X-Zmail-TransId: 2afb68804df32e2-c1398
X-Mailer: Zmail v1.0
Message-ID: <20250723105027140oF4Bwli1JuZcQ0V5-7pyK@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <zhang.enpei@zte.com.cn>
To: <horia.geanta@nxp.com>
Cc: <pankaj.gupta@nxp.com>, <gaurav.jain@nxp.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <christophe.jaillet@wanadoo.fr>
Subject: =?UTF-8?B?W1BBVENIIHYyXSBjcnlwdG86IGNhYW0gLSBzd2l0Y2ggdG8gdXNlIGRldm1fa21lbWR1cF9hcnJheSgp?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 56N2oQGx026563
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: zhang.enpei@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Wed, 23 Jul 2025 10:51:01 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68804E15.003/4bmzCn6yMmz6Fy6D

From: Zhang Enpei <zhang.enpei@zte.com.cn>

Use devm_kmemdup_array() to avoid multiplication or possible overflows.

Signed-off-by: Zhang Enpei <zhang.enpei@zte.com.cn>
---
 drivers/crypto/caam/ctrl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ce7b99019537..2250dce9c344 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -592,9 +592,9 @@ static int init_clocks(struct device *dev, const struct caam_imx_data *data)
        int ret;

        ctrlpriv->num_clks = data->num_clks;
-       ctrlpriv->clks = devm_kmemdup(dev, data->clks,
-                                     data->num_clks * sizeof(data->clks[0]),
-                                     GFP_KERNEL);
+       ctrlpriv->clks = devm_kmemdup_array(dev, data->clks,
+                                           data->num_clks, sizeof(*data->clks),
+                                           GFP_KERNEL);
        if (!ctrlpriv->clks)
                return -ENOMEM;

-- 
2.25.1
