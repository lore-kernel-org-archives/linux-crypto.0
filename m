Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E270EC636CA
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACC2F61166
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbhGRMug (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jul 2021 08:50:36 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:32398 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbhGRMug (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jul 2021 08:50:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626612455;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=p1yAbhZMGLVQP3MorUaxRlVTjrDgJwphS8789zGmb64=;
    b=W3v6nXsdUzwxeYMLvhC/MUFgtHID84HfppTwTGN+tBlw1ojVv29CDMvUnW15CRSuti
    +yFrWVsN/2NgeOubU8g0N1WDP0tTd/msSdcFYLM4wcQjEdAxY9A3E3PTwc0W4XXmPJVa
    VLIlcGokDaNwujPHtGjIFEcdmbzb31ye2pkUhzYzJQH2raujIA+B1HipJgLEvJnjAQpw
    y/lUUQ+Hol2LT9pvZp4Bj/zm3hdn8JWDcLZ3MbBowg4CcGtOUIhBjISCWKsPIne9+DuO
    PcKVSrOMXvPzEpZzTyX43YMHj52h8klI51zn85z3YKgauCz1HuxyZ4QdjB/GWB2tZuN/
    bxCw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbLvSWMgk="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id 9043bbx6IClXES7
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 18 Jul 2021 14:47:33 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 06/11] nvme: Implement In-Band authentication
Date:   Sun, 18 Jul 2021 14:47:32 +0200
Message-ID: <1892727.xFJX624jkQ@positron.chronox.de>
In-Reply-To: <b90298b5-28e7-1a9a-6a8a-5ae3562c1bfa@suse.de>
References: <20210716110428.9727-1-hare@suse.de> <5959906.z61SFhVlds@positron.chronox.de> <b90298b5-28e7-1a9a-6a8a-5ae3562c1bfa@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Sonntag, 18. Juli 2021, 14:43:43 CEST schrieb Hannes Reinecke:

Hi Hannes,

> >> +	size += 2 * chap->hash_len;
> >> +	if (ctrl->opts->dhchap_auth) {
> >> +		get_random_bytes(chap->c2, chap->hash_len);
> > 
> > Why are you using CRYPTO_RNG_DEFAULT when you are using get_random_bytes
> > here?
> Errm ... do I?
> Seems that my crypto ignorance is showing here; 'get_random_bytes()' is
> the usual function we're using for drivers; if there is another way for
> crypto please enlighten me.

Apologies, I was looking at CONFIG_RNG where you set CRYPTO_RNG_DEFAULT. 
Please ignore my comment here.

Ciao
Stephan


