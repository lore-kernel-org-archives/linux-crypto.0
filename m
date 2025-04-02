Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12B821B905;
	Wed,  2 Apr 2025 13:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743602085; cv=none; b=T9zdqUCYn8Qjq2zYCwvituejJAYdDMhRGTpCDutykfLmCjMNs6vdxYES7PxL1Z7a3xD5EQCfoi49IfLINlg4dbJRs3FPg6Ov4pYS6d8T2nkcFekfqvdmE65zsz3CJLrVKTwOGyDvcu34OJBbWVqWNfIkiRfUGeA0mWpBb280j4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743602085; c=relaxed/simple;
	bh=XR6WIesc11FIiICCuBhuVwuxtB1xAi1SbnYyzYIMNNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Grtyrrs9QHQDRBmcKbUenmJjGXL8ZaWPJX9QtIY2GeUkkFORNSWAFIp/iad9f7n+5nOTd7m4v+nqAsTF2pYWECCfhDSQdaYuYiFVu0psTLOD1xY5Ygbvg+MsrbEXYSgafMK/SpW5MWqF6oRYxPCcvpq9eMD2bbJwoYVMoTdRN0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rAybODNf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rAybODNf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=z5MarQ5YKizAAclNCE/wY8mFO4mvhwZ27LtrepgwAhU=; b=rAybODNfz7a7BS8efx2JwS86wq
	9N93tbReerqJIonphw6UvNfVmeeirLBhBWh82YvX1Q3lgF2nXG2bkrnVsFplFxDGEAUJUkVVBJzaO
	I9yceKK616vIueBEKIRCLL8BjCCYUBax6m9gd+WlAy0Wj7zXEcBttvpmo7Pb/q403MUHASfNCSd/p
	heKlExqmnfm/1CegEkKGS2Qug7wccxHznbOBs0RVcPdhmYS55ElnR3wkDdNNJ0UYtWVazX+ZEldDu
	5kj2iTXPppEGboZ0a8mcE9xBDTmr+4H9cre9ThUEFm/p2gKpgri6YEdDiPxIDtvqVIU3Y3Af1MCqi
	EhJa0qYg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzyY9-00C8ls-0c;
	Wed, 02 Apr 2025 21:54:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Apr 2025 21:54:37 +0800
Date: Wed, 2 Apr 2025 21:54:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH RFC 1/2] crypto: ti: Add support for SHA224/256/384/512
 in DTHE V2 driver
Message-ID: <Z-1BnSGNab34W6eU@gondor.apana.org.au>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-2-t-pratham@ti.com>
 <Z8QSVLoucZxG1xlc@gondor.apana.org.au>
 <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>

On Wed, Apr 02, 2025 at 07:01:25PM +0530, T Pratham wrote:
> 
> How are you planning to restore such states in import if the export is
> to be made compatible with sha512_state? Do you have any pointers for me
> on how to change the import/export before sending the next revision of
> my driver?

In struct sha512_state buflen is simply stored in the lower bits of
count[0].  So when you import count[0] you can derive buflen from it
as

	buflen = count[0] & (SHA512_BLOCK_SIZE - 1);

Of course when you're exporting don't forget to put buflen into
the lower bits of count[0] before you write it out.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
