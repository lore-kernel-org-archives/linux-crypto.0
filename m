Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCB123DE
	for <linux-crypto@vger.kernel.org>; Sun, 30 Mar 2025 01:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743298306; cv=none; b=jE05nygvPp7jiFJ5Lw9PrjU1fef27pVGyi+uWjabZ5dYzcez5dwYj/k96/Tgz5AyJW1+jiyl/G+2AJKfQ8YJMCDD1fVxHKM0+93ZjoZdQwxdk3q1+yiynN63USNY7H0NpvQ42IgNPNRCGAhLiNVIVSBF1UrtnTg04UQ4z7Tg9ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743298306; c=relaxed/simple;
	bh=ftJioRbUGY/1qDA9dJJf2tUJnNHruHSDyM2tQH5ozxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rck8c+cFCofovRk80Fu8Qr92SufvHXn+i6Rdz1vIXWaVrTmP1GJRYvlJ4vzvhTbNbqjeqtD7BgONEPKYT9n/I6Q02xhcirkAgYZyH49BBw9BUwh7l1j5vu48iwbyi4hOklH8TP9asyCa27w7rENrT68sHV5iml2ByqNchjxdR04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=abr5W57i; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="abr5W57i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7o8lHktJKzyUERxHMeokcR/hdPIEo/uJydzMYIYl1bU=; b=abr5W57ie2aKkU+y7P7cLok0Mw
	bgnizUrQ4IaHqIoSbGm5trxlH+Cc6s66rmDtAs6L8xeJyaVFMldc56BjujN18C6x0a9KcYG/24E2G
	rJQ3f43KfGm/vPut7tArixWD8+O79jc+9gDbjXY/yV6XUbRYLUz9sdPyI3uHoTapytUSNBjgRZ+eR
	QZlRo395mLhZsJOGu69MRBCdzB0tdm9AcMYp62hUdQCEQMzD0cGzPrtI4eNC8nrNDOyYVs8NnlqIE
	SW24wMAcvJYw6o/B8o5IZUJc43sj/1Q/zwS+hyNq6FnrnEAtCmzFQYxdk9E6jvVVI3CpVF8ojWtoh
	fOK9r6fg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tyhWK-00BHWd-1M;
	Sun, 30 Mar 2025 09:31:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 30 Mar 2025 09:31:28 +0800
Date: Sun, 30 Mar 2025 09:31:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Srujana Challa <schalla@marvell.com>
Subject: [v2 PATCH] MAINTAINERS: Update maintainers for crypto/marvell
Message-ID: <Z-ie8LWRsoGb4qIP@gondor.apana.org.au>
References: <Z91Ld28V6L2ek-JV@gondor.apana.org.au>
 <20f0162643f94509b0928e17afb7efbd@ssi.gouv.fr>
 <Z-JnegwRrihCos3z@gondor.apana.org.au>
 <20250325094829.586fb525@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325094829.586fb525@collabora.com>

On Tue, Mar 25, 2025 at 09:48:29AM +0100, Boris Brezillon wrote:
>
> I haven't reviewed contributions or contributed myself to this driver
> for while. Could you remove me as well?

Thanks for your contributions Boris.  I'll add you to the patch
as well:

---8<---
Remove the entries for Arnaud Ebalard and Boris Brezillon as
requested.

Link: https://lore.kernel.org/linux-crypto/20f0162643f94509b0928e17afb7efbd@ssi.gouv.fr/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/MAINTAINERS b/MAINTAINERS
index f8fb396e6b37..8eda257ffdc9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14009,8 +14009,6 @@ F:	drivers/gpu/drm/armada/
 F:	include/uapi/drm/armada_drm.h
 
 MARVELL CRYPTO DRIVER
-M:	Boris Brezillon <bbrezillon@kernel.org>
-M:	Arnaud Ebalard <arno@natisbad.org>
 M:	Srujana Challa <schalla@marvell.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
