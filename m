Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868FD23BD06
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 01:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178297; cv=none; b=SouKy/KmvDuQG4kjIBd3GkwWEhZspvRHpcZAeItiuo9D5ucfR199VudAdL/ToX37qHF8vNLKdYhcsjIoz8sJXnuMSL8sBwbFPB4eZr2LUrT28pUr8psByNyhVGta0QBCOh2EcYVE7Xu7OWqNYOqzzRiZeVqhAJe1sTxP0GyxEUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178297; c=relaxed/simple;
	bh=JyHiiGogNYk+hY1g8F8UzmmZKVOwTaCwgvR6h3ewOXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HhHrr+4M1T+YtRY5qCnRwdTZWHyR7FrnhyVfeteRGwOaBtuDhSx4vHVWRiMKk/33VTBdd5Ww2Lz/bDZ9pIYaamhHQNduh5XZeBfwi6CXklQZ+TxdRXK209PwSPtC5W5Dl9Y6fXphrciBNYb7XUYaMr1jzcDIZopT6cJWtsSUW2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gAXqYJVe; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gAXqYJVe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2kxRpqzCBwkBzaeYSjb7uZ6hJxjSLBmuWmzi7+dYXNM=; 
	b=gAXqYJVei+4KVqc4gxvdMHdWNix5xwm4g8BNu2TrlIWtaHci0w36q617iX3Xo2RLaOU2Ua/td2q
	uiYL9ABmICJpGDK9Cwg/AEIpqpxzj/UYTpoP1Feh0IgeKIQNyuDOWutSvK22fLFmi0mCrr4rv1lc+
	piFdiDJKjRIL/w49636L+5TDq3kfsszuYASWhKxqn55sR7p5ZzB8FH7EtDTIC1c4P6QD9aCPyVDdm
	A1Wdi48hVHRjpb3SaVtEtnD8VAg4zDW+c7iP1N03yc/yatRAXbMBuROx+2z1C+AO+ndYUwtGCxc+5
	iG24GLiZsMF+CuYfpPeJ2CI4DUf3XsC0h9Aw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8SYU-003QzV-10;
	Fri, 03 Apr 2026 09:04:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 09:04:53 +0800
Date: Fri, 3 Apr 2026 09:04:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com, atharvd440@gmail.com,
	andriy.shevchenko@intel.com, ahsan.atta@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - fix and cleanup RAS sysfs show
 functions
Message-ID: <ac8SNWjvV7KT8_az@gondor.apana.org.au>
References: <20260324181936.122027-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324181936.122027-1-giovanni.cabiddu@intel.com>

On Tue, Mar 24, 2026 at 06:17:22PM +0000, Giovanni Cabiddu wrote:
> This small series fixes a type mismatch bug in the RAS error counter
> sysfs interface of the Intel QAT driver and follows up with a cleanup to
> use the recommended sysfs output API.
> 
> Patch #1 fixes a type mismatch in the RAS sysfs show callbacks: the
> local counter variable was declared as 'unsigned long' while
> atomic_read() returns int, causing an implicit conversion and a wrong
> '%ld' format specifier. Patch #2 follows up by migrating the same
> callbacks from scnprintf() to the recommended sysfs_emit() API.
> 
> Atharv Dubey (1):
>   crypto: qat - replace scnprintf() with sysfs_emit()
> 
> Giovanni Cabiddu (1):
>   crypto: qat - fix type mismatch in RAS sysfs show functions
> 
>  .../intel/qat/qat_common/adf_sysfs_ras_counters.c    | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> 
> base-commit: 8da773efcd2b505cca6bbd13aad4a28fda61cf37
> -- 
> 2.53.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
