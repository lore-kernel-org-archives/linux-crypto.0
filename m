Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE3AC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 11:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238634AbiGZLIz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 07:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238632AbiGZLIy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 07:08:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDFA2F01B
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 04:08:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 549FFB8154D
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 11:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3366DC341C0;
        Tue, 26 Jul 2022 11:08:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QMe2gxUU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658833728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eRCT4Z7PUGAKaB5rftyQXYFEd48wDnvQnkjXMb+58kE=;
        b=QMe2gxUUHL9A6vDiEJY1ny5s2VrTPxwZhtggmq9pt16MU9GyfSDYVd6qXkRPbGFCjJbq5R
        S3rt5tWiyFW3PIu816wM+6CM/KwB519IRc3xUnprHRvi3KG5H7ard3E/kkCMu6aGAFUDSt
        +XDHdLDrN4e24mbi5Xpxp3r4HWraL/8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8c9f20db (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 11:08:48 +0000 (UTC)
Date:   Tue, 26 Jul 2022 13:08:46 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        luto@kernel.org, tytso@mit.edu
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Message-ID: <Yt/LPr0uJVheDuuW@zx2c4.com>
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
 <YtaPJPkewin5uWdn@zx2c4.com>
 <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
 <YtjREZMzuppTJHeR@sol.localdomain>
 <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
 <Ytj3RnGtWqg18bxO@sol.localdomain>
 <YtksefZvcFiugeC1@zx2c4.com>
 <29c4a3ec-f23f-f17f-da49-7d79ad88e284@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <29c4a3ec-f23f-f17f-da49-7d79ad88e284@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Tue, Jul 26, 2022 at 03:43:31PM +0800, Guozihua (Scott) wrote:
> Thanks for all the comments on this inquiry. Does the community has any 
> channel to publishes changes like these? And will the man pages get 
> updated? If so, are there any time frame?

I was under the impression you were ultimately okay with the status quo.
Have I misunderstood you?

Thanks,
Jason
