Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168468;
	b=tP1U/DtFLosgh/2YWGxzei6hnq0VDd59T8uXojXmiJX4qDrKofTRhdv3P+hsMGpRQHbX
	 nlJdY+laDlGQ1o0i3R5Ybw9pj710kGhToAJUhcpRNRIjeFaWKRlqg2ZmzmUZ98PJrLFhb
	 Rvc4xRdWAtl/iSmcm3UUfiIBkWwPpU7QZafCO4xzPVisb2cJw+lFQbjDijkzoXOiM9C0F
	 7Xb7pouTtSaFYgOmYKiQlKX9bmT376n6Vppa8iTihkqk9aNrk/e7rlLwN2j5NnsW5QU8U
	 iXki0gf+luIoETKtfq6O8hFqSHB3mHW3cquJN9iUCr2J0fFGg8Nrme8I2zSCJBTUqlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168468;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=wvm5O4QSr+2slEL7sSNtDaICWbKDd4kaL3RphmV8wS0=;
	b=5aKiVN6Vl0sGPLqsoDRqHJ2P0Yy+rzqh/QTbKOZYWUiumPbUh8r4NSY4t1EsRHiaVXkk
	 M2JlRmJd+VpkAaIofw3qoN7zmVfivra9RluhOtcrzgtOewAdrDrThs1Jkcjqv38KNPGk2
	 bngklAYwnKFOzmidtTbCfFbUqChX/1AWUSVxgS/3ktUsA3HY7F4dO/pHbXRU2MteUg5C7
	 vFW64Ns3XMS/koy6iIfK962zlJgNmlcDMQ3Vo4AU+cn8yenzTA/yqQDEiuZE6vBLzjaHe
	 Ej19dnoENx4YVTJXkYz3AYCavkKLx9UlklSLq83X1VloEySszVESUI3fPmuaad0GrEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=dh7SoQY+;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A7B606A33A;
	Fri, 20 Nov 2026 09:54:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31A7B606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=dh7SoQY+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=wvm5O4QSr+2slEL7sSNtDaICWbKDd4kaL3RphmV8wS0=; 
	b=dh7SoQY+YOdWpmwGsfPl1JIHoAtNavKeFsvj9blSEm/Te43IpDZqfKzMvwXIKY6ivpd2fZt8GKm
	A+EVjMpt97/1dgyHl/8KOmG5BbUW08HL8S7tc+9OXw951XR0O3jv8s4fSs7v/WXg3hcV7yzeLkxHE
	g5/Aevv0jm6SP0exp8qzh4rQx8yYvD4JGGg+x18V3XbCjMH8NwiWeB+gPqwoCPk2Xxl/OEGfMOMjo
	W4k41MG+1Dv0aJlN6QK30ANVXXT95LWFWuDB8R8MVsq5lrReJX9Qu5xp7OiV1LqLu8NhI7mQNQJJK
	QvjTXbBVP09gk4s2Nkb7j0QBobe9aBpu9JsA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULJx-0000000HYhV-0uQd;
	Fri, 20 Nov 2026 17:54:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:54:17 +0800
Date: Fri, 20 Nov 2026 17:54:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Laveesh Bansal <laveeshb@laveeshbansal.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Denis Kenzior <denkenz@gmail.com>,
	Maximilian Stahlberg <maximilian.stahlberg@uni-bremen.de>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] X.509: Accept a certificate with an empty subject
Message-ID: <awAYyQ-cZ3Nl4Ja_@gondor.apana.org.au>
References: <20261112074246.99421-1-laveeshb@laveeshbansal.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112074246.99421-1-laveeshb@laveeshbansal.com>

On Wed, Nov 11, 2026 at 11:42:44PM -0800, Laveesh Bansal wrote:
> Patch 1 fixes loading a certificate with an empty Subject, which iwd
> hits with an eduroam server certificate [1]. Patch 2 adds a KUnit test
> for it.
> 
> I developed this series using an LLM coding assistant.
> 
> [1] https://lore.kernel.org/r/9b05b89cf296b8a6392bbe6327228c1bc2f05c49.camel@uni-bremen.de
> 
> 
> Laveesh Bansal (2):
>   X.509: Accept a certificate with an empty subject
>   X.509: Add KUnit tests for the certificate parser
> 
>  crypto/asymmetric_keys/Kconfig            |  11 ++
>  crypto/asymmetric_keys/Makefile           |   1 +
>  crypto/asymmetric_keys/x509.asn1          |   8 +-
>  crypto/asymmetric_keys/x509_parser_test.c | 160 ++++++++++++++++++++++
>  4 files changed, 179 insertions(+), 1 deletion(-)
>  create mode 100644 crypto/asymmetric_keys/x509_parser_test.c
> 
> -- 
> 2.54.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
