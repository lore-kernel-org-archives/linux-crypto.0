Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357EA21CC64
	for <linux-crypto@vger.kernel.org>; Mon, 17 Mar 2025 08:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742200441; cv=none; b=X/8ZHNIDBSWYTq+SzP+wfQllekCBsbYYZgfWuJqqP1GdGSSoZVD9WG8Z2ep633qDKmzt7+ug8DItTO57FpJsPrVUM7RN5HW0In3exYsZmKa7D/Kz4DnA4cpF/N+zHOUtRVuZu3c5DUVRY52l0KGQu358au/uG2pIImhJvfI0mn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742200441; c=relaxed/simple;
	bh=w3Kvi1lTfM+9ggowzc1zbpxj8WjvVIdHbMPXBlLh65A=;
	h=Date:Message-Id:From:Subject:To:Cc; b=bZmlv6JhMdEncDh5ARtueN85MUfBZ0NJGen2xsyGNiWpP0L9unrN5EYXkLkOh7yz/cloATQl02GoL9uYctWuM4sYM58FPJ3PtF1NvJS9rNIb294VrgCIQl+wUW+SBWJATDRbPH8IijrRK0EegZZSLTrhTigYB8+3zNwXy2JkJrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WlgVFfcO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WlgVFfcO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9NK0jJn1zjkpBSA64etNCw/jcJ/IEgfDuQApXqAS7PQ=; b=WlgVFfcOqPXAloYIpGyq3YHRF7
	LivphQOt+kwZaEB1a//D04co4JeC7M8v56cduv+V89rDd267Dx+IWXka5stjxTWl6ASmqOaROKw39
	UebMwYEnhzrBwLmZBGdqpBGwCi0NpbOLEng/WB8EzANSXoY8t+DmEC+PWkAoF+NrLphVTqwwa2fmr
	EBd+aUClSqOtTxpi7Hx6UqTUG7w9zk0Cn3XzF+GYil3a7PYPWvPJBHfofGWsOTtlAz2BZ2NjWT9xB
	Vo1qxSVQ1IAJCuiStT1SHtXKrcA7gnp9Y4lSwwcIVkLyNz9YRTj5a96RJIr3f19I7SjQSCExVSLGE
	W33WVo/g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tu5uy-007UW8-1k;
	Mon, 17 Mar 2025 16:33:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 17 Mar 2025 16:33:52 +0800
Date: Mon, 17 Mar 2025 16:33:52 +0800
Message-Id: <cover.1742200161.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/3] crypto: scomp - Allocate per-cpu buffers on first use
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Per-cpu buffers can be wasteful when the number of CPUs is large,
especially if the buffer itself is likely to never be used.  Reduce
such wastage by only allocating them on first use of a particular
CPU.

The first two patches create the gound-work so that scomp can
safely flush work structs in its cra_destroy function.  The last
patch implements allocation on first use.

Herbert Xu (3):
  crypto: api - Move alg destroy work from instance to template
  crypto: api - Ensure cra_type->destroy is done in process context
  crypto: scomp - Allocate per-cpu buffer on first use of each CPU

 crypto/algapi.c                     |  48 +++++--
 crypto/api.c                        |  10 --
 crypto/internal.h                   |   3 +-
 crypto/scompress.c                  | 203 ++++++++++++++++++++++------
 include/crypto/acompress.h          |   6 -
 include/crypto/algapi.h             |   5 +-
 include/crypto/internal/acompress.h |   1 -
 include/crypto/internal/scompress.h |  13 ++
 8 files changed, 214 insertions(+), 75 deletions(-)

-- 
2.39.5

