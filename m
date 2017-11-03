From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v7 14/38] crypto: ccp: Implement SEV_FACTORY_RESET
 ioctl command
Date: Fri, 3 Nov 2017 13:42:25 +0100
Message-ID: <20171103124225.ivjtlb7j2mxyc3u5@pd.tnic>
References: <20171101211623.71496-1-brijesh.singh@amd.com>
 <20171101211623.71496-15-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171101211623.71496-15-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 01, 2017 at 04:15:59PM -0500, Brijesh Singh wrote:
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
> Acked-by: Gary R Hook <gary.hook@amd.com>

Acked-by: needs to go away too if you send a new revision with
non-trivial changes. Same as with Reviewed-by: tags.

> ---
>  drivers/crypto/ccp/psp-dev.c | 70 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 69 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index c61ca16096ca..a757bd1c34e8 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -235,9 +235,77 @@ static int sev_platform_shutdown(int *error)
>  	return rc;
>  }
>  
> +static int sev_platform_state(int *state, int *error)

It needs a verb in the name: sev_get_platform_state()

> +{
> +	int rc;
> +
> +	rc = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS,
> +				 psp_master->sev_status, error);
> +	if (rc)
> +		return rc;
> +
> +	*state = psp_master->sev_status->state;
> +	return rc;
> +}
> +
> +static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
> +{
> +	int state, rc;
> +
> +	rc = sev_platform_state(&state, &argp->error);
> +	if (rc)
> +		return rc;
> +
> +	if (state == SEV_STATE_WORKING) {

You could write a short blurb somewhere in a comment around here, what
the logic now is going to be for the SEV device: If in working state,
reset is denied. All other states accept it, because... <reasons>.

> +		argp->error = SEV_RET_INVALID_PLATFORM_STATE;

If you're going to write enum psp_ret_code types into argp->error, then
it needs to be of enum psp_ret_code type and not an int.

> +		return -EBUSY;
> +	}
> +
> +	if (state == SEV_STATE_INIT) {
> +		rc = __sev_platform_shutdown_locked(&argp->error);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return __sev_do_cmd_locked(SEV_CMD_FACTORY_RESET, 0, &argp->error);
> +}

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
