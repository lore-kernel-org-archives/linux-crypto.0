Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31170189BB0;
	Tue,  7 Oct 2025 14:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759846780; cv=none; b=iwwbcu2PrW0fmKIRrAW5BeqeeWUgwjbK3EZRjw53ImUxxDttcnRX7VCmcypgdG7pm63BBzwASQEOOIBkYjcbckL6iaPZBcDPFwrhMZUWY1hKZZFnRuXrvgoDUme8D23cK/na7qWZGSMmV7la1+srt9OVqqy30qByfvEhynPBiR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759846780; c=relaxed/simple;
	bh=CQPcQZEASX+8lu3nBu6CjRRon21/AdfPWUtGb7+8Vps=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YMiv+QoZuvzvaABfrtVMI5r55tUC1Ldxi1jjkHDxc8x8jhAkn8pGUjoz9AsvbaguDk4gnB8cXj8JfDmIEDlfhFa/e2Qm4v/cAjTt40Zwuoy/Hkc4ifb64s7py9eerocwX46ga7R1KofKvO+U7KOklItERNjXPJ3sbsfSPmoP7zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=qCZoxs9o; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="qCZoxs9o"
Received: from lelvem-sh01.itg.ti.com ([10.180.77.71])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTP id 597EJQxM3839955;
	Tue, 7 Oct 2025 09:19:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1759846766;
	bh=jLhm0wjkT3Ix64UN23GOIgK9LAgdlOztBdjVxrwqHz4=;
	h=From:To:CC:Subject:Date;
	b=qCZoxs9omyQHyUSAMXPJ+La3C2pkfkd1SrTiKvDAFd9TLyszqk3W6G3LX+gmtHe1R
	 FQVquVEnqVpGWLEG79egcv+q3l/sL5kY8jo5rbay3KbZwktMQD1BC1EZLnwVd40AKz
	 1EFUKSq6w6ORcPINY2r52m08Ry1lfWZwwFMU4ep0=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
	by lelvem-sh01.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 597EJQdM3032191
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Tue, 7 Oct 2025 09:19:26 -0500
Received: from DFLE201.ent.ti.com (10.64.6.59) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Tue, 7
 Oct 2025 09:19:25 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 7 Oct 2025 09:19:25 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 597EJOCR1003759;
	Tue, 7 Oct 2025 09:19:24 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, Manorit Chawdhry <m-chawdhry@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Shiva Tripathi <s-tripathi1@ti.com>,
        Kavitha Malarvizhi <k-malarvizhi@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: api - fix reqsize handling for skciphers and aeads
Date: Tue, 7 Oct 2025 19:27:51 +0530
Message-ID: <20251007141852.726540-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Commit afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
introduced cra_reqsize field in crypto_alg struct to replace type
specific reqsize fields. It looks like this was introduced specifically
for ahash and acomp from the commit description as subsequent commits
add necessary changes in these alg frameworks.

However, this is being recommended for use in all crypto algs [1]
instead of setting reqsize using crypto_*_set_reqsize(). Using
cra_reqsize in skcipher and aead algorithms, hence, causes memory
corruptions and crashes as the underlying functions in the algorithm
framework have not been updated to set the reqsize properly from
cra_reqsize. [2]

Add proper set_reqsize calls in the skcipher and aead init functions to
properly initialize reqsize for these algorithms in the framework.

[1]: https://lore.kernel.org/linux-crypto/aCL8BxpHr5OpT04k@gondor.apana.org.au/
[2]: https://gist.github.com/Pratham-T/24247446f1faf4b7843e4014d5089f6b

Fixes: afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
Signed-off-by: T Pratham <t-pratham@ti.com>
---

Found this while developing TI DTHEv2 crypto driver. I narrowed that
these crashes in [2] are due to some upstream change and not my code as
the same driver is working fine in our internal 6.12 LTS version (with
daily CI builds not showing any regression from crypto subsystem). The
*only* change is replacing crypto_skcipher_set_reqsize() with
cra_reqsize in algorithms as this patch was introduced after 6.12.

Now, these crashes were not caught earlier because [3] split the
in-kernel self-tests into two configs (CRYPTO_SELFTESTS and
CRYPTO_SELFTESTS_FULL) which went unnoticed in my local development flow
and the CRYPTO_SELFTESTS_FULL config was not enabled till recently. [2]
shows after applying this patch, the driver passes all selftests
succssfully with CRYPTO_SELFTESTS_FULL=y.

[3]: https://lore.kernel.org/linux-crypto/20250612174709.26990-1-ebiggers@kernel.org/
---
 crypto/aead.c     | 1 +
 crypto/skcipher.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/crypto/aead.c b/crypto/aead.c
index 5d14b775036ee..51ab3af691af2 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -120,6 +120,7 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
 	crypto_aead_set_flags(aead, CRYPTO_TFM_NEED_KEY);
+	crypto_aead_set_reqsize(aead, crypto_tfm_alg_reqsize(tfm));
 
 	aead->authsize = alg->maxauthsize;
 
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index de5fc91bba267..8fa5d9686d085 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -294,6 +294,8 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 		return crypto_init_lskcipher_ops_sg(tfm);
 	}
 
+	crypto_skcipher_set_reqsize(skcipher, crypto_tfm_alg_reqsize(tfm));
+
 	if (alg->exit)
 		skcipher->base.exit = crypto_skcipher_exit_tfm;
 
-- 
2.43.0

