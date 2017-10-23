From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 16/38] crypto: ccp: Implement SEV_PEK_GEN ioctl
 command
Date: Mon, 23 Oct 2017 11:32:40 +0200
Message-ID: <20171023093240.GC19523@nazgul.tnic>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-17-brijesh.singh@amd.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171020023413.122280-17-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 19, 2017 at 09:33:51PM -0500, Brijesh Singh wrote:
> The SEV_PEK_GEN command is used to generate a new Platform Endorsement
> Key (PEK). The command is defined in SEV spec section 5.6.
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
>  drivers/crypto/ccp/psp-dev.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 5c921b36bc23..1d7212da25a5 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -195,6 +195,24 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
> +{
> +	int ret, err;
> +
> +	ret = sev_platform_init(NULL, &argp->error);
> +	if (ret)
> +		return ret;
> +
> +	ret = sev_do_cmd(cmd, 0, &argp->error);

So this ret value gets potentially overwritten here. You need
to either handle the case properly when sev_do_cmd() fails and
sev_platform_shutdown() gets to issue SEV_CMD_SHUTDOWN (i.e., when it
gets overwritten), or not write into ret at all by initializing it to 0
at function entry.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
