Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA50B3E0C65;
	Fri, 15 May 2026 23:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778886244; cv=none; b=Y9SfnQLOw4ktYxNDnY94n8TRJC7jQkP6aSjcqPwJg44XtHku7HfKJcoOBOXOcdgR87DEV7O+lk3eb4KQwJesHxH5ORVwbj+0D3HISLeeExgI82ORCNamqdXIqRB/RVvKydshgFKgCn6swXUC6maNkfCeWBghherqREQBQHek8yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778886244; c=relaxed/simple;
	bh=PhQDSx6wqerXO7jp1SJIU+zkyjxdLRzIzDp+gw4Vw0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OOQfgQyB6zujaT5qWuUrXEG0D4Afq6Oybl8Gpgn9W3HrQLghkxwXGXMmgC9JSmEm/iCmljL6GVAyWLpwx81REsXGC7RT9DNOxSPRmXLzLlLFlNw8eAqm9sYXcoJEGcJE/8aT+yFowmyThukEKC5zY8TbAr6j3wFDlVIMuAh1hRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5BaN2Do; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5BaN2Do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0599BC2BCB0;
	Fri, 15 May 2026 23:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778886243;
	bh=PhQDSx6wqerXO7jp1SJIU+zkyjxdLRzIzDp+gw4Vw0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q5BaN2DoPrhb61jy1QKZ5LIBvFxgxcTzdzmJU3iVH3FjkufQerI72LCScJbcjuQ7T
	 W6dFcxj1mvS7hcMx1zhKOYozHElZ/lmUmomUGV0tOmZDp6vr06wfSbRWDilmRl7tG3
	 SfeItDd7AAF3QAg1Q5FClPyjcW2USYRVsx43w173yTB75mR4GlXYDxGZSB+qAPtYzw
	 P2M1X2jAjtRSzgg4UpJI9r9Mq3o4UnF4f66HRHU2YaA9lZqMldwFNPcU7MOJswlxWx
	 1zWdskK8k7tjmjhENLWRiY8raPEjV4W9Lbl7jL3lDQRxzD2o5t3boN7uqFob9PK64g
	 iedr4bo1BYvRQ==
Date: Sat, 16 May 2026 02:03:59 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Ross Philipson <ross.philipson@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, kexec@lists.infradead.org,
	linux-efi@vger.kernel.org, iommu@lists.linux.dev,
	dpsmith@apertussolutions.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, hpa@zytor.com, dave.hansen@linux.intel.com,
	ardb@kernel.org, mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com, peterhuewe@gmx.de,
	jgg@ziepe.ca, luto@amacapital.net, nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net, corbet@lwn.net,
	ebiederm@xmission.com, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com, andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: Re: [PATCH v16 01/38] tpm: Initial step to reorganize TPM public
 headers
Message-ID: <agemXwxVb9jvAbYM@kernel.org>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
 <20260515211410.31440-2-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515211410.31440-2-ross.philipson@gmail.com>

On Fri, May 15, 2026 at 02:13:33PM -0700, Ross Philipson wrote:
> Consolidate TPM1 constants in tpm_command.h and remove duplicate
> constants from tpm1-cmd.c.
> 
> Co-developed-by: Daniel P. Smith <dpsmith@apertussolutions.com>
> Signed-off-by: Daniel P. Smith <dpsmith@apertussolutions.com>
> Co-developed-by: Alec Brown <alec.r.brown@oracle.com>
> Signed-off-by: Alec Brown <alec.r.brown@oracle.com>
> Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
> ---
>  drivers/char/tpm/tpm-buf.c                |  1 -
>  drivers/char/tpm/tpm1-cmd.c               | 14 +-------
>  include/keys/trusted_tpm.h                |  1 -
>  include/linux/tpm.h                       |  2 ++
>  include/linux/tpm_command.h               | 41 ++++++++++++++++-------
>  security/keys/trusted-keys/trusted_tpm1.c |  1 -
>  security/keys/trusted-keys/trusted_tpm2.c |  1 -
>  7 files changed, 31 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
> index dc882fc9fa9e..4c4f450630df 100644
> --- a/drivers/char/tpm/tpm-buf.c
> +++ b/drivers/char/tpm/tpm-buf.c
> @@ -3,7 +3,6 @@
>   * Handling of TPM command and other buffers.
>   */
>  
> -#include <linux/tpm_command.h>
>  #include <linux/module.h>
>  #include <linux/tpm.h>
>  
> diff --git a/drivers/char/tpm/tpm1-cmd.c b/drivers/char/tpm/tpm1-cmd.c
> index b49a790f1bd5..664ca1fff2e8 100644
> --- a/drivers/char/tpm/tpm1-cmd.c
> +++ b/drivers/char/tpm/tpm1-cmd.c
> @@ -22,8 +22,6 @@
>  
>  #include "tpm.h"
>  
> -#define TPM_MAX_ORDINAL 243
> -
>  /*
>   * Array with one entry per ordinal defining the maximum amount
>   * of time the chip could take to return the result.  The ordinal
> @@ -308,9 +306,6 @@ unsigned long tpm1_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
>  		return duration;
>  }
>  
> -#define TPM_ORD_STARTUP 153
> -#define TPM_ST_CLEAR 1
> -
>  /**
>   * tpm1_startup() - turn on the TPM
>   * @chip: TPM chip to use
> @@ -459,7 +454,6 @@ int tpm1_get_timeouts(struct tpm_chip *chip)
>  	return 0;
>  }
>  
> -#define TPM_ORD_PCR_EXTEND 20
>  int tpm1_pcr_extend(struct tpm_chip *chip, u32 pcr_idx, const u8 *hash,
>  		    const char *log_msg)
>  {
> @@ -478,7 +472,6 @@ int tpm1_pcr_extend(struct tpm_chip *chip, u32 pcr_idx, const u8 *hash,
>  	return rc;
>  }
>  
> -#define TPM_ORD_GET_CAP 101
>  ssize_t tpm1_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>  		    const char *desc, size_t min_cap_length)
>  {
> @@ -511,7 +504,6 @@ ssize_t tpm1_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>  }
>  EXPORT_SYMBOL_GPL(tpm1_getcap);
>  
> -#define TPM_ORD_GET_RANDOM 70
>  struct tpm1_get_random_out {
>  	__be32 rng_data_len;
>  	u8 rng_data[TPM_MAX_RNG_DATA];
> @@ -580,13 +572,12 @@ int tpm1_get_random(struct tpm_chip *chip, u8 *dest, size_t max)
>  	return rc;
>  }
>  
> -#define TPM_ORD_PCRREAD 21
>  int tpm1_pcr_read(struct tpm_chip *chip, u32 pcr_idx, u8 *res_buf)
>  {
>  	struct tpm_buf buf;
>  	int rc;
>  
> -	rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND, TPM_ORD_PCRREAD);
> +	rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND, TPM_ORD_PCR_READ);
>  	if (rc)
>  		return rc;
>  
> @@ -609,7 +600,6 @@ int tpm1_pcr_read(struct tpm_chip *chip, u32 pcr_idx, u8 *res_buf)
>  	return rc;
>  }
>  
> -#define TPM_ORD_CONTINUE_SELFTEST 83
>  /**
>   * tpm1_continue_selftest() - run TPM's selftest
>   * @chip: TPM chip to use
> @@ -726,8 +716,6 @@ int tpm1_auto_startup(struct tpm_chip *chip)
>  	return rc;
>  }
>  
> -#define TPM_ORD_SAVESTATE 152
> -
>  /**
>   * tpm1_pm_suspend() - pm suspend handler
>   * @chip: TPM chip to use.
> diff --git a/include/keys/trusted_tpm.h b/include/keys/trusted_tpm.h
> index 0fadc6a4f166..3a0fa3bc8454 100644
> --- a/include/keys/trusted_tpm.h
> +++ b/include/keys/trusted_tpm.h
> @@ -3,7 +3,6 @@
>  #define __TRUSTED_TPM_H
>  
>  #include <keys/trusted-type.h>
> -#include <linux/tpm_command.h>
>  
>  extern struct trusted_key_ops trusted_key_tpm_ops;
>  
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index 202da079d500..1846d5485a2c 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -25,6 +25,8 @@
>  #include <crypto/hash_info.h>
>  #include <crypto/aes.h>
>  
> +#include <linux/tpm_command.h>
> +
>  #define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
>  
>  #define TPM2_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
> diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
> index f5c03e9c3913..174b043d8bbc 100644
> --- a/include/linux/tpm_command.h
> +++ b/include/linux/tpm_command.h
> @@ -3,27 +3,42 @@
>  #define __LINUX_TPM_COMMAND_H__
>  
>  /*
> - * TPM Command constants from specifications at
> - * http://www.trustedcomputinggroup.org
> + * == TPM 1 Family Chips ==
> + *
> + * TPM 1.2 Main Specification:
> + * https://trustedcomputinggroup.org/resource/tpm-main-specification/
>   */
>  
> +#define TPM_MAX_ORDINAL	243
> +
>  /* Command TAGS */
> -#define TPM_TAG_RQU_COMMAND             193
> -#define TPM_TAG_RQU_AUTH1_COMMAND       194
> -#define TPM_TAG_RQU_AUTH2_COMMAND       195
> -#define TPM_TAG_RSP_COMMAND             196
> -#define TPM_TAG_RSP_AUTH1_COMMAND       197
> -#define TPM_TAG_RSP_AUTH2_COMMAND       198
> +enum tpm_command_tags {
> +	TPM_TAG_RQU_COMMAND		= 193,
> +	TPM_TAG_RQU_AUTH1_COMMAND	= 194,
> +	TPM_TAG_RQU_AUTH2_COMMAND	= 195,
> +	TPM_TAG_RSP_COMMAND		= 196,
> +	TPM_TAG_RSP_AUTH1_COMMAND	= 197,
> +	TPM_TAG_RSP_AUTH2_COMMAND	= 198,
> +};
>  
>  /* Command Ordinals */
> -#define TPM_ORD_GETRANDOM               70
> -#define TPM_ORD_OSAP                    11
> -#define TPM_ORD_OIAP                    10
> -#define TPM_ORD_SEAL                    23
> -#define TPM_ORD_UNSEAL                  24
> +enum tpm_command_ordinals {
> +	TPM_ORD_CONTINUE_SELFTEST	= 83,
> +	TPM_ORD_GET_CAP			= 101,
> +	TPM_ORD_GET_RANDOM		= 70,
> +	TPM_ORD_PCR_EXTEND		= 20,
> +	TPM_ORD_PCR_READ		= 21,
> +	TPM_ORD_OSAP			= 11,
> +	TPM_ORD_OIAP			= 10,
> +	TPM_ORD_SAVESTATE		= 152,
> +	TPM_ORD_SEAL			= 23,
> +	TPM_ORD_STARTUP			= 153,
> +	TPM_ORD_UNSEAL			= 24,
> +};
>  
>  /* Other constants */
>  #define SRKHANDLE                       0x40000000
>  #define TPM_NONCE_SIZE                  20
> +#define TPM_ST_CLEAR			1
>  
>  #endif
> diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
> index 6ea728f1eae6..0d3244af8de3 100644
> --- a/security/keys/trusted-keys/trusted_tpm1.c
> +++ b/security/keys/trusted-keys/trusted_tpm1.c
> @@ -18,7 +18,6 @@
>  #include <keys/trusted-type.h>
>  #include <linux/key-type.h>
>  #include <linux/tpm.h>
> -#include <linux/tpm_command.h>
>  
>  #include <keys/trusted_tpm.h>
>  
> diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
> index 6340823f8b53..29d79c05ed6b 100644
> --- a/security/keys/trusted-keys/trusted_tpm2.c
> +++ b/security/keys/trusted-keys/trusted_tpm2.c
> @@ -9,7 +9,6 @@
>  #include <linux/string.h>
>  #include <linux/err.h>
>  #include <linux/tpm.h>
> -#include <linux/tpm_command.h>
>  
>  #include <keys/trusted-type.h>
>  #include <keys/trusted_tpm.h>
> -- 
> 2.47.3
> 

LGTM

I'll hold on from actual tags up until there is some consensus with the
patch set.

BR, Jarkko
