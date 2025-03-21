Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0C5AD2F
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 11:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742556030; cv=none; b=tZ15RkJxGlc1ApFBX8N6Ke72daRGfwVA8UwT93H7VXL5X7mujTGa0r8mZ5ElCa8Ctt+vuBu6TlxZdyPEYznsRgtMVYuyNOrLn2O6diyXE2UcPbGb0FDRoAQb6rxg9IpEdrr22+rRKwDKp0TMEmxI9JzsFVKtFo7um3kpoJOJpJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742556030; c=relaxed/simple;
	bh=4rvbQ3Uan2mknAt2ityl8R+iNODN3vsTRU03jxE3KQo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NdjsNH9H6+gsOejXDc6MV5OmTOvEYpLED2ZB+XdYYFVnHujcSfEeK+WA2HL11HKuRol2JHnWO1lI/kAnWQV/6tIO3pye/slFU+MrIRX4Uf7S9hHoNpr0EJX7wOO8aQ3Lozl8WmCznrpdk/ICCNHkn0WvB0TzwUSbnRY/rN3HGYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JtjxSNFR; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JtjxSNFR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aiNq/hSJa8IlXrAfN1QYD5gR0boZyXjnpA7t5nYbQG8=; b=JtjxSNFR9GIo6vXUy0LuODXtZD
	HtFmEcFdv7Womro4nEoh9sphwZG7VvUZvvvcnALy4VX16XoiplYwd6fX76Jxe+3rp3NL+0a4HhHe1
	7se4O5UVUPBDJSfvPfwwY+QWxaT52cjCN6O+/k3+74Oo7egzrpuUB6Qpc9hCggVAS1Fuc7bJOu007
	xT08MCIWFBXxujlp6C2oKKYR+ADNq5r1nh3jBCnM2dZCLeUNdah0fbDkfIjSpyj0WdRNX5OJBJaWD
	0pkYjdM7/IN40Nr5rXdMV7Jx6TbY9K5g5/0gg7yZ9+fHuXxSWNkAbKpbGSfdCZg9XnZKw35CK1yKl
	Pr5S6Fww==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvaQJ-0090NZ-1q;
	Fri, 21 Mar 2025 19:20:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 19:20:23 +0800
Date: Fri, 21 Mar 2025 19:20:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Arnaud EBALARD <arnaud.ebalard@ssi.gouv.fr>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Srujana Challa <schalla@marvell.com>
Subject: [PATCH] MAINTAINERS: Update email address for Arnaud Ebalard
Message-ID: <Z91Ld28V6L2ek-JV@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The existing email address for Arnaud Ebalard is bouncing.  Update
it to what appears to be the most recently used email address.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/MAINTAINERS b/MAINTAINERS
index f8fb396e6b37..68c903bf6aa0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14010,7 +14010,7 @@ F:	include/uapi/drm/armada_drm.h
 
 MARVELL CRYPTO DRIVER
 M:	Boris Brezillon <bbrezillon@kernel.org>
-M:	Arnaud Ebalard <arno@natisbad.org>
+M:	Arnaud Ebalard <arnaud.ebalard@ssi.gouv.fr>
 M:	Srujana Challa <schalla@marvell.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
