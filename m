Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00B6C43461
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 06:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 768DE214F1
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 06:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600152981;
	bh=dxZtT+y2MVmWbnrL1hiZeL+6klNtCSdsLYu64JnUXL8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=LBkNk4M/xWeGXQWDYbiPZBJ7kxJVt/OdDGcUBvG3CHhrvWD3NxJdjoF82nmLTrRi1
	 Q8Lu1hf1jglntZHd+Pdl2EnVeLMrtXvqFi4C3CgpBCsdAscEXTEJ9Zawlc9ev8rrhm
	 6djT7EWa/sPLP5LSofc8V6Pg2Fno7/1nSz34b0KY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgIOG4S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 02:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgIOG4P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 02:56:15 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C297C061788
        for <linux-crypto@vger.kernel.org>; Mon, 14 Sep 2020 23:56:13 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id c2so1776928ljj.12
        for <linux-crypto@vger.kernel.org>; Mon, 14 Sep 2020 23:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RifvNOOLyJbnwbwVWOF+enDD+qjD5Fjm0V/Mfqvmyes=;
        b=Ok+Gb7RSq0mYYx+0CWHlM3W78iPr+yr7ivPGBVwnLh/BuOKWy90Ma/i2VS7Q/jgtxO
         oCFqkSrxTfPbvmX64o7DrS7NwjwgR6qJ0V22sjaC6EXlUfruJNf2BmK+Jx03F/RbiG0I
         nXGxWy47Pu87zH1DeP3m4W32SIPgIILk7JZso=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RifvNOOLyJbnwbwVWOF+enDD+qjD5Fjm0V/Mfqvmyes=;
        b=qvcCpJnwCvHXx8H/V+vfqG3VXUCmsVQqf9ioF2NmTvHT8Ej0aN77uIiSbjftXriCei
         hede/IlzyLCkcbpDVS1Y0wUV6ll13RvGTXH7PPP9Oa5mXQQxHXrCO8fwlkmgGPaxqRPY
         tyb0xboWSZ+UEMGl5krN96MHb1ijsgvahx/pu8LBdciYjU/bFg6lUAgjO5/umSwNQ7bS
         CF8cx7K2CQ8Qm+1xX/CUbgBSUqNo/oQCL2RvYVYy5AIY4NrKTr/Un+s1bqpOyF8BM/Ln
         6zA+gpQUBEO4HhPtD9UWyRI+3NlbcvR4pR3/1hjrpenBXEG4ub65CVQIX/7EkcuBx4Lw
         JGgg==
X-Gm-Message-State: AOAM533cFzVeQU9mC0xKpHFCsqfS5/p/lmX7VsoHdtSbgJtMT55KapDI
        4vPDqRBbmizBwhzfip0aeRZBMjiTZd0Usw==
X-Google-Smtp-Source: ABdhPJzPi6/uqu+ZZpfSaoKsIyB6TrQ3frp0GQnmwcMnGYKEPq8rqocGXnsNVEYXzOWDPAo3z2sqAw==
X-Received: by 2002:a2e:9496:: with SMTP id c22mr5746418ljh.249.1600152971282;
        Mon, 14 Sep 2020 23:56:11 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id d28sm3813485lfn.277.2020.09.14.23.56.10
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 23:56:10 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id b19so1779334lji.11
        for <linux-crypto@vger.kernel.org>; Mon, 14 Sep 2020 23:56:10 -0700 (PDT)
X-Received: by 2002:a2e:7819:: with SMTP id t25mr5956337ljc.371.1600152969778;
 Mon, 14 Sep 2020 23:56:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200914204209.256266093@linutronix.de> <CAHk-=win80rdof8Pb=5k6gT9j_v+hz-TQzKPVastZDvBe9RimQ@mail.gmail.com>
 <871rj4owfn.fsf@nanos.tec.linutronix.de> <CAHk-=wj0eUuVQ=hRFZv_nY7g5ZLt7Fy3K7SMJL0ZCzniPtsbbg@mail.gmail.com>
 <CAHk-=wjOV6f_ddg+QVCF6RUe+pXPhSR2WevnNyOs9oT+q2ihEA@mail.gmail.com>
 <20200915033024.GB25789@gondor.apana.org.au> <CAHk-=wgX=ynJAXYYOAM7J8Tee8acERrGOopNu6ZcLN=SEXdGKA@mail.gmail.com>
In-Reply-To: <CAHk-=wgX=ynJAXYYOAM7J8Tee8acERrGOopNu6ZcLN=SEXdGKA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 14 Sep 2020 23:55:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wie0Kb-+XOZNasoay7AKCaQ8Ew8=LyvWTBeiPXC3v2GSA@mail.gmail.com>
Message-ID: <CAHk-=wie0Kb-+XOZNasoay7AKCaQ8Ew8=LyvWTBeiPXC3v2GSA@mail.gmail.com>
Subject: Re: [PATCH] crypto: lib/chacha20poly1305 - Set SG_MITER_ATOMIC unconditionally
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 14, 2020 at 11:45 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I mean, I did find one case that didn't set it (cb710-mmc.c), but
> pattern-matching to the other mmc cases, that one looks like it
> _should_ have set the atomic flag like everybody else did.

Oh, and immediately after sending that out I notice
nvmet_bdev_execute_rw(), which does seem to make allocations inside
that sg_miter loop.

So those non-atomic cases do clearly exist.

It does make the case for why kmap_atomic() wants to have the
debugging code. It will "just work" on 64-bit to do it wrong, because
the address doesn't become invalid just because you sleep or get
rescheduled. But then the code that every developer tests (since
developers tend to run on good hardware) might be completely broken on
bad old hardware.

Maybe we could hide it behind a debug option, at least.

Or, alterantively, introduce a new "debug_preempt_count" that doesn't
actually disable preemption, but warns about actual sleeping
operations..

             Linus
