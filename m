From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v7 18/38] crypto: ccp: Implement SEV_PEK_CSR ioctl
 command
Date: Fri, 3 Nov 2017 20:42:09 +0100
Message-ID: <20171103194209.epitwoakf3c3qlk5@pd.tnic>
References: <20171101211623.71496-1-brijesh.singh@amd.com>
 <20171101211623.71496-19-brijesh.singh@amd.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.skyhub.de ([5.9.137.197]:57976 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752465AbdKCTmV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 15:42:21 -0400
Content-Disposition: inline
In-Reply-To: <20171101211623.71496-19-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 01, 2017 at 04:16:03PM -0500, Brijesh Singh wrote:
> The SEV_PEK_CSR command can be used to generate a PEK certificate
> signing request. The command is defined in SEV spec section 5.7.
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
> ---
>  drivers/crypto/ccp/psp-dev.c | 68 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 42991c2e9085..4e2f9d037f0a 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -298,6 +298,71 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
>  	return __sev_do_cmd_locked(cmd, 0, &argp->error);
>  }
>  
> +static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
> +{
> +	struct sev_user_data_pek_csr input;
> +	struct sev_data_pek_csr *data;
> +	void *blob = NULL;
> +	int ret;
> +
> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> +		return -EFAULT;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	/* userspace wants to query CSR length */
> +	if (!input.address || !input.length)
> +		goto cmd;
> +
> +	/* allocate a physically contiguous buffer to store the CSR blob */
> +	if (!access_ok(VERIFY_WRITE, input.address, input.length) ||
> +	    input.length > SEV_FW_BLOB_MAX_SIZE) {
> +		ret = -EFAULT;
> +		goto e_free;
> +	}
> +
> +	blob = kmalloc(input.length, GFP_KERNEL);
> +	if (!blob) {
> +		ret = -ENOMEM;
> +		goto e_free;
> +	}
> +
> +	data->address = __psp_pa(blob);
> +	data->len = input.length;
> +
> +cmd:
> +	if (psp_master->sev_state == SEV_STATE_UNINIT) {
> +		ret = __sev_platform_init_locked(psp_master->sev_init, &argp->error);

Right, you're passing psp_master->sev_init (or whatever you're going to
end up calling it) down but then in __sev_platform_init_locked() you end
up doing

        if (!data)
                data = &psp->cmd_buf;

which looks silly.

IOW, if not really required, __sev_platform_init_locked() could have
only one argument instead:

static int __sev_platform_init_locked(int *error)

unless some later patch needs to pass in a different command buffer. I
guess I need to keep on reviewing...

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
