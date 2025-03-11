Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A77E22F3A8
	for <linux-crypto@vger.kernel.org>; Tue, 11 Mar 2025 10:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741688434; cv=none; b=HvpUZdsqw36gj7WVa56C4UGUgB6t2DF4VoHgiY+FFC8gOeYBcFA+vvv0CvPKQE9MuZcBv4Mw9eMqJkeEQe6jKjYnrFdKYlsqn5J1S4cD84najEai/1U5Bae7su27dRrCM1nOlu3viBTkjSAW8ATmwN9uxcPMotU3XDXGdthgtGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741688434; c=relaxed/simple;
	bh=Qg2W5OlrKGJP2xx5ofvO49MpeRmKPpr6WVWs581TAPQ=;
	h=Date:Message-Id:From:Subject:To; b=MUSpz6Obb35vG/ItcrOtpSNyT7nJqm0K0jT3uoCZVNpOpDeCJWrNZ0NbJZuCxHxicJ/fTeqRlsrqfeD4b2wFLGr+hnCTPanb3EnSKGtWa5Ko/3Syo5CbuUZ65Q6v+fBkdCxbPLIldos3W0C/9xjJ/T67oEcmei16iy9wsRgzIU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jFXRPSC1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jFXRPSC1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=97HnUa8Dij9lFW0VM5V8FYRa/Zx1qqSI6ppIeEu0h20=; b=jFXRPSC1P9VKC0qzKCyJpVF813
	gD1xs0ijZ4UdzaXwac5RL4n6354Tftb/lNmumK7VeoW/n5l4L+xhL+snyQAWPiZf91CvivkWqSW6q
	dOfVzmWViOUdBzQ0BffLfG6wL9hX5u6isI4mfBCS1Ia7B+d7Dc/cH4HDOKdlfwaYI0Kz9J4Scq5KI
	WkOQloUNPlno+klPcWP1WW3J2uIHgbNGjQqQOoCeQ1Xbiucqax+mUfPoFJStMFq/g0LUi+yTBLYYA
	dPj8FpMy4Jg6ttYrPrzFBuYrGIXqlAYg2jmUrbZOpBoywKIPHx0Vo9qXaCcNDkNrP/lgzkuh1N8YG
	DabBvJqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1trwio-005YUT-2u;
	Tue, 11 Mar 2025 18:20:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Mar 2025 18:20:26 +0800
Date: Tue, 11 Mar 2025 18:20:26 +0800
Message-Id: <cover.1741688305.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/3] crypto: Use nth_page instead of doing it by hand
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch series is based on top of:

https://patchwork.kernel.org/project/linux-crypto/patch/20250310172016.153423-1-ebiggers@kernel.org/

Curiously, the Crypto API scatterwalk incremented pages by hand
rather than using nth_page.  Possibly because scatterwalk predates
nth_page (the following commit is from the history tree):
    
        commit 3957f2b34960d85b63e814262a8be7d5ad91444d
        Author: James Morris <jmorris@intercode.com.au>
        Date:   Sun Feb 2 07:35:32 2003 -0800

            [CRYPTO]: in/out scatterlist support for ciphers.

Fix this by using nth_page.

Herbert Xu (3):
  crypto: scatterwalk - Use nth_page instead of doing it by hand
  crypto: hash - Use nth_page instead of doing it by hand
  crypto: krb5 - Use SG miter instead of doing it by hand

 crypto/ahash.c                   | 38 +++++++++++++++++++++-----------
 crypto/krb5/rfc3961_simplified.c | 34 +++++++++++++---------------
 include/crypto/scatterwalk.h     | 21 +++++++++---------
 3 files changed, 51 insertions(+), 42 deletions(-)

-- 
2.39.5

