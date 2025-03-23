Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB206566A;
	Sun, 23 Mar 2025 13:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742735654; cv=none; b=G+iqktBRq4opC2imVJs6ftTUVWmTEx94l7B0AwGzqwmNG4usgh0kaRHiepli/BLPhwBddjnHEXSCugJFCmV9U38VSUcreghaDqh7JdNCG7Z/Q+a8rekct1bTQ4E+5XsSQ4Tb47vON7DY1hjYnyzgH7faydYYdeI3GLWKZnVWj8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742735654; c=relaxed/simple;
	bh=FK+m2uon3Qc0WOvD2MimMMy3ADpn1nEMcAtUezGigdg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ccR0Zdw0VeJSgVvUBbXKUUje5fHMM0+opVJiZwTqNEXu3TBs8CVGSkyWQFYiwuwf6xQFiueEhHIHDyewwgMUnuaI9gho7iuvetcnIJq5rIV/Cei3InpuBXXlnPIhZ5eMLXZeMi9JTRkuc0y7W3MvihJkesHKPsZyXXinW/ylvCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CPdecXuA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CPdecXuA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RO7nA/vp0Zarez/nWhgwD5eKAe+sJXP/wCi8b5HhEzg=; b=CPdecXuA1cpNbV4zei0f5Fh9Gt
	64OBHrbbFtfjl1Exf5kEYpECwMyRGleBxthTVk3CdLRpjFgdrdDeDU6SkEKcCDH+kMRMxCc2er58f
	NfqCcQV/bAv9wApbG/ob5IYbHAwwX4qvNFdkarCZxAOMnqySKAmaKKplRMTwvnFNAqW1P6uXBtrSX
	u2ySPOCaP+IBDiSvNMqCbFP7nAVYRrWgqx50KdFH19F4IRKhK//1TiX7OAYfzSYn5QJ1zLROua0pY
	evAqvAl5qca7ZI95xxieSy3nBZZRzdabDL43DdeQpEs1baQIzcY+/bmX/4GCXBtwp5MXoJkBPtCOE
	wumqEJwg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1twL9L-009TJc-2j;
	Sun, 23 Mar 2025 21:14:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 23 Mar 2025 21:13:59 +0800
Date: Sun, 23 Mar 2025 21:13:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: s390 hmac
Message-ID: <Z-AJFwndherQBH2W@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Harald:

I'm working on making the export format of hash algorithms compatible
so that you can switch between implementations seamlessly.

I've got a question about the s390 hmac implementation.  How does
the hardware tell if it's the first update (where the cv from the
param block contains undefined state) or not? Is it a bit in
s390_kmac_gr0 or is it the imbl?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
