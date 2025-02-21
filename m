Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACADF1FAC46
	for <linux-crypto@vger.kernel.org>; Fri, 21 Feb 2025 09:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740129965; cv=none; b=C2r8mw54xkUU3KIjpG8I18D09Qs5GOTDhd1Y1b39WixsSduYaT8o/eLIiUgce5Oxz90Y30h3HM2xLh2mW477RTuUTqpKbwpRecpi+nGiMphAoH56HwtV1MpwmNDnW/UwTOkuJlqjiFOhxLW4kEStBO808PxPVWP7NGBNQlp+czw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740129965; c=relaxed/simple;
	bh=O71XCnqv03JhVcSf79Pc/SpZLW1qQ+MbP3HBDuqn4VA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RU20gHDAI3xEs3W7WXQ8lIsuqZ89pujHW6XVjxEy1cxBU6iAHF2xsRoG37mWXZCVrH7jF/mXr+kmyzlK6xSr+hZ1LvguTRaEfA5egtN2j31EiDHOXn+IMf+rtvoWy/xtH+Ns1GApFcnnP+jxFEc7ACqYbdef76GtLxeXOdG6+EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NgOYeJBT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NgOYeJBT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DL97NinnC0WRYLm9ZBtlYlMALjf3d7ydlWtbQYxFFYY=; b=NgOYeJBTRCyZnDIXmwvrrLwaXB
	LTt5IDdpHKkN9EYvcxJbsyq6nSvay4teEx6uidORQK1RXqkR81ta4UhJ/PGjX2clxklYo3HkKFjou
	508POr1j9a6bkS1ZGtaq64rO5agdT0to33OEENHQTzVbthvjC8DXm7Y+8wiLWXztJFaE+YdyIOylr
	0EClYHBI1yOI15Nzz7vMB0VQD7cHvyqjoVBjMzrhOlFrF7T5rrQ/OTpR0Gh+pXLsbecbBc5+sVBq9
	4qy5r3S/tifs029Ad3KDT/woxxE7pXniOwU03udtBgxvCDNONXVE2E8RWE3G0wGZhEtmKX1wiyL/o
	qsGhO81w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlPIF-000YQh-2R;
	Fri, 21 Feb 2025 17:26:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Feb 2025 17:25:59 +0800
Date: Fri, 21 Feb 2025 17:25:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, andriy.shevchenko@intel.com,
	qat-linux@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - refactor service parsing logic
Message-ID: <Z7hGp3euROKvFo_b@gondor.apana.org.au>
References: <20250214164855.64851-2-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250214164855.64851-2-giovanni.cabiddu@intel.com>

On Fri, Feb 14, 2025 at 04:40:41PM +0000, Giovanni Cabiddu wrote:
> This small series refactors the service parsing logic in the QAT driver
> by replacing hard-coded service strings with a more flexible approach.
> 
> The first patch removes an unnecessary export. The second patch reworks
> the service parsing logic to allow being extended in future.
> 
> Giovanni Cabiddu (1):
>   crypto: qat - do not export adf_cfg_services
> 
> Małgorzata Mielnik (1):
>   crypto: qat - refactor service parsing logic
> 
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |  16 +-
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  11 +-
>  .../intel/qat/qat_common/adf_accel_devices.h  |   1 +
>  .../intel/qat/qat_common/adf_cfg_services.c   | 167 +++++++++++++++---
>  .../intel/qat/qat_common/adf_cfg_services.h   |  26 ++-
>  .../intel/qat/qat_common/adf_cfg_strings.h    |   6 +-
>  .../intel/qat/qat_common/adf_gen4_config.c    |  15 +-
>  .../intel/qat/qat_common/adf_gen4_hw_data.c   |  26 ++-
>  .../intel/qat/qat_common/adf_gen4_hw_data.h   |   1 +
>  .../crypto/intel/qat/qat_common/adf_sysfs.c   |  12 +-
>  10 files changed, 202 insertions(+), 79 deletions(-)
> 
> -- 
> 2.48.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
