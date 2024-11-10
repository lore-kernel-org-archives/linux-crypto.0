Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE79E148308;
	Sun, 10 Nov 2024 03:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731210967; cv=none; b=WK1KA3AFZMv03r5e+adoUCa+fiz6wOH0ihN5ENG9J7DtlNfE2KsRaV7x+sGcvbgHeBHHP8rPDOyjSgpcjwBn75Td1dGIkmO2Wz8Uou2fTDKpMqQaMSBleJ1MvU3vzky3KuJYE2C7qtpMiZz/ozcIdZjNKlA4vX9/3UJvLO6Yf7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731210967; c=relaxed/simple;
	bh=w2mawgF58ONJbwh7mosusB1YDV6GcFCEEMJsScRxxvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SbXCdFr/vIj3XlH6Tj3MJJkoRjD099SBrYMA//aqDOrOT352rdPchwK8o0pPBe/20F/PV493+7jMNdprNIpVpw7LCA3bNivQDDc26idAks+VJbdBkyMzzHlujHwsvOAeU/fFw0WbR8kOJzN48xTY9ppkHu9oLdS1U0jPTD7VoBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PcJ23teR; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PcJ23teR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=y/a2GQ3nFt40l+lGaYgvIOC/EuDz7xB8jgMbukwBm7Q=; b=PcJ23teRQKN8D9JKvjcRkZADrN
	mdZUuNKjkYIsisnZTOTkhYZvfi7dfEqW8GyqWvTIHNxh7UGtJ7K6rO0flmYNWcrbO+NYASqX62vFK
	AG58hHSXBHH5f06S2i4uMEjJY75+VHhHipW4GboObXmHks0LMvW7eFMIR9uaGbKZMnXvjPrIYxur6
	VnCJiiytF1dG37FoQFuj+qIWX/BLFaQsQmMXpGvgNzs74d6GPnyhB4cKv4SakMh2josUba2iK3kBM
	+Q7Pvm/82JTk5JbSNnefcZ8dN4shTRY8TW8qB5mCysshXPFr6Zn92bWZwb3fr40R2u80i39TKtyYd
	x0p3qqRQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t9z3H-00FkF1-17;
	Sun, 10 Nov 2024 11:55:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 10 Nov 2024 11:55:51 +0800
Date: Sun, 10 Nov 2024 11:55:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Li Huafei <lihuafei1@huawei.com>
Cc: pliem@maxlinear.com, atenart@kernel.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure - Fix the return value of
 safexcel_xcbcmac_cra_init()
Message-ID: <ZzAux5qbAiGo9GTS@gondor.apana.org.au>
References: <20241031112755.2949815-1-lihuafei1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031112755.2949815-1-lihuafei1@huawei.com>

On Thu, Oct 31, 2024 at 07:27:55PM +0800, Li Huafei wrote:
> The commit 320406cb60b6 ("crypto: inside-secure - Replace generic aes
> with libaes") replaced crypto_alloc_cipher() with kmalloc(), but did not
> modify the handling of the return value. When kmalloc() returns NULL,
> PTR_ERR_OR_ZERO(NULL) returns 0, but in fact, the memory allocation has
> failed, and -ENOMEM should be returned.
> 
> Fixes: 320406cb60b6 ("crypto: inside-secure - Replace generic aes with libaes")
> Signed-off-by: Li Huafei <lihuafei1@huawei.com>
> ---
>  drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
