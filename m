Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53988C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  2 May 2022 15:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385960AbiEBPq4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 May 2022 11:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241392AbiEBPqz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 May 2022 11:46:55 -0400
X-Greylist: delayed 195 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 02 May 2022 08:43:23 PDT
Received: from gardel.0pointer.net (gardel.0pointer.net [85.214.157.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644122AEA;
        Mon,  2 May 2022 08:43:23 -0700 (PDT)
Received: from gardel-login.0pointer.net (gardel-mail [IPv6:2a01:238:43ed:c300:10c3:bcf3:3266:da74])
        by gardel.0pointer.net (Postfix) with ESMTP id C9D8BE8063B;
        Mon,  2 May 2022 17:43:21 +0200 (CEST)
Received: by gardel-login.0pointer.net (Postfix, from userid 1000)
        id 8A901160011; Mon,  2 May 2022 17:43:21 +0200 (CEST)
Date:   Mon, 2 May 2022 17:43:21 +0200
From:   Lennart Poettering <mzxreary@0pointer.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] sysctl: read() must consume poll events, not poll()
Message-ID: <Ym/8GTW2RfhnbqiF@gardel-login>
References: <20220502140602.130373-1-Jason@zx2c4.com>
 <Ym/5EEYHbk56hV1H@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ym/5EEYHbk56hV1H@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mo, 02.05.22 17:30, Jason A. Donenfeld (Jason@zx2c4.com) wrote:

> Just wanted to double check with you that this change wouldn't break how
> you're using it in systemd for /proc/sys/kernel/hostname:
>
> https://github.com/systemd/systemd/blob/39cd62c30c2e6bb5ec13ebc1ecf0d37ed015b1b8/src/journal/journald-server.c#L1832
> https://github.com/systemd/systemd/blob/39cd62c30c2e6bb5ec13ebc1ecf0d37ed015b1b8/src/resolve/resolved-manager.c#L465
>
> I couldn't find anybody else actually polling on it. Interestingly, it
> looks like sd_event_add_io uses epoll() inside, but you're not hitting
> the bug that Jann pointed out (because I suppose you're not poll()ing on
> an epoll fd).

Well, if you made sure this still works, I am fine either way ;-)

Lennart

--
Lennart Poettering, Berlin
