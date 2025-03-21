Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EA21C3F02
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 11:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742555160; cv=none; b=eqZwRVUJQodCPmzXC+oVH3kDlnfnp47k8dIgrhirBUcXfhXhVfK0z19y3w6aug4s3DHU89wfkMeF0CMgGCqJa9+12QEX8JjC+iEAMnDQoFs6RkZX1XevBMyH8Uu/5Bqwa6/7WW7kqH8CgPrGTmt6PJgLeXD+li6za/U78vmkzII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742555160; c=relaxed/simple;
	bh=6uRnMGVj6v2Rjum3N5cNbMH9cvpFX7y8N65sIRHw1cA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SbZ7QpZqyG3QMNud2DaUwQeO4QfE2++pW8eJI1l57uyR+eRZp3IciU9I6pJOm031rdrHkaPXEr4rLOafUlmZtNzS4CEwwbjy2tGj0ffUdSaGQf/QcpdWl5bmqCaRMAbf4vqGMH+eBtEKrcr8QP6IfnzEmzuLDprDZUT1pLiVx0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dPS29wWs; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dPS29wWs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KgPOrOahv6gAwQjYYWbuT6y46so/ge29bgQQ7b+iPNg=; b=dPS29wWs6bhpxQSY99KXlY3Rro
	b5EvkEIgPrqz//gbRbXTCNuU5shnCPJjALU3aXAP0VpnSDDIWt/4DSgwHbMFFcpr8rsO8Iyp4jcKK
	SyBa0banmZYzEgEc+RFEFUDZHAuJfmizqrknl5mQcmdoIUQeISJEk0QmMqEkCGmR4SCXF8aFCAJyi
	+4S21oLEU62dtrq+W2uPLw2ApBlaCLbQGj0fi/VbLnW4epsNKYWhxGrj+f9oJ+l+LIW5nWlW2uIKK
	UsCmwv4tQcb2i+e68KE71OlxWSKEKxZSMpmRc+gATbEeNQUjrMgd5ziTpfRIZtbTPOUxSDGUZnX/S
	q/cvuMHg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvaCI-0090Dq-0k;
	Fri, 21 Mar 2025 19:05:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 19:05:54 +0800
Date: Fri, 21 Mar 2025 19:05:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/3] crypto: qat - add improvements to FW loader
Message-ID: <Z91IEp-2WZV-s-qd@gondor.apana.org.au>
References: <20250314130918.11877-2-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314130918.11877-2-giovanni.cabiddu@intel.com>

On Fri, Mar 14, 2025 at 12:57:51PM +0000, Giovanni Cabiddu wrote:
> This small set of patches adds some minor improvements to the QAT
> firmware loader.
> 
> - Patch #1 removes some unused members in a structure that are not used
>   for doing the firmware authentication.
> - Patch #2 removes a redundant check on the size of the firmware image.
> - Patch #3 simplifies the allocations for the firmware authentication
>   an introduces an additional check to ensure that the allocated memory
>   meets the requirements of the authentication firmware.
> 
> Jack Xu (3):
>   crypto: qat - remove unused members in suof structure
>   crypto: qat - remove redundant FW image size check
>   crypto: qat - optimize allocations for fw authentication
> 
>  .../intel/qat/qat_common/icp_qat_uclo.h       | 10 -----
>  .../crypto/intel/qat/qat_common/qat_uclo.c    | 38 ++++++++++---------
>  2 files changed, 21 insertions(+), 27 deletions(-)
> 
> -- 
> 2.48.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
