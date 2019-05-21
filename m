Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C5FC04E87
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 18:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 261DA2184E
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 18:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfEUSK5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 14:10:57 -0400
Received: from smtprelay0210.hostedemail.com ([216.40.44.210]:43079 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728103AbfEUSK5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 14:10:57 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 55C4A837F27F;
        Tue, 21 May 2019 18:10:56 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: boy77_25271b82e5354
X-Filterd-Recvd-Size: 2508
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Tue, 21 May 2019 18:10:55 +0000 (UTC)
Message-ID: <3bd9fef9b11ccf49171227e9507cda0a899f8f9d.camel@perches.com>
Subject: Re: [PATCH v1 02/15] crypto: talitos - rename alternative AEAD
 algos.
From:   Joe Perches <joe@perches.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Andy Whitcroft <apw@canonical.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 21 May 2019 11:10:54 -0700
In-Reply-To: <3ac55e59-a75c-0b9a-be24-148007bb522e@c-s.fr>
References: <cover.1558445259.git.christophe.leroy@c-s.fr>
         <1449c1a24e2e06ac6c8c2e1b7f73feedfd51894c.1558445259.git.christophe.leroy@c-s.fr>
         <3ac55e59-a75c-0b9a-be24-148007bb522e@c-s.fr>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2019-05-21 at 17:54 +0000, Christophe Leroy wrote:
> Hi Joe & Andy
[]
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
[]
> > @@ -2356,7 +2356,7 @@ static struct talitos_alg_template driver_algs[] = {
> >   			.base = {
> >   				.cra_name = "authenc(hmac(sha1),cbc(aes))",
> >   				.cra_driver_name = "authenc-hmac-sha1-"
> > -						   "cbc-aes-talitos",
> > +						   "cbc-aes-talitos-hsna",
> 
> checkpatch reports the following warning on the above:
> 
> WARNING: quoted string split across lines
> #27: FILE: drivers/crypto/talitos.c:2359:
>   				.cra_driver_name = "authenc-hmac-sha1-"
> +						   "cbc-aes-talitos-hsna",
> 
> 
> But when I fixes the patch as follows, I get another warning:
> 
> @@ -2355,8 +2355,7 @@ static struct talitos_alg_template driver_algs[] = {
>   		.alg.aead = {
>   			.base = {
>   				.cra_name = "authenc(hmac(sha1),cbc(aes))",
> -				.cra_driver_name = "authenc-hmac-sha1-"
> -						   "cbc-aes-talitos",
> +				.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos-hsna",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC,
>   			},
> 
> 
> 
> WARNING: line over 80 characters
> #28: FILE: drivers/crypto/talitos.c:2358:
> +				.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos-hsna",
> 
> 
> So, how should this be fixed ?

For at least now, by ignoring this checkpatch message.

It's a brainless script.  You are not brainless.

