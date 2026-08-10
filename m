Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0C63A05F2;
	Mon, 10 Aug 2026 08:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350610; cv=none; b=DiCB/VwMhZayaLS/ISyfcPZZRulElKqh7z20sZJ3jNGV3GoRkZtyLSfsbXcIVBXWQW85fT0pyThCqiMgBcPT6O749+gXpleL4cweajZXsIG+QhzEtwTPCBlRiigXIWHkKyXPnJr/a5h74CFiPGyOadeunGkrvaEEJDrlnfeZizI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350610; c=relaxed/simple;
	bh=R4C0fR1BT3c2FbaeR928XF8CwRCSUgbr0fr2/PTIVpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EY7WRSus8dqVlgmZrqrd0PtYksMeP3C0lJRpgEz/s10F0uVAhyNH/2/BZoRh71New6EbV3IPuO8BUi4pTxr+wTndBVOc/Sc2Pfo1tPCkI1rywztuK+ZzWYzQSWSn53ySM/TxS/RRCUd4w2e6SZ5U5HPbOOuuPoL1cgm77IxKizg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FsML3Rp2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FsML3Rp2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=AtPUQqnsnCPEeovvHdcSnP6ioxXRd06P8NqMK/HyM9o=; 
	b=FsML3Rp2keTfR03Z5/OWkg+LJKHRvJ/jPC9alqeNOtHihwZ1vfmbVi8oQqD9IEj7CY+qlqxDH/L
	hIvGb8X8vSNQn6mYywHZ+v8jskvl6aenB+AUwYfXCakSozwGVa1v3lu2MSVyl82ahBMROcHRKXoEt
	kJMaelD06V5ByKPuiNa2LvbsoPKKOPUCVr/+FFJeWnG3d37jqIJ9e9n8gzWjI24yOE3nsBikDSjsq
	3/pdoo7yuiYqsqD22WSL3rO2a5uu4PRWkdI4HP6MbNROnPt60cNlmfFTtKV4CxJ2kG5v/lialcI2+
	JOodAYVWiZQO3PAkZSV3G9davU2875kjPTlQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLOS-00000003Wj9-313Q;
	Mon, 10 Aug 2026 16:30:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:30:00 +1000
Date: Mon, 10 Aug 2026 18:30:00 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - don't abuse kernel-doc comment format
Message-ID: <anmMCDkdRMEIsl0D@gondor.apana.org.au>
References: <20260730051710.1412969-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730051710.1412969-1-rdunlap@infradead.org>

On Wed, Jul 29, 2026 at 10:17:10PM -0700, Randy Dunlap wrote:
> Use plain C "/*" notation for comments that are not in kernel-doc format
> to avoid kernel-doc warnings:
> 
> Warning: include/uapi/linux/psp-sfs.h:18 expecting prototype for SFS().
>  Prototype was for PAYLOAD_NAME_SIZE() instead
> Warning: include/uapi/linux/psp-sfs.h:46 This comment starts with '/**',
>  but isn't a kernel-doc comment.
>  * Seamless Firmware Support (SFS) IOC
> 
> Fixes: 648dbccc03a0 ("crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Ashish Kalra <ashish.kalra@amd.com>
> Cc: Borislav Petkov (AMD) <bp@alien8.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> 
>  include/uapi/linux/psp-sfs.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
