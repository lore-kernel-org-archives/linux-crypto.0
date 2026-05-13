Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4AD224AF7;
	Wed, 13 May 2026 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778681356; cv=none; b=YfI+nQpYuvh5cc/eJm4LZjp72/2ufFajgS61tjOcoLTADWxfpb+ReB3ozgMPUed2IQuQrp21IE5Apu2c1A9Gs5vrT5hKYbPTSRzxFRjpGbz31xyisO7Jb8lf7i7CBOfa6SkpwcywTOZNSmm1RJBXO7Jh71OxYJf37oEBrnqzehg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778681356; c=relaxed/simple;
	bh=NUhZ34fNkOd0L2mNb0uN3WZEPb0BkQiMpixwaAv7GVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZM6TYPc+7ZxQAzfhAj1TjocyChoMYWZ5rKUWNbLRfc/6Zcj+UT+3YTz3v3SablIhgIrbo1biOdJHQlWaym+EH6+z9UpOueqc3SZotCWEB0HseIP745nhPpYd/tTkm7no9aAnaXx4P9h/9iBeXRCWJIyAsePDfxeSzsfzeUFi24c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id B4D05371;
	Wed, 13 May 2026 16:09:11 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 912B16016B8F; Wed, 13 May 2026 16:09:11 +0200 (CEST)
Date: Wed, 13 May 2026 16:09:11 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Qingfang Deng <qingfang.deng@linux.dev>
Cc: Anastasia Tishchenko <sv3iry@gmail.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ecc - Fix carry overflow in vli multiplication
Message-ID: <agSGB39WGpsiv1ep@wunner.de>
References: <20260513105741.55534-1-sv3iry@gmail.com>
 <20260513123948.842-1-qingfang.deng@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513123948.842-1-qingfang.deng@linux.dev>

On Wed, May 13, 2026 at 08:39:48PM +0800, Qingfang Deng wrote:
> On Wed, 13 May 2026 at 13:57:40 +0300, Anastasia Tishchenko wrote:
> > +++ b/crypto/ecc.c
> > @@ -393,14 +393,26 @@ static uint128_t mul_64_64(u64 left, u64 right)
> >  	return result;
> >  }
> >  
> > -static uint128_t add_128_128(uint128_t a, uint128_t b)
> > +/* Calculate addition with overflow checking. Returns true on wrap-around,
> > + * false otherwise.
> > + */
> > +static bool check_add_128_128_overflow(uint128_t *result, uint128_t a,
> > +				       uint128_t b)
> >  {
> > -	uint128_t result;
> > +	bool carry;
> >  
> > -	result.m_low = a.m_low + b.m_low;
> > -	result.m_high = a.m_high + b.m_high + (result.m_low < a.m_low);
> > +	result->m_low = a.m_low + b.m_low;
> > +	carry = (result->m_low < a.m_low);
> >  
> > -	return result;
> > +	result->m_high = a.m_high + b.m_high + carry;
> 
> If CONFIG_ARCH_SUPPORTS_INT128 is defined, you can convert them to
> "unsigned __int128" as done in mul_64_64(), and use check_add_overflow()
> to get the carry.

Okay, but that would be a separate feature on top of this fix.
This fix applies to *all* architectures whereas using native
128-bit integers would only solve the problem on arches which
support such integers.

ARCH_SUPPORTS_INT128 actually depends on CC_HAS_INT128 on all arches
that support it (arm64, loongarch, riscv, s390, x86).  Interestingly,
s390 additionally requires CC_IS_CLANG.  Commit fbac266f095d ("s390:
select ARCH_SUPPORTS_INT128") explains that "gcc generates inefficient
code, which may lead to stack overflows" when handling 128-bit integers.
It goes on to say: "The gcc generated functions have 6kb stack frames,
compared to only 1kb of the code generated with clang."

That reminds me of the high stack usage issue we're seeing when compiling
crypto/ecc.c on arm 32-bit:

https://lore.kernel.org/r/7e3d64a53efb28740b32d1f934e78c10086208ab.1778073318.git.lukas@wunner.de/

I'm fine with adding native 128-bit usage to check_add_128_128_overflow()
on top of this fix if somebody wants to submit a patch.  But I suspect
it might only actually be useful on s390 with clang.

Thanks,

Lukas
