Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4712A230BEC;
	Sat, 19 Jul 2025 08:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752914067; cv=none; b=JOieTN5dwMptrMSmIUCyJh0OgPQOI/62ftTM6H8boVVUSlA8S9FYhR228ewpI6CZ299h305HhKL84li/+p3UvmdrhKxUPCkSBHKwEtG3Pn4gSjr3BGHrGB1oETDNZDulgD2GjN0iAhPYvpJo4pVbpN2TIu+KLvuceoGB3iqzrFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752914067; c=relaxed/simple;
	bh=UkT6xN5CPR0q+PZGu5ho76QWP+ynIDrFXKgZgXpcfFA=;
	h=Date:Message-ID:Mime-Version:From:To:Cc:Subject:Content-Type; b=N4ZDPNYO9lVKRXacWRTyfRB46bKg+BDzoXaomYzMlz/5fOEP/2GmVbKVT5Jje1TmJ5xMyXiBMwsH+rI1nUZEI35KR6pTTDpwkJle5BrFQeDA6TgdD8zKqdVv5ShjdPJpIVHSKC5SuhL9scqB4iHNcAsaKnSivynFWtsOePp/v9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4bkg1l6Gfnz6Fy5c;
	Sat, 19 Jul 2025 16:34:19 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 56J8YErv033205;
	Sat, 19 Jul 2025 16:34:14 +0800 (+08)
	(envelope-from zhang.enpei@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 19 Jul 2025 16:34:16 +0800 (CST)
Date: Sat, 19 Jul 2025 16:34:16 +0800 (CST)
X-Zmail-TransId: 2af9687b58881bf-c2661
X-Mailer: Zmail v1.0
Message-ID: <20250719163416760SUAwKHXRQRBFKhvAOpNbT@zte.com.cn>
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
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBjcnlwdG86IGNhYW0gLSBzd2l0Y2ggdG8gdXNlIGRldm1fa21lbWR1cF9hcnJheSgp?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 56J8YErv033205
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: zhang.enpei@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sat, 19 Jul 2025 16:34:19 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 687B588B.002/4bkg1l6Gfnz6Fy5c

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
+                                           data->num_clks, sizeof(data->clks[0]),
+                                           GFP_KERNEL);
        if (!ctrlpriv->clks)
                return -ENOMEM;

-- 
2.25.1
