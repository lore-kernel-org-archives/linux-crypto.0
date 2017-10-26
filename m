From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6.1 16/38] crypto: ccp: Implement SEV_PEK_GEN
 ioctl command
Date: Thu, 26 Oct 2017 16:22:01 +0200
Message-ID: <20171026142201.GB12359@nazgul.tnic>
References: <20171020023413.122280-17-brijesh.singh@amd.com>
 <20171023215519.32512-1-brijesh.singh@amd.com>
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
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171023215519.32512-1-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 23, 2017 at 04:55:19PM -0500, Brijesh Singh wrote:
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
> 
> Changes since v6:
>  * when sev_do_cmd() and sev_platform_shutdown() fails then propogate
>    the error status code from sev_do_cmd() because it can give us
>    much better reason for the failure.
> 
>  drivers/crypto/ccp/psp-dev.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
