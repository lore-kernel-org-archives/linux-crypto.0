Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D989248881;
	Sat, 30 Aug 2025 08:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756543941; cv=none; b=chwYvuukhpCvGSpBbifkz6B7xZwtDHLa0L+Sga1pY7iFwiQiAz1Q53DDXHVVSPvoVMKrUqRSH7J+XJ2O7Iry+Vcm2mzbAsNIwPj36QUNv8dpQQ3sagxzblxtgGAr0Lwb3BQB1FBq/uXhC4fx1bkZNC7305roFpgpAHPzDOn3RC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756543941; c=relaxed/simple;
	bh=LbV7I4ddLMq9HPft1sLWTow4QyCQk2AW0T2gBLR8jdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+pHWRSUnIZ8+yKbfZuFsP4Fctdsz2sf1x84Pc8h5w84EBiwsWb8rRgQzYoaHhIcCYMqFxuyPZoI0CZKpzEGgr7ow38xiIgTbrzj2rjVDqa02U89uTF42NgB3eSXOxBa/KClNNrJansnE1ysYW12OXVOaUlx9IMVO5HDGuJi6iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XSkUYzHL; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XSkUYzHL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=spy8gCswGfl7VCQKNBPh9eTwsUjYvMDTKWTEUseVqB8=; b=XSkUYzHLT+75fgR2IgmKxAfe2z
	vYRV06k/6+qM4KZr32QkXGo6RROVqEtDg2YHYXAQoh08JFLto+2u+Q6omE6XGiOHYJPrwI1bVwDJb
	YNPtogTl+EVn2Z3X8pVtypF06ytlH7B7KfHjxed2pdQlK9aucFnhE2MvcRj+fxi6PXLhlaWEzjRrO
	0JQoEQCzzHDgUVQqsncq4ikzl+HJtrLaDfIkaabt8oVxmf5UNzBSOTUF0drkL2kJUT09x1ypaS3bi
	tMNAY3zEONrSAQBUj7n2L4dYLwFbX/i++VmtZp+ukeVfCYleA2nXjoKo8jpiXUDqR6vrAkf9YRruj
	HjmkZ0GQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usH4J-0017BP-32;
	Sat, 30 Aug 2025 16:52:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:52:12 +0800
Date: Sat, 30 Aug 2025 16:52:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S . Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>
Subject: [PATCH] crypto: ti - Enable compile testing for dthev2
Message-ID: <aLK7vIQktZuJFAQd@gondor.apana.org.au>
References: <20250820092710.3510788-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820092710.3510788-1-t-pratham@ti.com>

Allow ti dthev2 driver to be compile-tested.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index c0e8d4acc37c..170e10b18f9b 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -48,4 +48,4 @@ obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
 obj-y += starfive/
 obj-y += cavium/
-obj-$(CONFIG_ARCH_K3) += ti/
+obj-y += ti/
diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 38d22cab05a9..d4f91c1e0cb5 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config CRYPTO_DEV_TI_DTHEV2
 	tristate "Support for TI DTHE V2 cryptography engine"
-	depends on CRYPTO && CRYPTO_HW && ARCH_K3
+	depends on ARCH_K3 || COMPILE_TEST
 	select CRYPTO_ENGINE
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ECB
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
