Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788C8156F45;
	Sat, 15 Aug 2026 01:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786757475; cv=none; b=QFZH7paGz+gWa5eInPPZOoTJ+BRnip+2XobXbKcbEHHR0NrYRzZ4jr0qOhZVhyW6XHrqaQKF3efq7YEVIau/LdheE+Cju5AFt08gQz+mHyEOOehRZyiegFHQQTWvC8w8ofr4LjBazqdBdS1yM7YgejdTBlagtTW1d/c8WK/66NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786757475; c=relaxed/simple;
	bh=YDFTkQHt8HnJARMi6gDcRoWwjeA5/O638hK/VLKSipY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3w02Gay9HWwILY4Fp/g8k/gz0Jpv0X6TnCxW6rR3h99MVhwh5kQ0LkYHqIuWwJKektoa7mX2vbjAQlEYcGM4Thyc3rfYKOVveYOmAW73sH2t6sifSgupufejOpN+jQ4IY73YUo0I9yJ67mjainugx4toSg64n5cLK+NmDTPp18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cAOJ6Gmx; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cAOJ6Gmx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4jNghAtZwFig/xlQiovRnBECwDlgnSHSfon4Uu5rLD0=; 
	b=cAOJ6Gmx8d5QK57AOfxVWxEQ6xlBu8EIAP+5ZY8Ksm6o5+FcnmgqgQiOYnOpFiqvZmCrJgqQC+b
	FYgk3XtPrf91mGh18JpR/1SDx2s08I72NYgxFgYwJ9X2Hhpn8KxHt9PtXkAUyJTCa63+5F+NT8zn9
	wzEQYyhzTj2WHjxSdbh/v6er5G9MNpvJfRRNdfaZK8JXDB7VuaC2IlxojutRx8IZ+CaIdh7ZBZ6S8
	4bTWmC5Y3BxIpQ3m6lHF/xNXPS6slH4KrBrW500vg4u0vbVZMfgp7rlt7a6u8XXsqeA3MryLEYOUp
	YZ8fGi3TF7czcPHEAJbJ8tpmao002sL0Mrcw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv3Ec-0000000552w-0fvi;
	Sat, 15 Aug 2026 09:30:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:30:54 +1000
Date: Sat, 15 Aug 2026 11:30:54 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: pzalewski@thegoodpenguin.co.uk
Cc: Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mattia Dongili <malattia@linux.it>,
	Weili Qian <qianweili@huawei.com>,
	Olivia Mackall <olivia@selenic.com>,
	Corey Minyard <corey@minyard.net>, Peter Huewe <peterhuewe@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	linux-integrity@vger.kernel.org
Subject: Re: [PATCH 2/4] char: hw_random: use named initializers for
 acpi_device_id
Message-ID: <an_BTvo8t80rPGIW@gondor.apana.org.au>
References: <20260807-acpi-char-v1-0-742c450254dd@thegoodpenguin.co.uk>
 <20260807-acpi-char-v1-2-742c450254dd@thegoodpenguin.co.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807-acpi-char-v1-2-742c450254dd@thegoodpenguin.co.uk>

On Fri, Aug 07, 2026 at 12:26:09PM +0100, Pawel Zalewski via B4 Relay wrote:
> From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
> 
> Use a named initializer for the acpi_device_id fields which
> makes the code more readable and consistent with how lists
> are initialized in the rest of the kernel code base. Also
> drop explicitly setting fields to 0 where it is redundant.
> 
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
> ---
>  drivers/char/hw_random/hisi-trng-v2.c | 2 +-
>  drivers/char/hw_random/xgene-rng.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
