Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FADA1C695
	for <linux-crypto@vger.kernel.org>; Fri, 26 Dec 2025 00:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766709517; cv=none; b=eax3DTOJx+rTFiQIrImAFjLNnouxdyHz3jan9pyrsQnNNNyWf82JBDDByjueZ2oqMPfu0qRJ7ipExQu/Qanw/JKSy+hvgaC9Prz4BHrf+ETtlssy1mVR3fm1O6tPN1iF9s+sHoEPaOtQAF+xq0lt1lZ0ytwHNmUVGRZX6NGJIP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766709517; c=relaxed/simple;
	bh=1U1BeDwk8rP0Kx+H6mfGncFfE5g7C2FhV8hvC1vcYyo=;
	h=Date:Message-ID:From:Subject:To:Cc; b=jDhG6GUEJVlYIeXmfjU1Zfbirysa5X7nTQT1xxzS4JOjCGMtinr22nO6JfuhR+HJBEcJBfvsU4WWu5egvLQMDwN/ijK0UMvH0O+m9hrkU1o5kdsYcQGfa599V7EqM2PxuyhBggEN2VTqp8Xy1rZ8zyWThdANzH1uViexmeTqg48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NxMW8Qsx; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NxMW8Qsx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Cc:To:Subject:From:Message-ID:Date:cc:to:
	subject:message-id:date:from:content-type:in-reply-to:references:mime-version
	:reply-to; bh=sDXtI5CIaDi4PBETsXiFYDaLVc3DtB6P0GruglBPDmc=; b=NxMW8QsxPQtNHWu
	eylMzF5LV3ZuBB9dsQvIDE/GU08Om5K53QYNKU9oP1dxEiXWWp0JCqA1UrQRB7hhq6LE5y4P57cBf
	HdLJnHD/w0f4MnJ5aSgoV5AZoSdfzWnyUNo07xvx+rD7/ZeSXE5/mdbwHtbM6hjZBWVP7AFI5ijay
	zxgh44nQuj/LF1V3b9ZseLJQGr3fK0wX+UpWJdQTXeOj5G+NqKh64x1SOJR+IqULofK++tEsppMht
	ch4d8JGHdn0ywXpj9iWMzLcbdJlMdoBxOXLDkN+m3TiNJYKwTXy2sLOIl0QglehHdC4+jXv8QSl3r
	GNe26oBe7xJnDSmzS8w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vYvqZ-00CY7W-01;
	Fri, 26 Dec 2025 08:38:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Dec 2025 08:38:22 +0800
Date: Fri, 26 Dec 2025 08:38:22 +0800
Message-ID: <cover.1766709379.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/3] crypto: acomp - Add segmentation API for compression
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch adds segmentation support for compression and provides a
wrapper for existing algorithms so that they can accept a single
segment while returning the compressed length or error through
the dst SG list length.

Herbert Xu (2):
  crypto: acomp - Add bit to indicate segmentation support
  crypto: acomp - Add trivial segmentation wrapper

Kanchana P Sridhar (1):
  crypto: acomp - Define a unit_size in struct acomp_req to enable
    batching.

 crypto/acompress.c                  | 25 ++++++++++++++++---
 include/crypto/acompress.h          | 37 +++++++++++++++++++++++++++++
 include/crypto/algapi.h             |  5 ++++
 include/crypto/internal/acompress.h |  5 ++++
 include/linux/crypto.h              |  3 +++
 5 files changed, 72 insertions(+), 3 deletions(-)

-- 
2.47.3

