Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794386758;
	b=QLpdENWaNtV0Ye7x1EzdfCNA67bf7AK5rk9UV7fS83RqGVjpmGDDxeRqHBUAsiAew06e
	 StUnb0azKyzBRLELP+kfcTXdrxPXdy2lpF1kxLjVcV16KMlIORrPBpx0Q0RkwsMRCSfxc
	 Mdd/29Oz03UkuqFnHuWKCaZgEZ7koOFFuqcqwD24apP+BYXOO4UG692lDlO2aE9jK8Z73
	 JUNTDKC7wMXB14lPWZV70dDm2QnaAuR/LcCsVPJLUp/xZLMsv+XxtAMNk4BBC996dV8ML
	 lI4dF6vQ4DIEoS+2LILho9Gd990XSEhZlpnf5SPbOMSo6IgJS+Jp3ZniA9E1zP6Donw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794386758;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To:
	 Organization;
	bh=kncqX4lw1YZwjRHTnWDSvhtRyCgunphnrbNs5+1f+kU=;
	b=V/FHB2QVD1jAi5xumiRRcsJqe4+M8epgzOMcgFRJjilZEW2yFMe8bIJMGza7SKFGq1pO
	 c1jywUqbCL1AIM3/cLYuXhrtSqauU6pXjhafQMbWljTIDWQKFhsjq0H6OcxOM8UUjsSJW
	 5DPsGBejxKOhtsJ4qLCmFwDhfcd527ZgvDyELZnI+8KBkmzcm9u0bqRa4I2tKeSdZqYOx
	 i9dIW4FiytMvs3QIDVcm+36jAytf9d7k2ZcSxJKn7jnl+Dnt6W1aNL5DNrVnDEJUgnloA
	 okEE6IEMuas/lkgQ7zZ86GwQjXECNYmU86riHngWnxkpPHrdGY/5kPcDJfOhx0I6ocw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=APXoZQdi;
	arc=none smtp.remote-ip=192.198.163.19
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4068F606A321;
	Wed, 11 Nov 2026 08:45:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4068F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=APXoZQdi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794386758; x=1825922758;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=WNu/MWKjEWQu9WGprrc9CixlEoX3UeLS/7xFqiNwO6Q=;
  b=APXoZQdicxD+Y1huqUvh58RugUL88W7af38kAg5rFALSscIQ1p0HZdbH
   vqwRVuBat3sjyU2RV60nMGFLp5lXIADtdY65IlY/keCrfoJn11UawRo9b
   xxIgWQEiI3ulHZcG+zefZ1hamVoJ9egPqijCWMnwZki43QT8p7ZF2kU84
   CtdhT0Sd087MKmAQweEFeEJBHOZYz6ReWg3PeMyJy2jh8ev5KPnCAfvAg
   fEBvkjl6zq60tzEP5FNVLNCykcc9X0QuVBLD2wfXdgn1Sdk9WuVZ/2br+
   3iRWBf5zy74JobsU7vLD3RyjgOwrBaAcKX8pqImoDT0rNBM2/wKPkG23m
   A==;
X-CSE-ConnectionGUID: RbN81DBGRXSWCHmY7itjAg==
X-CSE-MsgGUID: ZbDRzIbeR7i3XgryVATRBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11962"; a="3253972"
X-IronPort-AV: E=Sophos;i="6.27,207,1787036400"; 
   d="scan'208";a="3253972"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 00:45:57 -0800
X-CSE-ConnectionGUID: bUxqKsr9T7u440+wBy8DEQ==
X-CSE-MsgGUID: jZDWUL46SBCKWU1u1b0onA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,207,1787036400"; 
   d="scan'208";a="8702945"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.142])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 00:45:50 -0800
Date: Wed, 11 Nov 2026 10:45:47 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Lee Jones <lee@kernel.org>, David Rhodes <david.rhodes@cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Zha Qipeng <qipeng.zha@intel.com>,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Thomas Richard <thomas.richard@bootlin.com>,
	linux-sound@vger.kernel.org, patches@opensource.cirrus.com,
	mfd@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Linus Walleij <linusw@kernel.org>
Subject: Re: [PATCH v4 10/20] mfd: Use named initializers for acpi_device_id
 arrays
Message-ID: <avQrO4etMgpOhvwF@ashevche-desk.local>
References: <cover.1794347059.git.u.kleine-koenig@baylibre.com>
 <39fc883cf1c7077bce8f16719cca59060a395b02.1794347059.git.u.kleine-koenig@baylibre.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39fc883cf1c7077bce8f16719cca59060a395b02.1794347059.git.u.kleine-koenig@baylibre.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Nov 10, 2026 at 10:54:35PM +0100, Uwe Kleine-König (The Capable Hub) wrote:
> While being less compact, using named initializers allows to more easily
> see which members of the structs are assigned which value without having
> to lookup the declaration of the struct. And it's also more robust
> against changes to the struct definition.
> 
> The mentioned robustness is relevant for a planned change to struct
> acpi_device_id that replaces .driver_data by an anonymous union.
> 
> This patch doesn't modify the compiled arrays, only their representation
> in source form benefits.

I don't know who is the first, you, guys, collaborate together and come up with
a solution, but I have reviewed already this
https://lore.kernel.org/lkml/20261104-acpi-mfd-v2-0-64b9dee3baaf@thegoodpenguin.co.uk/

-- 
With Best Regards,
Andy Shevchenko


