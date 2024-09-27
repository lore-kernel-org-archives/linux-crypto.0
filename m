Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8BF1C230D;
	Fri, 27 Sep 2024 18:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462958; cv=none; b=WvLbhkOx8IVW46GBiMOe+FwxZsW8NEJJi44oDsIl0SNCdK1Yvqgm9i1kycPSnxApTvO6PWt82nOgrrxJsokzq953iqU7F2BaOwoudghb/RBNQtKfM2woCgwWfySz1aEjvqNP750jFH2PitTQSB+RffXONi3LmMxEk6CelsYfYX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462958; c=relaxed/simple;
	bh=y/7cSwxsNP5gG8rsS+LqL1ZWq68q/juRgwY4ok3wZVs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=uMeN7nPgKykN8CQ2+ooXh6C6n2CGignYnEszUTOTJ8RH4Fyr1G3nvfOQMOw5FQ2WP3dg4xDPJqGypnt+ii+b3XwjrJTUIt7v9tNg/C4psIIYq9DKnGQGCO1zsWPdVCc9kIYShc5/01mvWzLCWzHItxokSNfH04JEPERElfmic7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cez9ZeDw; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cez9ZeDw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727462956; x=1758998956;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=y/7cSwxsNP5gG8rsS+LqL1ZWq68q/juRgwY4ok3wZVs=;
  b=Cez9ZeDwQr15mfwmS7ub3wtt2itI9gNYzxsSAE5YN9vurfd4oQw9L5QX
   DdpWNTK+pL7UUu6+JblcP/gZxsf2tWfhukcTFNZnAPcgIt4a7jAonACjH
   5CR8Cts7dkyzH1yZSno6zL+csSK4SIgFOE2LeuqHG3fgaYkReCj5cMyHz
   VEznh7j3XdXa4TflxdXoGyWpTEvlus9kWaKAT//ZiZGZ5Lqh+QuPe2E5C
   QdpkxAI3vgxNIinyL2S02JrLeqaVI0Q0C8kJaESs1Ad1yU8xOQr8/IUHe
   idcr7HSd3fz4nQDaH6AbDkMjpSoASp6MHyfHKOuUAkm7SfBq4ijAgws7b
   g==;
X-CSE-ConnectionGUID: AZ85WXwtRQG0DeZ45EdovA==
X-CSE-MsgGUID: mhqtoshnR/OF84taf+84GA==
X-IronPort-AV: E=McAfee;i="6700,10204,11208"; a="49144479"
X-IronPort-AV: E=Sophos;i="6.11,159,1725346800"; 
   d="scan'208";a="49144479"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 11:47:58 -0700
X-CSE-ConnectionGUID: 7Q1/PQMATFOXD5E9wYaQ0g==
X-CSE-MsgGUID: fXhCSlRqRn+GPhKo/AlG3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,159,1725346800"; 
   d="scan'208";a="103427647"
Received: from tzanussi-mobl4.amr.corp.intel.com (HELO [10.246.129.181]) ([10.246.129.181])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 11:47:56 -0700
Message-ID: <9afce713-db32-487b-b79e-3b294500d8d4@linux.intel.com>
Date: Fri, 27 Sep 2024 13:47:55 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 2/2] MAINTAINERS: Make Kristen Accardi the IAA crypto driver
 maintainer
Content-Language: en-GB
From: "Zanussi, Tom" <tom.zanussi@linux.intel.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
 linux-kernel <linux-kernel@vger.kernel.org>,
 "Accardi, Kristen C" <kristen.c.accardi@intel.com>, zanussi@kernel.org
References: <733a19ce-16f2-4d06-bce9-85d7473c9a4d@linux.intel.com>
In-Reply-To: <733a19ce-16f2-4d06-bce9-85d7473c9a4d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Since I'll be retiring from Intel and will no longer have access to
hardware, Kristen Accardi will be taking over as the iaa_crypto
maintainer.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a0b4c1210e92..b89c21ff2bc8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11300,7 +11300,7 @@ Q:	https://patchwork.kernel.org/project/linux-dmaengine/list/
 F:	drivers/dma/ioat*
 
 INTEL IAA CRYPTO DRIVER
-M:	Tom Zanussi <tom.zanussi@linux.intel.com>
+M:	Kristen Accardi <kristen.c.accardi@intel.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	Documentation/driver-api/crypto/iaa/iaa-crypto.rst
-- 
2.38.1


