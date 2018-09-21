From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Miscellaneous SEV fixes
Date: Fri, 21 Sep 2018 13:46:08 +0800
Message-ID: <20180921054608.vll7blxtjxiy3dyp@gondor.apana.org.au>
References: <cover.1536959537.git.Janakarajan.Natarajan@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brijesh Singh <brijesh.singh@amd.com>
To: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1536959537.git.Janakarajan.Natarajan@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 14, 2018 at 05:32:02PM -0500, Janakarajan Natarajan wrote:
> The first patch provides a fix for a static checker warning.
> 
> The second patch allows for the SEV firmware blob, which will
> be searched for when updating SEV during PSP initialization,
> to be named based on the family and model of the processor.
> 
> Janakarajan Natarajan (2):
>   Fix static checker warning
>   Allow SEV firmware to be chosen based on Family and Model
> 
>  drivers/crypto/ccp/psp-dev.c | 46 +++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 41 insertions(+), 5 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
