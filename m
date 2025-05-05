Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59AB1F91C8;
	Mon,  5 May 2025 12:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746447946; cv=none; b=s+5QNO64AHJ0ixyNx02yUY0cQ6p4nAfCbaDX6SpKbH6gpHR7fgIjflVfq0oMPCquEC/M8YhyBIR+C3ZA9/5oM1p/BMA05mfQUR/uyaxs2txk4962tgv4GloluS4BNuRZYHbaPx613r+EU2V1LMM6zyieaiksIlioAurCPnSVZwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746447946; c=relaxed/simple;
	bh=n/fgQL2fll6leEWqwIr7zBCkBz55zcXdMqkP5bDlmq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlwVNspWoTVACvJrGczChqPAVOglpFlHA5x2/hqUe4BoWCCor1++TavT+rX0sivbFXxdQyzvVzdyXlP4WEzARbiWSmdbu4qQcynT+gde5v7y01ZtbO6ht5LfoUbZM5bjdlm4XH/lE4tCVgBHxrrE+VvXvuHHWGfkyr04pLdwdNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MPEeNS2b; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MPEeNS2b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0A6oQOazpk50unQMUGteUzEmifVsuPz5yVPXYc5EEH8=; b=MPEeNS2bTw7QsXMxejiMfPK/Ou
	d6JcIi4BA3ptUObfzXKcqoLRzjarzsSrglOscN0tgbhU7ln+GDafNsCBF8rnVxqlCe2BgU8XkZLg7
	FxiJK6jTXxIwyR2ndvOH0qU8aoCZp2WPp78Hbeg7tLUqMGbJeK3boU4Q+dfl4335jvxVW9x8dqVHH
	ZsKMKVn9Acl0J75LBzjIz1BJC7fP9pCGMPIgEMDKo1lt+gdGnDj6CgqeZWKxylXqkeV/7Jct5980N
	78PQPLhZKDoqhf4aEdHe8pWEgBZKcOVVy+4hensf4p8iqMqUIRi/9W/As917DSPF0Fb3k3+ULSlwQ
	1jSgXYpA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBut8-003YGY-1r;
	Mon, 05 May 2025 20:25:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 May 2025 20:25:38 +0800
Date: Mon, 5 May 2025 20:25:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: rng - fix documentation for crypto_rng_alg()
Message-ID: <aBiuQqT404K56J_q@gondor.apana.org.au>
References: <20250430115953.1180650-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430115953.1180650-1-ovidiu.panait.oss@gmail.com>

On Wed, Apr 30, 2025 at 02:59:53PM +0300, Ovidiu Panait wrote:
> Current documentation states that crypto_rng_alg() returns the cra_name of
> the rng algorithm, but it actually returns a 'struct rng_alg' pointer from
> a RNG handle.
> 
> Update documentation to reflect this.
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  include/crypto/rng.h | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
