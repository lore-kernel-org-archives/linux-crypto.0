From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [Part2 PATCH v6 15/38] crypto: ccp: Implement SEV_PLATFORM_STATUS
 ioctl command
Date: Tue, 24 Oct 2017 13:41:26 -0500
Message-ID: <b3f6c45c-409e-f9af-d669-bbc5e9c1f5a7@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-16-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: bp@alien8.de, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171020023413.122280-16-brijesh.singh@amd.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/19/2017 09:33 PM, Brijesh Singh wrote:
> The SEV_PLATFORM_STATUS command can be used by the platform owner to
> get the current status of the platform. The command is defined in
> SEV spec section 5.5.
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
> Improvements-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/crypto/ccp/psp-dev.c | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 99f3761206da..5c921b36bc23 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -174,6 +174,27 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
>   	return ret;
>   }
>   
> +static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
> +{
> +	struct sev_user_data_status *data;
> +	int ret;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	ret = sev_do_cmd(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
> +	if (ret)
> +		goto e_free;
> +
> +	if (copy_to_user((void __user *)argp->data, data, sizeof(*data)))
> +		ret = -EFAULT;
> +
> +e_free:
> +	kfree(data);
> +	return ret;
> +}
> +
>   static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   {
>   	void __user *argp = (void __user *)arg;
> @@ -194,6 +215,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   	case SEV_FACTORY_RESET:
>   		ret = sev_do_cmd(SEV_CMD_FACTORY_RESET, 0, &input.error);
>   		break;
> +	case SEV_PLATFORM_STATUS:
> +		ret = sev_ioctl_do_platform_status(&input);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		goto out;
> 
