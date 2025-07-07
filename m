Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CA73214;
	Mon,  7 Jul 2025 03:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751858958; cv=none; b=jEVQTMorfW0rV73RasLWyxp51absugBcsrtAjUa/4m2zSxrb70k2Xpf3iaug9E0LtU+apuRn3/X7zsWfUilsZROelkjLaRfnkpHvOkWkhB2LlQ2czKyYubUeqiIgSKarq112BiGHZizrhAzGdyaIteKq7BIZ47LK7ei1IfGVHIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751858958; c=relaxed/simple;
	bh=RltF7f+GGOAdk1uXeWH9Q0yNg8vSevBU6Owoc5Jc03M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EEFo9xtQRbeQyGE2lJPunu7eLqXeC0JyFh0iLND4Rt28fX9tqdIHDpUNz1I796rr+jQpUlixkY4mWLzI6VDt7O2GRPkqxY2yJnFPOQMv6B25lwwDrzEmFcEBU4OR2mVKao4c4hoVSg1D1U35qrIHu7g0nOIdCRB+lnVD3wHKFyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=R7R9GKRz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="R7R9GKRz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cWbCCLkH3NHBs19k8S1rmvOybIRVJwRDSYoogeJP35M=; b=R7R9GKRzWMSstQEj1dxfFmlDq+
	rAgcNvZ/yx5GS1nwg5OSaTYjAKHnA6KKf0rWubXKui6tMsnCxoArdEdwJqt017HUG+0GPC5AeYdYC
	cZG2GX+jQON6cs7tySYn9PAd4Uf2MWkl/FmmrQKWz/maZPH6Isw6hpWJaZwSacTRSPiUHSsmKRq2f
	kNdOhljKXJKSvecJ9F0AuoSJ77dcrGmeQSy9qV+qwW7hD9Q/eGZaV3oqUiiClhEVUgOrJ0J2LbgnF
	BAJhtyjnEbshLyizR02mwAiEvk2QioT+KQOodPA2V5DNHsWQ5biC60cjuAZauwzY2SFFVTu+LzjA9
	/N/Axp0w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uYcI7-004VZO-0H;
	Mon, 07 Jul 2025 11:29:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Jul 2025 15:29:11 +1200
Date: Mon, 7 Jul 2025 15:29:11 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH] crypto/ccp: Fix locking on alloc failure handling
Message-ID: <aGs_B3NsVJiNWTSf@gondor.apana.org.au>
References: <20250617094354.1357771-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617094354.1357771-1-aik@amd.com>

On Tue, Jun 17, 2025 at 07:43:54PM +1000, Alexey Kardashevskiy wrote:
> The __snp_alloc_firmware_pages() helper allocates pages in the firmware
> state (alloc + rmpupdate). In case of failed rmpupdate, it tries
> reclaiming pages with already changed state. This requires calling
> the PSP firmware and since there is sev_cmd_mutex to guard such calls,
> the helper takes a "locked" parameter so specify if the lock needs to
> be held.
> 
> Most calls happen from snp_alloc_firmware_page() which executes without
> the lock. However
> 
> commit 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation when SNP is enabled")
> 
> switched sev_fw_alloc() from alloc_pages() (which does not call the PSP) to
> __snp_alloc_firmware_pages() (which does) but did not account for the fact
> that sev_fw_alloc() is called from __sev_platform_init_locked()
> (via __sev_platform_init_handle_tmr()) and executes with the lock held.
> 
> Add a "locked" parameter to __snp_alloc_firmware_pages().
> Make sev_fw_alloc() use the new parameter to prevent potential deadlock in
> rmp_mark_pages_firmware() if rmpupdate() failed.
> 
> Fixes: 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation when SNP is enabled")
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
