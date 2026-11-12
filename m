Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458519;
	b=P62j516bphTA8mffFw6xT+BqdQeqY1knMy274BbZvQAA9IcV/3huXNp+97bCzkBUOdyY
	 hhq+zaeg0gr3zGL2sdGHSslPpvJMl/GKeRfJc/CsuerVZwyG9A/OaQ6VjNvTzZH7kR+oi
	 ucT04c0FuMQR0+9z+DWXbJMJZ7LADVXnAhb7TypB/9J7955TRorcS/3gmtcpimcSkmRxo
	 zD1RFYsdz0rMriBeubwGpfd4rxIZN8oKfRVRvm0uQs6COxkZTR55srj7RuxiGjsgeAnpn
	 1XY0wfjlvrdk5/+C0DAN7m/RKqNg3zbmmfvkJtugfTDcpDb0SjRZZ1j+k1uOUpnfeVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458519;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=WBFaXiQf/AiU+Oy/oOiJP2JtXZtaF5fsy5mmLC1bpDA=;
	b=yPsdt7zcz16YdhwaF/KTXesncmVFRtPrX7gg6HFtoOQj/1Wbjvc3ZV4CiHVKFiCZp3JD
	 xBER7sz2twa+af2z9tZF67X2nb42MY96tRCqJWxGx7+8PAaNMTVRQZVUvz293gexjonsE
	 yPM5iQOVY7dzCecVr9K5oCqnA9PnRaKOAQB0qSmvsKucWt1kbH6CRy7qYqQ3Lxx/nwDM5
	 Hkfti6Fe7aiI8YSgxleJeab3ud8MgcLg/1LiT4Irbj7Kfalv/3SXTW5fk/KeRBiMcLnMF
	 HdxXK3wR9z6d6Qs/93GjABQji50fU39/Vwzs05gVcm8kjgK5X2MKsQ0WRdmte1x869A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=j0HYexEU;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D67606A321;
	Thu, 12 Nov 2026 04:41:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7D67606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=j0HYexEU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794458519; x=1825994519;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=to9WP0yYAsg2FwMUJoPAJl9KXn//Llym/25xqUG9m3o=;
  b=j0HYexEUv97gtHZ64HDRAPDkdXQSrCwRqokDMo4PofFUgp0aGVabSlR5
   FpHoBadUy7O2D3nY9+lMQo1ZDdydZjKs0BcTj5lB1Roe5Xgs1F64/3YDS
   yLosYWMo7SUad6SxxMCgoq9INuA1fWfIxkEjDt1sfNYlIsgOU2l+BrHMY
   fc1Z1qFPhRWld1yFH/oYJjmXk9ab+jqrB+Ysb2AExkPWZvhwsMaDKq9qJ
   rX0aPbqRaHFC9CYZDh8LADPMQArxF3PeRPvDrr7XKtUXG+BZq33cy30Uo
   XVFzHsBjPstV2oRL82QurujZsRR61qLMuXfm8enXEA//KFeQGj5uip2QA
   g==;
X-CSE-ConnectionGUID: b3+iCPGYTza/wsQiD6L7hQ==
X-CSE-MsgGUID: TZRE5MKMQ0SKpXvuv2osRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3112117"
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="3112117"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 20:41:58 -0800
X-CSE-ConnectionGUID: +omkRXtHQhGqp8nFWjl2Wg==
X-CSE-MsgGUID: PkOyTieZTVC7Yy4/j9hDKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="10451688"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 20:41:51 -0800
Date: Thu, 12 Nov 2026 05:41:48 +0100
From: Raag Jadav <raag.jadav@intel.com>
To: Pavel Popov <pavel.e.popov@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Arnd Bergmann <arnd@arndb.de>, Len Brown <lenb@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	"David S . Miller" <davem@davemloft.net>, x86@kernel.org,
	linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	platform-driver-x86@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject: Re: [PATCH 2/7] drm/i915: Include <asm/cpu_device_id.h>
 unconditionally
Message-ID: <avVDjIW5jd4rHw11@black.igk.intel.com>
References: <20261111234821.4814-1-pavel.e.popov@intel.com>
 <20261111234821.4814-3-pavel.e.popov@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111234821.4814-3-pavel.e.popov@intel.com>

Cc: Andy

On Wed, Nov 11, 2026 at 04:48:15PM -0700, Pavel Popov wrote:
> <asm/cpu_device_id.h> now has a generic version, so the #ifdef
> CONFIG_X86 around the include is no longer needed.
> 
> <asm/intel-family.h> is included by <asm/cpu_device_id.h>. The CPU
> match table still needs CONFIG_X86 for the INTEL_* model defines.
> 
> Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>

Reviewed-by: Raag Jadav <raag.jadav@intel.com>

> ---
> Depends on <asm-generic/cpu_device_id.h> from [1]; please apply after
> it is in mainline.
> 
> [1] https://lore.kernel.org/r/20261111234439.4098-1-pavel.e.popov@intel.com
> 
>  drivers/gpu/drm/i915/intel_cpu_info.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_cpu_info.c b/drivers/gpu/drm/i915/intel_cpu_info.c
> index e52d0ac713a..a6b46cc841a 100644
> --- a/drivers/gpu/drm/i915/intel_cpu_info.c
> +++ b/drivers/gpu/drm/i915/intel_cpu_info.c
> @@ -6,12 +6,11 @@
>   * intel_device_info.h by having a separate file.
>   */
>  
> +#include <asm/cpu_device_id.h>
> +
>  #include "intel_cpu_info.h"
>  
>  #ifdef CONFIG_X86
> -#include <asm/cpu_device_id.h>
> -#include <asm/intel-family.h>
> -
>  static const struct x86_cpu_id g8_cpu_ids[] = {
>  	X86_MATCH_VFM(INTEL_ALDERLAKE,		NULL),
>  	X86_MATCH_VFM(INTEL_ALDERLAKE_L,	NULL),
> -- 
> 2.54.0
> 
