Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33161C28CC6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 21:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1E8F23980
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 21:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559598451;
	bh=dDw/l+09r2MaBLjcFFfJjSPZLvE2heCBtLMWGhQ6pBg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=f5OcgSzbC0xxXugYdMkLksnZ7UTSwnjsr5SQLm2oA6hVSx9fdI9/j14CvfU5eWukx
	 S+qc0Sq0BkG0MihNdzVDilqI/yVAvfcnhdFKfWkmSgNwXGR7sVGnPg7zz84tz3TQuw
	 EE6RsJQsotF149N7uObLP0n+Ab9jM7H9kbuYTRSE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfFCVra (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 17:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbfFCVr3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 17:47:29 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16FFB23CB8;
        Mon,  3 Jun 2019 21:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559598449;
        bh=dDw/l+09r2MaBLjcFFfJjSPZLvE2heCBtLMWGhQ6pBg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2cBL6VGl6XPWx4El6h15JzACuh5Z0gGbMRGYppoMPJRfkSGgQhgWdgORMBN9uih7i
         9F+FK8cz+WhuxjRCYmkQ0JhZXMg6JqAzleSBlLqw3c1DAIKtJhW6bGZuFpNfX7x6LH
         a935NDfathGNEhNKsfhBdRJm7z4wEb2LJ9FlJvU4=
Date:   Mon, 3 Jun 2019 14:47:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Maninder Singh <maninder1.s@samsung.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        keescook@chromium.org, gustavo@embeddedor.com, joe@perches.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.sahrawat@samsung.com, pankaj.m@samsung.com, v.narang@samsung.com
Subject: Re: [PATCH 3/4] zstd: move params structure to global variable to
 reduce  stack usage
Message-Id: <20190603144728.1f89a4264170aa612365fc2a@linux-foundation.org>
In-Reply-To: <1559552526-4317-4-git-send-email-maninder1.s@samsung.com>
References: <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
        <CGME20190603090240epcas5p17d0881686df3fa3042d0b2d659e925b3@epcas5p1.samsung.com>
        <1559552526-4317-4-git-send-email-maninder1.s@samsung.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon,  3 Jun 2019 14:32:05 +0530 Maninder Singh <maninder1.s@samsung.com> wrote:

>
> Subject: [PATCH 3/4] zstd: move params structure to global variable to reduce  stack usage

If this affected lib/zstd/ I'd be alarmed.  But it's a client of
lib/zstd that is choosing to have a single kernel-wide copy.  I'll
rewrite this patch title to "crypto/zstd.c: ...".


