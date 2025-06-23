Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E00E235073;
	Mon, 23 Jun 2025 09:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670272; cv=none; b=anJuqMemxXOGHZNeTN6dFKTtY7ASr92l12guISqyRnUTTi4VYV8wbSL7D9ODJtAsnGt7LVhUjh0V/yTZK4UtWshIEC/RyBF2Jui4INdz5iUXSusmnQqaUG1DCyE5nr6qIwevEGYby13JN81LDEnKHo2yzaojDef2zIwGfOfmFXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670272; c=relaxed/simple;
	bh=68yU88ZsDP6flv9Iq+6DZZiYCh5OnMcMFj+JtAHofX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZBcNnu4IaTajgI6i0HE+9wIZJjCLqTuHD0G3NKLiRK9lOUMrbwGoZzN6L1FfZ9LdQFeKzMJYVT/ep5Ao8umDcW8PUsB1ZonunOCC95+SZXeOdGsk7Zf4zU4fx4mQPZ/nMgpS9oNHfZbuCKDbQO6DjjwT6q+0BJM+DQhQ14TNf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IZ1BofxI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IZ1BofxI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3pK3yHQ00Ie28/bNXr2JxWFBovPz2NQMh4thf0IZUWY=; b=IZ1BofxImkLmpZME6FjqOE5Lpn
	eBW2+jfeMSoHh2n+DGmDVDK4RbIKW386I5MPn2XhG2Holx2+oJD+LXq0ZT9qAkG2XlhGMuMFYXNOU
	ligHE5OE1SC7GL7rf8PjD1zMCNs6p7Vwe7wXvguXkTi0iSEtPXLISHfLdELj807Xdlr/Z+2jlTfIS
	+vZjwspVnRAuSxHqMGti5JLiDhRTA8LbgZzrK9Wu0g/zsU6mD7pcV+a1PeSXmkHL6lKTdwpxPR8/U
	9yGBtyOAHn5jU9UY/ctFbKSVgSY/ST6wZ0xCNLPtIoe2NzbPrBjLBBprKUDmBvzOu58AHf/25lwrO
	qNLScgMA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTd3P-000FT4-2Q;
	Mon, 23 Jun 2025 17:17:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:17:24 +0800
Date: Mon, 23 Jun 2025 17:17:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Russell King <linux@armlinux.org.uk>,
	Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@google.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: crypto: work around gcc-15 warning
Message-ID: <aFkbpCBUr-ujNMCF@gondor.apana.org.au>
References: <20250610093256.2645686-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610093256.2645686-1-arnd@kernel.org>

On Tue, Jun 10, 2025 at 11:32:52AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> I get a very rare -Wstringop-overread warning with gcc-15 for one function
> in aesbs_ctr_encrypt():
> 
> arch/arm/crypto/aes-neonbs-glue.c: In function 'ctr_encrypt':
> arch/arm/crypto/aes-neonbs-glue.c:212:1446: error: '__builtin_memcpy' offset [17, 2147483647] is out of the bounds [0, 16] of object 'buf' with type 'u8[16]' {aka 'unsigned char[16]'} [-Werror=array-bounds=]
>   212 |                         src = dst = memcpy(buf + sizeof(buf) - bytes,
> arch/arm/crypto/aes-neonbs-glue.c: In function 'ctr_encrypt':
> arch/arm/crypto/aes-neonbs-glue.c:218:17: error: 'aesbs_ctr_encrypt' reading 1 byte from a region of size 0 [-Werror=stringop-overread]
>   218 |                 aesbs_ctr_encrypt(dst, src, ctx->rk, ctx->rounds, bytes, walk.iv);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/arm/crypto/aes-neonbs-glue.c:218:17: note: referencing argument 2 of type 'const u8[0]' {aka 'const unsigned char[]'}
> arch/arm/crypto/aes-neonbs-glue.c:218:17: note: referencing argument 3 of type 'const u8[0]' {aka 'const unsigned char[]'}
> arch/arm/crypto/aes-neonbs-glue.c:218:17: note: referencing argument 6 of type 'u8[0]' {aka 'unsigned char[]'}
> arch/arm/crypto/aes-neonbs-glue.c:36:17: note: in a call to function 'aesbs_ctr_encrypt'
>    36 | asmlinkage void aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
> 
> This could happen in theory if walk.nbytes is larger than INT_MAX and gets
> converted to a negative local variable.
> 
> Keep the type unsigned like the orignal nbytes to be sure there is no
> integer overflow.
> 
> Fixes: c8bf850e991a ("crypto: arm/aes-neonbs-ctr - deal with non-multiples of AES block size")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/crypto/aes-neonbs-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
