Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33D845016;
	Sat,  2 Nov 2024 10:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730543244; cv=none; b=ThuXdKLOQSyaeeh2zr7Duo1313NS/Kv0xM2gAqkqdbmE43whOA5wBUn7cGFMQgA4/DAtLIQh26mY3tqqpO5An56Thk0PxpSCpCpgvSB7SiT23LGBDK2KNJZuVf7NgUP2yES1UB5fMNy8w7o+JNFGnFI2ze6oWb9/5AEVU1M0cFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730543244; c=relaxed/simple;
	bh=Txk6GmzjYkr1wwqxkSPue4VWxONIQ3ZfB6bijRamuKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BWoE1Uc+B1G2C77bCKeq66XOMcPjG2ROMP+OJcz0JvoIh8y91ZC0WH6T2nq246Gp0W3xKFigZs0p7UJmgqws20N5A+rrewJy+gVuQi5VplNZLJSz/HvDvMBAL3qIFPaROvEPqjKQ+SdaWG2J+5ZV3wUDtaCwCAOOeFzr1TeN9X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=htzaJFoY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="htzaJFoY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=c5NeMnXRdsNP6ID0beSwexT+OutEek3mNI6J1IERhXM=; b=htzaJFoY+4AqlAiF18PoXlOK6S
	f+yZ+Fm1Nzf6dsXj0t9noPP5Xvp4D/gnnWw19t98orLWaBVz36jB8nEB8jc97nfSw0AB7Wrt5N4M0
	/+nCPh/H5xITSswLuSW7dEw3abpA3gz398pQW+vYHF0MGFXZHZVx0PpYdNeRfa6+jhDbj13qUJdZ+
	nlVyiFmRe3eBSKUxbwpCHtgskzqeG8RXY7we8ff8sj2P8LiRrEQRg+mRWa9Tudd9Qc9DaulCzw0Z2
	2ICzLifA+3D04QWcAl9mt8Ou3t+97lueC2RufB40JwcR/3U4K23cMxUpQKEzxo9H5sjyFj4eyhOf2
	3XVGTuAg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t7BLf-00Dy5E-31;
	Sat, 02 Nov 2024 18:27:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 02 Nov 2024 18:27:15 +0800
Date: Sat, 2 Nov 2024 18:27:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	shenyang39@huawei.com, qianweili@huawei.com, taoqi10@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon - support querying the capability
 register
Message-ID: <ZyX-g5doORj29CiK@gondor.apana.org.au>
References: <20241026094651.1648131-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026094651.1648131-1-huangchenghai2@huawei.com>

On Sat, Oct 26, 2024 at 05:46:51PM +0800, Chenghai Huang wrote:
> From: Qi Tao <taoqi10@huawei.com>
> 
> Query the capability register status of accelerator devices
> (SEC, HPRE and ZIP) through the debugfs interface, for example:
> cat cap_regs. The purpose is to improve the robustness and
> locability of hardware devices and drivers.
> 
> Signed-off-by: Qi Tao <taoqi10@huawei.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  Documentation/ABI/testing/debugfs-hisi-hpre |   7 ++
>  Documentation/ABI/testing/debugfs-hisi-sec  |   7 ++
>  Documentation/ABI/testing/debugfs-hisi-zip  |   7 ++
>  drivers/crypto/hisilicon/hpre/hpre.h        |  23 ++++
>  drivers/crypto/hisilicon/hpre/hpre_main.c   | 121 +++++++++++++++-----
>  drivers/crypto/hisilicon/qm.c               |  88 +++++++++-----
>  drivers/crypto/hisilicon/sec2/sec.h         |  26 ++++-
>  drivers/crypto/hisilicon/sec2/sec_crypto.c  |   8 +-
>  drivers/crypto/hisilicon/sec2/sec_main.c    |  71 ++++++++++--
>  drivers/crypto/hisilicon/zip/zip.h          |  18 +++
>  drivers/crypto/hisilicon/zip/zip_main.c     | 116 +++++++++++++------
>  include/linux/hisi_acc_qm.h                 |  15 +++
>  12 files changed, 396 insertions(+), 111 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
