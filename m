Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF46424024E;
	Tue, 14 Jan 2025 03:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736826073; cv=none; b=AoWM0VJ+FGuweYMDjiEOQJ85E4W+35WbNPkTm9LkL6RBh1MHgkzLFMRe5ac88G6wpTRbzYxuvtEJoDnoLOBgBxLvLfAKWByCgWrADa3viKjny65ziFS8IBiSJE/3Kaa+DAJkN/2/2XUWM4WZ3RU+dA3m+Eeg4kWl05o3yl3Msi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736826073; c=relaxed/simple;
	bh=TR6pcgTbeb6MLt4lcExfE3fWcQNjr/t6GOpCrwIWjNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KFvRepa6Ix0XWmWYjjVORaqjrnCm67j4CbH7X60T3qekFa5OFbDpW6aNUPE8KHAvBFIdli2/I2tGhcinn+YniBVEvj0INHEeIJiOynafuA+4qP+BaG6fZSjCK+D7Bihlg6Yyuf/ru0bMzDlxIIwj6GRGxUMBnNDk2Mub7o3QZAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IHZKI90S; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IHZKI90S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IxjdR8qsMFRS7wjws5Do1fH+LSfkfqFtBOU2tHMNT7g=; b=IHZKI90SkR42O+MJKqShEy0CjF
	VePZ3qJ2rzk2g7aMqMSDexi55uu5ls0rJ6eJUBcl7bjGrSZr/5Vq5wVkV2ws/Gmp18ABwpB9nKgdY
	6sCbNWzrysdlHWYZ1anka5wvNSsvO531cXEHtxVhyMtMR/HEFOD57Ht10wG4Ubf6TN0qdKN+sC0xU
	UJRUwbdJiEv8yFZ+5tOefIo8fEWEgQwTJzA3BlMMIhSCF3x9UQsvfnSWJiMLBosiCflcx+rItQkc5
	S8fIMloNM4cUjZNvbMfJhhOIqouHgBq21ZCSW7f2icTyIeQyid54N6AlA46NT/Rw8Wo4/2PrKzv2i
	1FFsJ6qg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tXXak-008xWi-0u;
	Tue, 14 Jan 2025 11:41:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Jan 2025 11:41:07 +0800
Date: Tue, 14 Jan 2025 11:41:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Weili Qian <qianweili@huawei.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	liulongfang@huawei.com, shenyang39@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/qm - support new function communication
Message-ID: <Z4Xc0w7TGQpeXKM2@gondor.apana.org.au>
References: <20250103102138.28991-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250103102138.28991-1-qianweili@huawei.com>

On Fri, Jan 03, 2025 at 06:21:38PM +0800, Weili Qian wrote:
> From: Yang Shen <shenyang39@huawei.com>
> 
> On the HiSilicon accelerators drivers, the PF/VFs driver can send messages
> to the VFs/PF by writing hardware registers, and the VFs/PF driver receives
> messages from the PF/VFs by reading hardware registers. To support this
> feature, a new version id is added, different communication mechanism are
> used based on different version id.
> 
> Signed-off-by: Yang Shen <shenyang39@huawei.com>
> Signed-off-by: Weili Qian <qianweili@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c |   1 -
>  drivers/crypto/hisilicon/qm.c             | 233 ++++++++++++++++------
>  drivers/crypto/hisilicon/sec2/sec_main.c  |   1 -
>  drivers/crypto/hisilicon/zip/zip_main.c   |   1 -
>  include/linux/hisi_acc_qm.h               |   3 +
>  5 files changed, 178 insertions(+), 61 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
