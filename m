Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE21C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 13:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbiGYN6i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 09:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235191AbiGYN6h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 09:58:37 -0400
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E57B12D32
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 06:58:36 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id z13so16080422wro.13
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 06:58:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IhDDyub/tbS9mrMSZuLpshhTp0XVRGFWKnNd67pwL/o=;
        b=UF9+FequPRT5n70z2FIrRIUNms6p7buRllGqZ0sUReaE0UTrtcLZ8HNIAbu3bvUrg1
         G02K/BA+elvf1wqilGUkD4wDAgj5jmQsKV9MP/QAWM6gEvqF8+ux5IfTh5LSdb3HLFYE
         HQH57FphuIRYccEGo/WVMrUVjJ9NafvE55WDcOd1HpsSgW85sAwjfXrE8KPnhrUit1NM
         MfRqfdI1Lmbc7b2qWPR4WIMCAy9ZCPZg0XturswY9dovJp/2hYYSAncjlYsBfcukgXlB
         ujnFWqjO0S0osGM1mNKCtkgIPSlK5JfEWhs3EGlJgn67xmcs2xrrl1/c7skZlOeklHF3
         9koA==
X-Gm-Message-State: AJIora9JcMbBbsGzAR+izcEyL6B1HKLUPeKXY5NS7DsGLBQTp79NmIof
        BRKv9vYJp6ce93HlRwmTP7ZzKEz54/Ia8IX7DGk59KMPOhY=
X-Google-Smtp-Source: AGRyM1ucmXzAnxrh6tkvSEspV4vKUv9/ISjmDueRVf+T4RN93DsK1LhXWy6HyDxUXFAUgPDNy6l+GNPpZ+Tk8p04R+8=
X-Received: by 2002:adf:e411:0:b0:21e:6315:80b8 with SMTP id
 g17-20020adfe411000000b0021e631580b8mr7840376wrm.219.1658757514541; Mon, 25
 Jul 2022 06:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
 <87bktdsdrk.fsf@oldenburg.str.redhat.com> <Yt54x7uWnsL3eZSx@zx2c4.com>
 <87v8rlqscj.fsf@oldenburg.str.redhat.com> <Yt6eHfnlEN8ViWrA@zx2c4.com>
In-Reply-To: <Yt6eHfnlEN8ViWrA@zx2c4.com>
From:   =?UTF-8?Q?Cristian_Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Date:   Mon, 25 Jul 2022 09:58:23 -0400
Message-ID: <CAPBLoAcadZw=bqKRn1Wd+NU=Cp+M+4ASB1e4qZbi01vZsgSsNw@mail.gmail.com>
Subject: Re: arc4random - are you sure we want these?
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        "Jason A. Donenfeld via Libc-alpha" <libc-alpha@sourceware.org>,
        linux-crypto@vger.kernel.org, Michael@phoronix.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 25, 2022 at 9:44 AM Jason A. Donenfeld via Libc-alpha
<libc-alpha@sourceware.org> wrote:

> Or, if you insist on providing these functions t o d a y, and won't heed
> my warnings about designing the APIs alongside the implementations, then
> just make them thin wrappers over getrandom(0) *without* doing fancy
> buffering, and then optimizations later can improve it. That would be
> the incremental approach, which wouldn't harm potential users. It also
> wouldn't shut the door on doing the buffering: if the kernel
> optimization improvements go nowhere, and you decide it's a lost cause,
> you can always change the way it works later, and make that decision
> then.

My 2CLP here if that matters..I agree with this sentiment/approach.
provide this functions for source compat which all juist call
getrandom and abort on failure *for now*
and then  a future iteration can have something done about the syscall
overhead with kernel help.
