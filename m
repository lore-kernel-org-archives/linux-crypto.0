Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C300916CD1D;
	Tue, 15 Oct 2024 04:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728967987; cv=none; b=al56H8u9uyol8nFW3FmaRB6NVvN/dfMLBbemSqW2yfowbwO7cVdqROrjLKL3E5oYd3SeNORT9D7OM3s+bdkHzJ2BUFEIImr0RjbyAJMIPYX6heURVfOxEVJaBGzaivSkqhl/20yFEnscH4U6baPmY1WUPwltvHd9a9TsQwNMYnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728967987; c=relaxed/simple;
	bh=BqrNUw2K7RUtZMlq1Lf6fghkPnyhYNWO4K/G+1gUWMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYi951sP3YPhakOzBvcjiOiAmt2nSGKJH9vwyMGNmeeuSbTtjGC8ykjGk4rJBcBJXqonozxW6ovidMCjbtag9L+Ufl4AKbO1wLXGXGqpSDYIkjBrv5C+V0M9lXHS3m6wjp4Ww161a667dX25x2DTmtiFEPr2sxMrvcg3DGUF/zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pYcnStbb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pYcnStbb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BWsizNzSrPZ+r+201ZIsYtk0J5IsZolcXemWtkjSrFI=; b=pYcnStbbYju0pDNtlPl/UI7wGL
	zjYLz5a8i0LdHbzkKONRsKK2uzqOxpIsOZDa/oiGjAj5Jo+P1ByV7gP8A522DX6JG4VXOb/r7CW7m
	SOCuDLTGUxBqD98HtmK5JjWExJDqWjoyzT+T+RmCZJzzTUbMPL1KK0rQWwc8tz7jWN89coVSoO4d0
	cSBO5rs7EftTdk9IH5jSOyWOpsSbKHAhGENrc5Mdgi01LHH0sU1j7o3RE1SlZSzP8mWAa0pLJr/tp
	H/7gwJCp62sNF4Qmp266N1v10DR60iYNwNoqOadBVEy+PDc+ruAkDovUNZmGyLig8nISV+3yZLzRb
	+RBstA9A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t0ZOI-009QEG-20;
	Tue, 15 Oct 2024 12:52:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 15 Oct 2024 12:52:52 +0800
Date: Tue, 15 Oct 2024 12:52:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
Message-ID: <Zw31JIEyh28vK9q7@gondor.apana.org.au>
References: <ZwJUO5Nz3S7EeqO6@gondor.apana.org.au>
 <1fc4db6269245de4c626f029a46efef246ee7232.camel@gmail.com>
 <ZwObXYVHJlBaKuj2@gondor.apana.org.au>
 <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
 <ZwZAExmK52txvHE8@gondor.apana.org.au>
 <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>
 <ZwduxHxQtHdzz-kl@gondor.apana.org.au>
 <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
 <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>

On Thu, Oct 10, 2024 at 07:35:33PM +0200, Klaus Kudielka wrote:
>
> Hmmm, not really (patch applied on top of 6.12-rc2). 5 algorithms failed self-test.

OK, let's try disabling TDMA altogether.  And if it still fails with
this could you please bring back the printk patch and send me the
result of it with TDMA disabled please?

Thanks!

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 5fd31ba715c2..a3f0465aa178 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -278,7 +278,7 @@ static const struct mv_cesa_caps kirkwood_caps = {
 	.ncipher_algs = ARRAY_SIZE(orion_cipher_algs),
 	.ahash_algs = orion_ahash_algs,
 	.nahash_algs = ARRAY_SIZE(orion_ahash_algs),
-	.has_tdma = true,
+	.has_tdma = false,
 };
 
 static const struct mv_cesa_caps armada_370_caps = {
@@ -287,7 +287,7 @@ static const struct mv_cesa_caps armada_370_caps = {
 	.ncipher_algs = ARRAY_SIZE(armada_370_cipher_algs),
 	.ahash_algs = armada_370_ahash_algs,
 	.nahash_algs = ARRAY_SIZE(armada_370_ahash_algs),
-	.has_tdma = true,
+	.has_tdma = false,
 };
 
 static const struct mv_cesa_caps armada_xp_caps = {
@@ -296,7 +296,7 @@ static const struct mv_cesa_caps armada_xp_caps = {
 	.ncipher_algs = ARRAY_SIZE(armada_370_cipher_algs),
 	.ahash_algs = armada_370_ahash_algs,
 	.nahash_algs = ARRAY_SIZE(armada_370_ahash_algs),
-	.has_tdma = true,
+	.has_tdma = false,
 };
 
 static const struct of_device_id mv_cesa_of_match_table[] = {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
