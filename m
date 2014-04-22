From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/3] crypto: Fix potential leak in test_aead_speed() if aad_size is too big
Date: Wed, 23 Apr 2014 01:33:05 +0200
Message-ID: <201404230133.05256.marex@denx.de>
References: <20140421204439.7999f1c6@spike> <20140421204559.75b8aa71@spike>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tim.c.chen@linux.intel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Christian Engelmayer <cengelma@gmx.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140421204559.75b8aa71@spike>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Monday, April 21, 2014 at 08:45:59 PM, Christian Engelmayer wrote:
> Fix a potential memory leak in the error handling of test_aead_speed(). In
> case the size check on the associate data length parameter fails, the
> function goes through the wrong exit label. Reported by Coverity - CID
> 1163870.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
>  crypto/tcrypt.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 870be7b..1856d7f 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -282,6 +282,11 @@ static void test_aead_speed(const char *algo, int enc,
> unsigned int sec, unsigned int *b_size;
>  	unsigned int iv_len;
> 
> +	if (aad_size >= PAGE_SIZE) {

On an unrelated note ... Won't if (aad_size > PAGE_SIZE) be sufficient here?

Cheers!
