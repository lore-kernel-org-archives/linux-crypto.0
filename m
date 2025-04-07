Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251AE21D5AC
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020176; cv=none; b=LAZY2yMeYAsSH739zrMFYQ0E+nVpENBKqtaIAU7G0EfSUYCjQkZyOStJOJXbmO3++X3PUc19ZsNj4iwnSc6IgNd9EPGx3+mvYMo2C2d7L+AmTLJpZ2KcFxQyoVLWiym6VvA9msfZnyTdHvYSa8Z4NIdpwJU9qleFH6PCWxVigEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020176; c=relaxed/simple;
	bh=wSDdLm8fcYZQKj6Ofi/Hv6yfuXA6I/ul7+oMlWrjHcs=;
	h=Date:Message-Id:From:Subject:To:Cc; b=mvLZyKQoY4iKCCrv/aQa81za5FzqR2/sg+bE+dnyES8FwEGLbxcIRHjUimqrHYkqm0+GVlQDLx0Hmj9eJQQJ7uxUyFesSyi4Z28gDR2PO1tC8qR4HZ4F7IMcruRdIN6zGqLXBJnqkQf7S8QWy+dbmLlBVTrMeXpXYaAbTntwVrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FRFtJL44; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FRFtJL44"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sAojcFmicJFZNikvNR7lQ2WVK5MiLV0O5CFRpS64GnU=; b=FRFtJL44n7wdydfMd7HFSsqhgQ
	ALb2YNH49q1F+WjwMZdz/kLWscQTTzJYb1RzwwDcz/tZhR3tjA/964z7AVYFpZrgoplu2oO9FyK4y
	o12CKSkPWPcZxLE66ETdryCrZFWH1HGQJPZTmTbcIKP5K1lPlP776GrkoDr4bxbrlkUigJNa+LV0f
	ItXnC/aIUku06Fa/3cUkOvwzmcqPid7/nb8KMdNAGYm6MKOMRmIlV+10qS6aYEc3fN0z0IMJ1xh3u
	fFGhdOyysVYXwXdd/i/gIwifNmHqVfAbchIGUkwXsKZ0yXCE9iKB5YvvFyHBn1X4afteR2r9P1bAs
	FUxp+wNQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jJY-00DTH5-2o;
	Mon, 07 Apr 2025 18:02:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:02:48 +0800
Date: Mon, 07 Apr 2025 18:02:48 +0800
Message-Id: <cover.1744019630.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/7] crypto: acomp - Use optional async calling convention
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch series introduces the optional async calling convention
for acomp.  This will be extended to all other Crypto API types that
support async.

With this a stack request is setup initially and will be used as
long as the algorithm can complete synchronously.  If it cannot
then EAGAIN is returned, and the caller may choose to allocate a
dynamic request through the REQUEST_CLONE call and then redo the
call asynchronously.

This series is based on top of

https://lore.kernel.org/linux-crypto/cover.1744018301.git.herbert@gondor.apana.org.au

Herbert Xu (7):
  crypto: api - Add helpers to manage request flags
  crypto: acomp - Use request flag helpers and add acomp_request_flags
  crypto: acomp - Add ACOMP_FBREQ_ON_STACK
  crypto: iaa - Switch to ACOMP_FBREQ_ON_STACK
  crypto: acomp - Add ACOMP_REQUEST_CLONE
  ubifs: Use ACOMP_REQUEST_CLONE
  crypto: acomp - Remove ACOMP_REQUEST_ALLOC

 crypto/acompress.c                         |  37 +--
 drivers/crypto/intel/iaa/iaa_crypto_main.c |   5 +-
 fs/ubifs/compress.c                        | 251 ++++++++++-----------
 include/crypto/acompress.h                 |  48 ++--
 include/crypto/algapi.h                    |   5 +
 include/crypto/internal/acompress.h        |  33 ++-
 include/linux/crypto.h                     |  24 ++
 7 files changed, 227 insertions(+), 176 deletions(-)

-- 
2.39.5

