Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0C7E5;
	Sun,  3 Dec 2023 19:02:48 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
	by ex01.ufhost.com (Postfix) with ESMTP id 7CBD624DDB2;
	Mon,  4 Dec 2023 11:02:44 +0800 (CST)
Received: from EXMBX168.cuchost.com (172.16.6.78) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 4 Dec
 2023 11:02:44 +0800
Received: from ubuntu.localdomain (202.188.176.82) by EXMBX168.cuchost.com
 (172.16.6.78) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 4 Dec
 2023 11:02:42 +0800
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: starfive: Remove unneeded NULL checks
Date: Mon, 4 Dec 2023 11:02:39 +0800
Message-ID: <20231204030239.989183-1-jiajie.ho@starfivetech.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: EXCAS062.cuchost.com (172.16.6.22) To EXMBX168.cuchost.com
 (172.16.6.78)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: quoted-printable

NULL check before kfree_sensitive function is not needed.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311301702.LxswfETY-lkp@i=
ntel.com/
---
 drivers/crypto/starfive/jh7110-rsa.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-rsa.c b/drivers/crypto/starfi=
ve/jh7110-rsa.c
index c2b1f598873c..cf8bda7f0855 100644
--- a/drivers/crypto/starfive/jh7110-rsa.c
+++ b/drivers/crypto/starfive/jh7110-rsa.c
@@ -45,12 +45,9 @@ static inline int starfive_pka_wait_done(struct starfi=
ve_cryp_ctx *ctx)
=20
 static void starfive_rsa_free_key(struct starfive_rsa_key *key)
 {
-	if (key->d)
-		kfree_sensitive(key->d);
-	if (key->e)
-		kfree_sensitive(key->e);
-	if (key->n)
-		kfree_sensitive(key->n);
+	kfree_sensitive(key->d);
+	kfree_sensitive(key->e);
+	kfree_sensitive(key->n);
 	memset(key, 0, sizeof(*key));
 }
=20
--=20
2.34.1

