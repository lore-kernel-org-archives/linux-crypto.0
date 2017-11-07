From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [Part2 PATCH v8 14/38] crypto: ccp: Implement SEV_FACTORY_RESET
 ioctl command
Date: Tue, 7 Nov 2017 09:47:42 -0600
Message-ID: <233a2f09-9d00-48a0-7a45-956e020bf8cd@amd.com>
References: <20171106181130.68491-1-brijesh.singh@amd.com>
 <20171106181130.68491-15-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: bp@alien8.de, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171106181130.68491-15-brijesh.singh@amd.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 11/06/2017 12:11 PM, Brijesh Singh wrote:
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
>   drivers/crypto/ccp/psp-dev.c | 77 +++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 76 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 9915a6c604a3..b49583a45a55 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -232,9 +232,84 @@ static int sev_platform_shutdown(int *error)
>   	return rc;
>   }
>   
> +static int sev_get_platform_state(int *state, int *error)
> +{
> +	int rc;
> +
> +	rc = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS,
> +				 &psp_master->status_cmd_buf, error);
> +	if (rc)
> +		return rc;
> +
> +	*state = psp_master->status_cmd_buf.state;
> +	return rc;
> +}
> +
> +static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
> +{
> +	int state, rc;
> +
> +	/*
> +	 * The SEV spec requires that FACTORY_RESET must be issued in
> +	 * UNINIT state. Before we go further lets check if any guest is
> +	 * active.
> +	 *
> +	 * If FW is in WORKING state then deny the request otherwise issue
> +	 * SHUTDOWN command do INIT -> UNINIT before issuing the FACTORY_RESET.
> +	 *
> +	 */
> +	rc = sev_get_platform_state(&state, &argp->error);
> +	if (rc)
> +		return rc;
> +
> +	if (state == SEV_STATE_WORKING)
> +		return -EBUSY;
> +
> +	if (state == SEV_STATE_INIT) {
> +		rc = __sev_platform_shutdown_locked(&argp->error);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return __sev_do_cmd_locked(SEV_CMD_FACTORY_RESET, 0, &argp->error);
> +}
> +
>   static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   {
> -	return -ENOTTY;
> +	void __user *argp = (void __user *)arg;
> +	struct sev_issue_cmd input;
> +	int ret = -EFAULT;
> +
> +	if (!psp_master)
> +		return -ENODEV;
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
> +	mutex_lock(&sev_cmd_mutex);
> +
> +	switch (input.cmd) {
> +
> +	case SEV_FACTORY_RESET:
> +		ret = sev_ioctl_do_reset(&input);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
> +		ret = -EFAULT;
> +out:
> +	mutex_unlock(&sev_cmd_mutex);
> +
> +	return ret;
>   }
>   
>   static const struct file_operations sev_fops = {
> 
