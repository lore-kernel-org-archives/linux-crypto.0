From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v2 2/3] crypto: marvell: fix stack smashing in
 marvell/hash.c
Date: Fri, 9 Oct 2015 18:13:50 +0200
Message-ID: <20151009181350.75e76940@bbrezillon>
References: <20151009104637.GA18798@n2100.arm.linux.org.uk>
	<E1ZkVEH-0006GU-5m@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk> (by way of Thomas
	Petazzoni <thomas.petazzoni@free-electrons.com>)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34746 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933182AbbJIQNx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 12:13:53 -0400
In-Reply-To: <E1ZkVEH-0006GU-5m@rmk-PC.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 09 Oct 2015 11:48:49 +0100
Russell King <rmk+kernel@arm.linux.org.uk> (by way of Thomas Petazzoni
<thomas.petazzoni@free-electrons.com>) wrote:

> Several of the algorithms in marvell/hash.c have a statesize of zero.
> When an AF_ALG accept() on an already-accepted file descriptor to
> calls into hash_accept(), this causes:
> 
> 	char state[crypto_ahash_statesize(crypto_ahash_reqtfm(req))];
> 
> to be zero-sized, but we still pass this to:
> 
> 	err = crypto_ahash_export(req, state);
> 
> which proceeds to write to 'state' as if it was a "struct md5_state",
> "struct sha1_state" etc.  Add the necessary initialisers for the
> .statesize member.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/crypto/marvell/hash.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index e8d0d7128137..a259aced3b42 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -870,6 +870,7 @@ struct ahash_alg mv_md5_alg = {
>  	.import = mv_cesa_md5_import,
>  	.halg = {
>  		.digestsize = MD5_DIGEST_SIZE,
> +		.statesize = sizeof(struct md5_state),
>  		.base = {
>  			.cra_name = "md5",
>  			.cra_driver_name = "mv-md5",
> @@ -959,6 +960,7 @@ struct ahash_alg mv_sha1_alg = {
>  	.import = mv_cesa_sha1_import,
>  	.halg = {
>  		.digestsize = SHA1_DIGEST_SIZE,
> +		.statesize = sizeof(struct sha1_state),
>  		.base = {
>  			.cra_name = "sha1",
>  			.cra_driver_name = "mv-sha1",
> @@ -1048,6 +1050,7 @@ struct ahash_alg mv_sha256_alg = {
>  	.import = mv_cesa_sha256_import,
>  	.halg = {
>  		.digestsize = SHA256_DIGEST_SIZE,
> +		.statesize = sizeof(struct sha256_state),
>  		.base = {
>  			.cra_name = "sha256",
>  			.cra_driver_name = "mv-sha256",



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
