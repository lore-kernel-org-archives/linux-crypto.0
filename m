Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30C2C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Nov 2022 19:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiKJTmV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Nov 2022 14:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiKJTmT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Nov 2022 14:42:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012AC45EFF
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 11:42:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ED7C61E17
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 19:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE34AC433C1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 19:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668109337;
        bh=WjjGOkHaIEna0ZmvXYEagYqgp3HSVjzUdeW/KDT2wRE=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ZUIxHmDyyUA9YxTzc8hfD2HN52lBbwjMuSM6Z4sWrZg/Rbr+Muy67ohW8JWHc6q7t
         VmUPSuTjs6LMcRuvfJh7hZ+5TTtC1M0hoVgf8xYjGUZ1MFEAEY0ir9R9N90KEUuIcI
         Bo8G1XchrnIMsNjtPiT3MkI8pUl2Ke/1E4NPimJt1/7qsrXOMgc0qUYXrjeIv5/vjz
         WSUdwLi1L/QX6cz6GOfplVyvytRp1psGhojx9o4XfYtyakiK9zPVRRq2DE4vfq0OR4
         7q83aA+/6AWDeNJKJEVDaUyvpJ5dwDlKkVEfGfplaiGvtqwX+xyilYJplwSJCCcXQt
         4okKbZS+PSsxg==
Date:   Thu, 10 Nov 2022 19:42:16 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/6] crypto: optimize algorithm registration when
 self-tests disabled
Message-ID: <Y21UGAZMnytRfdmR@gmail.com>
References: <20221110081346.336046-1-ebiggers@kernel.org>
 <20221110081346.336046-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110081346.336046-2-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 10, 2022 at 12:13:41AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently, registering an algorithm with the crypto API always causes a
> notification to be posted to the "cryptomgr", which then creates a
> kthread to self-test the algorithm.  However, if self-tests are disabled
> in the kconfig (as is the default option), then this kthread just
> notifies waiters that the algorithm has been tested, then exits.
> 
> This causes a significant amount of overhead, especially in the kthread
> creation and destruction, which is not necessary at all.  For example,
> in a quick test I found that booting a "minimum" x86_64 kernel with all
> the crypto options enabled (except for the self-tests) takes about 400ms
> until PID 1 can start.  Of that, a full 13ms is spent just doing this
> pointless dance, involving a kthread being created, run, and destroyed
> over 200 times.  That's over 3% of the entire kernel start time.
> 
> Fix this by just skipping the creation of the test larval and the
> posting of the registration notification entirely, when self-tests are
> disabled.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/algapi.c | 151 ++++++++++++++++++++++++++----------------------
>  1 file changed, 82 insertions(+), 69 deletions(-)

FYI, I realized that this patch breaks CRYPTO_MSG_ALG_LOADED (it isn't always
sent now).  So I'll have to send a new version at least for that.

- Eric
