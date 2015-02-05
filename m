From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 7/7] Enabling VMX module for PPC64
Date: Thu, 05 Feb 2015 22:58:23 +0100
Message-ID: <1423173503.32511.16.camel@x220>
References: <20150205172126.GA15218@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:49220 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbbBEV60 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Feb 2015 16:58:26 -0500
In-Reply-To: <20150205172126.GA15218@bluepex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2015-02-05 at 15:21 -0200, Leonidas S. Barbosa wrote:
> This patch enables VMX module in PPC64.
> 
> Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
> ---
>  drivers/crypto/Kconfig      | 12 ++++++++++++
>  drivers/crypto/Makefile     |  1 +
>  drivers/crypto/vmx/Kconfig  |  9 +++++++++
>  drivers/crypto/vmx/Makefile | 21 +++++++++++++++++++++
>  4 files changed, 43 insertions(+)
>  create mode 100644 drivers/crypto/vmx/Kconfig
>  create mode 100644 drivers/crypto/vmx/Makefile
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 2fb0fdf..979cbff 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -436,4 +436,16 @@ config CRYPTO_DEV_QCE
>  	  hardware. To compile this driver as a module, choose M here. The
>  	  module will be called qcrypto.
>  
> +config CRYPTO_DEV_VMX
> +	bool "Support for VMX cryptographic acceleration instructions"
> +	depends on PPC64
> +	default n
> +	help
> +	  Support for VMX cryptographic acceleration instructions.
> +
> +if CRYPTO_DEV_VMX
> +	source "drivers/crypto/vmx/Kconfig"
> +endif
> +
>  endif # CRYPTO_HW
> +

Unneeded extra line.

> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 3924f93..20a7127 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -25,3 +25,4 @@ obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
>  obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
>  obj-$(CONFIG_CRYPTO_DEV_QAT) += qat/
>  obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
> +obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
> diff --git a/drivers/crypto/vmx/Kconfig b/drivers/crypto/vmx/Kconfig
> new file mode 100644
> index 0000000..6728864
> --- /dev/null
> +++ b/drivers/crypto/vmx/Kconfig
> @@ -0,0 +1,9 @@
> +config CRYPTO_DEV_VMX_ENCRYPT
> +	tristate "Encryption acceleration support on P8 CPU"
> +	depends on PPC64

The net effect of the "if CRYPTO_DEV_VMX" wrapper round the source-ing
of this file is that CRYPTO_DEV_VMX_ENCRYPT depends on CRYPTO_DEV_VMX.
That makes depending on PPC64 superfluous here. You might as well make
this symbol depend on CRYPTO_DEV_VMX and drop the "if CRYPTO_DEV_VMX"
wrapper.

> +	default y
> +	help 
> +	  Support for VMX cryptographic acceleration instructions on Power8 CPU.
> +	  This module supports acceleration for AES and GHASH in hardware. If you
> +	  choose 'M' here, this module will be called vmx-crypto.
> +	  

Trailing line of whitespace only.

> diff --git a/drivers/crypto/vmx/Makefile b/drivers/crypto/vmx/Makefile
> new file mode 100644
> index 0000000..8898ce6
> --- /dev/null
> +++ b/drivers/crypto/vmx/Makefile
> @@ -0,0 +1,21 @@
> +obj-$(CONFIG_CRYPTO_DEV_VMX_ENCRYPT) += vmx-crypto.o
> +vmx-crypto-objs := vmx.o aesp8-ppc.o ghashp8-ppc.o aes.o aes_cbc.o aes_ctr.o ghash.o
> +
> +ifeq ($(CONFIG_PPC64),y)

Can this test ever fail?

> +ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
> +TARGET := linux-ppc64le
> +else
> +TARGET := linux-pcc64
> +endif
> +endif
> +
> +quiet_cmd_perl = PERL $@
> +      cmd_perl = $(PERL) $(<) $(TARGET) > $(@)
> +
> +$(src)/aesp8-ppc.S: $(src)/aesp8-ppc.pl
> +	$(call cmd,perl)
> +  
> +$(src)/ghashp8-ppc.S: $(src)/ghashp8-ppc.pl
> +	$(call cmd,perl)
> +
> +.PRECIOUS: $(obj)/aesp8-ppc.S $(obj)/ghashp8-ppc.S


Paul Bolle
