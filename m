From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v7 19/38] crypto: ccp: Implement
 SEV_PEK_CERT_IMPORT ioctl command
Date: Sat, 4 Nov 2017 11:22:07 +0100
Message-ID: <20171104091530.ixhp6cysku54fzij@pd.tnic>
References: <20171101211623.71496-1-brijesh.singh@amd.com>
 <20171101211623.71496-20-brijesh.singh@amd.com>
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
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171101211623.71496-20-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 01, 2017 at 04:16:04PM -0500, Brijesh Singh wrote:
> The SEV_PEK_CERT_IMPORT command can be used to import the signed PEK
> certificate. The command is defined in SEV spec section 5.8.
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
>  drivers/crypto/ccp/psp-dev.c | 81 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      |  4 +++
>  2 files changed, 85 insertions(+)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
