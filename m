Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7FA33B6F8
	for <linux-crypto@vger.kernel.org>; Thu, 29 Jan 2026 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769704121; cv=none; b=ccdoQ5r1ybDplqJv0K8cJ8ljxriSS6xwnrB62dm6Le3fr16QNPeN2JAvVE2tnVbcMOodDU03hW53Bxkl+NqAI+1smBoi4PXyH5XlXf0nh+yt2wfu0ho9pSa82ONagDruAr8REtgsOREbA/kSHAVgahASyj1Ly3Gfe03LEI2T7c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769704121; c=relaxed/simple;
	bh=bg0nB5zJz+oUF/2yWzv6OLnyjcs2iI23Y2/WofTkQOY=;
	h=Message-ID:Date:MIME-Version:From:To:CC:Subject:Content-Type; b=JpnholJkGQnBr9l20n6NyII2f2DIpXav44QabatHnaHI35OuBWhCGwmVQ3XTGfHTQ3BFrHBWh7Lx6U4aGHXoZRvb7BzrdLLHjMTf6X7sWATLbPeftAIxfWbpIYaaTWKjekUgE4rAnqpwQMh9FnJy16qoKDFtP7f799/zoLQ2edc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=Q8oNaXQy; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="Q8oNaXQy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1769704120; x=1801240120;
  h=message-id:date:mime-version:from:to:cc:subject:
   content-transfer-encoding;
  bh=bg0nB5zJz+oUF/2yWzv6OLnyjcs2iI23Y2/WofTkQOY=;
  b=Q8oNaXQySIWjcVsRJTg6QO8qXNqtixE9c503p6Qwwnrv1GNBKu6SOJCN
   MCwmEWQeAqW5C+NueqZZ4+TPMXoDpGmkFUlrTitI0gKS4ixACFUY8BqHX
   e4xM6qt0afSNlRNdZPGRVMZd/FP7ZkTes36FE9zwAOOqR0uxhQAb4pAJp
   IPpdj2vlt6SSWFVvNd5bKkj6ERWCulzGQxd1wT5rrXN9MrpdtNUtilh96
   ds2Dj38yGhdzLPQ2IhLu2elHILUQUNomhK8phiOOSQH42LkUg/krn3jWO
   s9ddp5qDB0REW+mTFK12nxN5TXRclJU0ViJoSDabqPDl293dyQPUVuOaV
   Q==;
X-CSE-ConnectionGUID: Z2z9pO38R9W5gSIwLcScPQ==
X-CSE-MsgGUID: ATf9vy1jTGictqaD8lpZ4w==
X-IronPort-AV: E=Sophos;i="6.21,261,1763449200"; 
   d="scan'208";a="51905918"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 09:28:33 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.87.71) by
 chn-vm-ex3.mchp-main.com (10.10.87.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Thu, 29 Jan 2026 09:28:18 -0700
Received: from [10.10.179.162] (10.10.85.11) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Thu, 29 Jan 2026 09:28:17 -0700
Message-ID: <25e13e64-f39c-44b4-9877-1e3b6caed458@microchip.com>
Date: Thu, 29 Jan 2026 09:28:51 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ryan Wanner <ryan.wanner@microchip.com>
Content-Language: en-US
To: <linux-crypto@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
Subject: AFALG with TLS on Openssl questions
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello,

I am working on kernel v6.12 and trying to use
authenc(hmac(sha256),cbc(aes)) for a TLS connection. The driver I am
using atmel-aes.c and atmel-sha.c both do support this and I did pass
the kernel self tests for these drivers.

It seems that afalg does not call the authenc part of this driver, but
seems to call aes separately even though authenc is detected registered
and tested. Can I get confirmation if this is supported in afalg? From
what I understand afalg does not support hashes but cryptodev does. I
see cryptodev call both sha and aes while afalg just calls aes.

I do have CRYPTO_DEV_ATMEL_AUTHENC=y CRYPTO_USER_API_HASH=y
CRYPTO_USER_API_SKCIPHER=y CRYPTO_USER=y this is a SAMA7G54, ARM CORTEX-A7.

I also would like to know if authenc(hmac(sha512),gcm(aes)) is
supported? I would like to add that to the driver as well but due to the
issues I highlighted above and no selftest suite for authenc gcm I do
not know a good way to verify the driver integrates with the crypto system.

Thank you,

Ryan
