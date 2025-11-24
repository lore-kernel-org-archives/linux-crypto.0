Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC1E2F6187;
	Mon, 24 Nov 2025 09:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763977754; cv=none; b=kEblmgkymF7n04AkjMSkCkF6TqXvHFB6jPCzMEOmjIuf26CvCilUzrjK78j0IqKB125LOEOWe7I2a7CMFe0GHkQ68/AfP6fCHFLr97DnXWmmt3RtKJLyNrqf485VUsVYejTkELTQUK2TQklZGhmt8Lvyca8dji7c23sJK5Stksc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763977754; c=relaxed/simple;
	bh=XVv0a/j+GgVdwkLooNVu8/L88VoOFzXtseopbNrg0jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rbU7qOEL+tj3Dj0AEsZ+d6sweRquIaTO7Df5j9uUif3PTlupHXGqlF0EY5duRThJe6MbZHbdpuq+mOaZiv98w8IE32c9j83phkeVs2L6fHp1IXTj/v1qMfR0zVBwXJcQwcaAcc7eL7aT5NNkgh+hTp7sMdXJvUJvgP4jTR6INE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Gzok8FeU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Gzok8FeU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bcui04wUrJGLCUSACMGAJjVCbT+7fdon+daQNvMd9Zo=; 
	b=Gzok8FeUMi+72XYChLg5NvbnOmmS+6/dobmqOxyGZ3EPUr1DGs3dCT4nf7Jc6igiIg5VlkExM5o
	qfujUK4WYscZTivMF+W8YXg2ONdVoBVzpzgN0wY1o0UZwbUtE/1gcb8ZVOw2UyqUtlp/CWYs8rUN+
	WORtHCOxERS6jw39KJmj7/byJ2NqyWj9AXalsRX+tdtzNcuxJLiutXJHNJjxe9tlE9u9JPMvvyoq+
	xMShLX8tmDs/5pUnSHRsqBbSUoFBWF2H/G3YjU/nIUG8cjGFmn8k/4R1I0dEvk3uC/Gmqj+XQKik5
	R7ZZ8jTss3SADpVdsGTRydaFYdPiR4NSVq6A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vNTBT-005XMj-1s;
	Mon, 24 Nov 2025 17:48:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Nov 2025 17:48:35 +0800
Date: Mon, 24 Nov 2025 17:48:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - Add missing DES weak and semi-weak key
 tests
Message-ID: <aSQp8x2yrLTZQ-lj@gondor.apana.org.au>
References: <20251117114426.99713-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117114426.99713-2-thorsten.blum@linux.dev>

On Mon, Nov 17, 2025 at 12:44:26PM +0100, Thorsten Blum wrote:
> Ever since commit da7f033ddc9f ("crypto: cryptomgr - Add test
> infrastructure"), the DES test suite has tested only one of the four
> weak keys and none of the twelve semi-weak keys.
> 
> DES has four weak keys and twelve semi-weak keys, and the kernel's DES
> implementation correctly detects and rejects all of these keys when the
> CRYPTO_TFM_REQ_FORBID_WEAK_KEYS flag is set. However, only a single weak
> key was being tested. Add tests for all 16 weak and semi-weak keys.
> 
> While DES is deprecated, it is still used in some legacy protocols, and
> weak/semi-weak key detection should be tested accordingly.
> 
> Tested on arm64 with cryptographic self-tests.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/testmgr.h | 120 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 120 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
