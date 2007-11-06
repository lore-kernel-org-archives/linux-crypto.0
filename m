From: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: geode: fix not inplace encryption
Date: Tue, 6 Nov 2007 14:30:40 -0700
Message-ID: <20071106213040.GA30907@cosmic.amd.com>
References: <20071106200155.GA28183@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, stable@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:48119 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbXKFVcJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2007 16:32:09 -0500
In-Reply-To: <20071106200155.GA28183@Chamillionaire.breakpoint.cc>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 06/11/07 21:01 +0100, Sebastian Siewior wrote:
> Currently the Geode AES module fails to encrypt or decrypt if
> the coherent bits are not set what is currently the case if the
> encryption does not occur inplace. However, the encryption works 
> on my Geode machine _only_ if the coherent bits are always set.
> 
> Cc: Jordan Crouse <jordan.crouse@amd.com>
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Acked-by: Jordan Crouse <jordan.crouse@amd.com>

Anything in the cache is suspect - turning on coherency is the best plan
to be rock solid.

> ---
>  drivers/crypto/geode-aes.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
> index f2d4fba..0ca92d4 100644
> --- a/drivers/crypto/geode-aes.c
> +++ b/drivers/crypto/geode-aes.c
> @@ -81,8 +81,7 @@ geode_aes_crypt(struct geode_aes_op *op)
>  	 * we don't need to worry
>  	 */
>  
> -	if (op->src == op->dst)
> -		flags |= (AES_CTRL_DCA | AES_CTRL_SCA);
> +	flags |= (AES_CTRL_DCA | AES_CTRL_SCA);
>  
>  	if (op->dir == AES_DIR_ENCRYPT)
>  		flags |= AES_CTRL_ENCRYPT;
> -- 
> 1.5.3.4
> 
> 
> 

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.
