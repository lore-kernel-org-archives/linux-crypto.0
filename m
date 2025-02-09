Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C01914E2E2
	for <linux-crypto@vger.kernel.org>; Sun,  9 Feb 2025 10:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096257; cv=none; b=h3n/THmfxW7TYuXL4iY2T7NT7vc0zKzatl33E/Ffq1V8WJB8ksmvzRyc492RbemHgzK+U1e5dxb4IJOpr9pJNICF3ZL69pjZm/wfF7A6uN/WKluQjvzoK9OS90hgWzHvxTJMVzz29V1lL98nnh13GD+Eo5OZ0oQmfrDDXoOGYB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096257; c=relaxed/simple;
	bh=qzlJt3KwfcAeHRdso7ksznt1W1jDx+6Cw6lGA7Ifc8c=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oEmDmeIyWkRcUQRx3XkgTU5zX3v3LU/M790fnSJwualXkOfT9wT0LmJKI6URtz4fxO3hvhAp44OXxuS+ADfz5s1Z864W9HVZrf8LbVBPmXOOnYK2X0iXiadCdbpNpiuq4YsKgLARrHn2C7sJR1EQ6bnKxIbjAmEUX7M9Cdrywj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NuX8TQ2w; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NuX8TQ2w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=A82FAWxHJleqck+AE45WSC9Rbsnq5ELVc+buPu3gWKk=; b=NuX8TQ2wBnhmFogjbTQtTPILxl
	LnpR3qTR+Bp1QoP2m3tZrOljRgOvntZjvGLR0FjAlsG4+ZvAR1LurRJ/9LAuFEvSZoh+69yM3TNlL
	LauEhAMzBsoMvB3lkPYsXjQEkrPO3MYaW5oDDUqyMqBNAVl2xUctiE0DqwgHre6nLzUK+ZxrWfdQ6
	4tRS0Sf0rpA+jwdre2Yv76L4ZkbdxKbBoVEVqQZU/AEip7IiKiFNWaAWZI6MznDtUT/ylf5fNTVED
	2eArLIRpH3swkjDvjzY43tfxj4P2yraEQuXIjJaimuoOe7UBwZjzgFxgYCo8oDwAzNgQU/7SFdjNN
	M9OTPjIA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th4Ab-00GIe1-2H;
	Sun, 09 Feb 2025 18:17:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 18:17:30 +0800
Date: Sun, 9 Feb 2025 18:17:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: inside-secure - Eliminate duplication in top-level
 Makefile
Message-ID: <Z6iAutkbBLR8QU1I@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Instead of having two entries for inside-secure in the top-level
Makefile, make it just a single one.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 62c7ce3c9d3e..c97f0ebc55ec 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -43,11 +43,10 @@ obj-$(CONFIG_CRYPTO_DEV_TEGRA) += tegra/
 obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio/
 #obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
 obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
-obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
+obj-y += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
 obj-y += starfive/
-obj-y += inside-secure/eip93/
diff --git a/drivers/crypto/inside-secure/Makefile b/drivers/crypto/inside-secure/Makefile
index 13f64f96c626..30d13fd5d58e 100644
--- a/drivers/crypto/inside-secure/Makefile
+++ b/drivers/crypto/inside-secure/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += crypto_safexcel.o
 crypto_safexcel-objs := safexcel.o safexcel_ring.o safexcel_cipher.o safexcel_hash.o
+obj-y += eip93/
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
