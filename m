Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A6421A42B
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 22:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746051047; cv=none; b=WVKLr1dCdOm7kbKO/kgM06j1rzoWH+6ix0hbyBB/3enhvwEZyUXSrCTMmfLzce5pSv4ghJDOvfRWyk4tuWXQvjgtJqjeYiGsQJ09DBY3OTt8E7GbGSFaY2ShD+Vky6pGiMltKnb5S0l0lS/oO7PYUqJInK90wx4qVbAlgOt7XAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746051047; c=relaxed/simple;
	bh=D0gqaM5MI7QDV2nWuaX/nJxovRKweIrfNETOTmf8txI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VASgaSHO2xqqi60l8DkDxd5T736+fvU2nHzKQMzhg2qfn0tOZTV3UtBE84m7PeoLWKt6iFshxzuCPkbbWfqdU59h2PVgDD0QF9A9Eb7o5nMoO5jvAOMyTdHdDGc+jrJKb65b/qJ4+VxBEfquuEbHCSv2SaKTCC/HJe8PvxzyGD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y1A4Epg5; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y1A4Epg5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746051045; x=1777587045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D0gqaM5MI7QDV2nWuaX/nJxovRKweIrfNETOTmf8txI=;
  b=Y1A4Epg5cpAXU72vaRg4vPeKFi5Y2HfVITgSAbc60dUMN5D2ldWPjZ27
   gnVgi6Z6IxkoigPyuIqsQp5bUhPj7z6vGbS86EY7JwMD46Z9i0JcusB2d
   ew+MUqi1W0Dh+dT6E3nxjKlhDTdfY2u/80+eyzOtUDHt/KrAwXMdqVD+8
   eW2aLm5MkSuvhEdohO55cJMmcK0aaPykr93hd0LIYeqr7jnxEFVrwqfup
   p8yHE83Icr0ReQn5f7UEXo7K49IGHo3zMIp0C3t/fTwCEqtQBUYG85RBG
   lg9LDJzwMPp+B/qHdpsEs+dxSzI05EcToXSJbtqkrJKEX2gMNKmBO6O3G
   w==;
X-CSE-ConnectionGUID: m2qkq477Q2SH40dXTJ1uwg==
X-CSE-MsgGUID: R8FW+IlXTt+x6sVzBfMTew==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="59107785"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="59107785"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 15:10:44 -0700
X-CSE-ConnectionGUID: RK9KcG6bQkerTMK2W4yqcg==
X-CSE-MsgGUID: zhICuMhZQ9KOzV76Viwyew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="134543870"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa008.fm.intel.com with ESMTP; 30 Apr 2025 15:10:43 -0700
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: bigeasy@linutronix.de
Cc: kristen.c.accardi@intel.com,
	linux-crypto@vger.kernel.org,
	tglx@linutronix.de,
	vinicius.gomes@intel.com,
	wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: Re: [RFC] Looking at the IAA driver
Date: Wed, 30 Apr 2025 15:10:43 -0700
Message-Id: <20250430221043.23320-1-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250425151940.Bd_TKH82@linutronix.de>
References: <20250425151940.Bd_TKH82@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Sebastian,

I have been making significant changes to the iaa_crypto driver as part
of the "zswap compression batching" patch-series [1]. In particular, you
may want to review patch 6 ("crypto: iaa - New architecture for IAA
device WQ comp/decomp usage & core mapping.") of this series [2]. This
is a refinement of some re-architecting of the iaa_crypto driver that I
have been posting since v1 of [1] in Oct'24.

[1]  https://patchwork.kernel.org/project/linux-mm/list/?series=958654
[2]  https://patchwork.kernel.org/project/linux-mm/patch/20250430205305.22844-7-kanchana.p.sridhar@intel.com/


Thanks,
Kanchana
