Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E451C433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 07:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 230996135B
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 07:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhEUH2b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 03:28:31 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:10268 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbhEUH2b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 03:28:31 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621582024; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ZXy7snFZewmp25x52Hsqq85wU7yaW8i1hZ74y3E+eTK42qM6E+dqjs2rioC1Nc9UIZ
    Io+CyjGpiRonvmY7l4YKIRezonsRnVtmxfxCZUItE4pmD/HeWjSD4N/S4q0Sx7prYexC
    +iynzU+3OIzLo0AIQfaktFpplb76Ev49vO51sHuuAHBbpYCDlQkBHrsyASEMa+ydiP71
    o6hhaRWyI6lxtANkJJ3pOv+JNCzzA/BnTByeY/HaFL0uFu1gF31n8sF96KwT6KcRqE8E
    CUj/jTJffDDGFqH53g2TOuHDN80F/6hdQwiE1sc0TxgnecBlQtlU/O4Sa9WbfwWqG2zk
    sl/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621582024;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=6NSDXC09BFXaREsayvFsrKY2oVDkya6ZgyDLRcDATPc=;
    b=aJ085sN0TwUxpo7phON0YaPy7Ktx1Ro9bjH+cbD/p1lPaGW9s/L7YVrk2ywGFmCFU7
    fE5AraHn9azJpF8S75mPgb0iU169QInbU8T6C75b7kPhnyS+ZBgrDgxCiK4x55xm4hYg
    spqE8X3tuNgaeQ/YLUWXasitFBMZBxUQo9AF0EuxCDpBOzAdEgoNSEAI7gzQZ0Ka7WvL
    TTDe1nBQVJRbjWZ5yl/ngsV9rYA5NMUGreRW8xT7XJxcBfe5+bLZgtC2Ng94pBkvRnwB
    dNs1SlMwo0x+rv9XDgdTCJKNXcaOK1+tVCmzNiFgRz7dV2/LUVLXx5vC7F6jkscqrpKZ
    Gqxg==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621582024;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=6NSDXC09BFXaREsayvFsrKY2oVDkya6ZgyDLRcDATPc=;
    b=tx7Sg1AgTgGUbiSeUsWXrvzMfpfRuiuQh1Ez8AKhZmFPFo2VPuY6XfuUHZvuv/iOVh
    +xHBeTh4m2zvUNVer+49iSxB0YRiScjTDMYA6cZ3JX5xkdt5kmTcXwxcFAWowV8ZcgCz
    UChm/3YBaehiU+LIDOwuvlItd+xSTM2R1PM9R0BsdvBX03+lRmdDcuR8lzhQKkmrwIQV
    OchpO/PShaK5hsvxg27CPXhIIYQ0dVEE5scF8GWGpRM56LJsFQopeKWQBsBF42h2dMfw
    5DLBktKuFfWzqghHjoq7xx+0Pbo2wBAYFlkJWvodZ25KpwPEeHz4ecij55Kswvs3qj+N
    fDog==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJSlFkMRYOkE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.26.1 DYNA|AUTH)
    with ESMTPSA id V06bffx4L7R308z
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 21 May 2021 09:27:03 +0200 (CEST)
Message-ID: <7621dbe1bfb4f461382952ebeaada5ce103eaf88.camel@chronox.de>
Subject: Re: A possible divide by zero bug in drbg_ctr_df
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Yiyuan guo <yguoaz@gmail.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net
Date:   Fri, 21 May 2021 09:27:03 +0200
In-Reply-To: <20210521064825.vhovv7sa5qif2f3j@gondor.apana.org.au>
References: <CAM7=BFrCTTuBkYb-ceX5C=e8VhAuWBVb_pYQ+K0LB1gn3h=hqA@mail.gmail.com>
         <20210521064825.vhovv7sa5qif2f3j@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, dem 21.05.2021 um 14:48 +0800 schrieb Herbert Xu:
> On Fri, May 21, 2021 at 11:23:36AM +0800, Yiyuan guo wrote:
> > In crypto/drbg.c, the function drbg_ctr_df has the following code:
> > 
> > padlen = (inputlen + sizeof(L_N) + 1) % (drbg_blocklen(drbg));
> > 
> > However, the function drbg_blocklen may return zero:
> > 
> > static inline __u8 drbg_blocklen(struct drbg_state *drbg)
> > {
> >     if (drbg && drbg->core)
> >         return drbg->core->blocklen_bytes;
> >     return 0;
> > }
> > 
> > Is it possible to trigger a divide by zero problem here?


I do not think there is a problem. Allow me to explain:

To reach the drbg_ctr_df function, the drbg_ctr_update function must be
called. This is either called from the seeding operation or the generate
operation.

The seeding operation is guarded as follows:

1. if called from the instantiation drbg_instantiate, we have:

        if (!drbg->core) {
                drbg->core = &drbg_cores[coreref];

2. if called from the generate function drbg_generate, we have:

	if (!drbg->core) {
                pr_devel("DRBG: not yet seeded\n");
                return -EINVAL;
        }

Thus, in both cases, when no drbg and no drbg->core is present, either the
code tries to get it or it fails before trying to invoke the concerning code
path.


When the drbg_ctr_update function is invoked from the generate operation, the
step 2 above applies.


Thus, when we reach the call for drbg_blocklen to get the padlen, we always
have a drbg and a drbg->core pointer.

In general, as soon as the DRBG code path reaches the DRBG-specific
implementations hiding behind drbg->[update|generate], the entire DRBG is
fully initialized and all pointers/memory is set up as needed.

The sanity check in drbg_blocklen is there as the function may be called in
earlier functions where it is not fully guaranteed that the drbg and drbg-
>core is set.

Thanks for the review.
Stephan



