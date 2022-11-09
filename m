Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDE9C43217
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Nov 2022 09:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiKIJzX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Nov 2022 04:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiKIJzU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2022 04:55:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0441CFD8;
        Wed,  9 Nov 2022 01:55:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D7FDB81CFA;
        Wed,  9 Nov 2022 09:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C7FC433C1;
        Wed,  9 Nov 2022 09:55:16 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mpRP0hXj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667987713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oZshSE8V0gK3sPlp+UQXRzu6fn4sgo2cyoEtjL7uI+k=;
        b=mpRP0hXjQXAWhxawj9mk9joW0tM7oRwy8d0r7vw/cpKCXIgPU0w1jmgtoLJUkrE9A8PiMU
        VV7uxy2+bxJmh+IVrI6SqB9Dm2zsvodi9hNwLpR0ebEIdsNeK3/s2pr+7+zZNVIipbyapF
        qL6l2PkNlXxfUH9z5Ppk9XvnmAW8rNE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 75292193 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 9 Nov 2022 09:55:13 +0000 (UTC)
Date:   Wed, 9 Nov 2022 10:55:10 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Sachin Sant <sachinp@linux.ibm.com>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-crypto@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [6.1.0-rc4-next-20221108] Boot failure on powerpc
Message-ID: <Y2t4/sELkmB4pn2p@zx2c4.com>
References: <E051ACF6-5282-49D1-9C60-BB2450569268@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E051ACF6-5282-49D1-9C60-BB2450569268@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Should be fixed already in today's next.
