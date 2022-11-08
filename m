Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A80C4167E
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 18:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiKHSox (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 13:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiKHSoX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 13:44:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04B62228E;
        Tue,  8 Nov 2022 10:44:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C5DEB81C16;
        Tue,  8 Nov 2022 18:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB15C433D6;
        Tue,  8 Nov 2022 18:44:15 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DTP4enMR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667933053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w95BJJBjkl0keL4YrJ7SC1BUaAVTU+UtC+zkOIVVw2s=;
        b=DTP4enMRhO9TUHy5nfL1jd0svXYD7DU7FDzMJfzvoMCVZqfVX1KHf7Sc2phFdb5iyGlmiI
        zuvlGvSH0IcVmqSCAKxzQObZ93NQibGNmLCuv0OMNSjue+YdIc85dkRQaWKREwJfnB+elo
        5U3HdEwf4YwgJgIJZpoyr1JogwrvPLk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 820bebcf (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 8 Nov 2022 18:44:12 +0000 (UTC)
Date:   Tue, 8 Nov 2022 19:44:10 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     syzbot <syzbot+25aae26fb74bd5909706@syzkaller.appspotmail.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux@dominikbrodowski.net, olivia@selenic.com,
        sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] linux-next boot error: WARNING in kthread_should_stop
Message-ID: <Y2qjerZigLiO8YVw@zx2c4.com>
References: <000000000000e915eb05ecf9dc4d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <000000000000e915eb05ecf9dc4d@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Already fixed in the tree.
