Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF813122;
	Mon, 20 Nov 2023 07:11:27 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
	by fd01.gateway.ufhost.com (Postfix) with ESMTP id 351FC80A4;
	Mon, 20 Nov 2023 23:11:25 +0800 (CST)
Received: from EXMBX168.cuchost.com (172.16.6.78) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 20 Nov
 2023 23:11:25 +0800
Received: from ubuntu.localdomain (161.142.156.101) by EXMBX168.cuchost.com
 (172.16.6.78) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 20 Nov
 2023 23:11:22 +0800
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] hwrng: starfive - Fix dev_err_probe return error
Date: Mon, 20 Nov 2023 23:11:21 +0800
Message-ID: <20231120151121.60942-1-jiajie.ho@starfivetech.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [161.142.156.101]
X-ClientProxiedBy: EXCAS062.cuchost.com (172.16.6.22) To EXMBX168.cuchost.com
 (172.16.6.78)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: quoted-printable

Current dev_err_probe will return 0 instead of proper error code if
driver failed to get irq number. Fix the return err code.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202311160649.3GhKCfhd-lkp@intel.com/
---
 drivers/char/hw_random/jh7110-trng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_rando=
m/jh7110-trng.c
index 38474d48a25e..b1f94e3c0c6a 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -300,7 +300,7 @@ static int starfive_trng_probe(struct platform_device=
 *pdev)
 	ret =3D devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->n=
ame,
 			       (void *)trng);
 	if (ret)
-		return dev_err_probe(&pdev->dev, irq,
+		return dev_err_probe(&pdev->dev, ret,
 				     "Failed to register interrupt handler\n");
=20
 	trng->hclk =3D devm_clk_get(&pdev->dev, "hclk");
--=20
2.34.1

