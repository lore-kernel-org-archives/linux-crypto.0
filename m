Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E03189B84
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 12:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779453007; cv=none; b=KgrnRJarF9yR2W2lbbmvZdJ6TnfGspinB6QGPFnTOH9RUb/Xmzza9Rn8gsRh/C3lrulCcMvW3EyU+ME2VFcLVLJfDs+F+CVHy47p/XEJUTG3qdtlrLN3ewKsd16MW+A7OdFzXhhQoo27bzoRQGWxjmR/B7dkqBA2WVHzVD+6lMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779453007; c=relaxed/simple;
	bh=BCgA4gQY5eNkA+b3Sqabwy3bCl7Ae7TKKYfADjKby78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aTfWeQwFYaaEIQwcGSio5PU51W+VuwPB0xWRqiMLPjkdnouxoLZsvYxcrPEp/eNjeGBzPhmXzUJqIY/yA1PyXAX2eT1X0RfTOv26ldfHl4wTmU85i6ngkTZZn5Y4nk7F+C86AzlleLz/McY3x2ghQEtHqsQ6xdKsENOxXY5FVrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=nnOdBpXx; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="nnOdBpXx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xaN+pb91onNl5bDsA4aeipJAreTaHiXErkQ3i5GPWQI=; 
	b=nnOdBpXxyIOmuS5W2rlIGQWGSFm3sxgOY4ATnKDwvaazzmqUgUtFCfyBbHKiLwTew5PIkea5pv3
	Xd74UMgvp7XD8Z3Ez2UMrQ+GkSvOz36DcMqzd5wIiCnVGo6r43L+1Osd8G+minG623tYrVTLD620O
	GfStLhG9sVRZmP29xnb7mVJXtCht16/aROrd6tunAYjO/XJ07cNvoPRSgvYzk4i3q3Q3CSQY1cQjD
	ROCoAlhNVqFD2DPRPicvQVOsPQhJPDYgk3Ge7EfZinCJ9FdqO0OAPAkTKHI+2evG0BJnclFmM8Hre
	7SenBdfS+oLEb8LqCRV+KB2O9G4HFPrKNBGQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP0s-00GSNh-1d;
	Fri, 22 May 2026 20:30:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:30:02 +0800
Date: Fri, 22 May 2026 20:30:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/6] crypto: qat - add sysfs PCI reset support for QAT
 devices
Message-ID: <ahBMSqU--A975Oxu@gondor.apana.org.au>
References: <cover.1778685152.git.ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1778685152.git.ahsan.atta@intel.com>

On Wed, May 13, 2026 at 05:16:53PM +0200, Ahsan Atta wrote:
> A PCI reset triggered through sysfs (/sys/bus/pci/devices/.../reset)
> leaves QAT devices in an unusable state because the driver has never
> implemented the reset_prepare() and reset_done() callbacks. The reset
> proceeds without quiescing the device or restoring it afterward. This
> series adds the missing sysfs reset support and fixes the deadlocks,
> state-management issues, and corner cases that surface when the reset
> path is actually exercised.
> 
> Note on stable backport:
> Since this support was entirely absent rather than broken by a specific
> commit, there is no individual Fixes tag that can be cited. We believe
> this series warrants inclusion in stable to allow users to perform
> standard PCI resets on QAT devices without rendering them
> non-functional. We will need to revisit/retest when doing the backport
> as the PCI core may have changed.
> 
> In summary:
> Patch #1: Skip VF disable and enable during device restart when the VF
> topology is already present. This avoids lock-order issues in PCI
> reset callbacks while keeping VF quiesce notification intact.
> 
> Patch #2: Move fatal error notification earlier in the AER path. This
> ensures subsystems and VFs are informed as soon as fatal error handling
> begins.
> 
> Patch #3: Centralize PCI bus-master enable into a single init path.
> Remove scattered pci_set_master()/pci_clear_master() calls so BME
> state is deterministic across reset flows.
> 
> Patch #4: Skip the shutdown and restart flow for devices that were
> already administratively down before PCI reset. PCI state is still
> restored, but the device remains down as expected.
> 
> Patch #5: Factor the common AER shutdown and recovery sequences into
> reset_prepare() and reset_done() helpers to simplify the reset path
> and prepare it for reuse.
> 
> Patch #6: Hook reset_prepare() and reset_done() into the QAT PCI error
> handler. This makes sysfs-triggered PCI reset follow the same quiesce
> and recovery flow as AER reset.
> 
> Ahsan Atta (6):
>   crypto: qat - keep VFs enabled during reset
>   crypto: qat - notify fatal error before AER reset preparation
>   crypto: qat - centralize bus master enable
>   crypto: qat - skip restart for down devices
>   crypto: qat - factor out AER reset helpers
>   crypto: qat - handle sysfs-triggered reset callbacks
> 
>  drivers/crypto/intel/qat/qat_420xx/adf_drv.c  |   2 -
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |   2 -
>  drivers/crypto/intel/qat/qat_6xxx/adf_drv.c   |   2 -
>  drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c  |   1 -
>  .../crypto/intel/qat/qat_c3xxxvf/adf_drv.c    |   1 -
>  drivers/crypto/intel/qat/qat_c62x/adf_drv.c   |   1 -
>  drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c |   1 -
>  drivers/crypto/intel/qat/qat_common/adf_aer.c | 102 +++++++++++++-----
>  .../intel/qat/qat_common/adf_common_drv.h     |   1 +
>  .../crypto/intel/qat/qat_common/adf_init.c    |   2 +
>  .../crypto/intel/qat/qat_common/adf_sriov.c   |  12 ++-
>  .../crypto/intel/qat/qat_dh895xcc/adf_drv.c   |   1 -
>  .../crypto/intel/qat/qat_dh895xccvf/adf_drv.c |   1 -
>  13 files changed, 87 insertions(+), 42 deletions(-)
> 
> 
> base-commit: 6a69430dcc874c47fe5a25b70d87861c1cc9c0d8
> -- 
> 2.45.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
