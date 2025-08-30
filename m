Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094A41B425C;
	Sat, 30 Aug 2025 08:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756543560; cv=none; b=jz6h2BTelfBeI8hLUpNOc8zBUKsVOAb09RWKNe9QM52AIEr+VQx2+U8j7DW++8Fm9oTRGzSANzT9/YP4R/pMAMUmnwa+pMb7DPtkRDzTIWvllJQezWvgkjTwVMiEkdFnl0J0pT4GK+Uh8DEyY2vK1gvQ3gVQvAXnlByejGt04OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756543560; c=relaxed/simple;
	bh=N2cR7uUNq1iqC7cFL5GxSvRogB54uoyLUwIVNiXPrns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dDNDf9nKPaFCEBvDQWAGokZCb5uZJHoS5tbOmYMcZN8C2iMOepAO0WCr+4Pqb5wr+0fesAFLo1PlD2SDc6kU+ZW/zwooYDEZuNnGjsUJVmAFUk7U9kV3dAkfEr051dMATRogFKU2OcAPXd1i5GCY/eiB0z/PyhUVpNz3C/Nac0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=o5fgXgsC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="o5fgXgsC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=G2fGTB5Or3KKVaA/Jp6W5mmb2En4vRpC16mR271J0ac=; b=o5fgXgsCTbR6uWDwuxiD/pgFdc
	e8Udj+9akP0cd40XIr9SdbNi+4zKakD2IVzOmxxc3OkrcUVd4qvLFZWkqSf8gLx/TJBV5SaMdFI5b
	kW7K/DyhF2RKjsawha+5alml4cLgmgwczx0iaVnCU5wF6M0Fknrfej8kRjcrgD36tUwqMuA+ZjbJm
	z+omJASiKxrtVaGAEvzn3qv52UHwucJZKGAZbC0cQqaBpf5GgfNsUwCU9QplNA5isJSA2tguE5PJv
	DVlwGER8hxIR6vsh5iUgwOk1rUq3rC4bRXHRWVG770dTPDKOONwaHZOMSTqdWrqrDx4yfGbPUBaK6
	pUjz0cBg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usGy4-001780-1G;
	Sat, 30 Aug 2025 16:45:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:45:44 +0800
Date: Sat, 30 Aug 2025 16:45:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Edward Adam Davis <eadavis@qq.com>
Cc: smueller@chronox.de, davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V3] crypto: Mark intermediary memory as clean
Message-ID: <aLK6OBB3c4nqrlG-@gondor.apana.org.au>
References: <7740195.jRhZ6ZUK3Y@tauon>
 <tencent_65C6578989EEED6EE78C8B67E586DE92EB06@qq.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_65C6578989EEED6EE78C8B67E586DE92EB06@qq.com>

On Mon, Aug 18, 2025 at 09:24:17PM +0800, Edward Adam Davis wrote:
> This is not a leak! The stack memroy is hashed and fed into the
> entropy pool. We can't recover the original kernel memory from it.
> 
> Reported-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e8bcd7ee3db6cb5cb875
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> V1 -> V2: mark it as unpoison
> V2 -> V3: replace to sizeof, minimize the possibilities where inconsistencies can occur
> 
>  crypto/jitterentropy-kcapi.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
