Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6EB45016;
	Sat,  2 Nov 2024 10:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730543250; cv=none; b=YZmUxaiqI44nnfgWzsSBC6yhUIDSO51kJd5nVwL2ewZERMsCsmBS0Z9Z7sJY7Yq0TwPQUyNPby9MtJDSUmBY7QlrA/o+86SoHkPUQe/Z9hKZUE4JZhLN5oYdQ9B2+q70Ut68pA4VhB7C19fc449dORBwlheVBamwW/YxESPmP7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730543250; c=relaxed/simple;
	bh=gJ0yfazwv53p2TN/o65RhEqRJsKdSKYFP87MLWY1nXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4M3ZCCtKGnM/4IjSTcpsyA0MsUAspzHaM4FzVXiwCs3AqAeEa4NoZKKqi0RSz+k9cUlKsMaJzJkEFiYfx/5aJg8c9IIBg53Tl1+8quZuC8m6dfz+cua9rmhhsOb10MOgIxmtwn3fbTRi40+zQIHsAkBO/5tFFl/VlmjM922Ys4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EqIIcEnw; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EqIIcEnw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fybUe+1EsNhgWNHapJ1oIvkjUrejrg3OJXD9IeFCVX4=; b=EqIIcEnwBGFsILwMNDuJ+a/NYj
	I75hhgkNZHrKPTr3QCYdWhY1zIewAdE2CTexk4Ax8twG1ZXWgh9aOXQEK6nPCKtISLF0eL2HCPZDS
	kG2zuLmTOFcnvBsh8RJCa8b+V/haBAliQ+bpbdLzZVFHCte7H+/CfaqsyS9S2pbQeK9dKzA7h+OVG
	29Y6DpXiIHbHWGubYB/KNSiGmS75nDl8UCKGmMMARFGf+ObPtAybJhQhl3ICnEM/2W/74vJM7q+Ni
	yHZX7uZxQgnHo4OcuRTMSnjT9v0S726Bj1CPcbbBtZ4Kjt1m4U6Qze0luC0J+/ecY2DLLJRcw77xD
	RaxflAGg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t7BLm-00Dy5K-2v;
	Sat, 02 Nov 2024 18:27:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 02 Nov 2024 18:27:22 +0800
Date: Sat, 2 Nov 2024 18:27:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Weili Qian <qianweili@huawei.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	liulongfang@huawei.com, shenyang39@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/qm - disable same error report before
 resetting
Message-ID: <ZyX-ijCZdl0tN7Ki@gondor.apana.org.au>
References: <20241026114429.54090-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026114429.54090-1-qianweili@huawei.com>

On Sat, Oct 26, 2024 at 07:44:29PM +0800, Weili Qian wrote:
> If an error indicating that the device needs to be reset is reported,
> disable the error reporting before device reset is complete,
> enable the error reporting after the reset is complete to prevent
> the same error from being reported repeatedly.
> 
> Fixes: eaebf4c3b103 ("crypto: hisilicon - Unify hardware error init/uninit into QM")
> Signed-off-by: Weili Qian <qianweili@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 35 ++++++++++++++---
>  drivers/crypto/hisilicon/qm.c             | 47 +++++++----------------
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 35 ++++++++++++++---
>  drivers/crypto/hisilicon/zip/zip_main.c   | 35 ++++++++++++++---
>  include/linux/hisi_acc_qm.h               |  8 +++-
>  5 files changed, 110 insertions(+), 50 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
