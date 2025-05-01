Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D636622424E
	for <linux-crypto@vger.kernel.org>; Thu,  1 May 2025 12:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746103056; cv=none; b=N7ezMQ/3QJvDE/5VvoOcRVCXd9gHI+ae4nfb8KN4ygJflW8ZN0ZYpa0tHmGjbXvz89ZV9DrzQ4chi+h1YGds3AD7UthAjC82KC9XJDm1yAq5B/r+bHPhd7T9svqZPWyBOAhWEt+4yYQpBkN1A2DCTQ+w1ZaVQm1C2bBMnNR5rbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746103056; c=relaxed/simple;
	bh=avtpwhIW3bRRLQb/AnzzrWa9Q7V8Gm+IjYRqviykG6E=;
	h=Date:Message-Id:From:Subject:To:Cc; b=kA/V4BxVY/CxhGc/oksgdVDUEpPwp8jJZhW4qzJ0Ss2heWkOGbdrSusEDxZyFd/SxlZ3Oi8vbZAJpQyuZGHXKg+kIG4JO37oT9U9dx1VpHM23zxeOFSGMqAw5sFoRMviXhx0GVxd1zxEENyG4PBlbDLyxQIzplHEGGm7sBY9rwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BcXtvL85; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BcXtvL85"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UysRE2plIUSbEbpILLQODfglafbuYBTuvvnKb7nmn6M=; b=BcXtvL85YWssku5iLQQTXSHuML
	uLZmhSj0zqNJ0Y9Leb3G+94hjQ9a3YIIsVNxX9iKbrd3jOuD5N1EcuYcSs9wncvEZK5K2QFcYe6p4
	/8NtwmNCdTgNh31UBIzfd12MVaYFIvr85Ri5eFNUuIcgDcwj79P45oDn5IgvHarhhZcp4yC4/qnXz
	4dmGXXwzpj7MqQKj1LqWfGBhO2N0CYCDzc0YtQRRQNFSKyEsjKGm/7lR7GGzPqs1XI7J23wkiPQsT
	bXNzqQ28Xu6HC0SEJJmLezjtM9zvGIGXr5bUb2AewA5Y3f4p7IK2ZLJf+nx4QBuUHYM+KvbXuwxgX
	Fi0ULJnw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uATAO-002bEh-0c;
	Thu, 01 May 2025 20:37:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 May 2025 20:37:28 +0800
Date: Thu, 01 May 2025 20:37:28 +0800
Message-Id: <cover.1746102673.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/4] crypto: acomp - Add compression segmentation support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch series is a reboot of the acomp multibuffer patch series.
Instead of using request chaining, this time it is done using a
plain SG list and a unit size.

Either the Crypto API or optionally the algorithm can dice up the
request into unit-sized pieces.  The caller provides a single page
and a 2-entry SG list for output, and the Crypto API or algorithm
will dynamically extend it one page at a time through chaining if
necessary.  The compressed result will be tightly packed together.

If any unit fails to compress, a zero-length SG entry will be inserted
for it.

If at any time memory allocation fails (the first entry cannot fail
since it's compressed into memory provided by the caller), then
compression will stop and the caller can process what has been
compressed so far before resuming by calling with an offset into
the original SG list.

Herbert Xu (4):
  crypto: acomp - Clone folios properly
  crypto: api - Rename CRYPTO_ALG_REQ_CHAIN to CRYPTO_ALG_REQ_VIRT
  crypto: acomp - Add compression segmentation support
  crypto: testmgr - Add multibuffer acomp testing

 crypto/acompress.c                  | 172 ++++++++++++++++++++++++++--
 crypto/ahash.c                      |   6 +-
 crypto/algapi.c                     |   3 +
 crypto/deflate.c                    |   2 +-
 crypto/scompress.c                  |   2 +-
 crypto/testmgr.c                    | 145 ++++++++++++-----------
 include/crypto/acompress.h          | 107 +++++++++++++++--
 include/crypto/algapi.h             |   9 +-
 include/crypto/internal/acompress.h |  14 ++-
 include/crypto/internal/hash.h      |   4 +-
 include/linux/crypto.h              |   7 +-
 11 files changed, 367 insertions(+), 104 deletions(-)

-- 
2.39.5

