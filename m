From: Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v1.5 2/5] tpm: add module_put wrapper
Date: Tue, 23 Nov 2010 20:19:33 -0600
Message-ID: <20101124021933.GB25766@tiny>
References: <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1290552635-3356-3-git-send-email-zohar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1290552635-3356-3-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> For readability, define a tpm_chip_put() wrapper to call module_put().
> Replace existing module_put() calls with the wrapper.
> 
> (Change based on trusted/encrypted patchset review by David Howells.)
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Signed-off-by: David Safford <safford@watson.ibm.com>
> Acked-by: David Howells <dhowells@redhat.com>

Hard to object to this one :)

Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>

> ---
>  drivers/char/tpm/tpm.c |    4 ++--
>  drivers/char/tpm/tpm.h |    5 +++++
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 7c41335..26c09f3 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -736,7 +736,7 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
>  	if (chip == NULL)
>  		return -ENODEV;
>  	rc = __tpm_pcr_read(chip, pcr_idx, res_buf);
> -	module_put(chip->dev->driver->owner);
> +	tpm_chip_put(chip);
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(tpm_pcr_read);
> @@ -775,7 +775,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>  	rc = transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
>  			  "attempting extend a PCR value");
>  
> -	module_put(chip->dev->driver->owner);
> +	tpm_chip_put(chip);
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(tpm_pcr_extend);
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 792868d..72ddb03 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -113,6 +113,11 @@ struct tpm_chip {
>  
>  #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
>  
> +static inline void tpm_chip_put(struct tpm_chip *chip)
> +{
> +	module_put(chip->dev->driver->owner);
> +}
> +
>  static inline int tpm_read_index(int base, int index)
>  {
>  	outb(index, base);
> -- 
> 1.7.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
