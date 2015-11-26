From: Marek Vasut <marex@denx.de>
Subject: Re: mxs-dcp: Failed to register sha1 hash
Date: Thu, 26 Nov 2015 16:39:36 +0100
Message-ID: <201511261639.36548.marex@denx.de>
References: <CAOMZO5AyAAfZM07KYHCfRaeia8Ut1F6s=jsFg6C3YYzHx8C5UA@mail.gmail.com> <160969925.mts3FEnayM@myon.chronox.de> <CAOMZO5Dftr5-dRL_4_xMffc-Zd_r1gqZ0EX0Y8GKCWYg0gn6Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:33141 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbbKZPjk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Nov 2015 10:39:40 -0500
In-Reply-To: <CAOMZO5Dftr5-dRL_4_xMffc-Zd_r1gqZ0EX0Y8GKCWYg0gn6Ww@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, November 26, 2015 at 04:38:01 PM, Fabio Estevam wrote:
> Hi Stephan,
> 
> On Thu, Nov 26, 2015 at 1:25 PM, Stephan Mueller <smueller@chronox.de> wrote:
> > Briefly looking into drivers/crypto/mxs-dcp.c, it is an ahash and does
> > not contain halg.statesize in the algo definitions. Thus it looks very
> > much like the same issue that I see with ghash.
> 
> Thanks for your suggestion!
> 
> You are right: this makes the error goes away:
> 
> --- a/drivers/crypto/mxs-dcp.c
> +++ b/drivers/crypto/mxs-dcp.c
> @@ -836,6 +836,7 @@ static struct ahash_alg dcp_sha1_alg = {
>         .digest = dcp_sha_digest,
>         .halg   = {
>                 .digestsize     = SHA1_DIGEST_SIZE,
> +               .statesize      = sizeof(struct sha1_state),
>                 .base           = {
>                         .cra_name               = "sha1",
>                         .cra_driver_name        = "sha1-dcp",
> @@ -860,6 +861,7 @@ static struct ahash_alg dcp_sha256_alg = {
>         .digest = dcp_sha_digest,
>         .halg   = {
>                 .digestsize     = SHA256_DIGEST_SIZE,
> +               .statesize      = sizeof(struct sha256_state),
>                 .base           = {
>                         .cra_name               = "sha256",
>                         .cra_driver_name        = "sha256-dcp",
> 
> 
> Will submit it as a formal patch.

Excellent, thank you!

Best regards,
Marek Vasut
