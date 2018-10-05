From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp: Remove forward declaration
Date: Fri, 5 Oct 2018 10:27:05 +0800
Message-ID: <20181005022705.v7jcz35oqaq5usao@gondor.apana.org.au>
References: <20180924172615.25591-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>
To: Nathan Chancellor <natechancellor@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180924172615.25591-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 24, 2018 at 10:26:15AM -0700, Nathan Chancellor wrote:
> Clang emits a warning about this construct:
> 
> drivers/crypto/ccp/sp-platform.c:36:36: warning: tentative array
> definition assumed to have one element
> static const struct acpi_device_id sp_acpi_match[];
>                                    ^
> 1 warning generated.
> 
> Just remove the forward declarations and move the initializations up
> so that they can be used in sp_get_of_version and sp_get_acpi_version.
> 
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/crypto/ccp/sp-platform.c | 53 +++++++++++++++-----------------
>  1 file changed, 25 insertions(+), 28 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
