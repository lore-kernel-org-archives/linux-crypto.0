Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE04E29CE5;
	Sat, 26 Oct 2024 06:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925762; cv=none; b=gvuJJ/V1JlX/cSMU395j6V7Fz4hhkE2pA0ljLQLkQoRyRnta3jBLqbGOKttFABy3YIwMexY/b8T7uJsSeuTgr+bsVrykgYGKdjnTyoESXZv1H4tlA26ceYc698FmKq/XBh8C95ZVsjCE60iwbLvSZqk+V0ZFwk7VEtYvQzA0XZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925762; c=relaxed/simple;
	bh=TQQwS07gTVqhEJcJmiW/Yb1DL2TzJ+oDWR3IT5RoJkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=saA87wPmom0yNtEbNt4LdugLxi+GMCQeI0lDh5BN92CMbut7iKcxgAFF1Ers0NrhTukaYlP+X9wft/qXM3ShHrO8/0Gflv3i7PoW5sDsMjiDGYm5P+j5f9UqeY0xHvYwZyt/Tm5jcSsqsjiwgAuJ9UXrg2Fcw15b0Dmdr6rf5Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qx3meZGc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qx3meZGc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/Mq3fud90KAWp1yqh9QXH/sTcs1XrXUsNMckN2BVMGw=; b=qx3meZGcBwRoHwOlHVMgHrrgvN
	AJPbYh9meTvbVeR5qDNMcePSFbWG87dwcx9b3y2Ra/H7kiy5xQwmCUzqI5BY2zZanyYSjU76g7jpJ
	6f3LxhSd7o+LthEj2doAk7D5FfkNMP85y5CB8cbk2MVDHSIzTVzLBYlUijopFwo/4oRyTgXQ1PESa
	N2ffY+FLh4FzjgwlvDN02hpGXrwTXFehNZtkNPtN74VGkyzR3VNwZ1a7gcgXIn2t8yo2iMpE9Y6I+
	MEHR09FVSXPs0jPU1SyB6OTJiCCEXUm2TI+akR4abQ78x8Ll2KUwX9glwKXRUIu09e3RDBLBLv1me
	O3EAZxig==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4ai9-00CFur-1c;
	Sat, 26 Oct 2024 14:55:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:55:45 +0800
Date: Sat, 26 Oct 2024 14:55:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vishal Chourasia <vishalc@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, davem@davemloft.net, mpe@ellerman.id.au,
	npiggin@gmail.com, christophe.leroy@csgroup.eu, naveen@kernel.org,
	maddy@linux.ibm.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 1/2] crypto/nx: Rename devdata_mutex to
 devdata_spinlock
Message-ID: <ZxyScR5z4uvJ0g6r@gondor.apana.org.au>
References: <20241015105551.1817348-2-vishalc@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015105551.1817348-2-vishalc@linux.ibm.com>

On Tue, Oct 15, 2024 at 04:25:51PM +0530, Vishal Chourasia wrote:
> Rename devdata_mutex to devdata_spinlock to accurately reflect its
> implementation as a spinlock.
> 
> [1] v1 https://lore.kernel.org/all/ZwyqD-w5hEhrnqTB@linux.ibm.com
> 
> Signed-off-by: Vishal Chourasia <vishalc@linux.ibm.com>
> ---
>  drivers/crypto/nx/nx-common-pseries.c | 34 +++++++++++++--------------
>  1 file changed, 17 insertions(+), 17 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
