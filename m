From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [Part2 PATCH v6.1 19/38] crypto: ccp: Implement
 SEV_PEK_CERT_IMPORT ioctl command
Date: Tue, 24 Oct 2017 13:42:50 -0500
Message-ID: <a4b75c6b-f977-34eb-e92a-e2a158e36447@amd.com>
References: <20171020023413.122280-20-brijesh.singh@amd.com>
 <20171023221400.47047-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171023221400.47047-1-brijesh.singh@amd.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/23/2017 05:14 PM, Brijesh Singh wrote:
> The SEV_PEK_CERT_IMPORT command can be used to import the signed PEK
> certificate. The command is defined in SEV spec section 5.8.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>


Acked-by: Gary R Hook <gary.hook@amd.com>



> ---
> 
> Changes since v6:
>   * when sev_do_cmd() and sev_platform_shutdown() fails then propogate
>     the error status code from sev_do_cmd() because it can give us
>     much better reason for the failure.
> 
>   drivers/crypto/ccp/psp-dev.c | 92 ++++++++++++++++++++++++++++++++++++++++++++
>   include/linux/psp-sev.h      |  4 ++
>   2 files changed, 96 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index aaf1c5cf821d..108fc06bcdb3 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -301,6 +301,95 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
>   	return ret;
>   }
>   
> +void *psp_copy_user_blob(u64 __user uaddr, u32 len)
> +{
> +	void *data;
> +
> +	if (!uaddr || !len)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* verify that blob length does not exceed our limit */
> +	if (len > SEV_FW_BLOB_MAX_SIZE)
> +		return ERR_PTR(-EINVAL);
> +
> +	data = kmalloc(len, GFP_KERNEL);
> +	if (!data)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (copy_from_user(data, (void __user *)(uintptr_t)uaddr, len))
> +		goto e_free;
> +
> +	return data;
> +
> +e_free:
> +	kfree(data);
> +	return ERR_PTR(-EFAULT);
> +}
> +EXPORT_SYMBOL_GPL(psp_copy_user_blob);
> +
> +static int sev_ioctl_do_pek_cert_import(struct sev_issue_cmd *argp)
> +{
> +	struct sev_user_data_pek_cert_import input;
> +	struct sev_data_pek_cert_import *data;
> +	void *pek_blob, *oca_blob;
> +	int ret, err;
> +
> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> +		return -EFAULT;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	/* copy PEK certificate blobs from userspace */
> +	pek_blob = psp_copy_user_blob(input.pek_cert_address, input.pek_cert_len);
> +	if (IS_ERR(pek_blob)) {
> +		ret = PTR_ERR(pek_blob);
> +		goto e_free;
> +	}
> +
> +	data->pek_cert_address = __psp_pa(pek_blob);
> +	data->pek_cert_len = input.pek_cert_len;
> +
> +	/* copy PEK certificate blobs from userspace */
> +	oca_blob = psp_copy_user_blob(input.oca_cert_address, input.oca_cert_len);
> +	if (IS_ERR(oca_blob)) {
> +		ret = PTR_ERR(oca_blob);
> +		goto e_free_pek;
> +	}
> +
> +	data->oca_cert_address = __psp_pa(oca_blob);
> +	data->oca_cert_len = input.oca_cert_len;
> +
> +	ret = sev_platform_init(NULL, &argp->error);
> +	if (ret)
> +		goto e_free_oca;
> +
> +	ret = sev_do_cmd(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
> +
> +	if (sev_platform_shutdown(&err)) {
> +		/*
> +		 * If both sev_do_cmd() and sev_platform_shutdown() commands
> +		 * failed then propogate the error code from the sev_do_cmd()
> +		 * because it contains a useful status code for the command
> +		 * failure.
> +		 */
> +		if (ret)
> +			goto e_free_oca;
> +
> +		ret = -EIO;
> +		argp->error = err;
> +	}
> +
> +e_free_oca:
> +	kfree(oca_blob);
> +e_free_pek:
> +	kfree(pek_blob);
> +e_free:
> +	kfree(data);
> +	return ret;
> +}
> +
>   static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   {
>   	void __user *argp = (void __user *)arg;
> @@ -333,6 +422,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   	case SEV_PEK_CSR:
>   		ret = sev_ioctl_do_pek_csr(&input);
>   		break;
> +	case SEV_PEK_CERT_IMPORT:
> +		ret = sev_ioctl_do_pek_cert_import(&input);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		goto out;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index eac850a97610..d535153ca82d 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -620,6 +620,8 @@ int sev_guest_df_flush(int *error);
>    */
>   int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>   
> +void *psp_copy_user_blob(u64 __user uaddr, u32 len);
> +
>   #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>   
>   static inline int
> @@ -648,6 +650,8 @@ sev_issue_cmd_external_user(struct file *filep,
>   	return -ENODEV;
>   }
>   
> +static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
> +
>   #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>   
>   #endif	/* __PSP_SEV_H__ */
> 
