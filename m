Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DA9C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 12:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiGZMr4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 08:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiGZMrz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 08:47:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B851AF3F
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 05:47:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 669DFB811C6
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 12:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2F1C341C0;
        Tue, 26 Jul 2022 12:47:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="maomZSS8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658839669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ie3bPdZY7B4Kh+fcJxbsobSX2blxcpnoiGzVBltWr7M=;
        b=maomZSS8ydFUcPtReIfRZFKDDAov7ZSqjcSnpfAWMGEr6pfer6RWdp8PSSs79TbTolpNxC
        VeRx4KfIgUB13p75OUxIfpB9j20cszQ/GF0Vl+SOFF5mrfcicqrbftysQUTvjV8EFg8x8u
        M9lDUmyxoIpjhNBPg/v4I1tt3+T16lE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e1a6bc92 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 12:47:49 +0000 (UTC)
Date:   Tue, 26 Jul 2022 14:47:47 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Message-ID: <Yt/ic6Nmn/loPe4w@zx2c4.com>
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <9c576e6b-77c9-88c5-50a3-a43665ea5e93@linaro.org>
 <Yt/V78eyHIG/kms3@zx2c4.com>
 <e173ceb3-9005-fc36-8a21-f6f64f038ab6@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e173ceb3-9005-fc36-8a21-f6f64f038ab6@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Adhemerval,

On Tue, Jul 26, 2022 at 09:34:57AM -0300, Adhemerval Zanella Netto wrote:
> kernel newer than 3.17) it means some syscall filtering, and I am not sure
> we should need to actually handle it.

One thing to keep in mind is that people who use CUSE-based /dev/urandom
implementations might not like this, as it means they'd also have to
intercept getrandom() rather than just ENOSYS'ing it. But maybe that's
fine. I don't know of anyone actually doing this in the real world at
the moment.

Jason
