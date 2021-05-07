Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E3CC43461
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 05:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE8060FE9
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 05:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhEGFms (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 May 2021 01:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbhEGFmq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 May 2021 01:42:46 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F041DC0613ED
        for <linux-crypto@vger.kernel.org>; Thu,  6 May 2021 22:41:46 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id j11so5840880qtn.12
        for <linux-crypto@vger.kernel.org>; Thu, 06 May 2021 22:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=G2kOry2o6vDINWYKN+kItqoO3L4K4kcs80lC7IG5WJU=;
        b=bRNCVPdRqAocCuyFxBXJy2AsS3Qe16WxtrKO74QvMjIBi0wx/v0BGOcsSVuCwagmwO
         mEpXlMTxD1HFdaXZU/T1fxWDz699KuxZayEaQSrFIDZLj8Ead5DAxXB9JfrfRt3f2cRc
         rNLBYP7Y77arlJFye/ae+jdYD4IXyPTUZ0cUY0OXf49OBpBiYq76ArNyvrHpbghR9Rhg
         qOhCTh4uIpwLhVXQOSAPeJwuful8xOMAXw5jI01ZZNM/dq+XJLqGGQ63QLXI42+uDEF0
         pU9ZzPvgxK4IDacYhC1eWthFdl4lsGumueuhlWco99oFSq6f1ccZdXPiqKhDsysYq+Jx
         PGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=G2kOry2o6vDINWYKN+kItqoO3L4K4kcs80lC7IG5WJU=;
        b=lWC7Qy9tZY3Wz12h5ikmUH6Zrt5hxJC1m0OwHdZj+YBvQhXzpCtSXm482w0WcpjIK/
         j8ETFmb7JwYirQeFaumi/TCALz4ggPG1HU2Sg/GP6UahZWhD9zrsKn0ubNnumUxTPwA6
         R7+VpldsOHSnXF7innXrBqnzkMldUXkMt+N7ix9FVLTMYSwaGMhDP6IVqF9rA+qWrZRS
         eKnfs9deQK1mtzcfR7/EEZdvIlNXL+T6NDrpdnk4Gwi587C6xUmYhsw0u+rQ6j9Qpzh7
         DsIqx79b3kbGn2jPZpuaefrF5p5N8+/Miaaid2FTOfBCaGtgfVTY1WvmG5+BnDrGck7k
         SbEg==
X-Gm-Message-State: AOAM531Eq7IvL3GT2lbTm2lyVE70m0RvOMkMajoX3z1MVYYbE7MQCJAK
        LOG2s2UAZpvNNwRk+OddbfzlsiVhGiqiiXMcfDJffnVWdDY=
X-Google-Smtp-Source: ABdhPJxKzVdU7bSErDYXXQjwSjZWZmXz9hyH9G8BChwcxOvNxbG1yz0nOahlJ4/XXLydJCJ11FAw2oQ3ssxn5ejbvYM=
X-Received: by 2002:ac8:714c:: with SMTP id h12mr8066884qtp.221.1620366106260;
 Thu, 06 May 2021 22:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAE9cyGSX4nwRrDbazih2FDp1_8e+wGTD17euyCJyitXWOignMw@mail.gmail.com>
 <YJF708LCG0l8WBaD@gmail.com>
In-Reply-To: <YJF708LCG0l8WBaD@gmail.com>
From:   Kestrel seventyfour <kestrelseventyfour@gmail.com>
Date:   Fri, 7 May 2021 07:41:35 +0200
Message-ID: <CAE9cyGToQUPuU3GfZK1SSTEUts3Ot1x7nAW1QdttvfVNDQqBoQ@mail.gmail.com>
Subject: Re: cannot pass split cryptomgr tests for aes ctr
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

thanks for the info. Walksize did the trick returning the chunks.

D. Kestrel

Am Di., 4. Mai 2021 um 18:52 Uhr schrieb Eric Biggers <ebiggers@kernel.org>:
>
> On Mon, May 03, 2021 at 09:56:40AM +0200, Kestrel seventyfour wrote:
> > Hi,
> >
> > I am trying to update the old ifxdeu driver to pass the crypto mgr tests.
> > However, I continously fail to pass the split tests and I wonder what to do.
> >
> > For example, I successfully pass the test vector 0 here:
> > https://elixir.bootlin.com/linux/latest/source/crypto/testmgr.h#L16654
> > if there is no split.
> >
> > But if the text "Single block msg" is split into two 8 byte blocks
> > (single even aligned splits), which end up as separate skcipher walks
> > in the driver, the second block is wrong and does not compare
> > correctly, to what is hardcoded in testmgr.h. Same if I try it with
> > online aes-ctr encoders in the web.
> > I have tried doing the xor manually with the aes encoded iv, but I get
> > the same result as the hardware and if I use the next last iv, I still
> > do not get the second 8 bytes that are hardcoded in cryptomgr.h.
> >
> > Can someone shed a light on it?
> > Is it valid to compare a crypto result that was done on a single walk
> > with 16byte with two separate walks on the 8 byte splits (of the
> > original 16)? Is the cryptomgr test on the split tests expecting that
> > I concat the two walks into a single one?
> > If yes, how to do that on the uneven splits with separations like 15
> > 16 5 byte sequences, etc., fill up the walk up to full block size and
> > spill over into the next walk?
> >
>
> The split test cases expect the same output (same sequence of bytes) as the
> non-split test cases.  The only difference is how the data is split up into
> scatterlist elements.  Yes, that means that a single 16-byte block of the
> keystream may need to be XOR'ed with data from multiple scatterlist elements.
> Take a look at how other drivers handle this.
>
> - Eric
