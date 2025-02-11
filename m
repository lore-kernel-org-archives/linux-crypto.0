Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA6D1F03F9
	for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 09:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739265299; cv=none; b=PhPkAsp1U5oZD+Lw2MtoON0AIdk7vDFncSeGCIOzZ1faxzxrxGsQ1UM0RHjXn72Zl+Fa7Jbr/QzplGScFYcoqE8ye+t7bWRK6mER0RNJMnybxtQsnVq4Qg94iuLtnocHcsPe9C9HRO2Gjd9uw7tBFoeYfvgalRsjewZcLFsCfqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739265299; c=relaxed/simple;
	bh=CvvjDePU5vwbfpFd53cP3BZV76wBojYiG3jSdROVDpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P4m8eY0bNY002UOoivtB59FNv5YkybqJ1khXiu/kdoft9jxT76OXXIYhNxarJy192vCoYBZ/CbmqtualaLd6bctLfqwG9kgzvz5ijI5NJheYniqfVXL6fjzfkHWFoBOX8yy0G2jfSoqu6h731yHmjjsozId5RpnbprszxtkLSbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bZ4meYo4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bZ4meYo4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Aqd7pu1/9zHZNZevNyPwtXv2vM6VaCSaz2bXB3N32sk=; b=bZ4meYo4P4wtvhn9jhNqld3CHJ
	s2FMuiZ0wUHfAGAPBx6Ysbt/zyox7Jo8oHAxiz6Lel3Zhb9rMF5Jqmo2NrmmjMjEKvgw14x5M8Z/s
	GPgcH06KMHxhYvA10wkbEqSY0uXFNT8nRzg2qza4eguUYltH0a3LDkfR36Eht5AaKhwGh+6hrAHq1
	kmt6wEqdb0hHAsb8qAfWPSHl+TCHMMCNo/PcGHbbBLCItaG0b2dlpQuFTWN2fhy7XjeSiLIktnKlU
	7X2Coo3a1TozHW0LDia+YuoxZbyRq2XzHpEAz5e0XW9t6+vic9DeYwRNGyWpcCWVdKp9HSbv24nDk
	E4ATNvZQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1thm93-00GyUM-2n;
	Tue, 11 Feb 2025 17:14:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Feb 2025 17:14:50 +0800
Date: Tue, 11 Feb 2025 17:14:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Markus Theil <theil.markus@gmail.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, smueller@chronox.de
Subject: Re: [PATCH] crypto: jitter - add cmdline oversampling overrides
Message-ID: <Z6sVCpb-DxqXOw1s@gondor.apana.org.au>
References: <20250127160236.7821-1-theil.markus@gmail.com>
 <Z6hy7LFoHPffWuWi@gondor.apana.org.au>
 <1157db48-ba02-4977-9604-fdca26da575b@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1157db48-ba02-4977-9604-fdca26da575b@gmail.com>

On Mon, Feb 10, 2025 at 01:40:10PM +0100, Markus Theil wrote:
>
> This was also my first thought, just enable fips mode. Our workloads don't
> have to run in FIPS mode and I don't know which software may reacts to the
> kernel announcing to be fips enabled in an unexpected way.
> 
> So basically, this seems to be useful, even when not in FIPS mode.

That's not a strong reason for adding a new run-time toggle.  It
sounds like you could just enable FIPS mode instead.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
