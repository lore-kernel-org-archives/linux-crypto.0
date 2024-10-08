Received: from cmccmta1.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057122038BD;
	Tue,  8 Oct 2024 07:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728372179; cv=none; b=jUxclQTk7H9VhqcPl7Kp6aAdOrIi7adTVkYH2uh5rjJnxNzELjjF7kRjjF5pffdVIv+nW9f34+lpwgG45OUW/GkWE0EK+JuN/MJLN79zPLqLiKdNoR2NB+QyR3pYYbLLuUk/lFIEa5+Lqrptx9oVJCz+HMM96stVScmwCQ+ZaqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728372179; c=relaxed/simple;
	bh=UuLI0zDrCi7LCedc02GhHPMfdvFyZ3e4qegkfmmgw2g=;
	h=From:To:Cc:Subject:Date:Message-Id; b=W9nYxMR1RXsrVAEalbIyYByWKOPT4vvh7SDHxWSjR+UfhILUt0CTbvKv+dKUxL6as8wb+Ugxbbpcn4uS4xHU89feNllSviM7Zk19VGzhg5pYSt0BstdSv0PjEw7sjXC6HKPzTnIeo6PfLHtpmqwCXBm10ILx/as/cYMefsJPhPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee36704ddcbfbc-b07cc;
	Tue, 08 Oct 2024 15:22:51 +0800 (CST)
X-RM-TRANSID:2ee36704ddcbfbc-b07cc
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from ubuntu.localdomain (unknown[10.55.1.71])
	by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee46704ddca1cd-93490;
	Tue, 08 Oct 2024 15:22:51 +0800 (CST)
X-RM-TRANSID:2ee46704ddca1cd-93490
From: Zhu Jun <zhujun2@cmss.chinamobile.com>
To: olivia@selenic.com
Cc: herbert@gondor.apana.org.au,
	zhujun2@cmss.chinamobile.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/histb-rng: Fix the wrong format specifier
Date: Tue,  8 Oct 2024 00:22:48 -0700
Message-Id: <20241008072248.12681-1-zhujun2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The format specifier of "unsigned int" in printf() should be "%u", not
"%d".

Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
---
 drivers/char/hw_random/histb-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/histb-rng.c b/drivers/char/hw_random/histb-rng.c
index f652e1135e4b..1b91e88cc4c0 100644
--- a/drivers/char/hw_random/histb-rng.c
+++ b/drivers/char/hw_random/histb-rng.c
@@ -89,7 +89,7 @@ depth_show(struct device *dev, struct device_attribute *attr, char *buf)
 	struct histb_rng_priv *priv = dev_get_drvdata(dev);
 	void __iomem *base = priv->base;
 
-	return sprintf(buf, "%d\n", histb_rng_get_depth(base));
+	return sprintf(buf, "%u\n", histb_rng_get_depth(base));
 }
 
 static ssize_t
-- 
2.17.1



