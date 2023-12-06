Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3B01B8;
	Tue,  5 Dec 2023 17:42:50 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
	by ex01.ufhost.com (Postfix) with ESMTP id 001AE24E23E;
	Wed,  6 Dec 2023 09:42:47 +0800 (CST)
Received: from EXMBX068.cuchost.com (172.16.6.68) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 6 Dec
 2023 09:42:47 +0800
Received: from ubuntu.localdomain (202.188.176.82) by EXMBX068.cuchost.com
 (172.16.6.68) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 6 Dec
 2023 09:42:44 +0800
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Rob Herring <robh+dt@kernel.org>, "Krzysztof
 Kozlowski" <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley
	<conor+dt@kernel.org>, <linux-crypto@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] hwrng: starfive - Update compatible string
Date: Wed, 6 Dec 2023 09:42:35 +0800
Message-ID: <20231206014236.1109832-3-jiajie.ho@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231206014236.1109832-1-jiajie.ho@starfivetech.com>
References: <20231206014236.1109832-1-jiajie.ho@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX068.cuchost.com
 (172.16.6.68)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: quoted-printable

Add compatible string for StarFive JH8100 SoC.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
---
 drivers/char/hw_random/jh7110-trng.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_rando=
m/jh7110-trng.c
index 38474d48a25e..46272a9e5964 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -374,6 +374,7 @@ static DEFINE_SIMPLE_DEV_PM_OPS(starfive_trng_pm_ops,=
 starfive_trng_suspend,
=20
 static const struct of_device_id trng_dt_ids[] __maybe_unused =3D {
 	{ .compatible =3D "starfive,jh7110-trng" },
+	{ .compatible =3D "starfive,jh8100-trng" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, trng_dt_ids);
@@ -381,7 +382,7 @@ MODULE_DEVICE_TABLE(of, trng_dt_ids);
 static struct platform_driver starfive_trng_driver =3D {
 	.probe	=3D starfive_trng_probe,
 	.driver	=3D {
-		.name		=3D "jh7110-trng",
+		.name		=3D "starfive-trng",
 		.pm		=3D &starfive_trng_pm_ops,
 		.of_match_table	=3D of_match_ptr(trng_dt_ids),
 	},
--=20
2.34.1

