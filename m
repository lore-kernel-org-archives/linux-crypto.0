Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E6A29ACF6;
	Thu, 23 Apr 2026 07:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776930382; cv=none; b=bRrvdg6WACyNfWhXUblLTIEDYVyfrFQoK2xPQBpOuSGI09c34NyjsMXYtTYURpmDIPeOyOtkWkIoO5Np/T2r592MPppMTj2UdDIg3I6t2Js4rjLwx8PDDKc2vBnAnoS3/QEA2bJCnCkLRTSom+sGIXEUeDWzgjH/OHRw0Ba63Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776930382; c=relaxed/simple;
	bh=8ZNFc51pEvlR9htuu7uiJvdGd102cpwocB5mOx5LAWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DAOhV1iDq0nH1Em5oX1xqv/Ap4wpcjVfbacMShjd/Yh1qEkuam0sNH6sMrgi0kqQ/Mxd5Yic5xijLohV0sAdBXoxufGQhqKBcIsr/bHp1HhVBYWS2iaZEyaWG6GVEiUKq9TbD87yyRbzvYM4mcFCCSOotoE5v7xm1h1cdUnlT8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7176E68D05; Thu, 23 Apr 2026 09:46:15 +0200 (CEST)
Date: Thu, 23 Apr 2026 09:46:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-raid@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 3/8] xor/arm64: Use shared NEON intrinsics
 implementation from 32-bit ARM
Message-ID: <20260423074614.GB31018@lst.de>
References: <20260422171655.3437334-10-ardb+git@google.com> <20260422171655.3437334-13-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422171655.3437334-13-ardb+git@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +extern void __xor_eor3_2(unsigned long bytes, unsigned long * __restrict p1,
> +		const unsigned long * __restrict p2);

Does the alias magic prevent this from being in a header?  If so a comment
would be nice, otherwise moving it to a header would be even better.

