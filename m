From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5 10/31] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Thu, 5 Oct 2017 11:56:05 +0200
Message-ID: <20171005095605.mhfudr5vwz2ptcxs@pd.tnic>
References: <20171004131412.13038-1-brijesh.singh@amd.com>
 <20171004131412.13038-11-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171004131412.13038-11-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 04, 2017 at 08:13:51AM -0500, Brijesh Singh wrote:
> The Platform Security Processor (PSP) is part of AMD Secure Processor
> (AMD-SP), PSP is a dedicated processor that provides the support for
> key management commands in a Secure Encrypted Virtualization (SEV) mode,
> along with software-based Trusted Execution Environment (TEE) to enable
> the third-party trusted applications.
> 
> Note that the key management functionality provided by the SEV firmware
> can be used outside the kvm-amd driver hence we don't do depends on
> CONFIG_KVM_AMD.

Minor corrections:

"The Platform Security Processor (PSP) is part of the AMD Secure
Processor (AMD-SP) functionality. The PSP is a dedicated processor
that provides support for key management commands in Secure Encrypted
Virtualization (SEV) mode, along with software-based Trusted Execution
Environment (TEE) to enable third-party trusted applications.

Note that the key management functionality provided by the SEV firmware
can be used outside of the kvm-amd driver hence it doesn't need to
depend on CONFIG_KVM_AMD."

...

> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index 9c84f9838931..454c25d9f197 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -33,3 +33,14 @@ config CRYPTO_DEV_CCP_CRYPTO
>  	  Support for using the cryptographic API with the AMD Cryptographic
>  	  Coprocessor. This module supports offload of SHA and AES algorithms.
>  	  If you choose 'M' here, this module will be called ccp_crypto.
> +
> +config CRYPTO_DEV_SP_PSP
> +	bool "Platform Security Processor (PSP) device"
> +	default y
> +	depends on CRYPTO_DEV_CCP_DD && X86_64
> +	help
> +	 Provide the support for the AMD Platform Security Processor (PSP).
> +	 The PSP is a dedicated processor that provides support for key
> +	 management commands in Secure Encrypted Virtualization (SEV) mode,
> +	 along with software-based Trusted Execution Environment (TEE) to
> +	 enable the third-party trusted applications.

Minor corrections:

---
diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 454c25d9f197..b9dfae47aefd 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -39,8 +39,8 @@ config CRYPTO_DEV_SP_PSP
 	default y
 	depends on CRYPTO_DEV_CCP_DD && X86_64
 	help
-	 Provide the support for the AMD Platform Security Processor (PSP).
+	 Provide support for the AMD Platform Security Processor (PSP).
 	 The PSP is a dedicated processor that provides support for key
 	 management commands in Secure Encrypted Virtualization (SEV) mode,
 	 along with software-based Trusted Execution Environment (TEE) to
-	 enable the third-party trusted applications.
+	 enable third-party trusted applications.

with that taken care of:

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
