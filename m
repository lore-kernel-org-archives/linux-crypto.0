Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B680238D42;
	Sat, 30 Aug 2025 08:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756544009; cv=none; b=W6oDKmWZbUIlBiKlVthOywyo5dJFmKUvSQzoErJHyozc7qqRjuQ016LXH4QhjK/3VKMgM5UFFLMaACwMRA8BISUopmIKC+ZW0IMo8l5/E72SwA5QG6AyYH4n3/aRJXCAIYOlNU/GP+gvhsWGvOqEXyVECSyETAFHLSNoTlkENbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756544009; c=relaxed/simple;
	bh=cHFd4LwVyQ3i2Qr99V7e91jSmAE9fUkWLBu3dK+cOh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2v4QXi34kx7B2gSTIUSyGKxmUGQ3UlIVfd1oVx/BQ5z/teM8mwnR7aGIBiDWEuvoh+vIuGe3i0Odu/Vrxs32BmB85o1I9CC/auZ63aHokp7WrOXI6AmCPZR2IjBIW2xGQS8IjW1rVe/bNVwonxpVJHqiVOpOz/H536kkH56umQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=evE+u03S; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="evE+u03S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1hBJ+y7BTZuBwDX5FrIGMICXQkoBbJdFjwvnRG08DFY=; b=evE+u03SNhapXMLJOV+jJYrf9o
	NhUonEMOb9Tt4q+RyyHtE3beePAZaHZfFxRCiYqavJgl870KtSOeTMjyxnKGNmVnOvWJ5JZgCXUU6
	MLwemXeUNC6ocafDI6dT3+h66GgVi9NBHtMHQfagZ9KvzyJk+DDJJT2IwX5S/LodLaNpPXzjGMIVB
	TrXYtui8R3E0W7Uty8MLXWF0VsnpjWUMICzgVCAj2PlkGvUANIMS1JIi1jrq5w+FJodiXhz1uBQQ7
	7MDtEcyO9hEkM4hbPf31aQjZX0K69KXFmyftiPikZvo74fLdM9lPOeNggrlpaWdFkvcL+gQYfwXbn
	FXVFdw8Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usH5S-0017Eh-1z;
	Sat, 30 Aug 2025 16:53:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:53:22 +0800
Date: Sat, 30 Aug 2025 16:53:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linuxarm@openeuler.org,
	liulongfang@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com,
	yinzhushuai@huawei.com
Subject: Re: [PATCH v2 0/6] crypto: hisilicon - enhancements and fixes for
 device reset and configuration
Message-ID: <aLK8AorGGwAE78KL@gondor.apana.org.au>
References: <20250821013809.4016506-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821013809.4016506-1-huangchenghai2@huawei.com>

On Thu, Aug 21, 2025 at 09:38:03AM +0800, Chenghai Huang wrote:
> 1.Cleanup performance mode configuration function, this register
> which do not require read-back verification.
> 2.The configuration of each modules need to be restored after
> device reset.
> 3.Add a check for the sva status before resetting.
> 4.Check if the input parameters match the device PF.
> 5.Register reserved interrupt for virtual function to avoid
> Warnings with GICv4 and VF passthrough.
> 6.Repair a hardware register, otherwise the stream mode LZ77
> algorithm will be affected.
> 
> V1: https://lore.kernel.org/all/20250816102834.828655-1-huangchenghai2@huawei.com/
> Updates:
> - Move hisi_zip_open_sva_prefetch() to hpre_set_user_domain_and_cache().
> - Swap the order of patch1 and patch2.
> 
> Chenghai Huang (3):
>   crypto: hisilicon/zip - remove unnecessary validation for
>     high-performance mode configurations
>   crypto: hisilicon - re-enable address prefetch after device resuming
>   crypto: hisilicon/zip - enable literal length in stream mode
>     compression
> 
> Weili Qian (2):
>   crypto: hisilicon - check the sva module status while enabling or
>     disabling address prefetch
>   crypto: hisilicon/qm - request reserved interrupt for virtual function
> 
> Zhushuai Yin (1):
>   crypto: hisilicon/qm - check whether the input function and PF are on
>     the same device
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c |  66 +++++++++---
>  drivers/crypto/hisilicon/qm.c             |  45 ++++++--
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 126 +++++++++++++++-------
>  drivers/crypto/hisilicon/zip/zip_main.c   | 112 ++++++++++++++-----
>  4 files changed, 260 insertions(+), 89 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
