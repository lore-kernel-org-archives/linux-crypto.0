From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 18/38] crypto: ccp: Implement SEV_PEK_CSR ioctl
 command
Date: Mon, 23 Oct 2017 14:49:16 +0200
Message-ID: <20171023124916.GC24208@nazgul.tnic>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-19-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.skyhub.de ([5.9.137.197]:43554 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751296AbdJWMtV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 08:49:21 -0400
Content-Disposition: inline
In-Reply-To: <20171020023413.122280-19-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 19, 2017 at 09:33:53PM -0500, Brijesh Singh wrote:
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
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/psp-dev.c | 69 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)

Improvements-by: Borislav Petkov <bp@suse.de>

> +static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
> +{
> +	struct sev_user_data_pek_csr input;
> +	struct sev_data_pek_csr *data;
> +	void *blob = NULL;
> +	int ret, err;
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
> +	ret = sev_platform_init(NULL, &argp->error);
> +	if (ret)
> +		goto e_free_blob;
> +
> +	ret = sev_do_cmd(SEV_CMD_PEK_CSR, data, &argp->error);

This is the same issue: nothing is handling the case where sev_do_cmd()
here fails. If it doesn't matter, then you should simply do:

	sev_do_cmd(SEV_CMD_PEK_CSR, data, &argp->error);

along with explaining why we don't care about the command failing. But
simply writing into ret to overwrite it later, looks strange.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
