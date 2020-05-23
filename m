Return-Path: <SRS0=aEsr=7F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20679C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 23 May 2020 22:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B4120727
	for <linux-crypto@archiver.kernel.org>; Sat, 23 May 2020 22:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590273617;
	bh=PeI+WYnPsD7w0jwv2k/jUh8n9+ukJb90e5rZ9yP2Czs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=SMqZqDCuYb/StU/K7bC2K/7YY79UC8UXkBlYtywLr1vv6ysHEdC/SfK2XWldz658Y
	 o/fgvanFqWT3mOdo9mViUA5ACDTEZyy7XdeJE241f7pDRtdy0Wxr41bYhPo07mnSOM
	 qdIQHUdrl3mDFHjCDA7VaY+7YVdVZjRRkytInZsY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgEWWkR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 May 2020 18:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbgEWWkR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 May 2020 18:40:17 -0400
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B7C720727
        for <linux-crypto@vger.kernel.org>; Sat, 23 May 2020 22:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590273616;
        bh=PeI+WYnPsD7w0jwv2k/jUh8n9+ukJb90e5rZ9yP2Czs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nnFvQEzMjolV/IawZclz6nakDTmydTSeo6A2kSbIydHNLPJzHOxOVzdMcM5jbI6rf
         yf/mHWw3195y/yc0HNvl16CBQKyAE3PWGvSZ/MEofZ8cmd/7UlpVEqScL9DsSOf6EB
         mIHvvhAFHZTo7YDZEYjYOvoMFVu4XxIvq/x8lIS4=
Received: by mail-io1-f41.google.com with SMTP id h10so15278052iob.10
        for <linux-crypto@vger.kernel.org>; Sat, 23 May 2020 15:40:16 -0700 (PDT)
X-Gm-Message-State: AOAM530NVH5wzIechyhp2S8ErRND+J7jPFzLnEPbZrkw9JLXZcjBPbkC
        0ObIMPhL4tNIopYKb32oyaf6q7dhnxciXq7yk9s=
X-Google-Smtp-Source: ABdhPJyzVeU86GlVacAqa4xWM29EOFA4kXo723B/Wa5Uqrdl2aeZl3OjnwdRlS1pf+ifI+wzJWGqXW+iymYOfxhzfgY=
X-Received: by 2002:a6b:5008:: with SMTP id e8mr8369503iob.161.1590273615918;
 Sat, 23 May 2020 15:40:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200519190211.76855-1-ardb@kernel.org> <CAOtvUMc8PhToLDVO+Y4NVhVkA6B7yndp3gbaeaQZJtrW_NSzaw@mail.gmail.com>
 <CAMj1kXFJJcg-YeSw+_FDfyOvjQTJ6w1YyKqWaxCWSjDhRLEDoA@mail.gmail.com> <9730423.nUPlyArG6x@positron.chronox.de>
In-Reply-To: <9730423.nUPlyArG6x@positron.chronox.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 24 May 2020 00:40:04 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG2SuWWyAkinAumW=uBVSdg6BUX0zVPWDX1pnxVW8RusA@mail.gmail.com>
Message-ID: <CAMj1kXG2SuWWyAkinAumW=uBVSdg6BUX0zVPWDX1pnxVW8RusA@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
To:     =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 23 May 2020 at 20:52, Stephan M=C3=BCller <smueller@chronox.de> wro=
te:
>
> Am Donnerstag, 21. Mai 2020, 15:23:41 CEST schrieb Ard Biesheuvel:
>
> Hi Ard,
>
> > On Thu, 21 May 2020 at 15:01, Gilad Ben-Yossef <gilad@benyossef.com> wr=
ote:
> > > Hi Ard,
> > >
> > > Thank you for looping me in.
> > >
> > > On Wed, May 20, 2020 at 10:09 AM Ard Biesheuvel <ardb@kernel.org> wro=
te:
> > > > On Wed, 20 May 2020 at 09:01, Stephan Mueller <smueller@chronox.de>
> wrote:
> > > > > Am Mittwoch, 20. Mai 2020, 08:54:10 CEST schrieb Ard Biesheuvel:
> > > > >
> > > > > Hi Ard,
> > > > >
> > > > > > On Wed, 20 May 2020 at 08:47, Stephan Mueller <smueller@chronox=
.de>
> wrote:
> > > > ...
> > > >
> > > > > > > The state of all block chaining modes we currently have is de=
fined
> > > > > > > with
> > > > > > > the
> > > > > > > IV. That is the reason why I mentioned it can be implemented
> > > > > > > stateless
> > > > > > > when I am able to get the IV output from the previous operati=
on.
> > > > > >
> > > > > > But it is simply the same as the penultimate block of ciphertex=
t. So
> > > > > > you can simply capture it after encrypt, or before decrypt. The=
re is
> > > > > > really no need to rely on the CTS transformation to pass it bac=
k to
> > > > > > you via the buffer that is only specified to provide an input t=
o the
> > > > > > CTS transform.
> > > > >
> > > > > Let me recheck that as I am not fully sure on that one. But if it=
 can
> > > > > be
> > > > > handled that way, it would make life easier.
> > > >
> > > > Please refer to patch 2. The .iv_out test vectors were all simply
> > > > copied from the appropriate offset into the associated .ctext membe=
r.
> > >
> > > Not surprisingly since to the best of my understanding this behaviour
> > > is not strictly specified, ccree currently fails the IV output check
> > > with the 2nd version of the patch.
> >
> > That is what I suspected, hence the cc:
> > > If I understand you correctly, the expected output IV is simply the
> > > next to last block of the ciphertext?
> >
> > Yes. But this happens to work for the generic case because the CTS
> > driver itself requires the encapsulated CBC mode to return the output
> > IV, which is simply passed through back to the caller. CTS mode itself
> > does not specify any kind of output IV, so we should not rely on this
> > behavior.
>
> Note, the update to the spec based on your suggestion is already in a mer=
ge
> request:
>
> https://github.com/usnistgov/ACVP/issues/860
>
> Thanks for your input.
>

Thanks for the head's up. I've left a comment there, as the proposed
change is not equivalent to the unspecified current behavior.
