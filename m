Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB4DC636C9
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 15:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8FCB6115B
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 15:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhGQPGa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jul 2021 11:06:30 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:10413 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbhGQPG3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jul 2021 11:06:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626534208;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=7WJUP7CO371Ox38MLS3F6Pu/++9FjOfLN9lRQi3hrS0=;
    b=fhIgSQhlyEv7Y3ASIp1IWSiIQDJz/w3kvFQNMjYiIClN7mSXQ6Y3gerLG6EIwtE5fq
    qUVrDtGMi0JvXlWKv32dUiUYMD3w98w5Gwm7u7xkDqUi42JfnoL1M5u/cuQjYm9ll/em
    82TigQ4h3N4Ls1DczcSqUPpfm0wBacohxrgLSSFhH1KMLaKvweWESlwSHur2zXoToMGg
    zRz2gRqEARmPaW0N455fFi18wTC/ZnC5uzMXsIbf+qvzVl8c1BK0QyDsAvJ/69pGcfPF
    MoxB21fEeozwV9BzqefRtCgtus6jCIUaUBtOCg/ksoUvggI+VKn/fLRk06Vyf2IInURe
    ywRA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSZEqc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id 9043bbx6HF3RC9v
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 17 Jul 2021 17:03:27 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/11] crypto/ffdhe: Finite Field DH Ephemeral Parameters
Date:   Sat, 17 Jul 2021 17:03:26 +0200
Message-ID: <29491463.gfxVf8N7Et@positron.chronox.de>
In-Reply-To: <20210716110428.9727-4-hare@suse.de>
References: <20210716110428.9727-1-hare@suse.de> <20210716110428.9727-4-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 16. Juli 2021, 13:04:20 CEST schrieb Hannes Reinecke:

Hi Hannes,

> +#include <linux/module.h>
> +#include <crypto/internal/kpp.h>
> +#include <crypto/kpp.h>
> +#include <crypto/dh.h>
> +#include <linux/mpi.h>
> +
> +/*
> + * ffdhe2048 generator (g), modulus (p) and group size (q)
> + */
> +const u8 ffdhe2048_g[] = { 0x02 };

What about using static const here (and for all the following groups)?

Ciao
Stephan


