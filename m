Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A366C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 03:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1DA92077B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 03:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576035073;
	bh=dA0Xef0QUmlZ+r0pHhzospDvrRyZ+MDNb2N1fvRIu74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=yL4bq4UeI1WNtU04Njr4EBnnXYgl3EyzLqbnwbSuXRhwFQXZAShBJKtAnajmOHUCY
	 U2X/bhZQXPlMnFxfU2uK/9h/v6L4dCpXnQ418l7/UkFjcbfq+EXVHskY6J/PF5FCZs
	 tY0qmfyoDoNcP1JGjpo37BaYNwRJlm1VcXYkvttw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfLKDbM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 22:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbfLKDbM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 22:31:12 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 864EB2073B;
        Wed, 11 Dec 2019 03:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576035071;
        bh=dA0Xef0QUmlZ+r0pHhzospDvrRyZ+MDNb2N1fvRIu74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GdSyi0EynEDQ1W8SxkWpAzK3bbsWxl461zryQYGtU9WMBtUnO4a3QeiHV+I0laVOj
         ZUuKNP164ozvdh54Jr/i4VDo8m2nbdL+NOvwXonSmwbRp8onlMC2vULidCXur9dy9m
         3BWKkH49qKklYGdW1STzhJLXci6f/GsnOz0RRX0Y=
Date:   Tue, 10 Dec 2019 19:31:10 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 2/3] crypto: padlock-sha - Use init_tfm/exit_tfm
 interface
Message-ID: <20191211033110.GE732@sol.localdomain>
References: <20191208054229.h4smagmiuqhxxc6w@gondor.apana.org.au>
 <E1idpLI-0008Rc-L5@gondobar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1idpLI-0008Rc-L5@gondobar>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 08, 2019 at 01:42:52PM +0800, Herbert Xu wrote:
> @@ -231,6 +225,8 @@ static struct shash_alg sha1_alg = {
>  	.final  	=	padlock_sha1_final,
>  	.export		=	padlock_sha_export,
>  	.import		=	padlock_sha_import,
> +	.init_tfm	=	padlock_cra_init,
> +	.exit_tfm	=	padlock_cra_exit,
>  	.descsize	=	sizeof(struct padlock_sha_desc),
>  	.statesize	=	sizeof(struct sha1_state),

Nit: these should be renamed to padlock_sha_init_tfm() and
padlock_sha_exit_tfm().

- Eric
