Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5AE3955FB;
	Fri,  3 Jul 2026 09:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783070641; cv=none; b=I0UzB9Hjxvildbt1MZvwDrq0/OD72TNu+IchC7INIwtsQsCviS9mzMeDmzdpausqMCIxXGhd7J1r1mreer9lVQ07ylNuXSlIdc6vSVIsyJVMZTz+YvKUai8XMj9JiwnfxbacTljgTbWj/7It00u2X3WJzEX+wqViAYAwghMqhs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783070641; c=relaxed/simple;
	bh=cauSp18KyEE16pHZhdaFI0rad7buc1sKzMNb4PtuJQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ijskk3uUwXm348BYGZ11ntxqIa86fpoFtOVKus57CR1X181l92qum2jBjH2jtmJ963OYlxgYYQ7i/zwi9SwD7dLWWHUNSlMLgzPbemDvI5KiociUkF2qw6P7Fygd2c1sytX1d2bqRQXRfPQkyvGYzI0wuO78UjoSxWeVf6kbRaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=EBOppEHH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="EBOppEHH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=TYJFOLn851Tsz51dqj1HNvlJtqSVi+oJKTRYLTFxOKE=; 
	b=EBOppEHHcVpFIcyBrfeqexxwsnkddf+O12EGIUQ8LxMZsu8SwRkGVpcbRNxBbvHDDToOC/RqZU2
	LLkpugF8W4fuNNsu4iisNGOeiWjS5+/xi5keTvkynIoluSwxpxpBVy8eIV8B2JZ+MsRVzi1ykZ28L
	i9EvO82cKOm+At6BF5xK2uoARoM+6Frlz5NYUGCLGQz6UsO7unXfsmlglOPCQy6NXIRb8BdZeEm0r
	qxX91RctCYJjza+GskXsZY6AkXxAF4AZanU5QsI3OuusL1zqtENfbd/vnOmXPS5OHr+wLEYJ5mLZB
	HVtHqfflVNp8aomJ9JYJDknzvIQOyPyiML+w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wfa7j-0000000AKA0-30o6;
	Fri, 03 Jul 2026 17:23:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Jul 2026 17:23:51 +0800
Date: Fri, 3 Jul 2026 17:23:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	brgl@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 2/8] crypto: qce - Fix HMAC self-test failures for
 empty messages
Message-ID: <akd_p0Psntcp01F1@gondor.apana.org.au>
References: <20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com>
 <20260622-qce-fix-self-tests-v4-2-4f82ffa716c6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622-qce-fix-self-tests-v4-2-4f82ffa716c6@oss.qualcomm.com>

On Mon, Jun 22, 2026 at 03:18:10PM +0200, Bartosz Golaszewski wrote:
> BAM DMA cannot process zero-length transfers. For plain hashes this is
> handled by returning the precomputed hash of the empty message
> (tmpl->hash_zero), but for keyed HMAC the result depends on the key and
> cannot be a constant. As a result, hmac(sha256) produced an incorrect
> digest for an empty message and the crypto self-tests failed.
> 
> Allocate a software fallback ahash for the HMAC transforms and use it to
> compute the digest whenever the message is empty (in both the .final()
> and .digest() paths). The fallback is allocated in a dedicated cra_init
> for the HMAC algorithms and is excluded from matching the crypto engine's
> own algorithm to avoid recursion. It is kept keyed in sync with the
> hardware transform in .setkey().
> 
> Cc: stable@vger.kernel.org
> Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
> Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
>  drivers/crypto/qce/sha.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/crypto/qce/sha.h |  1 +
>  2 files changed, 84 insertions(+), 1 deletion(-)

There is no need to allocate fallbacks anymore because the Crypto
API now does it unconditionally.

Please see aspeed for an example on how to use the fallback.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
