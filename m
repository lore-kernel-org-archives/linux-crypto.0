Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9BC4122F
	for <linux-crypto@vger.kernel.org>; Tue, 14 Nov 2023 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43354F1;
	Tue, 14 Nov 2023 09:12:32 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
	by fd01.gateway.ufhost.com (Postfix) with ESMTP id 710BA24DFDC;
	Wed, 15 Nov 2023 01:12:29 +0800 (CST)
Received: from EXMBX168.cuchost.com (172.16.6.78) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 15 Nov
 2023 01:12:29 +0800
Received: from ubuntu.localdomain (161.142.156.101) by EXMBX168.cuchost.com
 (172.16.6.78) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 15 Nov
 2023 01:12:27 +0800
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] crypto: starfive - Minor fixes in driver
Date: Wed, 15 Nov 2023 01:12:12 +0800
Message-ID: <20231114171214.240855-1-jiajie.ho@starfivetech.com>
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

First patch updates the dependency for JH7110 drivers as the hash module
depends on pl08x dma to transfer data. The second patch fixes an
intermittent error in RSA where irq signals done before the actual
calculations have been completed.

Jia Jie Ho (2):
  crypto: starfive - Update driver dependencies
  crypto: starfive - RSA poll csr for done status

 drivers/crypto/starfive/Kconfig       |  2 +-
 drivers/crypto/starfive/jh7110-cryp.c |  8 -----
 drivers/crypto/starfive/jh7110-cryp.h | 10 +++++-
 drivers/crypto/starfive/jh7110-rsa.c  | 49 +++++++--------------------
 4 files changed, 23 insertions(+), 46 deletions(-)

--=20
2.34.1

