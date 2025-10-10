Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244181E25E3;
	Fri, 10 Oct 2025 06:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760079495; cv=none; b=OxbGl+uSgVoI14GNd2ltYQPYDNk3wVqqAqhRNppEMw6GLKIOl7n82cYAMnfNJhJEf9WuxOunO7ADrkbhgnqtCTWWzuFr+XGtHNls2n6Cjt/Lr9ySMS0jWARgIT5xBtn4DCdCWnMxeETPUIPSV45TxZZhLPatK57vlZmyXUfFcW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760079495; c=relaxed/simple;
	bh=YTrFfPtg/05akktd8J0VkElMumJpc/EaG48vErmcPF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=lsL4U05Ac+Vap7oQDUJu/KRZuYicTG0M2KoP9nJBOVt4HqJZoPjO6Uadat1AfxT1jBrrsy93mRwOsHGFHBy9P93/HxIMClJa6nUZBK9k75Rpc+AY7/X1ILZ4yG2nrAOPCjczFQ6F+2yAeNeW2vexKm6Jpe7eMaVscCx+m8OeAeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=gZ1nB3rO; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="gZ1nB3rO"
Received: from lelvem-sh01.itg.ti.com ([10.180.77.71])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTP id 59A6w2Kc708783;
	Fri, 10 Oct 2025 01:58:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1760079482;
	bh=aYHutxQoncsNseCKuAmhdGONiwwJp38s9lk2CYc638Y=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=gZ1nB3rOwURVzHPsN1Z6sKgq2Hh3lQ7EzMobv5CYCzlm0dQC49+Lqn6Me81hkXnls
	 eLjCA5QiGutjqzg7VqkpzyKGghaHkr2gQjcJpCqUa4HFmXLttQC1Ad3uHBhjAgHalh
	 kadzylTIOnwY5Cx1nEbsJDVIkSjhbss37YGigmAc=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
	by lelvem-sh01.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 59A6w2HG871380
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Fri, 10 Oct 2025 01:58:02 -0500
Received: from DLEE201.ent.ti.com (157.170.170.76) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Fri, 10
 Oct 2025 01:58:01 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 10 Oct 2025 01:58:01 -0500
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 59A6vvOD1253935;
	Fri, 10 Oct 2025 01:57:58 -0500
Message-ID: <66ade5d8-22d8-46d6-92c0-338271ac2e99@ti.com>
Date: Fri, 10 Oct 2025 12:27:57 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/4] Add SPAcc Crypto Driver
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <robh@kernel.org>
CC: <krzk+dt@kernel.org>, <conor+dt@kernel.org>, <Ruud.Derwig@synopsys.com>,
        <manjunath.hadli@vayavyalabs.com>, <adityak@vayavyalabs.com>
References: <20251007065020.495008-1-pavitrakumarm@vayavyalabs.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <20251007065020.495008-1-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi
On 07/10/25 12:20, Pavitrakumar Managutte wrote:
> Add the driver for SPAcc(Security Protocol Accelerator), which is a             
> crypto acceleration IP from Synopsys. The SPAcc supports multiple ciphers,      
> hashes and AEAD algorithms with various modes. The driver currently supports    
> below                                                                           
>                                                                                 
> hash:                                                                           
> - cmac(aes)                                                                     
> - xcbc(aes)                                                                     
> - cmac(sm4)                                                                     
> - xcbc(sm4)                                                                     
> - hmac(md5)                                                                     
> - md5                                                                           
> - hmac(sha1)                                                                    
> - sha1                                                                          
> - sha224
> - sha256                                                                        
> - sha384                                                                        
> - sha512                                                                        
> - hmac(sha224)                                                                  
> - hmac(sha256)                                                                  
> - hmac(sha384)                                                                  
> - hmac(sha512)                                                                  
> - sha3-224                                                                      
> - sha3-256                                                                      
> - sha3-384                                                                      
> - sha3-512                                                                      
> - hmac(sm3)                                                                     
> - sm3                                                                           
> - michael_mic                                              
> 
> Pavitrakumar Managutte (4):
>   dt-bindings: crypto: Document support for SPAcc
>   Add SPAcc ahash support
>   Add SPAcc AUTODETECT Support
>   Add SPAcc Kconfig and Makefile

Use appropriate subject prefixes in commits. For crypto drivers, it is "crypto: <org/chip/soc> - <your commit header>". You can find the correct prefixes with `git log --oneline -- DIRECTORY_OR_FILE` on the directory your patch is touching.

> 
> changelog:
>   v1->v2 changes:
>     - Added local_bh_disable() and local_bh_enable() for the below calls.
>       a. for ciphers skcipher_request_complete()
>       b. for aead aead_request_complete()
>       c. for hash ahash_request_complete()
>     - dt-bindings updates
>       a. removed snps,vspacc-priority and made it into config option
>       b. renamed snps,spacc-wdtimer to snps,spacc-internal-counter
>       c. Added description to all properties
>     - Updated corresponding dt-binding changes to code 
> 
>   v2->v3 changes:
>     - cra_init and cra_exit replaced with init_tfm and exit_tfm for hashes.
>     - removed mutex_lock/unlock for spacc_skcipher_fallback call
>     - dt-bindings updates
>      a. updated SOC related information
>      b. renamed compatible string as per SOC
>    - Updated corresponding dt-binding changes to code 
> 
>   v3->v4 changes:
>    - removed snps,vspacc-id from the dt-bindings 
>    - removed mutex_lock from ciphers
>    - replaced magic numbers with macros
>    - removed sw_fb variable from struct mode_tab and associated code from the
>      hashes
>    - polling code is replaced by wait_event_interruptible
> 
>   v4->v5 changes:
>    - Updated to register with the crypto-engine
>    - Used semaphore to manage SPAcc device hardware context pool
>    - This patchset supports Hashes only 
>    - Dropping the support for Ciphers and AEADs in this patchset 
>    - Added Reviewed-by tag on the Device tree patch since it was reviewed on 
>      v4 patch by Krzysztof Kozlowski and Rob Herring (Arm)
> 
>   v5->v6 changes:
>    - Removed CRYPTO_DEV_SPACC_CIPHER and CRYPTO_DEV_SPACC_AEAD Kconfig options,
>      since the cipher and aead support is not part of this patchset
>    - Dropped spacc_skcipher.o and spacc_aead.o from Makefile to fix build errors
>      reported by kernel test robot
>    - Added Reported-by and Closes tags as suggested
> 
>   v6->v7 changes:
>    - Fixed build error reported by Kernel test robot
>    - Added Reported-by and Closes tags as suggested
> 
>  .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
>  drivers/crypto/Kconfig                        |    1 +
>  drivers/crypto/Makefile                       |    1 +
>  drivers/crypto/dwc-spacc/Kconfig              |   80 +
>  drivers/crypto/dwc-spacc/Makefile             |    8 +
>  drivers/crypto/dwc-spacc/spacc_ahash.c        |  980 +++++++
>  drivers/crypto/dwc-spacc/spacc_core.c         | 2394 +++++++++++++++++
>  drivers/crypto/dwc-spacc/spacc_core.h         |  830 ++++++
>  drivers/crypto/dwc-spacc/spacc_device.c       |  283 ++
>  drivers/crypto/dwc-spacc/spacc_device.h       |  233 ++
>  drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
>  drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
>  drivers/crypto/dwc-spacc/spacc_interrupt.c    |  328 +++
>  drivers/crypto/dwc-spacc/spacc_manager.c      |  613 +++++
>  14 files changed, 6289 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
>  create mode 100644 drivers/crypto/dwc-spacc/Kconfig
>  create mode 100644 drivers/crypto/dwc-spacc/Makefile
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
> 
> 
> base-commit: c0d36727bf39bb16ef0a67ed608e279535ebf0da


-- 
Regards
T Pratham <t-pratham@ti.com>
