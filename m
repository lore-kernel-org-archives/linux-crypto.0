From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [Part2 PATCH v6.1 20/38] crypto: ccp: Implement
 SEV_PDH_CERT_EXPORT ioctl command
Date: Tue, 24 Oct 2017 13:43:05 -0500
Message-ID: <bbdc1f8f-55b8-96a4-643e-74f1f1f83cdf@amd.com>
References: <20171020023413.122280-21-brijesh.singh@amd.com>
 <20171023221949.47898-1-brijesh.singh@amd.com>
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
In-Reply-To: <20171023221949.47898-1-brijesh.singh@amd.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/23/2017 05:19 PM, Brijesh Singh wrote:
> The SEV_PDH_CERT_EXPORT command can be used to export the PDH and its
> certificate chain. The command is defined in SEV spec section 5.10.
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
>   drivers/crypto/ccp/psp-dev.c | 110 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 110 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 108fc06bcdb3..b9f594cb10c1 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -390,6 +390,113 @@ static int sev_ioctl_do_pek_cert_import(struct sev_issue_cmd *argp)
>   	return ret;
>   }
>   
> +static int sev_ioctl_do_pdh_cert_export(struct sev_issue_cmd *argp)
> +{
> +	struct sev_user_data_pdh_cert_export input;
> +	void *pdh_blob = NULL, *cert_blob = NULL;
> +	struct sev_data_pdh_cert_export *data;
> +	int ret, err;
> +
> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> +		return -EFAULT;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	/* Userspace wants to query the certificate length */
> +	if (!input.pdh_cert_address || !input.pdh_cert_len ||
> +	    !input.cert_chain_address || !input.cert_chain_address)
> +		goto cmd;
> +
> +	/* allocate a physically contiguous buffer to store the PDH blob */
> +	if (!access_ok(VERIFY_WRITE, input.pdh_cert_address, input.pdh_cert_len) ||
> +	    (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)) {
> +		ret = -EFAULT;
> +		goto e_free;
> +	}
> +
> +	pdh_blob = kmalloc(input.pdh_cert_len, GFP_KERNEL);
> +	if (!pdh_blob) {
> +		ret = -ENOMEM;
> +		goto e_free;
> +	}
> +
> +	data->pdh_cert_address = __psp_pa(pdh_blob);
> +	data->pdh_cert_len = input.pdh_cert_len;
> +
> +	/* allocate a physically contiguous buffer to store the cert chain blob */
> +	if (!access_ok(VERIFY_WRITE, input.cert_chain_address, input.cert_chain_len) ||
> +	    (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)) {
> +		ret = -EFAULT;
> +		goto e_free_pdh;
> +	}
> +
> +	cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
> +	if (!cert_blob) {
> +		ret = -ENOMEM;
> +		goto e_free_pdh;
> +	}
> +
> +	data->cert_chain_address = __psp_pa(cert_blob);
> +	data->cert_chain_len = input.cert_chain_len;
> +
> +cmd:
> +	ret = sev_platform_init(NULL, &argp->error);
> +	if (ret)
> +		goto e_free_cert;
> +
> +	ret = sev_do_cmd(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
> +
> +	/*
> +	 * If we query the length, FW responded with expected data
> +	 */
> +	input.cert_chain_len = data->cert_chain_len;
> +	input.pdh_cert_len = data->pdh_cert_len;
> +
> +	if (sev_platform_shutdown(&err)) {
> +		/*
> +		 * If both sev_do_cmd() and sev_platform_shutdown() commands
> +		 * failed then propogate the error code from the sev_do_cmd()
> +		 * because it contains a useful status code for the command
> +		 * failure.
> +		 */
> +		if (ret)
> +			goto e_free_cert;
> +
> +		ret = -EIO;
> +		argp->error = err;
> +		goto e_free_cert;
> +	}
> +
> +	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
> +		ret = -EFAULT;
> +		goto e_free_cert;
> +	}
> +
> +	if (pdh_blob) {
> +		if (copy_to_user((void __user *)input.pdh_cert_address,
> +				 pdh_blob, input.pdh_cert_len)) {
> +			ret = -EFAULT;
> +			goto e_free_cert;
> +		}
> +	}
> +
> +	if (cert_blob) {
> +		if (copy_to_user((void __user *)input.cert_chain_address,
> +				 cert_blob, input.cert_chain_len))
> +			ret = -EFAULT;
> +	}
> +
> +e_free_cert:
> +	kfree(cert_blob);
> +e_free_pdh:
> +	kfree(pdh_blob);
> +e_free:
> +	kfree(data);
> +	return ret;
> +}
> +
>   static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   {
>   	void __user *argp = (void __user *)arg;
> @@ -425,6 +532,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   	case SEV_PEK_CERT_IMPORT:
>   		ret = sev_ioctl_do_pek_cert_import(&input);
>   		break;
> +	case SEV_PDH_CERT_EXPORT:
> +		ret = sev_ioctl_do_pdh_cert_export(&input);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		goto out;
> 
