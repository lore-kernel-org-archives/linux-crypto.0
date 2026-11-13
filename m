Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794605654;
	b=XP++pAfFs/UPfZMnCUZQWRM44eEhns5cuzQAYM6wizdB9toFpScqsMJzKnWCVZ6NcCCc
	 P8d/Jhm4+0eFPbdCxwQ1cfdrW0z6fgomH7E6KrA1eVCBaX/0mpwwboco49Qqgn2NHqCJy
	 YvCm1GpqsvGft2nYhvru4WXgHNXwZT7xyAJsfrSpsM+BzJqzA3vc+Cj9re3rf4fHAHRk9
	 Rb6Kpv7JZb1Hi4JwXvTni70o4n7A6ymx8CQ9ykdGyuZ39KbxBwGLkscrFVc6SDqTBwqt8
	 CTmWviXQygP6A97Tg0D8+0Wffit8AkzpxUJUb4TfUyFd1H/aTuQ9RPrq85jYuGCFCYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794605654;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:
	 Organization:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=AfGkZPNe0g6Nw9LmU0I8+cKHSNqAZxOuxjNAJhbRjIw=;
	b=YxUGlg/z+qtCv9p6G8BUQ/FdWHYZuS17M2ghE/Kxv8w2XKSJuH4wpBpjsIBDGoqxA5DJ
	 MfU4+348KLpVWBV/eIRrmgw4+EALSBvYEd8V6Nsk5Oyq5Vn19ZoGkiioaI5WFPij1B1Vi
	 N6d7g76uGz4xyL7Uj/acwZ8kZzfWGfv9713rskEwfmLLOPpFMC16rvGSDknoC6UbPQsC9
	 5QAUEB9tKKoIUJGNdDud7OL3VH1UpAJrdB3E9fxUoUndl9Iq4bETbj/ocIB9RyMB1qYIm
	 AZycvSE/AfWdagROzta9+TtOBd3wb9aZksGe7XuQUWiuJUau/I5bzQ+5lTyc3a8xefA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kVy3Le0q;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476AC606A889;
	Fri, 13 Nov 2026 21:34:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 476AC606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kVy3Le0q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794605653; x=1826141653;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5H18aAry4/GXJ6hd2/WDeC5xY+R/z+QH0pzgy9iRGOQ=;
  b=kVy3Le0qh2EnrkBBmHiVtyIxrqVoNnkk+N3X68mUvHqQAdjH1TgoEeu4
   YezJ6Je3WUz4UTzDkJlEItV+T9g7xjmRvRy0p4zAPFXA58LjXy++h97wp
   c1NKsKoxDt+P4KfbUjs10cT0NlClEMmuGfl5solZxem/2E0uMWEgWjyeq
   fTs+eYj2rSpo8UJdNuNTEFC2yUHdLmqSeg2s92ftTlDy+X9CbOYErUFmM
   RvHfpTs7QrrKeb6Hi5L2oUUN3YigiE/IPBPdUkNvSxK6blmkhCpITAPXk
   gMnpM1D0jBhZp5/adF1341hufASYfnkKgCJBMB8MudlN5bTLm4zvXrLsO
   Q==;
X-CSE-ConnectionGUID: jA+ZCfHoSPaWk2BfJA6oSw==
X-CSE-MsgGUID: Ln2bkXw/SAS5VY9O2fUYnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3410644"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3410644"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 13:34:13 -0800
X-CSE-ConnectionGUID: 5uaN0zGOSKClUoi4WnQggg==
X-CSE-MsgGUID: v1L1tUjtRSSjwXDnysT+fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="8829869"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.245.244.254])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 13:34:06 -0800
Received: from kekkonen.localdomain (localhost [IPv6:::1])
	by kekkonen.fi.intel.com (Postfix) with SMTP id 5F3FB11F7E7;
	Fri, 13 Nov 2026 23:34:07 +0200 (EET)
Date: Fri, 13 Nov 2026 23:34:07 +0200
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo
From: Sakari Ailus <sakari.ailus@linux.intel.com>
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
	Jason Gunthorpe <jgg@ziepe.ca>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	"David S . Miller" <davem@davemloft.net>, x86@kernel.org,
	linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	platform-driver-x86@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] ACPI: mipi-disco-img: Include <asm/cpu_device_id.h>
 unconditionally
Message-ID: <aveCT1hwhMcJ_Efm@kekkonen.localdomain>
References: <20261111234821.4814-1-pavel.e.popov@intel.com>
 <20261111234821.4814-2-pavel.e.popov@intel.com>
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
In-Reply-To: <20261111234821.4814-2-pavel.e.popov@intel.com>

On Wed, Nov 11, 2026 at 04:48:14PM -0700, Pavel Popov wrote:
> <asm/cpu_device_id.h> now has a generic version, so the #ifdef
> CONFIG_X86 around the include is no longer needed.
> 
> <asm/intel-family.h> is included by <asm/cpu_device_id.h>. The CPU
> match table still needs CONFIG_X86 for the INTEL_* model defines.
> 
> Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
