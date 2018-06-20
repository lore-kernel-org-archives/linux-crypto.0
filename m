From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] crypto: testmgr: add test vectors for skein
Date: Wed, 20 Jun 2018 10:56:38 -0700
Message-ID: <20180620175638.GB76265@gmail.com>
References: <20180620105714.18359-1-j.m.torrespalma@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
To: Juan Manuel Torres Palma <j.m.torrespalma@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180620105714.18359-1-j.m.torrespalma@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Juan,

On Wed, Jun 20, 2018 at 07:57:14PM +0900, Juan Manuel Torres Palma wrote:
> Adds test vectors specified in skein v1.3
> specification. The main code is still in staging
> directory, but this is required to eventually be
> moved to the crypto directory.
> 
> Signed-off-by: Juan Manuel Torres Palma <j.m.torrespalma@gmail.com>
> ---
>  crypto/testmgr.c |  21 ++++++
>  crypto/testmgr.h | 203 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 224 insertions(+)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 11e45352fd0b..9fa08cbc8852 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -3453,6 +3453,27 @@ static const struct alg_test_desc alg_test_descs[] = {
>  		.suite = {
>  			.hash = __VECS(sha512_tv_template)
>  		}
> +	}, {
> +		.alg = "skein1024",
> +		.test = alg_test_hash,
> +		.fips_allowed = 1,

Are you sure Skein should be on the "FIPS allowed" list?  I'm not particularly
familiar with FIPS, but my understanding is that the fips_allowed flag is only
supposed to be set on specific "approved" algorithms.  So if you're unsure, it
shouldn't be set.

Eric
