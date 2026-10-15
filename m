Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B88150E587
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 09:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792058121; cv=none; b=OzP59PRrE3/VK9FAzGpIbdL+h19W+qSXH46/eEzdVsY5FQ2cIiN3WHyH6liudfXxhAa/AKSXpEEBJoEghNdH7Xc0H+zVyp24j7GacqX2GxlPQUf0ER9lhP5uBA4o2hQPKWQLjHwt3eoFapOy+W1jx49xciXP54ha36DGV2Jc5ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792058121; c=relaxed/simple;
	bh=55T7lClmsZPrRNK2JvVNE3Tz78N3UKmyAJpypEWz5Y8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QaWtCOYrX8OMJ+nhLKauclq/MZn6u2kMJBiL3PmgN5tg14TWYrFLivGl/gDk6fIaxXO49eW0xTfmA2gGef5TV1lz16zU8Aqu+H8Hwy+Fczt1IMslpcKc2Hc9iYstg2tj3sAIzkQdMwPRqULKbAl9UHBFm0ihMBUXGdeNVGUncjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=foEvXILA; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="foEvXILA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7HdUDboBu1gzfYtTumCQeS79pPxWLB3igACHXqixSFU=; 
	b=foEvXILAgXhHq+ujRMdO87MUmAPZtXoJLE+M5U/IcNgEurpAintTUe8iKHgXSf7Kl2MkPyDrOJd
	G8ryTGxibwxAWE0NIs+AxtHjrqF2ffXyUCS79quLA0HmbZ9vV2l+xP7BPwAmhacZjMFswhhnQ46lp
	SvVy7e5klB4gsDDIkxOYpBT5RT/uiX+JFnhyNyVWP7TzFTRm40/XSMXNw+dz9UXd1ub+a8LFC6zO0
	gAGgq9R4vPWvy9W5d5ZYnCvyM3UYOs+Qf3ThUF41xvdXm/P2KQKihN47P6ri8tVUx+QbdLf8Qnxpk
	SuYJ9261NfIn8UwLjWLBXwVofUsDiEZoMH2w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHIB2-000000047tX-2GBg;
	Thu, 15 Oct 2026 17:55:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2026 20:55:08 +1100
Date: Thu, 15 Oct 2026 20:55:08 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - fix mutex lifetimes in the device
 manager
Message-ID: <atCi_HkJrgmA0wwt@gondor.apana.org.au>
References: <20261006150649.2517748-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006150649.2517748-1-ahsan.atta@intel.com>

On Tue, Oct 06, 2026 at 04:06:46PM +0100, Ahsan Atta wrote:
> Two mutexes used by the QAT driver are initialised or destroyed on paths
> that do not match their actual lifetime, so with CONFIG_DEBUG_MUTEXES
> enabled both are reported on a dh895xcc with 32 host-bound VFs.
> 
> In summary:
> Patch #1: state_lock is initialised at the end of adf_devmgr_add_dev(),
> after the early return taken when an id mapping for the VF already
> exists. Since that mapping outlives the VF, recreating VFs on the same
> BDF leaves the lock uninitialised while adf_dev_up() and adf_dev_down()
> take it. Move the initialisation up so it happens on every path.
> 
> Patch #2: vf2pf_lock is destroyed as part of the VF interrupt teardown
> in adf_dev_down(), but adf_dev_stop_async() sends the RESTARTING_COMPLETE
> message to the PF afterwards and takes that lock, so every PF restart
> locks a destroyed mutex. The notification cannot be moved earlier, so
> tie the lock lifetime to the accel device instead, next to state_lock in
> adf_devmgr_add_dev()/adf_devmgr_rm_dev().
> 
> Both patches are fixes for stable.
> 
> Ahsan Atta (2):
>   crypto: qat - initialise state_lock on every path in
>     adf_devmgr_add_dev()
>   crypto: qat - fix use of destroyed vf2pf_lock on VF restart
> 
>  drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c | 10 +++++++++-
>  drivers/crypto/intel/qat/qat_common/adf_vf_isr.c  |  2 --
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> 
> base-commit: ee0454474a0f1b636dc96217b346e3571878b292
> -- 
> 2.50.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
