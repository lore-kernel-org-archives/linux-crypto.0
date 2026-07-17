Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713DD1ADC83;
	Fri, 17 Jul 2026 08:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275995; cv=none; b=NFnGKC32XuJ8qC6QFs3ujSXnNNPFM9jfME/rv6ToNyfGI2Yhw0ptPnHJjh/i3hKeBnbu2rDcMiEzDZk3W3mgzmqvusv+ASvbxttmpNfRfd5RCo4OYkurrTkc87G9RYdsgE8auy84nrx9yVFRA2Q1rJ1Ce484A+zO5/0BQou47yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275995; c=relaxed/simple;
	bh=vyVN2xKxK37MKv9a2meapEDa4qjuSaEZUMHmrpVx5k8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u1XpNbBdskdjieXFKKBehaUGbHQQ5EjFanQbzeYHIThLl5BiOUsN4V2/MLuUDQFAV0QE+oiEPO0Pq0OtXmDdTN8xnbWnc4ttWS5kClUlX0iMiGrMlXgNtI1TU1aM73ecWWkgGuCwfNFzsKwQhytXOtD6TbWppF86dvwuMy4ZLLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sfXU54AJ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sfXU54AJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=aAyMu8xW113y/X1MnGxLBqu4NoSvASjlUJbJj0ZTTVY=; 
	b=sfXU54AJIsLSegdHfsNG+cnWGj8MqzvCldPMICz1/q5MHN8khC/v+oDc4677aCNvcgO1O/5nWdo
	be4t6S71KkjvQLeZ9ZZuNOMoMHh3wdSWQ0w03RPyf5zzhw5R5103HU2ToW5GI4CLE0vrQUqgmqf/A
	PmmgL+d1iaUTCebRj9mFBWapVCv+Wx7bKHmHQ00rTlqpTBYJk6HvIu6BwIhoLyKe7ypBVguT0Ju44
	GcxwIHeeHxjnc39U+XbtmD3gQ4LdjCqXj116A+R8hLKYXS33ZPNPc08Orc/rF4ogfRs/r+suiMCCI
	3nuHUxOuNwME9xSQUypXcPMn8GPuljXValrg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdgz-0000000EO4K-2Bus;
	Fri, 17 Jul 2026 16:13:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:13:09 +1000
Date: Fri, 17 Jul 2026 18:13:09 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Allow additional ciphers for cryptsetup
Message-ID: <alnkFT0WgfSSKXUF@gondor.apana.org.au>
References: <20260705184419.40762-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705184419.40762-1-ebiggers@kernel.org>

On Sun, Jul 05, 2026 at 11:44:19AM -0700, Eric Biggers wrote:
> Add "xts(camellia)", "xts(serpent)", and "xts(twofish)" to the allowlist
> for af_alg_restrict=1.  These niche AES alternatives have continued to
> see rare but persistent use via cryptsetup, which has historically
> relied on the AF_ALG support for these ciphers in XTS mode for
> performing the keyslot encryption.  (cryptsetup v2.8.7 and later fall
> back to a temporary dm-crypt mapping, but that requires root.)
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  crypto/algif_skcipher.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
