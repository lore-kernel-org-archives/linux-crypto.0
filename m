Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B634085D;
	Sat,  5 Oct 2024 05:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106464; cv=none; b=taW5Ko3xvyiwm8FjRI2pXWbmXqbP/DsR1drEFUDx7prVzC71zT+2mepsycTZzmTGKBcvoj1BvmG8m7lRR6rIi8id4IP0ie/Em+aaW9oYT1ULc923hk+B5upmazMy8+7T6UQy6zq845rEKAh7Bft+tGD6tg60+gZ7HCY2MGwdh1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106464; c=relaxed/simple;
	bh=ujbYPLabAdR8JgUyD1Mt5HS/u8J8KzH1IiW4YrqM4YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GRyYTxMuPjVmmsMxcU/GVzk70M6IRS0ysSsC1q3VYHQ6QjWtqqfoNIe+QsZPpecnuZkaeht4LRs/HDImcinh6DLE9x+uM0agDvaZN6bT8XCRTHQnJJDNdLLl+FKKo8m/qD6kukPu3fHpoPaT2PsYReTMvi6xWHLonZNa5Z9Szuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XpTl/zSs; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XpTl/zSs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FwP3BIfeGi1gWq5qcpBuZiDJdeoe7QoJ+uGgFCqailk=; b=XpTl/zSsA2dwitEOJZAf8nY97A
	DMZN1/b88bo0BFLcd91cBg4FudZ2lQPFQbfrbTWeu0keP8qfobiGb7dqhvnNYkbX0MAKO2GQvMB/C
	4pT9/CY6/OpejHrR3GMiSAFy75RuSni8lFAWEwQY9M1P6AY4ut1J50KkSjcKtoodCqLynC9tJbgTi
	AE7MG+KFAcVZeaY+FL2KGIB809TpgWNAFZPb6vR5LvR7D/4hkIiydxJD70/6Rmj3zzL24VPzrqYXz
	bvbTP48tx4sOQ7hwNa85B1+GTZpiSk1T15XraD8wtlN8WesmT3pX8eqfkPtpPuAGT1aTeWvQj6nwf
	gyfwEySA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxGs-0071ak-0T;
	Sat, 05 Oct 2024 13:34:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:34:15 +0800
Date: Sat, 5 Oct 2024 13:34:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yu Jiaoliang <yujiaoliang@vivo.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com
Subject: Re: [PATCH v1] crypto: ccree - Fix typo in comment
Message-ID: <ZwDP1wtRG0_jNvWo@gondor.apana.org.au>
References: <20240919073521.1688740-1-yujiaoliang@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240919073521.1688740-1-yujiaoliang@vivo.com>

On Thu, Sep 19, 2024 at 03:35:20PM +0800, Yu Jiaoliang wrote:
> Corrected typos in comment:
> Asynchronize->Asynchronous,
> encryped->encrypted,
> decryped->decrypted,
> fallabck->fallback.
> 
> Signed-off-by: Yu Jiaoliang <yujiaoliang@vivo.com>
> ---
>  drivers/crypto/ccree/cc_aead.c   | 4 ++--
>  drivers/crypto/ccree/cc_cipher.c | 2 +-
>  drivers/crypto/ccree/cc_hash.c   | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
