Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E2BC54FD0
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 09:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D1BE2063A
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 09:23:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="C1bnSjEv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgD0JXc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 05:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgD0JXc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 05:23:32 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01117C0610D5;
        Mon, 27 Apr 2020 02:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1587979408;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=8AIbUURSuhkjyDjFCzUOEIbS/Bgw02Kr8qCPJU3dtH8=;
        b=C1bnSjEvzZ98dDls9h6GOT51TGbwl9zjH4AltxeWW9BSgGYZKJfSZp5lTV+Hrw3LsV
        HYvceydgef+E1mGfWtc22k8+tYJghFwfL65MiRDYpY/2ez+xU+lQ9ziJyPqfUSK7VIOn
        U/QPal+CbvSzoFOP9U+OPzutvOUEHukLdBkBjy95iasHo8nATE9ULHhWga++EyJ9UjIw
        Ohw24xRm9C3iXfeXbTmEnifVvnkVAHn0GSfaKhN7HD4Ka6GqWdzoflBiCHYDXFSQ+GgZ
        tAYteJvxxZ8QfPm7fkdHUQUO6s9wTNYneUyLJFud8EzycZBs4iE7ZjQIZZMYNhBW89rl
        OerA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaL/ScjTZA"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id u08bf3w3R9NFS1y
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 27 Apr 2020 11:23:15 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 13/14] crypto: sun8i-ce: Add support for the PRNG
Date:   Mon, 27 Apr 2020 11:23:15 +0200
Message-ID: <5634597.9v007L4FOH@tauon.chronox.de>
In-Reply-To: <20200427084137.GA8787@Red>
References: <1587736934-22801-1-git-send-email-clabbe@baylibre.com> <2397344.pSczEbEFGg@tauon.chronox.de> <20200427084137.GA8787@Red>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 27. April 2020, 10:41:37 CEST schrieb LABBE Corentin:

Hi Corentin,

> > Shouldn't they all be kzfree?
> 
> Yes
> Probably it miss also a memzero_explicit, I think that seeds/data are
> sensitive

kzfree uses memset_secure since very recently. So, kzfree should be all you 
need.


Ciao
Stephan


