Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384BA4430;
	Sat,  5 Apr 2025 01:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743816988; cv=none; b=Hc/vRWMseMoLP3kbDBghkTdD8e10emWSS9VGY+t3TXNeeoOYdlWDa+iKEll16pdBS9V3slqQ9u8b1TYo/S5SCYAA58R7qGSsZEL4TkAlPZXm47CEts/PVEzYEvGQc+4KzUf/MbbW3Fb5ktCGaY3QGB6Tn8W4IQrWHQDk83zQal4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743816988; c=relaxed/simple;
	bh=xVrkcKcDu/Sx8DgpNbf6S6ch7iL+i7maBa3ur0Fu5Yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jUEdyKCDupQ2ELVWMGfgCaqo4M3l2IGofYdAiNXT4v5I07pm/va9DFnQDr+yuFlbZFI0KdzSgU32UcJ60zjkLVIRvo+qfF30xE0GY1owy4j7dtMGwhw6WXxLXBN6DHivOHGOfpsYHkM7x0MwVMo6SkkZipv8EOVQwlLYngihvAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=onB85GR3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="onB85GR3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LdNfgo5LdMi+OWZTcfRuPHCbrKLIP4sBcG9FsApsoek=; b=onB85GR3PyyFOTgcuFyV+wtkNO
	cTayvdrSWg1mlxDCeDwuTCQiSzTJhdgZ0lNnk5hnjsHIHhCxe1R5/L733bW/SvN97OmteqRbO51FG
	qQZHhGZa4/dn8B6WPJ14PGOdpHSZzemFBTuIlR8zZo3atso4RQRO6jxaDMsc1y0W5U3Gds6p58xCY
	y/AZsD1P+bJ7NyES+JzAPMu/QVHyX3haZ4q8UVQisqmQLLy0475CB2zVG4MryzmzUW6kWCMwTXtKD
	X94HmnosK2CdRBM6MVoFGF2UTsIAFlBkZqTzgtdHKR3C0RxdgdmD0NPU0yUs2+WxONN4Iwll0VyHw
	T/CVf9Ew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u0sSL-00CxTn-37;
	Sat, 05 Apr 2025 09:36:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Apr 2025 09:36:21 +0800
Date: Sat, 5 Apr 2025 09:36:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH RFC 1/2] crypto: ti: Add support for SHA224/256/384/512
 in DTHE V2 driver
Message-ID: <Z_CJFVjAtvhi5Rvy@gondor.apana.org.au>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-2-t-pratham@ti.com>
 <Z8QSVLoucZxG1xlc@gondor.apana.org.au>
 <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>
 <104cdd15-8763-49fc-9f4b-9b21020bd6a1@ti.com>
 <Z-5IaY0JoTYcx1JW@gondor.apana.org.au>
 <8aa65022-8adc-4c4a-a812-11bfd64e628c@ti.com>
 <Z--zFB8Rm007AMzP@gondor.apana.org.au>
 <8536cdf7-f4bd-4f9a-9eaf-9e38fba67741@ti.com>
 <Z_CIUXS-YfiRJxi5@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_CIUXS-YfiRJxi5@gondor.apana.org.au>

On Sat, Apr 05, 2025 at 09:33:05AM +0800, Herbert Xu wrote:
>
> This is not unique either.  Even the software implementation has
> to deal with this.
> 
> This needs to be dealt with in your update function.  Simply buffer
> leftover data and only feed whole blocks to the hardware, until
> fina/finup is called.

But it's a bit silly to duplicate code dealing with this common
problem.  Since I'm going through every driver for the export format,
I think I will change the calling convention so that non-whole blocks
are dealt with by the API.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
