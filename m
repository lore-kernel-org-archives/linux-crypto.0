From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto-2.6] crypto: ccp: add timeout support in the SEV
 command
Date: Tue, 4 Sep 2018 13:19:30 +0800
Message-ID: <20180904051930.5kvyyu75ym5mubuz@gondor.apana.org.au>
References: <1534367485-4386-1-git-send-email-brijesh.singh@amd.com>
 <1534367485-4386-2-git-send-email-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        Gary Hook <Gary.Hook@amd.com>, linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1534367485-4386-2-git-send-email-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 15, 2018 at 04:11:25PM -0500, Brijesh Singh wrote:
> Currently, the CCP driver assumes that the SEV command issued to the PSP
> will always return (i.e. it will never hang).  But recently, firmware bugs
> have shown that a command can hang.  Since of the SEV commands are used
> in probe routines, this can cause boot hangs and/or loss of virtualization
> capabilities.
> 
> To protect against firmware bugs, add a timeout in the SEV command
> execution flow.  If a command does not complete within the specified
> timeout then return -ETIMEOUT and stop the driver from executing any
> further commands since the state of the SEV firmware is unknown.
> 
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Gary Hook <Gary.Hook@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/psp-dev.c | 46 +++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 41 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
