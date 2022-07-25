Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91920C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 21:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiGYV60 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 17:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGYV6Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 17:58:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7335B1EC45
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 14:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F9E6612F1
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 21:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29238C341C6
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 21:58:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="key not found in DNS" (0-bit key) header.d=libc.org header.i=@libc.org header.b="OsR7xu1W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libc.org; s=20210105;
        t=1658786301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cYfe2ZrAUJl0cv5K4oqcBrhs+2+NT2q9lAMJzQL8js0=;
        b=OsR7xu1WYs0PQBS85AtHd9ChG6lv8qn4STzewRcTksdzKWn/+SYRZH//yVHaWCAXqZnLDr
        grFNry0l9EAhkKZN7bHMiGbI9N5KLYoEsHKNmRV3z70Qhbk19kb4Jezl9M4r0ciicsoDrR
        77/M0I3PfXw0ViFqVEaZ4E1HiYEytcA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8ce13a4c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 25 Jul 2022 21:58:21 +0000 (UTC)
Date:   Mon, 25 Jul 2022 14:49:30 -0400
From:   Rich Felker <dalias@libc.org>
To:     Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Cc:     Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org,
        Michael@phoronix.com, jann@thejh.net, linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
Message-ID: <20220725184929.GJ7074@brightrain.aerifal.cx>
References: <YtwgTySJyky0OcgG@zx2c4.com>
 <Ytwg8YEJn+76h5g9@zx2c4.com>
 <6bf352e9-1312-40de-4733-3219721b343c@linaro.org>
 <20220725153303.GF7074@brightrain.aerifal.cx>
 <878rohp2ll.fsf@oldenburg.str.redhat.com>
 <20220725174430.GI7074@brightrain.aerifal.cx>
 <CAPBLoAe89Pwt=F_jcZirVXQA7JtugV+5+BWHBt0RaZka1y0K=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPBLoAe89Pwt=F_jcZirVXQA7JtugV+5+BWHBt0RaZka1y0K=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 25, 2022 at 02:33:05PM -0400, Cristian Rodríguez via Libc-alpha wrote:
> On Mon, Jul 25, 2022 at 1:44 PM Rich Felker <dalias@libc.org> wrote:
> 
> > Then don't fallback to /dev/urandom.
> 
> Those are my thoughts as well.. but __libc_fatal() if there is no
> usable getrandom syscall with the needed semantics, in short making
> this interface usable only when the kernel is.
> 
> This is quite drastic, but probably the only sane way to go.

You can at least try the sysctl and possibly also /dev approaches and
only treat this as fatal as a last resort. If you can inspect
entropy_avail or poll /dev/random to determine that the pool is
initialized this is very safe, I think. And some research on distro
practices might uncover whether this should be believed to be
complete.

(Note: I know some folks have raised seccomp sandboxing as an issue
too, but unlike kernel which is sometimes locked in by legacy
hardware, bad seccomp filters are in principle always fixable and are
a form of user/admin error since it's not valid to make assumptions
about what syscalls libc needs.)

Rich
