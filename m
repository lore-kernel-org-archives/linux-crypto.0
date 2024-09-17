Received: from mxe.seznam.cz (mxe.seznam.cz [77.75.78.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFEA136351;
	Tue, 17 Sep 2024 09:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.75.78.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726564847; cv=none; b=JI/kH1ZPSMYTHwVHhcPDzeZzlg6b0cY6DKhthXkUSwzASmQqDuWBJ0LHj5Sj3KzVSTApEe+iTpKzRDKvzlKadnMchfeI0Vc9cOUXQcMQqpKa7DBK+0AE8zWcglI9p55xI25+nQVzoOXwhwJh0CsvqYCAJ9L8r65IDZSvL7skZKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726564847; c=relaxed/simple;
	bh=YWcSGgii0kjSXN2C6TXGhqMl7BdnBamLfMUrfZsE+6c=;
	h=From:To:Cc:Subject:Date:Message-Id:Mime-Version:Content-Type; b=i2ZumyyomDmJfPz6310zcDPDYAsCbVURaJ2/3f2NBo+FdTXIRX0+wgooIHyYs6V+vMBz1UIeYjMw4ezxfF8PGK+CNT2nfS8qw9XezI4rYNRU/RKHc4hMh/4v+zyyw6yLsx2utv72uXvAoHbgbYNTRsz747PhuRz9qbuRawSJ15s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.cz; spf=pass smtp.mailfrom=email.cz; dkim=pass (2048-bit key) header.d=email.cz header.i=@email.cz header.b=OzCOLtqT; arc=none smtp.client-ip=77.75.78.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=email.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=email.cz header.i=@email.cz header.b="OzCOLtqT"
Received: from email.seznam.cz
	by smtpc-mxe-6b57b49b5-v6frq
	(smtpc-mxe-6b57b49b5-v6frq [2a02:598:128:8a00::1000:512])
	id 13e37486ed17c62c136dfa9e;
	Tue, 17 Sep 2024 11:20:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz;
	s=szn20221014; t=1726564823;
	bh=XQ/r9k6iIDpXJmlOKdz92zJ7UI7i/2S2EpvU0oDuCtw=;
	h=Received:From:To:Cc:Subject:Date:Message-Id:Mime-Version:X-Mailer:
	 Content-Type:Content-Transfer-Encoding;
	b=OzCOLtqTUZcecRryevHvgR4O7JEJMjUWEqmJy2OZroGkoP70t1LeHuP99Hag5UToC
	 8nANEY2jh7bJg5GQuiGZhcx8g1fo/CaejbL/v5ZiA0mN+7+TbRuqkhBCIspqpGbtMr
	 j0Fs2d/UK/1pm8+c/eJUc4yAv3VDGmmnJGxyuLuBujRd6/tsIIpOUk65H9Dy10IE9E
	 5EZuuyjgKsUoHwmozMR8WphQYz8+owz042FamdRaOwSjhjN2z0pxmJ0M5fOvQl1rmy
	 hGTf+ceM7PdlVJaKnrhLpGXOj6RJpSY4/Nuv8vclEcs90p6URZHgi080k0G7Yj2mHm
	 LqpZbNFngKT8g==
Received: from 215-143.ktuo.cz (215-143.ktuo.cz [82.144.143.215])
	by email.seznam.cz (szn-ebox-5.0.189) with HTTP;
	Tue, 17 Sep 2024 11:20:12 +0200 (CEST)
From: "Tomas Paukrt" <tomaspaukrt@email.cz>
To: <linux-crypto@vger.kernel.org>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: algif_skcipher - Enable access to internal skciphers
Date: Tue, 17 Sep 2024 11:20:12 +0200 (CEST)
Message-Id: <3ge.ZcSB.212DbbvIi2E.1cwKdC@seznam.cz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (szn-mime-2.1.61)
X-Mailer: szn-ebox-5.0.189
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add an option to enable the userspace interface for symmetric key
cipher algorithms marked as internal (CRYPTO_ALG_INTERNAL).

Signed-off-by: Tomas Paukrt <tomaspaukrt@email.cz>
---
 crypto/Kconfig          | 10 ++++++++++
 crypto/algif_skcipher.c |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a779cab..2ce1877 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1392,6 +1392,16 @@ config CRYPTO_USER_API_SKCIPHER
 	  See Documentation/crypto/userspace-if.rst and
 	  https://www.chronox.de/libkcapi/html/index.html
 
+config CRYPTO_USER_API_SKCIPHER_INTERNAL
+	bool "Enable access to internal symmetric key cipher algorithms"
+	depends on CRYPTO_USER_API_SKCIPHER
+	default n
+	help
+	  Enable the userspace interface for symmetric key cipher algorithms
+	  marked as internal (CRYPTO_ALG_INTERNAL).
+
+	  Say N unless you know what you are doing.
+
 config CRYPTO_USER_API_RNG
 	tristate "RNG (random number generator) algorithms"
 	depends on NET
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 125d395..028aef7 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -342,6 +342,10 @@ static struct proto_ops algif_skcipher_ops_nokey =3D =
{
 
 static void *skcipher_bind(const char *name, u32 type, u32 mask)
 {
+#ifdef CONFIG_CRYPTO_USER_API_SKCIPHER_INTERNAL
+	type |=3D CRYPTO_ALG_INTERNAL;
+#endif
+
 	return crypto_alloc_skcipher(name, type, mask);
 }
 
-- 
2.7.4
 
