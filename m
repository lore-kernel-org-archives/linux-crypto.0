Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E2E2D7D2E;
	Sat,  7 Feb 2026 01:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770428020; cv=none; b=j79uEfJ3468QbaAHnDU22aqqFsi0kfjQ+0oymKGnaXYbQqdSPYWau6eq4Hg6/PXH70UOgdj8BXkjnnQDQCkLMSipP992NlBqUqtBoVuMbS7ifQlKYZeSrQY4+RMxkDfrZQ8gA2dkcEi8MwHGKcy6YexLkd/UHuLU5WbTbnmn1hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770428020; c=relaxed/simple;
	bh=LKV10Wx7JZFnWsD22mp3fXmYDXMNQU/di4xVlUPLVrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HFcLb6nL0eJMdf/UAoU7KpEwfSiMpAlEPQuleF49uzIOAmuVZtdPUhVA3yxfALCyRRjSdszExlvqAttuYxXLsC6piLpWLsXvsTFX6fmBj7Oi5pnb+YkdZPld6QUh2gXc6wdHcomNAezjl9yKIsHPWWYZ6iRk7dTm2hDjSeJg9TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=p7lxJoZ8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="p7lxJoZ8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ZP0q/N4Mv9/YFhWpAEXqYZ/5tMDPuAMQxDVCxLLtahA=; 
	b=p7lxJoZ8nABuzGCYhDzD+n1dsvvbK1j2iCbx0SqWB2b0vbHpJSXopIgM1OGu0oCjJ3d8vTykhIp
	ecg1yN6ilbWsjkmaTkn9TuW51rR3R4inFr0kMp6c9kR9LWFW6TZyx7Qf3vxSYkLAmlF5t54BPo6Gc
	BG4g9Qyk2bSiGK72c5TbHfljUbOswSrYdyXCX6ZG5sjtjfd41AycIi/KY/nAcfPtYmZmGez3/dKHA
	oYsNQ8B6vc5BFkt0mpTjjNPkJ9pMFC8re5A/WVw2aP/abhy08iOQbDyCro3kjvT6np4GIYWY8VhRL
	P//eABMNc1MQv+ElULnIYCkvxGlAc1HJI/xQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voXCF-005AtF-2W;
	Sat, 07 Feb 2026 09:33:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Feb 2026 09:33:15 +0800
Date: Sat, 7 Feb 2026 09:33:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - Add test vectors for
 authenc(hmac(md5),cbc(des3_ede))
Message-ID: <aYaWWy2KSYz787a-@gondor.apana.org.au>
References: <20260201112834.3378-1-olek2@wp.pl>
 <aYXKFtmVJCCZpUVw@gondor.apana.org.au>
 <3622af67-b083-488a-998a-29b8657be73a@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3622af67-b083-488a-998a-29b8657be73a@wp.pl>

On Fri, Feb 06, 2026 at 08:40:18PM +0100, Aleksander Jan Bajkowski wrote:
>
> While resolving the conflict, the entry was added in the wrong place. As a
> result, the test manager complains about sorting:
> [    0.050891] testmgr: alg_test_descs entries in wrong order:
> 'authenc(hmac(md5),ecb(cipher_null))' before
> 'authenc(hmac(md5),cbc(des3_ede))'

Thanks for the heads up.  I've just pushed out a fix, can you
please double-check?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
