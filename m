Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C2C4B1E58;
	Tue,  6 May 2025 20:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746562372; cv=none; b=JMjQSsBsoXF0WBxAx94eC7N4zw/dvjUj8eAf+bbK30LeZ0AbrCoYBF91EBEkh3HHSarkuoNWvPsDAnq30dQGHLg9/nsiVg/PDl9o3hdI5RhhBZQX3ECxd19b/GapjzELlmryjFrsnKNPX5IH/9xFXDp8EqJw2165NKWLtUd8SLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746562372; c=relaxed/simple;
	bh=awMeNr6abV7AbTeegTPDyRKGh6d7lvNYeOQHM1iAeyk=;
	h=Message-ID:Date:MIME-Version:From:To:CC:Subject:Content-Type; b=iOMQXSAFuHcd5UXrkjNVubn0rAxSP+tLFvMvgpsTyiSaPIEVWcddvqQdvOj1OTDHkhn/e2czmKvWslydq/jX5A1apA+9ibRvOzSQPYL3EqNZXR1g5rjnA3fzNhJH7vQY1WhWxCVxvvNKuWMCWSZ5PaLk8asQV9R+wp+dY4PmRHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=GAGpcnVc; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="GAGpcnVc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1746562371; x=1778098371;
  h=message-id:date:mime-version:from:to:cc:subject:
   content-transfer-encoding;
  bh=awMeNr6abV7AbTeegTPDyRKGh6d7lvNYeOQHM1iAeyk=;
  b=GAGpcnVcqx48aUyO62at6HKyE5MHpDU4A+1vtTv6LA0K4Nkokvh9k//X
   4V0LDvOhHflHrlmtNSD/L7FkS6fYufGuRnKyYZ3N1CYeH4+5zPsoG+JtZ
   +BmLlTCKf2vX57pahSwiiDgFyF3X5ain57du+q2cNOnLDS/ohqXaoP/Hd
   vphHVs3v7QlrnRTTDktg2MHNOvaeVp0/gyrr9ppd11qsDYlF40terPGhl
   p4XJTRRSCP4Vid7e1qkawL3kqR6iP1Zumi+Div0vKGdT1P/L6jLRG88FS
   CfhRR2vpNLmxxFU8koQ+2KRfW8+Hq9M1akJnKlxw1fWvakvNtXY1NFJuV
   g==;
X-CSE-ConnectionGUID: YO4aNdYySY6N+8fIHIRbMw==
X-CSE-MsgGUID: t60EVRrQSuWFFejWtRjsIw==
X-IronPort-AV: E=Sophos;i="6.15,267,1739862000"; 
   d="scan'208";a="41298320"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 May 2025 13:12:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 6 May 2025 13:12:34 -0700
Received: from [10.10.179.162] (10.10.85.11) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.44 via Frontend
 Transport; Tue, 6 May 2025 13:12:34 -0700
Message-ID: <468a8e17-d564-441d-9893-72b0ed48d8bb@microchip.com>
Date: Tue, 6 May 2025 13:12:31 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Ryan Wanner <ryan.wanner@microchip.com>
To: <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto self-test errors kernel 6.12.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello,

I upgraded my ARM kernel from v6.6.9 to v6.12.4 and I am seeing some
crypto self test errors that I did not see before. Shown below. These
errors are different every boot and I did not see them on 6.6.9 kernel.
I did notice that when I compile the crypto HW acceleration drivers as
modules like this:
CONFIG_CRYPTO_DEV_ATMEL_AES [=m]
CONFIG_CRYPTO_DEV_ATMEL_TDES [=m]
CONFIG_CRYPTO_DEV_ATMEL_SHA [=m]

and have them loaded by systemd at boot I do not get errors and all the
self tests pass.

Is there a race condition I am not aware of? Or is the new asynchronous
crypto tests creating bugs in the HW acceleration drivers.


DRBG: could not allocate digest TFM handle: hmac(sha512)
alg: drbg: Failed to reset rng
alg: drbg: Test 0 failed for drbg_nopr_hmac_sha512
alg: self-tests for stdrng using drbg_nopr_hmac_sha512 failed (rc=-22)
------------[ cut here ]------------
WARNING: CPU: 0 PID: 90 at crypto/testmgr.c:5928 0xc0397fd0
alg: self-tests for stdrng using drbg_nopr_hmac_sha512 failed (rc=-22)

alg: hash: error allocating hmac(sha512-generic) (generic impl of
hmac(sha512)): -17
alg: self-tests for hmac(sha512) using atmel-hmac-sha512 failed (rc=-17)
------------[ cut here ]------------
WARNING: CPU: 0 PID: 53 at crypto/testmgr.c:5928 0xc0397fd0
alg: self-tests for hmac(sha512) using atmel-hmac-sha512 failed (rc=-17)


Best,
Ryan
