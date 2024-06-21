Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE19F1534E8;
	Fri, 21 Jun 2024 12:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718972950; cv=none; b=COriNnPFObk0389uD/WxhQB0ObMrZNh5FyAKDhDHkGSKwvTX4tJEpT/1pucWa7u4BpjCjp8+vI1e4Pxd6lw7gpEsYbuNHNPt/ZBKixaQnlk84VxG69++FZUVeeXRtWWbYBFn22OR5SLgf2sUuurFet1m1IBwPcJDHcAt7tJJWtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718972950; c=relaxed/simple;
	bh=XzQqElddduEUupZUPqXe2PBUtkb4x+yCw+Lda9yPS/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sactUeRHXwf7vMvL/gfEOxeamcgR9oJhHItPFvnFTbk8HK1DpDgfCfaicus97RMcQobnuShe02SfqHT+HM/8wWfq+ofp5II+nZh9QTXzrH4XVi9g21xBQ2w9ffNCos5JoNztxMa/hm0zy2Gggfpe4JV/NqrOjvamt6EbNXDo0l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sKdNU-002egk-1h;
	Fri, 21 Jun 2024 22:28:29 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Jun 2024 22:28:29 +1000
Date: Fri, 21 Jun 2024 22:28:29 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Xin Zeng <xin.zeng@intel.com>
Cc: alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
	arnd@arndb.de, linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	qat-linux@intel.com
Subject: Re: [PATCH] crypto: qat - fix linking errors when PCI_IOV is disabled
Message-ID: <ZnVx7RaLAP66L3MV@gondor.apana.org.au>
References: <20240610143756.2031626-1-xin.zeng@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610143756.2031626-1-xin.zeng@intel.com>

On Mon, Jun 10, 2024 at 10:37:56PM +0800, Xin Zeng wrote:
> When CONFIG_PCI_IOV=n, the build of the QAT vfio pci variant driver
> fails reporting the following linking errors:
> 
>     ERROR: modpost: "qat_vfmig_open" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_resume" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_save_state" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_suspend" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_load_state" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_reset" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_save_setup" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_destroy" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_close" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     ERROR: modpost: "qat_vfmig_cleanup" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
>     WARNING: modpost: suppressed 1 unresolved symbol warnings because there were too many)
> 
> Make live migration helpers provided by QAT PF driver always available
> even if CONFIG_PCI_IOV is not selected. This does not cause any side
> effect.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Closes: https://lore.kernel.org/lkml/20240607153406.60355e6c.alex.williamson@redhat.com/T/
> Fixes: bb208810b1ab ("vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV VF devices")
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/Makefile | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
