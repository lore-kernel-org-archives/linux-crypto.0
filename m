From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.1 12.1/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Sun, 8 Oct 2017 08:30:47 -0500
Message-ID: <c6ec79f7-5192-8ed3-4df3-260c09ceccb9@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007184049.jrbxebb4jlciu3hj@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171007184049.jrbxebb4jlciu3hj@pd.tnic>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/7/17 1:40 PM, Borislav Petkov wrote:
...
> A bunch of fixes ontop:
>
> * sev_fops_registered is superfluous if you can use psp->has_sev_fops

I am okay with all your fixes except this one. I will add my comment below.

...
>  static int sev_ops_init(struct psp_device *psp)
>  {
>  	struct miscdevice *misc = &psp->sev_misc;
> -	int ret = 0;
> +	int ret;
>  
>  	/*
> -	 * SEV feature support can be detected on the multiple devices but the
> -	 * SEV FW commands must be issued on the master. During probe time we
> -	 * do not know the master hence we create /dev/sev on the first device
> -	 * probe. sev_handle_cmd() finds the right master device to when issuing
> -	 * the command to the firmware.
> +	 * SEV feature support can be detected on multiple devices but the SEV
> +	 * FW commands must be issued on the master. During probe, we do not
> +	 * know the master hence we create /dev/sev on the first device probe.
> +	 * sev_do_cmd() finds the right master device to which to issue the
> +	 * command to the firmware.
>  	 */
> -	if (!sev_fops_registered) {
> -		misc->minor = MISC_DYNAMIC_MINOR;
> -		misc->name = DEVICE_NAME;
> -		misc->fops = &sev_fops;
> -
> -		ret = misc_register(misc);
> -		if (!ret) {
> -			sev_fops_registered = true;
> -			psp->has_sev_fops = true;
> -			init_waitqueue_head(&psp->sev_int_queue);
> -			dev_info(psp->dev, "registered SEV device\n");
> -		}
> +	if (psp->has_sev_fops)
> +		return 0;
> +

This will always be false.  The struct psp_device is used for storing
per-device instance.

> +	misc->minor = MISC_DYNAMIC_MINOR;
> +	misc->name = DEVICE_NAME;
> +	misc->fops = &sev_fops;
> +
> +	ret = misc_register(misc);
> +	if (!ret) {
> +		psp->has_sev_fops = true;
> +		init_waitqueue_head(&psp->sev_int_queue);
> +		dev_info(psp->dev, "registered SEV device\n");
>  	}


During the device probe, sev_ops_init() will be called for every device
instance which claims to support the SEV.  One of the device will be
'master' but we don't the master until we probe all the instances. Hence
the probe for all SEV devices must return success.

With your changes, the first device instance will able to create
/dev/sev node but all other instances will fail hence the probe routine
for other instances will also fail.

Basically we need some variable which is outside the per-device
structure so that we don't end up creating multiple /dev/sev nodes. If
needed, I think we can remove 'has_sev_fops' variable from struct
psp_device if we decide to dynamic alloc 'struct miscdevice sev_misc' in
struct psp_device. The 'has_sev_fops' is  mainly used in sev_exit(). If
we decide to dynamic alloc sev_misc then in  sev_exit() we can use
psp->sev_misc != NULL instead of psp->has_sev_ops.


>  
>  	return ret;
> diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
> index 6e8f83b41521..60a33f5ff79f 100644
> --- a/drivers/crypto/ccp/psp-dev.h
> +++ b/drivers/crypto/ccp/psp-dev.h
> @@ -36,7 +36,7 @@
>  #define PSP_CMDBUFF_ADDR_HI             PSP_C2PMSG(57)
>  #define PSP_FEATURE_REG			PSP_C2PMSG(63)
>  
> -#define PSP_P2CMSG(_num)		(_num << 2)
> +#define PSP_P2CMSG(_num)		((_num) << 2)
>  #define PSP_CMD_COMPLETE_REG		1
>  #define PSP_CMD_COMPLETE		PSP_P2CMSG(PSP_CMD_COMPLETE_REG)
>  
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 2b334fd853c9..10b843cce75f 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -512,8 +512,7 @@ struct sev_data_dbg {
>  	u32 len;				/* In */
>  } __packed;
>  
> -#if defined(CONFIG_CRYPTO_DEV_SP_PSP)
> -
> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  /**
>   * sev_platform_init - perform SEV INIT command
>   *
> @@ -562,9 +561,9 @@ int sev_platform_status(struct sev_data_status *status, int *error);
>   * sev_issue_cmd_external_user - issue SEV command by other driver with a file
>   * handle.
>   *
> - * The function can be used by other drivers to issue a SEV command on
> - * behalf by userspace. The caller must pass a valid SEV file descriptor
> - * so that we know that caller has access to SEV device.
> + * This function can be used by other drivers to issue a SEV command on
> + * behalf of userspace. The caller must pass a valid SEV file descriptor
> + * so that we know that it has access to SEV device.
>   *
>   * @filep - SEV device file pointer
>   * @cmd - command to issue
>
