Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756605;
	b=MFDXG5KpmqwhKJK57IoJrVnx+xsNVuDawyns2Z4NNygsRXioO0rrQ+ydcQ11jxdsQCAy
	 6ADvz09JsL8k82kKlCYNSYfcWhS2+GqSytEvajLtJxh8mRtjARqPRCXDldXyBO1cFzMut
	 eJXdseM0+2gUIbJ1D8xr8SrQRP+fBSS1oJYw2gtTuhAL8turhWjsax4W7j7ceHAVHDa5X
	 Mf2uWYFlQIDL2dOrs9cYOaaTv5a3Z+2mu1UVuSqiDX2zguE/zBqwN/gSVrHlOFdGIG8Hj
	 td6WtzBfNzjt+4MsNGpo8AQT+LvvxX+E+M5vtqMgy6cBrdcHa+TOSg6w76JvXIqo42A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756605;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=1KCeidIU1Kme/yUIbfVqd55sbVEcgjU99vnNkDGVpGA=;
	b=bHPx/zUOM2zt3dE00gOo9tbh3LcfrB4A59+hHE3zQ4V9Zg1Gwh7/2/RkcYFtrQ0Hz1b4
	 GkZxq8hLhb1IRRz+Ntvh8Xd1rmoJMkLPL+V8T6lD+U0ARzx26sw+OqABm6v6T8HmpxPdf
	 Hsbo6tnSG2xKRQX9LeYrwaSj+7lU/G8LAw1MzCBrbCnPAs3Yt0SbPbVOvqd/ts9pNNgvm
	 AyDRYHgWnktwJI/3VHAOsqsAsq5uZ4+YQD1bP26tRSVSzey7VaSWLDDWfvzZFXBVn/UVW
	 Z/dyr3PF72Rks2qDB9NTeVhgV7exMdzw4f65df3eRtYZyxo0oyO12vuPBV/IaaSwc4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=KBxKSn9s;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139D8606A31C;
	Fri, 27 Nov 2026 05:16:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 139D8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=KBxKSn9s
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1KCeidIU1Kme/yUIbfVqd55sbVEcgjU99vnNkDGVpGA=; 
	b=KBxKSn9shk0DUOL4quOwSiya0Z3Iyi2JwuAGrsaLZcn/xzeut8iiwORRSCBFQaN9+lhjLmZR7qq
	qh7AOyhrtqQbXqJz016mBtspLt+L2EDfRs65yCj5l1DHjWjBk7+A7xsYu2egzvKF8lXagqpK2/QkX
	UpvCBhIZR6s+RZ6KJXCBlyBPD7OUNiQ1fG+GXD+3kmvKc2FwPXey+BjfKjp6a6FSZPjv3ZZxpnxWV
	tlrkfS0iLs3AfQ76b28xfDfR/QCtcCKN+hbZeRmRoGmk6XpJNeIkzyy7mL0yMJIMWjeuyCnY++oQB
	m0v1/plhvofjfkl0Kat72OnpjUDeNsTu/AWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoK8-00000002VXL-1mFj;
	Fri, 27 Nov 2026 13:16:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:16:40 +0800
Date: Fri, 27 Nov 2026 13:16:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, krzk@kernel.org,
	conor+dt@kernel.org, ruud.derwig@gf.com, rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	nazim.khan@vayavyalabs.com
Subject: Re: [PATCH v31 0/4] crypto: spacc - Add SPAcc Crypto Driver
Message-ID: <awkSOCWwb9D_-64c@gondor.apana.org.au>
References: <20261120131404.976959-1-pavitrakumarm@vayavyalabs.com>
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
In-Reply-To: <20261120131404.976959-1-pavitrakumarm@vayavyalabs.com>

On Fri, Nov 20, 2026 at 06:44:00PM +0530, Pavitrakumar Managutte wrote:
> Add the driver for SPAcc(Security Protocol Accelerator), which is a
> crypto acceleration IP from Synopsys. The SPAcc supports multiple ciphers,
> hashes and AEAD algorithms with various modes. The driver currently supports
> below
> 
> hash:
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
>   v7->v8 changes:
>    - Fixed misleading comment: Clarified that only HMAC key pre-processing
>      is done in software, while the actual HMAC operation is performed by
>      hardware
>    - Simplified do_shash() function signature by removing unused parameters
>    - Updated all do_shash() call sites to use new simplified signature
>    - Fixed commit message formatting by adding "crypto: spacc - <subject>" to
>      all patches
>    - used __free() for scope based resource management
> 
>   v8->v9 changes:
>    - Updated the software fallback implementation to use HASH_FBREQ_ON_STACK
>    - Corrected dynamic allocation of statesize and reqsize in init_tfm
>    - Fixed synchronization issues in the digest request
> 
>   v9->v10 changes:
>    - Fixed unused variable warning
> 
>   v10->v11 changes:
>    - Removed the redundant crypto_alloc_ahash in the init_tfm function
>    - Removed the redundant crypto_free_ahash in exit_tfm function
>    - Removed the redundant crypto_ahash_setkey call in setkey function
> 
>   v11->v12 changes:
>    - Removed do_shash() and switched to lib/crypto API in spacc_hash_setkey
>    - Dropped support for SM3 algorithm
>    - Improved multi-device safety by encapsulating handling within priv
>    - Added memzero_explicit() in sensitive paths
>    - Minor code cleanups and style fixes
>    - Algorithm registration cleanups
> 
>   v12->v13 changes:
>    - Removed all the sleep function from setkey function
>    - Added shash implemntation for aes algorthims
> 
>   v13->v14 changes:
>    -Added fixes based on the reports by Sashiko
>    -Removed the spacc_is_mode_keysize_supported call from do_one_request
> 
>   v14->v15 changes:
>    -Added fixes based on the reports by Sashiko on 19/jun/2026
>    -Fixed styling in the Kconfig
> 
>   v15->v16 changes:
>    -Added fixes based on the reports by Sashiko
> 
>   v16->v17 changes:
>    -Added fixes based on the reports by Sashiko
> 
>   v17->v18 changes:
>    -Added fixes based on the reports by Sashiko
> 
>   v18->v19 changes:
>    -Added fixes based on the reports by Sashiko
> 
>   v19->v20 changes:
>    -Added fixes based on the reports by Sashiko
> 
>   v20->v21 changes:
>    -Added fixes based on the reports by Sashiko
> 
>   v21->v22 changes:
>    -Added fixes based on the reports by Sashiko
> 
>   v22->v23 changes:
>    -Added fixes based on the reports by Sashiko
> 
>   v23->v24 changes:
>    -Added fixes based on the reports by Sashiko
> 
>   v24->v25 changes:
>    -Added fixes based on the reports by Sashiko
> 
>   v25->v26 changes:
>    -Added fixes based on the reports by Sashiko
>    -Removed the additional fallback
>    -Added the CRYPTO_AHASH_ALG_BLOCK_ONLY flag to the cra_flags
>    -Minor code cleanups and style fixes
> 
>   v26->v27 changes:
>    -Added fixes based on the reports by Sashiko
> 
>   v27->v28 changes:
>    -Added fixes based on the reports by Sashiko
> 
>   v28->v29 changes:
>    - Resent with patch 2/4 regenerated; v28 2/4 had a corrupt hunk
>      header and failed to apply. No functional changes from v28.
> 
>   v29->v30 changes:
>     -Added fixes based on the reports by Sashiko
> 
>   v30->v31 changes:
>     -Added fixe based on the reports by Sashiko
> 
> Pavitrakumar Managutte (4):
>   dt-bindings: crypto: Document support for SPAcc
>   crypto: spacc - Add SPAcc ahash support
>   crypto: spacc - add spacc autodetect support
>   crypto: spacc - Add SPAcc Kconfig and Makefile
> 
>  .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
>  drivers/crypto/Kconfig                        |    1 +
>  drivers/crypto/Makefile                       |    1 +
>  drivers/crypto/dwc-spacc/Kconfig              |   64 +
>  drivers/crypto/dwc-spacc/Makefile             |    7 +
>  drivers/crypto/dwc-spacc/spacc_ahash.c        |  806 ++++++
>  drivers/crypto/dwc-spacc/spacc_core.c         | 2407 +++++++++++++++++
>  drivers/crypto/dwc-spacc/spacc_core.h         |  861 ++++++
>  drivers/crypto/dwc-spacc/spacc_device.c       |  340 +++
>  drivers/crypto/dwc-spacc/spacc_device.h       |  178 ++
>  drivers/crypto/dwc-spacc/spacc_hal.c          |  349 +++
>  drivers/crypto/dwc-spacc/spacc_hal.h          |  113 +
>  drivers/crypto/dwc-spacc/spacc_interrupt.c    |  365 +++
>  drivers/crypto/dwc-spacc/spacc_manager.c      |  641 +++++
>  14 files changed, 6183 insertions(+)
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
> base-commit: 04cd6899aaaeeab82afb97e58eb8619fde35b47d
> --
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
