From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2 0/2] Add new SEV commands
Date: Thu, 31 May 2018 00:28:19 +0800
Message-ID: <20180530162819.4xbwb3jbbx5dey24@gondor.apana.org.au>
References: <cover.1527274269.git.Janakarajan.Natarajan@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>
To: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1527274269.git.Janakarajan.Natarajan@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 25, 2018 at 03:23:28PM -0500, Janakarajan Natarajan wrote:
> This patchset adds two new SEV commands, introduced in SEV API v0.15
> and v0.16 respectively.
> 
> * DOWNLOAD_FIRMWARE allows the SEV firmware to be updated if a blob newer
>   than or similar to the exisiting build is available.
> 
> * GET_ID allows to query for a unique ID that can be used to retrieve the
>   Chip Endorsment Key (CEK) public key signed by the AMD SEV Signing Key
>   (ASK). 
> 
> v1->v2:
> * Added cover letter.
> * Misc changes based on Boris' feedback.
> 
> Janakarajan Natarajan (2):
>   crypto: ccp: Add DOWNLOAD_FIRMWARE SEV command
>   crypto: ccp: Add GET_ID SEV command
> 
>  drivers/crypto/ccp/psp-dev.c | 143 ++++++++++++++++++++++++++++++++++++++++---
>  drivers/crypto/ccp/psp-dev.h |   4 ++
>  include/linux/psp-sev.h      |  23 +++++++
>  include/uapi/linux/psp-sev.h |  12 ++++
>  4 files changed, 172 insertions(+), 10 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
