Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D2A34388E;
	Fri, 11 Sep 2026 05:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789103228; cv=none; b=VipVQEglzOt+gpgKtNf8kMzde3pe3vBRS7um//WOyeT5NAVasCIVorL5pT5kCfF7/SVDr1AQ8jJz1DMKAKfmZenD2IxgB6aqMezuyG6y2Yl+v5MIylN+Hxboe77iOa/p3YaGA1FgN9Bdq0lDcKNtHiQLidG4egbg0TUbqF2WyrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789103228; c=relaxed/simple;
	bh=yw8fLNwBbMUPSyGG4yRvzZGlGcBx+83dbxW3/xXGyrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GosLsjfmcg+EJC6kVwUru3Lhay66DKFBkLXkAOkdr2dtGCr8uOQwalMMkAvE3So2oJq1WB2xMOZlW6fHJW4yF6TlUyBLmStFAo4PtTFEOTk294sfHT77Iau7yEE3TXiZKa3poZDtv860W2aL4w/k4alFOt809WIzxADDoJ5aTfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rqNx6Y2v; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rqNx6Y2v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bgXj9iW4L8xDvAQnLVHYY9iMfqiEAgCZF8Tut2lsVRs=; 
	b=rqNx6Y2vRspOzRws6KhcNKe9q0Y5z7Yl63mj2rZZT+RmuqaYGyLN5eNxSXQfJ6ppRHTAayEzOb2
	SP1BRIbe88AuVEvR8CvLcxEQZ/UKhRIV37+62Qo5YeXJhE3sInWAbnRZ7eBrlvAMqjmqddYs9+gVW
	C53AVqZtDTPOuWkGUFvdADOL51gVhoZPPF41WJOujfAACnbd1m3kRVVo2mpKD8tPFEOJLWH+8FqI4
	GFf1LNyAO1VmkKbRsCUuWGpS8ydQuZ7yKkF0rRaG0//2+TfI5CpPk7E/YdGE0+7qf7TJs4RT2KKjp
	s/RsPB3aHpiHYVP8RcarO+Ldsn8xLyU7sYJA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tTX-0000000Ctmc-24FK;
	Fri, 11 Sep 2026 13:07:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:06:59 +1000
Date: Fri, 11 Sep 2026 15:06:59 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, robh+dt@kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, xuwei5@huawei.com,
	prime.zeng@hisilicon.com, liulongfang@huawei.com,
	qianweili@huawei.com, wangzhou1@hisilicon.com,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH v2] crypto: hisilicon/sec - remove SEC crypto block
 cipher accelerator
Message-ID: <aqOMc1vGnmiULh2E@gondor.apana.org.au>
References: <20260819075353.94500-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819075353.94500-1-huangchenghai2@huawei.com>

On Wed, Aug 19, 2026 at 03:53:53PM +0800, Chenghai Huang wrote:
> The Hisilicon SEC crypto cipher accelerator has been superseded
> by the newer SEC2 driver (drivers/crypto/hisilicon/sec2/). SEC2
> provides wider algorithm coverage and is the maintained path forward,
> and users have migrated to it.
> 
> The legacy SEC driver has had no active users for some time, and its
> primary maintainer, Jonathan Cameron, has moved on from Huawei and
> is no longer in a position to maintain it. With thanks to Jonathan
> for his contributions to this driver over the years, and with no one
> left to keep it up to date, remove it from the tree.
> 
> This drops the legacy SEC driver together with all of its residual
> configuration, devicetree binding and board description references:
> 
>   - drivers/crypto/hisilicon/sec/
>   - CONFIG_CRYPTO_DEV_HISI_SEC Kconfig option
>   - sec/ entry from drivers/crypto/hisilicon/Makefile
>   - Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
>   - hisilicon,hip07-sec device nodes and their supporting mbigen_alg /
>     smmu_alg infrastructure from arch/arm64/boot/dts/hisilicon/hip07.dtsi
> 
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> Reviewed-by: Longfang Liu <liulongfang@huawei.com>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Acked-by: Wei Xu <xuwei5@hisilicon.com>
> ---
>  .../bindings/crypto/hisilicon,hip06-sec.yaml  |  134 --
>  arch/arm64/boot/dts/hisilicon/hip07.dtsi      |  280 ----
>  drivers/crypto/hisilicon/Kconfig              |   14 -
>  drivers/crypto/hisilicon/Makefile             |    1 -
>  drivers/crypto/hisilicon/sec/Makefile         |    3 -
>  drivers/crypto/hisilicon/sec/sec_algs.c       | 1122 --------------
>  drivers/crypto/hisilicon/sec/sec_drv.c        | 1307 -----------------
>  drivers/crypto/hisilicon/sec/sec_drv.h        |  428 ------
>  8 files changed, 3289 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
>  delete mode 100644 drivers/crypto/hisilicon/sec/Makefile
>  delete mode 100644 drivers/crypto/hisilicon/sec/sec_algs.c
>  delete mode 100644 drivers/crypto/hisilicon/sec/sec_drv.c
>  delete mode 100644 drivers/crypto/hisilicon/sec/sec_drv.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
