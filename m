Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267E6C71133
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Aug 2023 11:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242681AbjHYLFX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242916AbjHYLFQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2023 07:05:16 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41C919BA;
        Fri, 25 Aug 2023 04:05:13 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qZUcd-007iZ5-EO; Fri, 25 Aug 2023 19:05:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Aug 2023 19:05:00 +0800
Date:   Fri, 25 Aug 2023 19:05:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Thore Sommer <public@thson.de>
Cc:     dhowells@redhat.com, davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X.509: if signature is unsupported skip validation
Message-ID: <ZOiK3Cn6mn6b63x+@gondor.apana.org.au>
References: <20230815112942.392572-1-public@thson.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815112942.392572-1-public@thson.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 15, 2023 at 02:29:42PM +0300, Thore Sommer wrote:
> When the hash algorithm for the signature is not available the digest size
> is 0 and the signature in the certificate is marked as unsupported.
> 
> When validating a self-signed certificate, this needs to be checked,
> because otherwise trying to validate the signature will fail with an
> warning:
> 
> Loading compiled-in X.509 certificates
> WARNING: CPU: 0 PID: 1 at crypto/rsa-pkcs1pad.c:537 \
> pkcs1pad_verify+0x46/0x12c
> ...
> Problem loading in-kernel X.509 certificate (-22)
> 
> Signed-off-by: Thore Sommer <public@thson.de>
> ---
>  crypto/asymmetric_keys/x509_public_key.c | 5 +++++
>  1 file changed, 5 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
