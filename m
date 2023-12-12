Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF21B8F;
	Mon, 11 Dec 2023 19:25:33 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
	by fd01.gateway.ufhost.com (Postfix) with ESMTP id BB1748080;
	Tue, 12 Dec 2023 11:25:32 +0800 (CST)
Received: from EXMBX068.cuchost.com (172.16.6.68) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 12 Dec
 2023 11:25:32 +0800
Received: from ubuntu.localdomain (202.188.176.82) by EXMBX068.cuchost.com
 (172.16.6.68) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 12 Dec
 2023 11:25:29 +0800
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Rob Herring <robh+dt@kernel.org>, "Krzysztof
 Kozlowski" <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley
	<conor+dt@kernel.org>, <linux-crypto@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] hwrng: starfive: Add support for JH8100
Date: Tue, 12 Dec 2023 11:25:25 +0800
Message-ID: <20231212032527.1250617-1-jiajie.ho@starfivetech.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: EXCAS062.cuchost.com (172.16.6.22) To EXMBX068.cuchost.com
 (172.16.6.68)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: quoted-printable

This series adds driver support for StarFive JH8100 trng. It also
updates pm ops of the original driver.

v1->v2:
Dropped driver .compatible change, express new compatible string in
devicetree bindings instead. (Krzysztof)

Thanks,
Jia Jie

Jia Jie Ho (2):
  dt-bindings: rng: starfive: Add jh8100 compatible string
  hwrng: starfive - Add runtime pm ops

 .../devicetree/bindings/rng/starfive,jh7110-trng.yaml     | 6 +++++-
 drivers/char/hw_random/jh7110-trng.c                      | 8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

--=20
2.34.1

