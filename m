Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D661E51FE
	for <linux-crypto@vger.kernel.org>; Sun, 27 Jul 2025 12:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753620241; cv=none; b=BYiYqjwEZCiezWuwDXTdyZquWQ2+otnI3ZzLndHoM9vNQ2hagwGiTH/Jm9TTY268c253Vg+h124VNHd+VasUvffNimZpvTHklLpvY43bWs4FLHu9+O/h6xI4zwfVNSlVBizMyu3Jt2VhO4IOmX/0c9qNpwlVFPfjMTgXdcxXof4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753620241; c=relaxed/simple;
	bh=bRQ7K9emn64OWOhxAnOE8QbeCrKgoTxnrIe5M6p/JWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ulVncXxO0yA4XtWwwBO7r6lhAozcqvbraq0hPt368dfSIgXQTUMILq0jYLEygHOjnWIfbQrz0H8qr4L0WX69y41xjYuJRfS2Kqn6SeAPaTc/2xck5S+TzqUjeu/P80pbBo/iPQFURwrKIiqraPbO19Jhja62PeZC0Gt9bxsh2OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OEIXShAc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OEIXShAc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ntSuMYRzWQmm/ffbTWGukWs61STa7KuZJEyyq2skvnY=; b=OEIXShAcbZ18hYVi7vPUhIgJFL
	UjwkUWcT0KdVo+kWuEZHpLmojpkMOGoN/w5ci183UGbg/Ywd8JVbPDpA/joitsI8eRjKw12twUhAv
	Xqh7Nm/CzwwF9pAK8Caq5o4n0gGpra90TaRsAmynEGpfttZHTrzXpTRkTZWOH03BFjdG25ESiCPF8
	eM+RwB0A+CkLGG4ofq5447RUEaadoknkBIGfd7insnH5UxqfgCw1mAwsgMc5GdkxjAvF6D/C+PnRd
	Zy7fDucXvcsZXwDL+avOhWfyfZi6akkiNMIYAXoL3/CjIX9kDP9OPRsu1viLs8Wr+NySuJxy0Em8X
	eCEyIxUA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ug0Ts-00A4sC-0N;
	Sun, 27 Jul 2025 20:43:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Jul 2025 20:43:52 +0800
Date: Sun, 27 Jul 2025 20:43:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: Re: [PATCH] crypto: qat - fix DMA direction for compression on GEN2
 devices
Message-ID: <aIYfCFFZhPZghFY-@gondor.apana.org.au>
References: <20250714070806.5694-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714070806.5694-1-giovanni.cabiddu@intel.com>

On Mon, Jul 14, 2025 at 08:07:49AM +0100, Giovanni Cabiddu wrote:
> QAT devices perform an additional integrity check during compression by
> decompressing the output. Starting from QAT GEN4, this verification is
> done in-line by the hardware. However, on GEN2 devices, the hardware
> reads back the compressed output from the destination buffer and performs
> a decompression operation using it as the source.
> 
> In the current QAT driver, destination buffers are always marked as
> write-only. This is incorrect for QAT GEN2 compression, where the buffer
> is also read during verification. Since commit 6f5dc7658094
> ("iommu/vt-d: Restore WO permissions on second-level paging entries"),
> merged in v6.16-rc1, write-only permissions are strictly enforced, leading
> to DMAR errors when using QAT GEN2 devices for compression, if VT-d is
> enabled.
> 
> Mark the destination buffers as DMA_BIDIRECTIONAL. This ensures
> compatibility with GEN2 devices, even though it is not required for
> QAT GEN4 and later.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Fixes: cf5bb835b7c8 ("crypto: qat - fix DMA transfer direction")
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_bl.c          | 6 +++---
>  drivers/crypto/intel/qat/qat_common/qat_compression.c | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
