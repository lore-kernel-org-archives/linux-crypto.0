From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [Part2 PATCH v6 14/38] crypto: ccp: Implement SEV_FACTORY_RESET
 ioctl command
Date: Tue, 24 Oct 2017 13:41:50 -0500
Message-ID: <753c954c-5daa-892f-df4c-155ef9518542@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-15-brijesh.singh@amd.com>
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
In-Reply-To: <20171020023413.122280-15-brijesh.singh@amd.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/19/2017 09:33 PM, Brijesh Singh wrote:
> The SEV_FACTORY_RESET command can be used by the platform owner to
> reset the non-volatile SEV related data. The command is defined in
> SEV spec section 5.4
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
>   drivers/crypto/ccp/psp-dev.c | 28 +++++++++++++++++++++++++++-
>   1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index e9966d5fc6c4..99f3761206da 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -176,7 +176,33 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
>   
>   static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   {
> -	return -ENOTTY;
> +	void __user *argp = (void __user *)arg;
> +	struct sev_issue_cmd input;
> +	int ret = -EFAULT;
> +
> +	if (ioctl != SEV_ISSUE_CMD)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&input, argp, sizeof(struct sev_issue_cmd)))
> +		return -EFAULT;
> +
> +	if (input.cmd > SEV_MAX)
> +		return -EINVAL;
> +
> +	switch (input.cmd) {
> +
> +	case SEV_FACTORY_RESET:
> +		ret = sev_do_cmd(SEV_CMD_FACTORY_RESET, 0, &input.error);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
> +		ret = -EFAULT;
> +out:
> +	return ret;
>   }
>   
>   static const struct file_operations sev_fops = {
> 
