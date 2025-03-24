Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D7E2E3372
	for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2025 02:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742784074; cv=none; b=knn0WrC2VEZ/g6o9Uf44j86wdH0Gdwr1RqAlgD8N4fCltkY2svhNHUjsvkX0tsVukWpcy/9yD20Ts6ZwxvL65NU+DViOwpUBgblitmpS/LH+2fmaVHhWsT+A+asjvGg/rYZfCV14Qv4/NgvFXviB7H0aUpEdQsc9LAzExKY5caY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742784074; c=relaxed/simple;
	bh=CMcWlmbqB/H7PtxVdZY9WGy38fLLBv8T0wtaZztYAxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhtthE5gu2dMozzaqiL5nHAc037MCER0bDjXNVHQWtgWmQxTuL4a3wX3yu7EAMfE8QZTMaSNcDuMDjcgehf7M9QYjxPh+SlB4fpA6xPGC58anDt/iBVXGF7kEQR2830GBVQfgauFfcXYiodYNS9p7j6lg+pix4BbDOl8aekjsCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IKWY5Ikj; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IKWY5Ikj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bRGr+RnYPCVmP/cpAG9NJUC2XZdr+hfBIrVJIejK9Gc=; b=IKWY5IkjVX6DixvVUp4VpzU6FV
	5wEAvJ3CVPGBObKt76qvQpQHbD5W3ONTpXOYVUfUOmKjQ2jxmmwx8sU1IYhVjswMzqK0xKLGN8P0G
	bJsYX0OwSpP0Ltjyv5sUrvePtSPAbKA1n1NNn2R22tmaoM7nnMvFF1i1pDYHWHuVs7yFmboVZ9uRc
	h2fg6BzWHnkpKYat/RsoJr3aUIORsutU6HsGu28uImbfhz87Cn5jc7UcF0Tx8pZeojzYLG5EUKRl+
	N9EK3eOGBodaJomgXUHJnq1sB68GmnmtWaK5OTYK83oi0NaKljx/9NTO4lSMe37lswT6iOKVYjOlT
	aqNy2x+Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1twXkQ-009aBA-1K;
	Mon, 24 Mar 2025 10:41:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Mar 2025 10:41:06 +0800
Date: Mon, 24 Mar 2025 10:41:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Wojciech Ziemba <wojciech.ziemba@intel.com>,
	Randy Wright <rwright@hpe.com>
Subject: Re: [PATCH] crypto: qat - power up 4xxx device
Message-ID: <Z-DGQrhRj9niR9iZ@gondor.apana.org.au>
References: <20210916144541.56238-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916144541.56238-1-giovanni.cabiddu@intel.com>

Hi Giovanni:

On Thu, Sep 16, 2021 at 03:45:41PM +0100, Giovanni Cabiddu wrote:
>
> +static int adf_init_device(struct adf_accel_dev *accel_dev)
> +{
> +	void __iomem *addr;
> +	u32 status;
> +	u32 csr;
> +	int ret;
> +
> +	addr = (&GET_BARS(accel_dev)[ADF_4XXX_PMISC_BAR])->virt_addr;
> +
> +	/* Temporarily mask PM interrupt */
> +	csr = ADF_CSR_RD(addr, ADF_4XXX_ERRMSK2);
> +	csr |= ADF_4XXX_PM_SOU;
> +	ADF_CSR_WR(addr, ADF_4XXX_ERRMSK2, csr);
> +
> +	/* Set DRV_ACTIVE bit to power up the device */
> +	ADF_CSR_WR(addr, ADF_4XXX_PM_INTERRUPT, ADF_4XXX_PM_DRV_ACTIVE);
> +
> +	/* Poll status register to make sure the device is powered up */
> +	ret = read_poll_timeout(ADF_CSR_RD, status,
> +				status & ADF_4XXX_PM_INIT_STATE,
> +				ADF_4XXX_PM_POLL_DELAY_US,
> +				ADF_4XXX_PM_POLL_TIMEOUT_US, true, addr,
> +				ADF_4XXX_PM_STATUS);
> +	if (ret)
> +		dev_err(&GET_DEV(accel_dev), "Failed to power up the device\n");
> +
> +	return ret;
> +}

I just received a bug report that this printk is triggering on
a warm reboot via kexec:

https://issues.redhat.com/browse/RHEL-84366

[   11.040319] vpr089-p05-15u kernel: 4xxx 0000:01:00.0: Failed to power up the device
[   11.148557] vpr089-p05-15u kernel: 4xxx 0000:01:00.0: Failed to initialize device
[   11.148702] vpr089-p05-15u kernel: 4xxx 0000:01:00.0: Resetting device qat_dev0
[   11.148809] vpr089-p05-15u kernel: 4xxx 0000:01:00.0: probe with driver 4xxx failed with error -14

Could you please take a look at it?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
