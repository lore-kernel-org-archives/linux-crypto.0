Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965D626FA72
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 02:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744339907; cv=none; b=Jp5TQS8XtP1nA5nauRbdHYv3uQvCG+0i1AH4palDPV8+xljDCF3As+an4X+hf+PvXvrpsFGYV/wj0uiaIrrsuMGjL41opyhygwvmhvu819tcxrEhCPGCgVDTGFrGfGIdOqYmuTQqxC43yxrN9/FboxnnoU8/7kZs1yAt90Mu5Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744339907; c=relaxed/simple;
	bh=O8XuO41CIvdVGIr68miQVaejTPtTayD4FaOW86ejofo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xbh+VrJNZR+TAP0h5BpvtMgxHodJMOGPCg48icdW1Qzq6D1IE69cDUQZ2uvAs7Peh6cFNX0FTEWFLoOnoXfvjLc+VPbNnXpbTcWyPPCa0t4jViZ5HHid8Y2UOV76slNR98xrPG1aEJeqY7CIWy6aojSvqQfVvFnguRYU4+vocus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ias2Rfdb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ias2Rfdb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OQS+9UtVyxjrNGQif9473kak2wCt3dIsRSK1+8D6aL4=; b=ias2RfdbJFYka9/7sGYGeJRnKj
	vnsfxut5elscD6x61tIqd0S0SIpwo2LQg2qKzw5FB0DzEXqNyLjuyvrhpGQ6qgZ+xQ0cfxh+M07sv
	rZzUhgP3WUilgO0Xc1UzcoYvFycrc158TqLhN9GnlSGd9eJZV+HV8NXwe/QIfuXZiDQ+USbWVkBgs
	hUPnfCG48mpKXA9WuSEqH1XDegEP4LfX8eOC9ujzjhpj++VCrMY+rgKxvMP+v9/anQRR30jxruWP1
	Gji0cHJGvup6CTD5JdcI6IBXnjY/23F7YCpKZ/gaE7t5fEtIogf78IwC9HpPKNz+1hUHOq9mKw4Ub
	lNHcZZpg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u34UQ-00Eily-1e;
	Fri, 11 Apr 2025 10:51:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Apr 2025 10:51:34 +0800
Date: Fri, 11 Apr 2025 10:51:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, kuni1840@gmail.com, linux-crypto@vger.kernel.org,
	syzkaller@googlegroups.com
Subject: Re: [v2 PATCH] crypto: scomp - Fix wild memory accesses in
 scomp_free_streams
Message-ID: <Z_iDtlYed_NUn4jG@gondor.apana.org.au>
References: <Z_hv117exy6sjUI7@gondor.apana.org.au>
 <20250411024346.64403-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250411024346.64403-1-kuniyu@amazon.com>

On Thu, Apr 10, 2025 at 07:43:18PM -0700, Kuniyuki Iwashima wrote:
>
> I didn't move the assignment just because I was not sure if the
> immature alg->stream could be accessed by another thread.

The initialisation is conducted under the scomp lock which is taken
by everyone in init_tfm, so until the allocation completes and the
lock is dropped no other init_tfm can see the assigned value.

As to the actual users of alg->stream, it must have first passed
through a successful init_tfm call, again guaranteeing that the
value of alg->stream has been initialised.

> But if it's okay, v2 looks better to me.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
