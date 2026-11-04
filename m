Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828255;
	b=SaLQuvQ0lQL52aU8WKXBCMjjePUFUNSfc7rFymkQ9ditRu6PG0NnTuHZ31+aGdo/ox3y
	 nQhbYf+ij0T55GaVBv2vR5D2KAmyAu80czns06DpyLkQ7seYQOyhdLAsX7hsrZyQVjgqp
	 A3k3z+ugjTIfhJ0hsgmJrUY5UZfzr8sFuNneYOup7iEE5ObJJUX90pqcXftDXk9T3Rynn
	 WG18upJLf6jRW0ttSnn1GKtpuXy1OF9zg1pGpO/+CghGuQDjNGsj7qGFgB7kdDETcqQSz
	 ql9B0zq65IepPTSsJcnidQJbRfCNePEonojd4KH3wvjNCIUVbCvBvQ0x84L497GSqdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828255;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:Organization;
	bh=m7+UjEQlQkkKXo+SrGwhjslI4kiyxiy6gxcX9h/S7MQ=;
	b=SYukd1HPGsGw7KRPJLmPKqjwL2RpTp/nGbzVuh3puWTXTngrXModtPFtJd8X2NhXSKAS
	 z1rIzG2SmogGXV3P+NXNso2wXQrUkKPgftlNyCeal24otmV3Qu/w1P2m4o3oVH5e5Aqtn
	 QN4Eox7kB5/svya7RsrmK6SFUJP5JsRmS1dlfc23ckXTN8O7S5cHm0jnhN6xacUHKYWT6
	 eJoPKdyOnsrq5LkHPP/owbbi9QGoFjKWvJYzNCw8w+CFeMAdlvv9yR7t1fjd7xi8tUcf1
	 fJHabN4dUhzTt7R5pobYs/piZQqowf5sRJFPbc1464dplWGnkFAUKCHVgu05Z0rWWUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QwmX5T1D;
	arc=none smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252F6606D4F0;
	Wed,  4 Nov 2026 21:37:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 252F6606D4F0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QwmX5T1D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793828255; x=1825364255;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=46YglNF+8f6KFAaUBnNOh2wI7onYitDRzw1WALL9nd0=;
  b=QwmX5T1Dv3ex3DvY8lTjLJDgidT8I9B+oMtt0zTjmr16c0L1PO9fVp/J
   JEQ0zoI/N+G5gogAZsAEB3wuBTXvr4gsU7ZG2+kB4TNjweQEGppuBpCbp
   fcwMRDW6uxTe1otXPRDKr1bw8fEMuuXj0I+sLZU1nENnOwpGbw7LbkiDX
   OY/4p+L5C42uTm/wSXiNSb/+Hn27ipT4jOgntTp6VRqmg7eFNjzTqIj+2
   sFLktpEjxMXgs6di4pjLbkg33cn9tkKjzKRSmZBnWN52U+1WUPnKEc0UV
   XuaYFxCtxTbjf3Hbuo17bGrsoKYCbeYfuTVbYZke66zHzSeVJZvwIa5MC
   A==;
X-CSE-ConnectionGUID: x1fxgkMqQR2Fo8mwP3hPuQ==
X-CSE-MsgGUID: rOOT0I2eQwy2cT89ShHPyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2605688"
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="2605688"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 13:37:34 -0800
X-CSE-ConnectionGUID: LybouB71TeKSnPQ+sgtgIw==
X-CSE-MsgGUID: veFHshv/TgylCOraYFlGHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="8606258"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.24])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 13:37:31 -0800
Date: Wed, 4 Nov 2026 23:37:28 +0200
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
	patches@opensource.cirrus.com, linux-crypto@vger.kernel.org,
	Charles Keepax <ckeepax@opensource.cirrus.com>
Subject: Re: [PATCH v2 2/2] mfd: Use named initializers for acpi_device_id
Message-ID: <auulmL-HXdzcdM2V@ashevche-desk.local>
References: <20261104-acpi-mfd-v2-0-64b9dee3baaf@thegoodpenguin.co.uk>
 <20261104-acpi-mfd-v2-2-64b9dee3baaf@thegoodpenguin.co.uk>
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
In-Reply-To: <20261104-acpi-mfd-v2-2-64b9dee3baaf@thegoodpenguin.co.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Nov 04, 2026 at 04:09:31PM +0000, Pawel Zalewski wrote:
> Use a designated initializer for the acpi_device_id fields which makes the
> code more readable and consistent with how lists are initialized in the
> rest of the kernel code base. Also drop explicitly setting fields to 0
> where it is redundant.
> 
> Unify the list terminator to have a single space between the brackets and
> no trailing comma.

Haven't I given the tag for Intel PMIC drivers?

-- 
With Best Regards,
Andy Shevchenko


