Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC341537C3;
	Tue, 10 Dec 2024 05:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809623; cv=none; b=fO48srPvavQ4bCVdseEb/fgGL8JXQpjkOFFzlIqGoFfqvOTyrDmoHrO656ejfXmuOAwSTuGl3GCideqGekR1TmS7vqFNB9cp41VqDBLllxgwvZKQzlsuUHiQ+R5lS2qKEdIEYiIZRZw3QTm8Xfpfd49l9gEm0OBxp6WIlfLURDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809623; c=relaxed/simple;
	bh=cxGdyHiB8fZ58AhIYjyIS4StBivvAUcpKNkys6PZHNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bwKUN93xEH7d2QveDcgsiL0jiz2anKcD/7B+MS4FNUBgdg2Dgjhj2O1LuwuBs8k6ZKjRZfLH6e2ylY4IFcprk8luDGt1hvqoRG9/6sBSfOuQE/PN/sw/joHyvNWqeLSdhQDaoSfgjvQgA4OciZ73GizyX6mu3eQZ9rglS+oXaIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CXnKGoG3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CXnKGoG3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3KKW3aYukuzlk4AU++XqNaNLDdb0OBTaGDvQ0iBhnQk=; b=CXnKGoG3FgGboBihomWyo7eK9Z
	CNbsVWwV5T45GyS0KmQxoGrSoZ4Z5qk6JSSZZxEab97Z4ldkSeIeaM7cx89ynasEWaNmrakRt6fb6
	XhqjceaAJL2eQS8Pqyk6abQsJD/lxeKJOGorGw5Ay9igzLwLYphO2QjME5YcMOrUuoBdxu6uphknN
	qZHJ837JXoQb4pxqEAaJ1l7LrTph7nBfxq4EIyB0kv7KwekSNx+gc7Dh/HoT4Up6ZhP9F0xoTgrZu
	uu1qjnG0erAzky4jvln6bborKbduwRrYhi7RfMosj2wp5M0EYN69RMgTwG0rlhhcdeGqYr0Lj4RH9
	w/FLZRxA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tKssK-000OAr-05;
	Tue, 10 Dec 2024 13:46:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Dec 2024 13:46:56 +0800
Date: Tue, 10 Dec 2024 13:46:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Weili Qian <qianweili@huawei.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	liulongfang@huawei.com, shenyang39@huawei.com
Subject: Re: [PATCH 0/2] crypto: hisilicon - add data aggregation feature
Message-ID: <Z1fV0Jj0RHd6IC1Q@gondor.apana.org.au>
References: <20241115112651.54299-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115112651.54299-1-qianweili@huawei.com>

On Fri, Nov 15, 2024 at 07:26:49PM +0800, Weili Qian wrote:
> The zip device supports the data aggregation feature. This patchset
> enables the hardware data aggregation feature, and registers it to uacce
> subsystem to support submit operations in user space. In addition,
> error detection and reporting of the data aggregation feature are enabled.
> 
> Weili Qian (2):
>   crypto: hisilicon/zip - add data aggregation feature
>   crypto: hisilicon/zip - support new error report
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c |  12 +
>  drivers/crypto/hisilicon/qm.c             |  58 +++--
>  drivers/crypto/hisilicon/sec2/sec_main.c  |  12 +
>  drivers/crypto/hisilicon/zip/Makefile     |   2 +-
>  drivers/crypto/hisilicon/zip/dae_main.c   | 262 ++++++++++++++++++++++
>  drivers/crypto/hisilicon/zip/zip.h        |   8 +
>  drivers/crypto/hisilicon/zip/zip_main.c   |  51 ++++-
>  include/linux/hisi_acc_qm.h               |   5 +
>  8 files changed, 385 insertions(+), 25 deletions(-)
>  create mode 100644 drivers/crypto/hisilicon/zip/dae_main.c
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
