Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408D3C12002
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 05:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F2EA610A5
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 05:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhGSFqg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 01:46:36 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:14817 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhGSFqg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 01:46:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626673410;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Nm/KOK1c4wxhJ3C7gNiEaHozX/gtQT+c7GIAXjet9TE=;
    b=aHl95kqg03WPaR3l9V/Fh4+S22dc/sou4yCpQALv12P4yJaGHbU8x/OEtkwpLxZcrX
    PhOA5T7Lyr6kLoDtMZPtbew5k5ZPzc0zFHlN4vAeSDgt0tr93m1yrpzrU6LOuGoAClsV
    TFqh7HY82oJYyJZahUSCOXWLvUpXkk6dEgVmK7fCHRoLKIF+R84S6qLOnu+xrI7vNOg/
    t6+YRm02TYFPd+iP7l28Gj68DODJRvgUy9L2SU2VYKVHf06Ak3usTjV5jnt+CP0p1rqG
    qNha1919BCQ23nsBUL1J7MDDyXsBEZUTrZJrrfUik1UKaFLQ+WPYOtIGGm151g7qr1Lv
    HP1g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJSlBkMRYMkE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id 9043bbx6J5hTFoB
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 19 Jul 2021 07:43:29 +0200 (CEST)
Message-ID: <6604f8be7a73f727cbfae7f93a74da706e46befc.camel@chronox.de>
Subject: Re: linux-next: Fixes tag needs some work in the crypto tree
From:   Stephan Mueller <smueller@chronox.de>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Date:   Mon, 19 Jul 2021 07:43:29 +0200
In-Reply-To: <20210719081320.1d205c98@canb.auug.org.au>
References: <20210719081320.1d205c98@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, dem 19.07.2021 um 08:13 +1000 schrieb Stephen Rothwell:
> Hi all,

Hi Stephen, Herbert
> 
> In commit
> 
>   5261cdf457ce ("crypto: drbg - select SHA512")
> 
> Fixes tag
> 
>   Fixes: 9b7b94683a9b "crypto: DRBG - switch to HMAC SHA512 DRBG as default
> 
> has these problem(s):
> 
>   - Subject has leading but no trailing quotes
> 
> Please do not split Fixes tags over more than one line.
> 

Thank you for the report.

Herbert, how do we go about this fix? I can surely prepare another patch. But
considering that the old patch is already in the git tree, are you considering
to revert it?

Thanks
Stephan

