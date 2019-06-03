Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92629C04AB5
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 21:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D05823A5C
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 21:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559598554;
	bh=roe7k85B1WBARYVkgdFOauIjF/htR4Atr22VzMKxNss=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=VuGCCceOMFY/fu/ltMqz943e0huiNSEd67Ywk37izSlbRK718cYEsFcrby1T7TWmK
	 qlwyh0KfmQYqzf3iWxsCj0LN5PHnudSpq/w7bWbKd02tCraaaJ2lOmXPzSCZP27LII
	 ZXb1+rwKMuFaKc2Vm5AqQrQwInYevOPCnNlFH7Vk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFCVtN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 17:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfFCVtN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 17:49:13 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07C4A23A48;
        Mon,  3 Jun 2019 21:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559598553;
        bh=roe7k85B1WBARYVkgdFOauIjF/htR4Atr22VzMKxNss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aHoSjDuYs+ZX4i6zuooI42FjZrBT6jsYBTiyfvLT8vIiE2+NJ4cpctPy3uJslHaoD
         DuOAqey1CzPQxtM6n7R7knkOHI2Tkhnh2bGu84jZ9Qjh9Br1aMTrU9/qB0sRq8fZ+B
         ZZBE8Z1SJPdqOtoBIHdsiJwu9Lv1ZaysBitSi/AU=
Date:   Mon, 3 Jun 2019 14:49:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Maninder Singh <maninder1.s@samsung.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        keescook@chromium.org, gustavo@embeddedor.com, joe@perches.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.sahrawat@samsung.com, pankaj.m@samsung.com, v.narang@samsung.com
Subject: Re: [PATCH 0/4] zstd: reduce stack usage
Message-Id: <20190603144912.34e1414376e07c7b1af53205@linux-foundation.org>
In-Reply-To: <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
References: <CGME20190603090227epcas5p348327061a3facbb9dfcf662bf2bc196e@epcas5p3.samsung.com>
        <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon,  3 Jun 2019 14:32:02 +0530 Maninder Singh <maninder1.s@samsung.com> wrote:

> This patch set reduces stack usage for zstd code, because target like ARM has
> limited 8KB kernel stack, which is getting overflowed due to hight stack usage
> of zstd code with call flow like:

That's rather bad behaviour.  I assume the patchset actually fixes this?

I think I'll schedule the patchset for 5.2-rcX so that zstd is actually
usable on arm in 5.2.  Does that sound OK?

