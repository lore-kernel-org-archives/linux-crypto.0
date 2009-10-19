From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/7] crypto: testmgr: fix warning
Date: Mon, 19 Oct 2009 15:52:47 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0910191551030.8582@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com> <1255906474-25091-4-git-send-email-felipe.contreras@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jarod Wilson <jarod@redhat.com>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	linux-crypto@vger.kernel.org
To: Felipe Contreras <felipe.contreras@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbZJSNwo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2009 09:52:44 -0400
In-Reply-To: <1255906474-25091-4-git-send-email-felipe.contreras@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 19 Oct 2009, Felipe Contreras wrote:

> crypto/testmgr.c: In function ?test_cprng?:
> crypto/testmgr.c:1204: warning: ?err? may be used uninitialized in this function
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  crypto/testmgr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 6d5b746..1f2357b 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1201,7 +1201,7 @@ static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
>  		      unsigned int tcount)
>  {
>  	const char *algo = crypto_tfm_alg_driver_name(crypto_rng_tfm(tfm));
> -	int err, i, j, seedsize;
> +	int err = 0, i, j, seedsize;
>  	u8 *seed;
>  	char result[32];

As it is not obvious to me immediately why/whether tcount couldn't be zero 
(which would cause uninitialized use of 'err'), I am not merging this 
through trivial tree. Herbert?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
