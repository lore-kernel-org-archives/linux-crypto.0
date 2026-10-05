Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF188834;
	Mon,  5 Oct 2026 03:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791171567; cv=none; b=GCjU2gCD0JQX3eVFiMU/re3J5HxfviELbMTuG+UyOzz75qS1GyhXRzwbyBei5JfTCb0ykgq8IAW9cca/7j5P9NDrw1/72hKpmumu49enBFvs9XS60fOTEIvgKv2AZWCSmlGB2a8DUy6/QRF4wkT9dNyvAZmAbPOguY9HzfrKmVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791171567; c=relaxed/simple;
	bh=cCiHl4jEoGPkJUlakweHfZxTNCcbS9pl80v79X+FT4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmYvNC0rmGg/ur1BoCOaWyby3+V+dk/BF/8GNvr1tUBJgtGLrhKXtcO75S/KfCGx5iTXZXIZvLuueuTvZKcIaNE0HEDfdAW0pyYw3mklzQLP1dNPxl2N4QL2sEsGq6wrvQbMK/L09coQ5K2YzRWzex4y5ktUB6nls5EtW3UBAis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=PGE1FxT2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="PGE1FxT2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=lE1WXrsQUzVJQmj+DxFtRA5RAPvMuyALJBMv1hvni70=; 
	b=PGE1FxT2E4ugplPBWvMB0fdxCBEFibA1Cc5EXzqF779Qdidp6i3nX/V6QELVXjH1jA66Pb1PiSn
	oqe9TxnPqx7vM17fFVwPj7yEBL9C03z4f82pAh8OVu8geL5u+TJOpxuJgiIeb1y2rIfOs3dvq+FXc
	VXWog7lzzLo7qD2alIaSLOPGYp3qG/ahDoRSeNeQvukKPr2u+ZnXScK9mx3is4OJr1gQKzC5lwWW1
	A1zBl1tDuj15cIvOwjqPMhY9X1/bHtuicABEXt/zDqJOVo3gY+D/tX8w/GVi0K8MI3sf6qJTifst0
	1j41hkanFcj8F5f7j641Nfz3x69aIO9FzO2w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xDZXl-00000000jFm-1VCi;
	Mon, 05 Oct 2026 11:39:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 Oct 2026 14:39:13 +1100
Date: Mon, 5 Oct 2026 14:39:13 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yuqi Xu <xuyuqiabc@gmail.com>
Cc: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Rusty Russell <rusty@rustcorp.com.au>, stable@vger.kernel.org,
	Vega <vega@nebusec.ai>, Ren Wei <weir@nebusec.ai>,
	xuyq21@lenovo.com
Subject: Re: [PATCH v2] KEYS: Account for asymmetric key payload data in the
 quota
Message-ID: <asMb4fv8WjWR9Wch@gondor.apana.org.au>
References: <4a0b2e00f5cc62c173a01fec2f56eab1b04d70bb.1790568982.git.xuyuqiabc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a0b2e00f5cc62c173a01fec2f56eab1b04d70bb.1790568982.git.xuyuqiabc@gmail.com>

On Mon, Sep 28, 2026 at 04:27:24PM +0800, Yuqi Xu wrote:
> add_key("asymmetric", ...) preparses the supplied blob and then
> instantiates the key with generic_key_instantiate(), which charges
> prep->quotalen to the owning user's key quota through
> key_payload_reserve().
> 
> pkcs8_parse() duplicates the attacker-controlled PrivateKey OCTET
> STRING with kmemdup() into pub->key. pkcs8_key_preparse() stores that
> object in the asymmetric-key payload but hard-codes prep->quotalen to
> 100, so the quota records 100 bytes regardless of the retained private
> key size. The ASN.1 decoder accepts blobs up to 65535 bytes, so one
> key can pin about 64 KiB while consuming 100 quota bytes. With the
> default non-root limits (200 keys / 20000 bytes) a user can retain
> roughly 12 MiB instead of the 20 KiB the limit is meant to allow.
> 
> x509_key_preparse() keeps the parsed public key, its parameters, the
> signature and the authority key IDs, but also charges a fixed 100
> bytes. PKCS#8 later repeated the same fixed-100 accounting. The same
> add_key() call reaches the X.509 parser, so fixing only PKCS#8 would
> leave the bypass reachable.
> 
> Charge the size of the retained payload instead. An oversized PKCS#8
> key now fails with -EDQUOT instead of being accepted for 100 bytes,
> and the same applies to an X.509 certificate that retains an oversized
> public key or set of authority key IDs.
> 
> Measured on v7.3-rc1 (10396a2d6d41), 2 vCPU / 2 GiB QEMU guest, as uid
> 1000, adding PKCS#8 keys with a 65000-byte PrivateKey field. Before
> the patch, 176 keys were retained (about 11.4 MiB) while
> /proc/key-users charged only 19712 bytes. After the patch the
> oversized key is rejected immediately, and a 200-byte PrivateKey still
> loads and is charged 264 bytes. A small X.509 certificate whose only
> large object is a 26000-byte authorityKeyIdentifier is likewise
> rejected, while the unpatched kernel accepted it and charged 109
> bytes.
> 
> Fixes: c26fd69fa009 ("X.509: Add a crypto key parser for binary (DER) X.509 certificates")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: LLM
> Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
> Reviewed-by: Ren Wei <weir@nebusec.ai>
> ---
> Changes in v2:
>  - Move the bug details and the measured quota numbers into this
>    commit message, as requested by Ignat Korchagin.
>  - Sashiko (High): "keys: integer truncation in key->quotalen causes
>    permanent quota leak" on pkcs8_key_preparse() and
>    x509_key_preparse(). Not changed. The truncation is real only past
>    USHRT_MAX, the unprivileged maxbytes is 20000 so add_key() fails
>    with -EDQUOT first, and this patch does not widen key->quotalen.
>    Replied publicly: Message-ID
>    20260920073515.64399-1-xuyuqiabc@gmail.com
>  - v1 Link: https://lore.kernel.org/all/cover.1789801335.git.xuyuqiabc@gmail.com/
>  crypto/asymmetric_keys/pkcs8_parser.c    |  2 +-
>  crypto/asymmetric_keys/x509_public_key.c | 23 ++++++++++++++++++++++-
>  2 files changed, 23 insertions(+), 2 deletions(-)

This patch wasn't reviewed by Sashiko.  Please repost.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
