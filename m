Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB31466B72;
	Tue, 20 Jan 2026 15:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768924228; cv=none; b=AWdD3tahAExMNQLNYLVhdUevh+2zJkvLNsbb9ZC++QH9z/T1YjiN4OQJD0iEAyw3cIdN7Qr4naxTgAdhOslrxTzwcKTBL+cSRTAX4zkMdnYaCS69i6jGx5zEkv1Eit1bKNe5xWk720FMx+QL+UUK/BK1aAw+m/EmP7+sEyJAHH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768924228; c=relaxed/simple;
	bh=LKRmFLYmVpfCIH+4mOxV/Sn0Uf+Kg1tNr4flB+0XpUk=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=B2nFZRF9eKRTAyFDzR7wh9xPC4I50xhdisCs6nte+nOIw4bscUBeUhQhF0RM5gVZs3ftrOjYUdijfZKY/UHW6/c6kDE4mloJE6afs/LsFyw7WxMY5mR1Jq1J2Kw0HnleGGn7OtmkxgOVBPx4FYiu0kBXjkdFTxDB6lamyG05Rp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RmIXS04L; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RmIXS04L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768924225; x=1800460225;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=LKRmFLYmVpfCIH+4mOxV/Sn0Uf+Kg1tNr4flB+0XpUk=;
  b=RmIXS04LpsE9Ee0++d7rDyF7r5CMNf/FbKBf28ILhlSxY1ejxQbevoY3
   ngrl2GJRXuzrmFE0nNVNIFe0B8STXNHcHE/qvkya3NLJwVsST9P/axQtg
   e1v/pFIAxHN9koBfywZ+M8jyBo+LdtNZwg0ZVfItxScu/7Z5XH4PeHLhp
   DrGBVjmupRvjiZvX9G7JxM6Dd9PFm+S5IIKKK4hv7gMFzeJLWQvazpIDH
   pUSaNadRbeDArvsJapnfyIvgbk3FnILV1ixdZwGCzazBMyKv/uhHIccJH
   RzSR7V+5oUdeAe9N6rzDf0WmNaQ2zN6/q/SnAtfi/AdtiJ6LYGhfj4tJ3
   A==;
X-CSE-ConnectionGUID: CeSPzKs7TTqaq336pfAoKQ==
X-CSE-MsgGUID: 75Qn1GiuQUSC1SLH7cohbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="74004267"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="74004267"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 07:50:24 -0800
X-CSE-ConnectionGUID: so59NhtSQ6SjR7eCoEl13A==
X-CSE-MsgGUID: XdbfPwMcRhOWpT2nMsOZ3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="229091953"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.10])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 07:50:20 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 20 Jan 2026 17:50:17 +0200 (EET)
To: "Mario Limonciello (AMD)" <superm1@kernel.org>
cc: Tom Lendacky <thomas.lendacky@amd.com>, 
    Herbert Xu <herbert@gondor.apana.org.au>, 
    Shyam Sundar S K <Shyam-sundar.S-k@amd.com>, 
    Rijo Thomas <Rijo-john.Thomas@amd.com>, John Allen <john.allen@amd.com>, 
    "David S . Miller" <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>, 
    "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER" <linux-crypto@vger.kernel.org>, 
    "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>, 
    Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>, 
    Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Subject: Re: [PATCH v6 0/5] Fixes for PMF and CCP drivers after S4
In-Reply-To: <20260116041132.153674-1-superm1@kernel.org>
Message-ID: <93beb504-e6f0-00f5-d974-6293f51839d5@linux.intel.com>
References: <20260116041132.153674-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 15 Jan 2026, Mario Limonciello (AMD) wrote:

> Lars Francke reported that the PMF driver fails to work afer S4 with:
>   ccp 0000:c3:00.2: tee: command 0x5 timed out, disabling PSP
> 
> This is because there is a TA loaded to the TEE environment that
> is lost during S4.  The TEE rings need to be reinitialized and the
> TA needs to be reloaded.
> 
> This series adds those flows to the PMF and CCP drivers.
> 
> v5->v6:
>  * Fix Tom's feedback on patch 3/5
> 
> Mario Limonciello (AMD) (4):
>   crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
>   crypto: ccp - Add an S4 restore flow
>   crypto: ccp - Factor out ring destroy handling to a helper
>   crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT
>     fails
> 
> Shyam Sundar S K (1):
>   platform/x86/amd/pmf: Prevent TEE errors after hibernate
> 
>  drivers/crypto/ccp/psp-dev.c          | 11 +++++
>  drivers/crypto/ccp/sp-dev.c           | 12 ++++++
>  drivers/crypto/ccp/sp-dev.h           |  3 ++
>  drivers/crypto/ccp/sp-pci.c           | 16 ++++++-
>  drivers/crypto/ccp/tee-dev.c          | 56 ++++++++++++++++++------
>  drivers/crypto/ccp/tee-dev.h          |  1 +
>  drivers/platform/x86/amd/pmf/core.c   | 62 ++++++++++++++++++++++++++-
>  drivers/platform/x86/amd/pmf/pmf.h    | 10 +++++
>  drivers/platform/x86/amd/pmf/tee-if.c | 12 ++----
>  include/linux/psp.h                   |  1 +
>  10 files changed, 161 insertions(+), 23 deletions(-)

I've applied this to the review-ilpo-next branch (and reorganized the 
NPU metrics to come after this series as these seemed to have a context 
conflict).

-- 
 i.

