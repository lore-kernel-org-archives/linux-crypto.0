Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8749C3A6F05;
	Tue,  5 May 2026 08:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777969455; cv=none; b=UUY7qwFAqU+zQ03aanmjvaaIo53VTdPFrqUgtdSvDdcAPlNvgyRQwh+GicBhUO713n8Y5cTHmbzDHv3BjeblmV29ky6TqU6RHL/e91sjqJY+IiYDgcfFNV4g0ZNzVjl4qpywFPKSorC58hdpRqAUzrZIp4y4OnkncSy/Z67e1Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777969455; c=relaxed/simple;
	bh=65d4mfJqll7aTN94krnPXFp0SpPrPnQFXDOZmXugglY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmiUW+XFwYvI9HN6fm0mwjfTf0yYmG0XNBch2e47RRqkndbThFZQf+Et7CbQWPRSc0JRz8ajXuqrGigd4hgz2fWVLyHzGAG/0ARJbZwfr2V61KqcbO8+i2ywz/kPnZs5UXwDnqwS+q3ZoFm/qErKTvc74dn3WTrAp5bU/1KOpGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qakh+Pca; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qakh+Pca"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=W2L/wc4nO4TQ1KbAL57CA3IDUihdxHp/UFeH7YUly2g=; 
	b=qakh+PcatNIPaMFzF+xyn7z41x6WBbM6BazmKo1xpOsqEeExYKHAYg22c97p3xxE3F0UXv+W/gG
	1ee5hy9UarXuZ1hurIE9HVhNUdVDhbahMmQNCxPaBdC+qNcRH4xtwtn62LaHVrUwyClAqDg5DlAZp
	ZsrbW7esIBoSuA2WhDarQiQ6784bY2pny5HcnJW7gRv7w9Dg9UC7aPrlWGILjwTiSY8CpF+nce92M
	jn8mXNCoW6+yaT954DpbQ5l/WuaqmRWeWSv1BuIDaTcYSPmm1p9jCAeLnhJUkeNmL/p/2ZWRKcQG7
	f4/3Uus+geyXZi0u8i20co/tntZtGKRmwQqg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKB4H-00BMe7-30;
	Tue, 05 May 2026 16:23:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 16:23:49 +0800
Date: Tue, 5 May 2026 16:23:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Weiming Shi <bestswngs@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Vivek Goyal <vgoyal@redhat.com>, Kees Cook <kees@kernel.org>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>, Jarkko Sakkinen <jarkko@kernel.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH] crypto: fix OOB read in pefile_digest_pe_contents
Message-ID: <afmpFd_iRXDxdxBT@gondor.apana.org.au>
References: <20260430173632.277436-3-bestswngs@gmail.com>
 <afmEQ5ove_8fqEhH@gondor.apana.org.au>
 <afmYY6bDIrKwbwBT@Air.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afmYY6bDIrKwbwBT@Air.local>

On Tue, May 05, 2026 at 03:12:35PM +0800, Weiming Shi wrote:
>
> Do you mean this should be `pelen <= tmp` ?
> 
> pelen == tmp means the cert table sits right at EOF with no trailing data 
> in between - that's a legitimate layout.

Nevermind, I misread the patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
