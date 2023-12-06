Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB111AA;
	Tue,  5 Dec 2023 17:42:52 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
	by ex01.ufhost.com (Postfix) with ESMTP id 0CF6024E284;
	Wed,  6 Dec 2023 09:42:51 +0800 (CST)
Received: from EXMBX068.cuchost.com (172.16.6.68) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 6 Dec
 2023 09:42:51 +0800
Received: from ubuntu.localdomain (202.188.176.82) by EXMBX068.cuchost.com
 (172.16.6.68) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 6 Dec
 2023 09:42:47 +0800
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Rob Herring <robh+dt@kernel.org>, "Krzysztof
 Kozlowski" <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley
	<conor+dt@kernel.org>, <linux-crypto@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] hwrng: starfive - Add suspend-to-idle support
Date: Wed, 6 Dec 2023 09:42:36 +0800
Message-ID: <20231206014236.1109832-4-jiajie.ho@starfivetech.com>
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

Define SET_SYSTEM_SLEEP_PM_OPS for StarFive TRNG driver.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
---
 drivers/char/hw_random/jh7110-trng.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_rando=
m/jh7110-trng.c
index 46272a9e5964..2f77f811a383 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -369,8 +369,12 @@ static int __maybe_unused starfive_trng_resume(struc=
t device *dev)
 	return 0;
 }
=20
-static DEFINE_SIMPLE_DEV_PM_OPS(starfive_trng_pm_ops, starfive_trng_susp=
end,
-				starfive_trng_resume);
+static const struct dev_pm_ops starfive_trng_pm_ops =3D {
+	SET_SYSTEM_SLEEP_PM_OPS(starfive_trng_suspend,
+				starfive_trng_resume)
+	SET_RUNTIME_PM_OPS(starfive_trng_suspend,
+			   starfive_trng_resume, NULL)
+};
=20
 static const struct of_device_id trng_dt_ids[] __maybe_unused =3D {
 	{ .compatible =3D "starfive,jh7110-trng" },
--=20
2.34.1

