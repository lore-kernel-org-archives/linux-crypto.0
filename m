Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F52223716
	for <linux-crypto@vger.kernel.org>; Sun, 27 Apr 2025 01:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745716333; cv=none; b=Jg92XIOC+rQJD1VJArxMS3yLi7FDPpvDKOq3Bn4WtMUh6bJNiI4ag33BnSkjc/pSe+ON5UBMTkdur49k74ZCtGk/RrN+QEd0TWIq4Pi8x/kLTi9gegjrTfsKv6ocoIgUuKcCvdaBwB/iORtKooOoRDcaRGirjJkwzP1GBQiRQUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745716333; c=relaxed/simple;
	bh=TIk0jz9PykdFArCl0mJ/+Dz82xaMXLytP0vrdTvZujU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lPv1s54IlEMk1HhDRd6avQ1katy/2A6PTNMSF7fQBOJctHIFchP5EWr0OMjA7Qg8lCcjMoOjJgaKR/SFDr6c7G1JAU/Y1GQKD3N0VBDSXCfg5rMBA/GyFnBW/siT1H+56xkoH8zQBjGgkX+j3EhZpTCQvErI7kekwMMm8h4BtWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=V6tf6Irw; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="V6tf6Irw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ket0Pollt0sYL6uy29gMHsvqQTVdoVptvZgXOyZswKk=; b=V6tf6Irwt0hqki+gkm1fHNUzZ/
	7JejiOZ6uwVLn8MXIFvfT7EQuCqKSulh9JlbMXXmFtvz2dG41i0ZU52ZwFIxy/MqGXopIrabfMNDW
	JlKWsogdi++SMgb8yRGJrPquxe6fi4e1SSV7NqtBCkzVPk77GtdIgpNE+EyOT21SgqyOHpZ5hd4JH
	L9oWrbK4XHDw/bn83jsZeBrWNKEM8KXjMUQHYiyuEwWOECHzgfeCI4QNUNRY5GWgpGsiuba56Z4Ww
	kTAoapeAaYYwK8455l4pDdB0+fXdjA3/zSFaKTUsocT2g1ohyHS9COIAVrb/e9adsp0ayuWJJZ2xw
	fksdoEWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8qYx-001JSf-2B;
	Sun, 27 Apr 2025 09:12:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Apr 2025 09:12:07 +0800
Date: Sun, 27 Apr 2025 09:12:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/2] crypto: scatterwalk - Move skcipher walk and use it
 for memcpy_sglist
Message-ID: <aA2EZ3q4qcFSKJxO@gondor.apana.org.au>
References: <cover.1745714222.git.herbert@gondor.apana.org.au>
 <8a564443ba01b29418291a4e3045e2546cd9e3a8.1745714222.git.herbert@gondor.apana.org.au>
 <20250427010834.GB68006@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427010834.GB68006@quark>

On Sat, Apr 26, 2025 at 06:08:34PM -0700, Eric Biggers wrote:
>
> I think it would end up faster and simpler to just implement the copy from first
> principles instead of trying to share the code with skcipher_walk.  There is way
> too much stuff that skcipher_walk has to handle that isn't relevant for a simple
> copy.

Sure, please feel free to improve this function further.  I just
needed something that works for chacha20poly1305 and this was the
easiest way to get it done.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
