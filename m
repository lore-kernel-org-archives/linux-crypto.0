Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07AE1C1ABE;
	Fri, 27 Sep 2024 18:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462747; cv=none; b=FgV1l4Ys2XlhBURG81IPPmeOsawOtkZPtrTO4Dji4p923GvPShiXCV3qnk8lXGUzj2kQG8/K20zvvAPL/7h47VFwk0PLr8MBv4iMCguXr1Pm90kL+WWk7dmMMIUUng1W9X48q/HWg9DgZrTZFqAWUkRAQTeCFjB/YClBqyShMgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462747; c=relaxed/simple;
	bh=OYbZ+I5NLmU+sIvkSBEim9uLXgOc9b3UgVRdmncdeXM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=s+r/+KX40ey4447jRWGlZQF8BlkZ7sMNO+13LIZYDtEqxs+iy2bBbOLJurrN5pcnQ41XllvxXXniQCmRnJQRuqHVl9KMPx76Y1sqdhDDwq4hIG1KzkibiFCu3tJHeOSOwGGygHcKzPdiR2mxuszjRuKkr12oVivTLI7x0hsAB6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=al1QNybg; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="al1QNybg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727462746; x=1758998746;
  h=message-id:date:mime-version:to:cc:from:subject:
   content-transfer-encoding;
  bh=OYbZ+I5NLmU+sIvkSBEim9uLXgOc9b3UgVRdmncdeXM=;
  b=al1QNybgSz8HrSzwkjDDks4Zj2PIu2xEi/kd32n/MO7XkyD59TDsEbRP
   dg3+3rhVf5BNWjdQbcKaAD2dTGjlozyc4XxfVOhzynVWzzAYXChCHnQm9
   Re3CdE8nYU6XQT4TWppNtKGfmeICY7kLk0L8yIvmkDtj2mrOK4eebrGCU
   pgBMghoOJ4CDbS2uCDN6Bdi6ivaHKrRJLKuP71UXe1TLi5enMEWaS+Nw/
   2WR1u0NH74pzgZ3T9e0dxGIOPx1wBU2hASqv+W6i/uAkHlO8GTkY+QfRX
   7mplKvz5Srnan0evGXUvyiwd1BZMCDpxoPV/KGDuzoGBleo8F1lzehNaB
   A==;
X-CSE-ConnectionGUID: AfPPgKmdSGauSMHyxfWigw==
X-CSE-MsgGUID: xm9wBO64Qy6rKt7qKoVoNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11208"; a="52033430"
X-IronPort-AV: E=Sophos;i="6.11,159,1725346800"; 
   d="scan'208";a="52033430"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 11:45:45 -0700
X-CSE-ConnectionGUID: 6/cnjpviQQOIqzF3kxGTGw==
X-CSE-MsgGUID: TW/Rjb3wROO8VZZXqWU+7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,159,1725346800"; 
   d="scan'208";a="72500964"
Received: from tzanussi-mobl4.amr.corp.intel.com (HELO [10.246.129.181]) ([10.246.129.181])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 11:45:44 -0700
Message-ID: <733a19ce-16f2-4d06-bce9-85d7473c9a4d@linux.intel.com>
Date: Fri, 27 Sep 2024 13:45:42 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
 linux-kernel <linux-kernel@vger.kernel.org>,
 "Accardi, Kristen C" <kristen.c.accardi@intel.com>, zanussi@kernel.org
From: "Zanussi, Tom" <tom.zanussi@linux.intel.com>
Subject: [PATCH 0/2] iaa_crypto bugfix and maintainer change
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Herbert,

The first patch here fixes a bug seen on some systems with broken IAA
hardware; it doesn't fix the hardware issue itself but exposes an
issue with trusting the hardware to either send a completion or
trigger a timeout - if neither happens, it shouldn't spin endlessly.

The second patch hands over iaa_crypto maintainership, since I'll be
retiring from Intel and won't have access to IAA hardware myself.

Thanks,

Tom

Tom Zanussi (2):
  crypto: iaa - Remove potential infinite loop in check_completion()
  MAINTAINERS: Make Kristen Accardi the IAA crypto driver maintainer

 MAINTAINERS                                |  2 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.38.1

