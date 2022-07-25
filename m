Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9829C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 21:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbiGYVum (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 17:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237340AbiGYVuV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 17:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752FB26D4
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 14:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1015EB81134
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 21:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D5DC341D4
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 21:50:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="key not found in DNS" (0-bit key) header.d=opensuse.org header.i=@opensuse.org header.b="NWwLCWgD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=opensuse.org;
        s=20210105; t=1658785809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9+idQqBWdX5mURxuBE4eJRKFRCSZyA5bMwG+uu+jVjQ=;
        b=NWwLCWgDFfEUWkioLqbm9ZECVuyxCQq+mwopu1MRZGsy9KH50bPpuuCCQA0cexc3ePXnUz
        pJIs1Ro3g7ShR5n8ZjBQXr7D88/3Pogxxf++jX/tr6t0SOIyzRiy0rDsdM4HCa9P6wy6rt
        vuM8Aou/b2v2CfvsaMWi+asXYehu9CQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ba595037 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 25 Jul 2022 21:50:09 +0000 (UTC)
MIME-Version: 1.0
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
 <6bf352e9-1312-40de-4733-3219721b343c@linaro.org> <20220725153303.GF7074@brightrain.aerifal.cx>
 <878rohp2ll.fsf@oldenburg.str.redhat.com> <20220725174430.GI7074@brightrain.aerifal.cx>
In-Reply-To: <20220725174430.GI7074@brightrain.aerifal.cx>
From:   =?UTF-8?Q?Cristian_Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Date:   Mon, 25 Jul 2022 14:33:05 -0400
Message-ID: <CAPBLoAe89Pwt=F_jcZirVXQA7JtugV+5+BWHBt0RaZka1y0K=g@mail.gmail.com>
Subject: Re: arc4random - are you sure we want these?
To:     Rich Felker <dalias@libc.org>
Cc:     Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org,
        Michael@phoronix.com, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 25, 2022 at 1:44 PM Rich Felker <dalias@libc.org> wrote:

> Then don't fallback to /dev/urandom.

Those are my thoughts as well.. but __libc_fatal() if there is no
usable getrandom syscall with the needed semantics, in short making
this interface usable only when the kernel is.

This is quite drastic, but probably the only sane way to go.
