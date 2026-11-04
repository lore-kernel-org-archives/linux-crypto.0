Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828187;
	b=X1Kb3by+JhDO2j+ccUG0rUraZ1dLQNladZ8xENciNTzZRL5SS02ZQg+3KQNJiWBDkhLe
	 QXqcu4WTCajNeo5ljee61iboTHiNYxs6lajAjzeBCjSSARjXCEW61t7VAuznm7e4E1KhH
	 oCx/DSbumORr6dY7FDLxivngNUTQKaemCx6l/egPcMmZ6VsQVEvr3W6sxAghJz2NBHsrS
	 hj4bHl17nC7xycH2I2icvskAD1hyrLAQLg7jpU/knCyzXPJtMYScRpygzMHITwulGElDS
	 izlVnWHzJl7sZahmhWPXmbsALt4l+xaoVaO67v+7kyBieRa7C4bgm1SI6k3cH2JZH0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828187;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:Organization;
	bh=S6Fl7SFlssMK8z7BFKvgvcuZU+aYYxnEAjFSgyi9yYU=;
	b=F3wA+8QzeHRMvYuBS9RQIeIZI3SwU4zw0F4sD+ive7wIJWNz4ynHHbxUt2/qxedERxSF
	 7DkfXAU3qb3CzhjvR7bPnD5g+Q6tVW1q0HHeTQAmQgLzqashrhyslWuHc73GvPgYKyhii
	 ryVXXx+zDL4nyn4LU6XhAFD1cJ6GQ+DRbdsAjub8Pm8owwF8byupVTLhPC4ablQt4G2Xh
	 F8AjkjL6V275pEm3H9Ioe0lT9+2uV124gfVX4agCOmyoDHGL/UU8r24SO2QyKlwLrVbsu
	 6SdRUSkf/GqvoQsK6amztxkKf2PEk3qecyZbdWCgEqUSrLLMmQaWylv7IdAVAt5mw7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ag9l0Plq;
	arc=none smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAC4606BA3A;
	Wed,  4 Nov 2026 21:36:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEAC4606BA3A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ag9l0Plq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793828181; x=1825364181;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2jDc0ScAesHiS9pWt0QyQGiSMKCUxOa06C0uLEtfp3g=;
  b=Ag9l0PlqxxDQh5VH8QKhSNlyg+uyW/CIGNrMu3Hwvegkr2LVBMdr9iF9
   G7o6nta/1++3tQZuxdvlz/MWFKXqRhffi0jFs65JXWvmB1S/MiYzj7aj3
   iVfo9ewOTWAcryI8JfM3VY2LaaNud3Pp19YzQ1ZxU7CfwoSa0TZwZHLnE
   2fv1gpx9vo4P0oBPlXzwq2wKRCPsnfJ4jRs+QLi1+M+QHvn9czmJ2A6s3
   tgtysSKwynPLDiHYalgaZ+f97SjTzKGcerm8W10d/9INvea26uvXBOxed
   Vy3KPMRawGuRJE3XLxl5DbCYplvuCpxluBcHP7f0TFtSbf/Z0lcYsa7M8
   A==;
X-CSE-ConnectionGUID: /n2wt3RWSHiQ+uPiEwsNxA==
X-CSE-MsgGUID: iEOc95p6SIiwctTdMQhglg==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2605600"
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="2605600"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 13:36:21 -0800
X-CSE-ConnectionGUID: y4HkVJ1FT/KFGnISVdi3Zg==
X-CSE-MsgGUID: stdznUwoSYiX9CzP1ljcOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="8606136"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.24])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 13:36:18 -0800
Date: Wed, 4 Nov 2026 23:36:15 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
Cc: Lee Jones <lee@kernel.org>, Chen-Yu Tsai <wens@kernel.org>,
	David Rhodes <david.rhodes@cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Zha Qipeng <qipeng.zha@intel.com>,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Thomas Richard <thomas.richard@bootlin.com>,
	Andy Shevchenko <andy@kernel.org>, mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mfd: intel-lpss-acpi: Use named initializers for
 acpi_device_id
Message-ID: <auulT6SLr7mRzsr-@ashevche-desk.local>
References: <20261104-acpi-mfd-v2-0-64b9dee3baaf@thegoodpenguin.co.uk>
 <20261104-acpi-mfd-v2-1-64b9dee3baaf@thegoodpenguin.co.uk>
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
In-Reply-To: <20261104-acpi-mfd-v2-1-64b9dee3baaf@thegoodpenguin.co.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Nov 04, 2026 at 04:09:30PM +0000, Pawel Zalewski wrote:
> Use a designated initializer for the acpi_device_id fields which makes the
> code more readable and consistent with how lists are initialized in the
> rest of the kernel code base.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


