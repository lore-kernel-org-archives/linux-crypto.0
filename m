From: Fabio Estevam <festevam@gmail.com>
Subject: Re: mxs-dcp: Failed to register sha1 hash
Date: Thu, 26 Nov 2015 13:38:01 -0200
Message-ID: <CAOMZO5Dftr5-dRL_4_xMffc-Zd_r1gqZ0EX0Y8GKCWYg0gn6Ww@mail.gmail.com>
References: <CAOMZO5AyAAfZM07KYHCfRaeia8Ut1F6s=jsFg6C3YYzHx8C5UA@mail.gmail.com>
	<160969925.mts3FEnayM@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34401 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbKZPiD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Nov 2015 10:38:03 -0500
Received: by ioir85 with SMTP id r85so91199833ioi.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2015 07:38:02 -0800 (PST)
In-Reply-To: <160969925.mts3FEnayM@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On Thu, Nov 26, 2015 at 1:25 PM, Stephan Mueller <smueller@chronox.de> wrote:

> Briefly looking into drivers/crypto/mxs-dcp.c, it is an ahash and does not
> contain halg.statesize in the algo definitions. Thus it looks very much like
> the same issue that I see with ghash.

Thanks for your suggestion!

You are right: this makes the error goes away:

--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -836,6 +836,7 @@ static struct ahash_alg dcp_sha1_alg = {
        .digest = dcp_sha_digest,
        .halg   = {
                .digestsize     = SHA1_DIGEST_SIZE,
+               .statesize      = sizeof(struct sha1_state),
                .base           = {
                        .cra_name               = "sha1",
                        .cra_driver_name        = "sha1-dcp",
@@ -860,6 +861,7 @@ static struct ahash_alg dcp_sha256_alg = {
        .digest = dcp_sha_digest,
        .halg   = {
                .digestsize     = SHA256_DIGEST_SIZE,
+               .statesize      = sizeof(struct sha256_state),
                .base           = {
                        .cra_name               = "sha256",
                        .cra_driver_name        = "sha256-dcp",


Will submit it as a formal patch.

Thanks!
