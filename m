Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6211322DA14;
	Fri, 23 May 2025 11:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747999667; cv=none; b=iaQmmRUGyLtcd+/rmgXo1bnaAq7tNSGTXXUEMxrV1QLrIsvQaq/MZG+qnmNOkWHHrOIn7v7Wmr0nUmejvqVpS2ewzJiNws1bNcvz8X+RWRAKy0tLFT3cJIDmKwJ/EVdZoRq/uCP2IAsT+alVLCxUest9lCf6eHCAdVvHL41UrAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747999667; c=relaxed/simple;
	bh=5a6zXSJpthJyYT44WU0aQWWYfu96MpiKVHej83rcEj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YixtR2iCmNJyezxdklBx2vbL3EqfdEUdvGcgxqtAvR3TLfH62X9F+AKxjcik8qausMH2ZD8xefOu8iAhW6/TXxownSISsjaInYXVrC7DuWtGNLEwD521fZv0m6Qlsfl+s/GfILxAvQ+TUqFUHJosfZuzTtx8B4KQ67NLbuq9ogY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UZWt0IPU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UZWt0IPU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/Ee1Be1+UNySSvEO6FEZOcPUAesZ+CIZK6qOt0mZxSg=; b=UZWt0IPUBXVoHCrxMHFQN2zzox
	wYa2xM3VZodNjHqc4mcduwnV8ZP7Iy7EZQABbJ1vs8DMOhB9fU6FIGbuQlEEEd/uvL0cCC+tw2TfJ
	RtsnYSTvuUaKHgU0qJoq10Hz/lQLXKZcyfCgukoaBQsa/aPNMD+WOTGFbnP5U2v378S1yOmsKEXb2
	pMjziZCq90bKXAonm6EEmdcS3ndbsblC8xqhjYKGdMPx+8a0di++DlcPInaPB20sgnK0ooOS+yba0
	vzx3+rZt80CusGJWcC4PF1Hls534aQYYmgoojuJCT5ZaclW2tijg3mzYi2fvkxlU5FzDiuhX8rw6D
	LyUNPXwQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uIQYm-008L2w-08;
	Fri, 23 May 2025 19:27:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 May 2025 19:27:32 +0800
Date: Fri, 23 May 2025 19:27:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Karthikeyan Gopal <karthikeyan.gopal@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	George Abraham P <george.abraham.p@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: qat - add missing header inclusion
Message-ID: <aDBbpOtpr5ATk4Rj@gondor.apana.org.au>
References: <20250520161148.3562622-1-arnd@kernel.org>
 <aC1c7+PQZN++5mgf@gcabiddu-mobl.ger.corp.intel.com>
 <aC76tZFMTee1hHI3@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC76tZFMTee1hHI3@gcabiddu-mobl.ger.corp.intel.com>

On Thu, May 22, 2025 at 11:21:41AM +0100, Cabiddu, Giovanni wrote:
>
> Without this header, the build of the new qat_6xxx driver fails when
> CONFIG_PCI_IOV is not set:
> 
>     In file included from drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c:7:
>     drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h: In function 'adf_gen4_init_pf_pfvf_ops':
>     drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h:13:34: error: 'adf_pfvf_comms_disabled' undeclared (first use in this function)
>        13 |         pfvf_ops->enable_comms = adf_pfvf_comms_disabled;
>           |                                  ^~~~~~~~~~~~~~~~~~~~~~~
> 
> Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h | 1 +
>  drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h | 1 +
>  2 files changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
