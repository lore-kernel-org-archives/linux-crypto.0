Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B232F3E
	for <linux-crypto@vger.kernel.org>; Fri, 23 May 2025 12:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748002001; cv=none; b=r7rGUqXZerTv4KhYuOw6Tp9C81wpI6GZOrzdmpLjxE9RfJ1yc34epR9y/y4Jpdb03aq6+u/QVFm7OmvPOzREO2s4uEeA20nw6KAnYQTxJcZ/fNG2CGDJ2ocdOnYQSp3JndwcWKY1I/aO57q2QBlMgJFdaDIzB/i4fWohXttFnlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748002001; c=relaxed/simple;
	bh=r+2WMk2MFopVLu1knj7fJUt/u4MSdXUj4ol0XckOpKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ANpK5ZROJFr3lN/e/ESTt+7Iddb5sQ8wQqYaI9TtuBvsLDAut6UXi7XhlPluzFo1f0EJ+DQZr80F1nbg4B44r1NJaGppGeDZGlzr7e83YsTJ+R8iX0Eile8acKRocOIIVz5rYFcPSoTOHlwvaP9a9e3hfsBsgZBST3/IsQf/+0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GUQuRJss; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GUQuRJss"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hdBhAst6NQJdzBWnMYeLf5wpSXCnHUyZDq04FfSwfnQ=; b=GUQuRJssW1eszVCUz/4KBtgKlZ
	VxM5s4COcDFC0zP8QGetryVo7ff10Rax1iybODJaGsDODEb4K8gXcz+8Icyqqh7EMfagxivC6lfOY
	V2xmZ9EP2hHUc0wg/7UTIf8oVxK5QH4PdQ0HmSpqSMxS5NTrvRQu8DxlMFFB5JUGTcu2+/XUNjORW
	EWNL8vXZTzluxUWg8WwfVNG4KRTsekGLdD7oCz9iRY3nzb0h0d0fxfHmXB5r8gt6RaAwke/gQBF5q
	TPSVlJACpvpF7huECTsOHcWl24+L9qUf5GiddhzKGPTWzHtMYV9R59m1TakR8hbtb4a4Xt4ny9CfF
	Ifsyn10g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uIRAZ-008LP6-0S;
	Fri, 23 May 2025 20:06:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 May 2025 20:06:35 +0800
Date: Fri, 23 May 2025 20:06:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: Re: CI: Selftest failures of s390 SHA3 and HMAC on next kernel
Message-ID: <aDBky-9a56tyJTuJ@gondor.apana.org.au>
References: <623a7fcb-b4cb-48e6-9833-57ad2b32a252@linux.ibm.com>
 <aDBe3o77jZTFWY9B@gondor.apana.org.au>
 <38637840-a626-49a9-a548-c1a141917775@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38637840-a626-49a9-a548-c1a141917775@linux.ibm.com>

On Fri, May 23, 2025 at 02:03:23PM +0200, Ingo Franzki wrote:
>
> Here is the output from modprobing sha3_256_s390:
> I guess the output is somehow interleaved, since both sha3-224 and sha3-256 are tested concurrently.....
> I hope you can sort it out what belongs to what.

Nice :)

> May 23 13:50:09 b8345006.lnxne.boe kernel: alg: ahash: sha3 export state different from generic: sha3-256-s390
> May 23 13:50:09 b8345006.lnxne.boe kernel: alg: ahash: sha3 export state different from generic: sha3-224-s390
> May 23 13:50:09 b8345006.lnxne.boe kernel: 00000000: 82 b2 3c 2d 20 76 43 a5 08 dd 0f 8e 75 dc ac a1

...

> May 23 13:50:09 b8345006.lnxne.boe kernel: 00000000: a5 43 76 20 2d 3c b2 82 a1 ac dc 75 8e 0f dd 08

So it is the byte-order.  That should be easy to fix.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
