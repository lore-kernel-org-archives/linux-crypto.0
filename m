Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69106C433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 06:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 314DA61164
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 06:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbhEGG5B (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 May 2021 02:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232974AbhEGG5B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 May 2021 02:57:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EBDD61164;
        Fri,  7 May 2021 06:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620370561;
        bh=5oJ7/xRlvEPW7909i7SHjDtYMORz8Ni4G8mzMy6rqdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jP+MW8zigZV/sd1L87PnhXbALvTo9d67vwc/XP60wvtfTdukLArbMJqtPQ9NMMfuw
         gQhEaX1/iLx/h/SGYhVjwHvngJRUuLZNDyXZO41YN8TVqvoCrf9kTAcunhMmq+s6FQ
         Q/COIVr7z/bWhzdSORg2RGz0Vg7bcGM8uFFvVuqOKqu/DbXjepdZLBTuHNR+rvymJb
         qnqS1OX4TDCzJa1Ekf0SQB3AUUob3wAZ8jHhPexCXwHuoHg6cL6OOVXR5omjs1Ifcz
         ZOq4SGExO1EQDL287phRdKfOVJc1exgmynd0CAlR+ms8+N3875lAR5FMER5rj9htRd
         5kst/LuIwZoXA==
Date:   Thu, 6 May 2021 23:55:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kestrel seventyfour <kestrelseventyfour@gmail.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: xts.c and block size inkonsistency? cannot pass generic driver
 comparision tests
Message-ID: <YJTkf0F5IZhqiXI5@sol.localdomain>
References: <CAE9cyGRzwN8AMzdf=E+rBgrhkDxyV52h8t_cBWgiXscvX_2UtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9cyGRzwN8AMzdf=E+rBgrhkDxyV52h8t_cBWgiXscvX_2UtQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 07, 2021 at 07:57:01AM +0200, Kestrel seventyfour wrote:
> Hi,
> 
> I have also added xts aes on combining the old hardware cbc algorithm
> with an additional xor and the gfmul tweak handling. However, I
> struggle to pass the comparision tests to the generic xts
> implementation.

XTS can't be built on top of CBC, unless you only do 1 block at a time.

It can be built on top of ECB, which is what the template already does.

Before getting too far into your questions, are you sure that what you're trying
to do actually makes sense?

- Eric
