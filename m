Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8359C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 14:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8410420738
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 14:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594649945;
	bh=7okJSavCtHwHai6JZ4nUCc+G5Gb+VD9dOCnLgQFeNPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NpYtZAjsszkz893oB7kE93pxqaeUiD+NxGGG6Yvtn4zUl6OzWBb2rLurh0pj9cori
	 jicUnGfcO0ptKWgXfOaSA6wSclSliSqlA9JTepYDS0EnWjbht0YVkz8ocwC4okZ5uV
	 j1KOFej+6TOxv9nPbSuH2kjPpEAEF5HCjBWEYH8Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbgGMOTF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 10:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729659AbgGMOTE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 10:19:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 106C92072D;
        Mon, 13 Jul 2020 14:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594649944;
        bh=7okJSavCtHwHai6JZ4nUCc+G5Gb+VD9dOCnLgQFeNPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MH8hhlqfgzIIyjZhB1EbzirONb87/opHJVkx9UXTe1aUKeZB5dMCQjInu+vYNK1gG
         EEMaoWRpmey1OuTS/7UDQ39Hwy/Gj07QdN8htya6ZVy2wphOS8u1xZ6FmWbDrTbRQA
         M5tJ2Ib68JLypQhu3AdKKY2hnI+JF2GEbOSDFJUg=
Date:   Mon, 13 Jul 2020 16:19:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     trix@redhat.com
Cc:     giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, wojciech.ziemba@intel.com,
        karen.xiang@intel.com, bruce.w.allan@intel.com, bo.cui@intel.com,
        pingchaox.yang@intel.com, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qat: fix double free in
 qat_uclo_create_batch_init_list
Message-ID: <20200713141904.GA3730398@kroah.com>
References: <20200713140634.14730-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713140634.14730-1-trix@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 13, 2020 at 07:06:34AM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis flags this error
> 
> qat_uclo.c:297:3: warning: Attempt to free released memory
>   [unix.Malloc]
>                 kfree(*init_tab_base);
>                 ^~~~~~~~~~~~~~~~~~~~~
> 
> When input *init_tab_base is null, the function allocates memory for
> the head of the list.  When there is problem allocating other list
> elements the list is unwound and freed.  Then a check is made if the
> list head was allocated and is also freed.
> 
> Keeping track of the what may need to be freed is the variable 'tail_old'.
> The unwinding/freeing block is
> 
> 	while (tail_old) {
> 		mem_init = tail_old->next;
> 		kfree(tail_old);
> 		tail_old = mem_init;
> 	}
> 
> The problem is that the first element of tail_old is also what was
> allocated for the list head
> 
> 		init_header = kzalloc(sizeof(*init_header), GFP_KERNEL);
> 		...
> 		*init_tab_base = init_header;
> 		flag = 1;
> 	}
> 	tail_old = init_header;
> 
> So *init_tab_base/init_header are freed twice.
> 
> There is another problem.
> When the input *init_tab_base is non null the tail_old is calculated by
> traveling down the list to first non null entry.
> 
> 	tail_old = init_header;
> 	while (tail_old->next)
> 		tail_old = tail_old->next;
> 
> When the unwinding free happens, the last entry of the input list will
> be freed.
> 
> So the freeing needs a general changed.
> If locally allocated the first element of tail_old is freed, else it
> is skipped.  As a bit of cleanup, reset *init_tab_base if it came in
> as null.
> 
> Fixes: b4b7e67c917f ("crypto: qat - Intel(R) QAT ucode part of fw loader")
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/crypto/qat/qat_common/qat_uclo.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
