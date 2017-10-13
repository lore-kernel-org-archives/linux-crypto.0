From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.1 12.8/31] crypto: ccp: Implement
 SEV_PEK_CERT_IMPORT ioctl command
Date: Fri, 13 Oct 2017 11:09:26 -0500
Message-ID: <5c47342c-0d0c-d14f-bf8a-027dfc21ec77@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-8-brijesh.singh@amd.com>
 <20171013145344.wfll3ltikl26zj2y@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171013145344.wfll3ltikl26zj2y@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/13/2017 09:53 AM, Borislav Petkov wrote:
...

>   
> -	if (copy_from_user(data, (void __user *)(uintptr_t)uaddr, len))
> +	if (copy_from_user(data, (void __user *)uaddr, len))
>   		goto e_free;


IIRC, typecast was needed for i386 build, but now we have depends on 
X86_64 hence I will go ahead and remove the typecast from all other places.


>   
>   	return data;
> @@ -409,8 +409,7 @@ static int sev_ioctl_pek_cert_import(struct sev_issue_cmd *argp)
>   	int ret, state, do_shutdown = 0;
>   	void *pek_blob, *oca_blob;
>   
> -	if (copy_from_user(&input, (void __user *)(uintptr_t) argp->data,
> -			   sizeof(struct sev_user_data_pek_cert_import)))
> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>   		return -EFAULT;
>   
>   	data = kzalloc(sizeof(*data), GFP_KERNEL);
> @@ -456,10 +455,10 @@ static int sev_ioctl_pek_cert_import(struct sev_issue_cmd *argp)
>   		do_shutdown = 1;
>   	}
>   
> -	ret = sev_handle_cmd(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
> +	ret = sev_do_cmd(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
>   
>   	if (do_shutdown)
> -		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
> +		sev_do_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
>   
>   e_free_oca:
>   	kfree(oca_blob);
> @@ -503,14 +502,14 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   		ret = sev_ioctl_pdh_gen(&input);
>   		break;
>   
> -	case SEV_PEK_CSR: {
> +	case SEV_PEK_CSR:
>   		ret = sev_ioctl_pek_csr(&input);
>   		break;
> -	}
> -	case SEV_PEK_CERT_IMPORT: {
> +
> +	case SEV_PEK_CERT_IMPORT:
>   		ret = sev_ioctl_pek_cert_import(&input);
>   		break;
> -	}
> +
>   	default:
>   		ret = -EINVAL;
>   		goto out;
> 
