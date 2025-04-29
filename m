Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A147E29DB79;
	Tue, 29 Apr 2025 08:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745916577; cv=none; b=SDTdseD+zXzG2aAjU61u8ltUpnBY8zasv2UeJd/G9jyYsfI6wTBxI460h17Rmjm4v8xrb6cSjPQdKP7Gk69yPHms6obm97HUM+nC7Tw9+2/iQZ2wILFW9avF/LX3Sdv4w+YgwAlSKgKYV8jssuYMyJyJUI/z6BI5+ljdh71zWVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745916577; c=relaxed/simple;
	bh=H5K//5oJi2n2cTlYABZNbEIjwdJfrOL7BV7QEzoZCTM=;
	h=Date:Message-Id:From:Subject:To:Cc; b=AT4SSitkQeBd/lJ7Sj/IFvrA7LxmyZCCiXYkriVyp1t+BeHNTYwud6VbD+oU13FYGNzEDJ5ImAk9+z432EnczQ6+41FGyozzv9nXdaj926JPbESJCvugtBVRkLG09pNN1nTqj7XNZ6laHCYBBDS6p0itG/ZGaWNiBNUCSZNEQPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jBeAYNdR; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jBeAYNdR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gai7WJW5v50AocdvHn3GT8iGFrAaP3spBCKjqsB4buU=; b=jBeAYNdRA1NYYPKq/Cv6VRT4as
	OAZdYv34Ooo9oinQtfGB8bWIpIhAzXru8Zd0kyYPytDqe9lyKvd166ESIea5yhYq+P6vFfbXJLOzU
	3RQFb6Vwgy0mXArqMBqXRn9iJ+nGCHCj6NFs/hBFYJRQLAMc3nUGV8lbJXfbHz7mELtmDtXWQuJVS
	sDdOCI2yUQ+ukt5MvJOWshjQ8QjQTM/ndIGq6snhByPqxNh7/AxjdCTQoAexx2cRMbI9m34ovUgn0
	L1qGEcJ6+VDGVBDT4kkZ0S9r2Q9hHH3Tn054/aNUnFf6uTGiUjEs/uTpLeJlPoJo5faHDVYXxUt9l
	XZxkHXyg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9geg-001t5a-1P;
	Tue, 29 Apr 2025 16:49:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 29 Apr 2025 16:49:30 +0800
Date: Tue, 29 Apr 2025 16:49:30 +0800
Message-Id: <cover.1745916278.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/2] crypto: s390/hmac - Use generic hash export format
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Harald Freudenberger <freude@linux.ibm.com>, Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This mini series converts the s390 hmac implementation to use
the generic export format.  First it extends the implementation
to support large lengths (you could always import a partial hash
with a length that is just about to overflow), and then it adds
export/import functions matching the format of the generic hmac
sha2 implementation.

Herbert Xu (2):
  crypto: s390/hmac - Extend hash length counters to 128 bits
  crypto: s390/hmac - Use generic hash export format

 arch/s390/crypto/Kconfig     |   4 +-
 arch/s390/crypto/hmac_s390.c | 200 ++++++++++++++++++++++++++++++++---
 2 files changed, 187 insertions(+), 17 deletions(-)

-- 
2.39.5

