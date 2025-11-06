Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CA3219A8A;
	Thu,  6 Nov 2025 09:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762422414; cv=none; b=Wf+dPACgOQxdwQlDVydQWF4zwrv/KmdBmQyZs44UX0vLy8xwac86zwj083t8MISwGP11EOMMvLeVvDJ/wsTqmE27RGNsea4DVDvwg5Tf91JbpI73YI5oKQZaNI+dyz5vyGycUFFCaHho16feALFMRnLnF+SE1EPpmzvYbCixqNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762422414; c=relaxed/simple;
	bh=wIvSPrfSZJBaRt6Uny14DEyJb3LN3B18gCvGxdwis3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jv6EOzrQXKNaMcsi1s+nOt1ch9vM3/2UaBxYvTI5OAwCU8F1Sq4/r3j/R+ONWa7N0SHmlooIzXkBqtuW8LvkUY0LAHKVyl9jL5Q449EsqDwSvLxWcZimoBxwwNX3yZVVCgFXMKDblg8wOHU0Osnm9meKBPtlBtUgGABk3mUQKDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kcHlkpBh; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kcHlkpBh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IJsXxqo/dnRw7Ci3ZoBABd96KKU10Kci5SA0QVqxseY=; 
	b=kcHlkpBhVMogjZVqzR/tIcvnkAZ0wAfUPM3spDYdCcYiKd1VSPOHnJCCqxih5Bs7PayO2vZLArq
	ugp1rOrVVmER2ks6HWNnbz+iKgRCiGz4EJcfRxFd7x38zA4flaI3YSjU6pEKcQq9Dt6DBHGm2WsuJ
	dHEZnT/vZNKz4FUXeyBSFhGTEi3SHRT8/IaReVOUTNzaJfkB5pgwJm+nmQgHSEnD7nLZS6Qchwk3S
	OQ7HQgMd++LxO+taJQoBLdPj8kFA6lTVXYpaLK9r3TwMWZMnSpthMlhP+xgaVHf7u+YrppxR2uexu
	uDVj9aJYmNO2B9pRCT+vRXVqgdI168o94D1A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGwZh-000tWa-1V;
	Thu, 06 Nov 2025 17:46:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 17:46:37 +0800
Date: Thu, 6 Nov 2025 17:46:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: syzbot <syzbot+bd936ccd4339cea66e6b@syzkaller.appspotmail.com>,
	daniel.m.jordan@oracle.com, linux-kernel@vger.kernel.org,
	steffen.klassert@secunet.com, linux-crypto@vger.kernel.org
Subject: Re: padata: Is padata_find_next() thread-safe?
Message-ID: <aQxufVwZWwRfEaHG@gondor.apana.org.au>
References: <6860c5d3.a00a0220.c1739.0009.GAE@google.com>
 <68c34150.050a0220.3c6139.0045.GAE@google.com>
 <5823185b-55c6-416b-a85c-1191a045caf8@I-love.SAKURA.ne.jp>
 <aQxqTiUUrDmF5M_X@gondor.apana.org.au>
 <60778a1e-c29d-4d41-8272-9e635d9ff427@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60778a1e-c29d-4d41-8272-9e635d9ff427@I-love.SAKURA.ne.jp>

On Thu, Nov 06, 2025 at 06:41:19PM +0900, Tetsuo Handa wrote:
>
> OK. But what is about the "Can a sequence shown below possible?" part?

It's a false positive, i.e., it cannot dead-lock as shown.

> Is using _nested(lock, 1) wrong?

That should kill this particular warning but there could still be
similar warnings if you treat these two locks as the same class.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
