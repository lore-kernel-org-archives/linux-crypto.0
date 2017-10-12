From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.2 12.3/31] crypto: ccp: Implement
 SEV_FACTORY_RESET ioctl command
Date: Thu, 12 Oct 2017 16:13:12 +0200
Message-ID: <20171012141312.trux34l66efvqnig@pd.tnic>
References: <20171007010607.78088-3-brijesh.singh@amd.com>
 <20171011165521.115904-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171011165521.115904-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 11, 2017 at 11:55:21AM -0500, Brijesh Singh wrote:
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
> ---
> 
> Changes since v5.1:
>  * rename sev_handle_cmd -> sev_do_cmd (from Boris)
>  * skip copy_to_user when invalid cmd id is passed (from Boris)
>  * use SEV_MAX instead of SEV_CMD_MAX to check for invalid command
> 
>  drivers/crypto/ccp/psp-dev.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 175cb3c3b8ef..a9c885a39910 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -179,7 +179,34 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
>  
>  static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  {
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
> +	case SEV_FACTORY_RESET: {
> +		ret = sev_do_cmd(SEV_CMD_FACTORY_RESET, 0, &input.error);
> +		break;
> +	}

Those curly braces are still here. Just use my diff I sent you by saving
the mail to a file and doing

$ patch -p1 --dry-run -i /tmp/boris.mail

ontop of this patch. If it applies ok, remove the --dry-run.

Then you can do changes ontop. This way you won't miss changes I've sent
you.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
