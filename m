Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18BE8460;
	Tue, 21 Oct 2025 05:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761024360; cv=none; b=soB5i27hIRqIdLtlNiuDZauBzu+6fALw79Q/ZAOjeTLta+oYmsmnRr1S1TH+dq588+U6J36m47PBfPunb8+KMK0BJZcP3umP9smYl4ZqpNPkxdLrgjTsyeY/MoG7+2s2Hud8v/mQIac8/+XdopMdSTWziA6kyQfL21kH/0FJr8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761024360; c=relaxed/simple;
	bh=yM+Pg1AWDMiYbWEqrjp7q84Qg0Qtc/acEG0az9UPlOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lBJvPRwgm6zvY0qzu0kGQ3G6ZquYrGJmjACWcHqIUbVjyfHmG9U/Fc6LCoIPZH07P5+lo5aZ75RA6S27ay2ITIrADFRZ3Nz09fcMmuNjZ3oUfKwCpjW6PXQJVvwbcATGSWYEGSboZbvCWEX/ewKaL90lCIaVtP4ELQdBhnYdrzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=P7GSMQ6i; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="P7GSMQ6i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=sb/zVQ5Y8GIOyh/TGSmy6BFkpVtA7W39/sutF0Ei4ik=; 
	b=P7GSMQ6iLIwqHZmkafulaM30AZ5N5EVRQhH3Rzy+QfROXnW0YflestFzm0013vQl6ybqKz7DcH+
	fy+Ezhlte49tsr0XtO80/xKcOENlwZDNIQK64qi8kXkHnzjQq6Jpz84bc3VlFNWaQlGld9kH1ETDp
	5bf/qE6s+04TT3YhB2JBzcRdttpQio7gNZkgFFjsEzwNX70IPMWX9YpK/s6DJPWfndkOnmJEJznOH
	5P+8x1SZ5y2ynBNnStgpzCpCuCncLTbFlj72anV81N+G7ZfZL1ykcTiCL5s7Cs6jYptDZmJBXpYI3
	vUqLXQZE+WgEsYqORM8d7KiX15V8JXztrEew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vB4sK-00EFB9-0c;
	Tue, 21 Oct 2025 13:25:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Oct 2025 13:25:36 +0800
Date: Tue, 21 Oct 2025 13:25:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?utf-8?B?6IKW5rKb?= <xiaopei01@kylinos.cn>
Cc: syzbot+01fcd39a0d90cdb0e3df <syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com>,
	davem <davem@davemloft.net>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH] [patch] syz test
Message-ID: <aPcZUDOSDQrU-S05@gondor.apana.org.au>
References: <6fnt99vd47a5-6fo0chqsqcpq@nsmail8.2--kylin--1>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6fnt99vd47a5-6fo0chqsqcpq@nsmail8.2--kylin--1>

On Tue, Oct 21, 2025 at 01:16:06PM +0800, 肖沛 wrote:
>
> <pre id="b" style="font-size: 13px; font-family: monospace; background: #ffffff; color: #000033; white-space: pre-wrap; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">but now syzbot has tested the proposed patch and the reproducer did not trigger any issue
> after modified.</pre>

Please stop sending html emails.

Yes please submit the patch properly to lib/crypto:

CRYPTO LIBRARY
M:      Eric Biggers <ebiggers@kernel.org>
M:      Jason A. Donenfeld <Jason@zx2c4.com>
M:      Ard Biesheuvel <ardb@kernel.org>
L:      linux-crypto@vger.kernel.org
S:      Maintained
T:      git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-next
T:      git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-fixes
F:      lib/crypto/

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
