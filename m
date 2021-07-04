Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5A1C07E95
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Jul 2021 06:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA6E8613D0
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Jul 2021 06:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhGDGpn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 4 Jul 2021 02:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGDGpm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jul 2021 02:45:42 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF719C061762
        for <linux-crypto@vger.kernel.org>; Sat,  3 Jul 2021 23:43:06 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id g10so3371630wmh.2
        for <linux-crypto@vger.kernel.org>; Sat, 03 Jul 2021 23:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=IuRMdF3AUX9V4pecQXQtrwKpIB8Qm5JMXD3no5oFrJs=;
        b=e9yKfObL86tUw0Q8MzG+PMjZB/x+MAn27u2pGI1m5PN5bkcintsYfherPwu8GMqcpv
         pGpEL64cFAJa3MvG5J49E/JMh6cu+GXLo1GHUiCRbGBWumvfo3VSLjWn1Bfi3rlqTtyQ
         28x0oOiB0GgctfiARoOMdJ7S07V8boJXLgdVyax2oz89/r5SHpo0wQG3BWeCTDuOhF7E
         JbC3KIeDgpTjRNZVxbiHJ3G6NDs2tF4zn22xsZ9Syjo2bFF5K1vPEchZe5waSCVunjIn
         QXzi1NnWQJRgOigzwpVniCiA9oXfZN8owmqxcITNarZQO5yYNYd/z4A7xFnUqzMxdu/E
         CB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=IuRMdF3AUX9V4pecQXQtrwKpIB8Qm5JMXD3no5oFrJs=;
        b=IwPfo3SIsFmAn55V+bh0UFcynplgbhQhDUxTGUERTfKIPeDfdWmek11V/MZaravgBu
         kZfNGcikG49ggPsV1U7qte1EXYfFsNnSDQ6ApJhakh3aDLlTiBtvepJP+XqAx7n+LFSM
         2WQNoR19pRTobdBw8ffG4ryNTignyVmVD2q3A1/ghwJv4OXXOvuFjNyqCOdfzt5rErux
         WklL4XeKvhAXHNx3jjzRguUzNXjxZjpnOMi4TuvMorS1eGH9l2tKz+0AZXSRgkgZpJSg
         vvW3BCwuBKgy1atb1EJNd1SKWsr8LCIG6gxJiO79UCkZI0rGDIvpKnNmxtrShBMBgLBY
         fYQg==
X-Gm-Message-State: AOAM530sz4FrplFI3wAGnQ0T7L0kD5EBnVIe+iReoXpwVl8ku3vYeoe9
        mfs7HajVJTtVR5tzhw69TJZ3HMrUVi9ZmD0/R8Vmnw27AlY=
X-Google-Smtp-Source: ABdhPJz0g7078sm7kBnhpLtiix9WbLE6n97jVal7nEGQTUGJ6sqTMokdpB9x+YbVt7G8J/2qPUAXa+TGvfdbMxYmX1Q=
X-Received: by 2002:a05:600c:5110:: with SMTP id o16mr8610563wms.24.1625380985216;
 Sat, 03 Jul 2021 23:43:05 -0700 (PDT)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Sun, 4 Jul 2021 14:42:53 +0800
Message-ID: <CACXcFmkg9socPcQzWapcYx+faAa+Km6RncYsuBpdH0BEbsXE9A@mail.gmail.com>
Subject: random(4) thoughts
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, John Denker <jsd@av8n.com>,
        Stephan Mueller <smueller@chronox.de>, m@ib.tc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I strongly suspect there are systems, mainly low-powered embedded
ones, where what I am about to suggest does not apply. I think,
though, that it will work in many of today's Linux environments.

Perhaps we might end up with two versions, one that does it the hard
way (roughly, the current driver) & another that goes the easy way
when the resources are available. I think the second one could be made
quite a bit simpler & faster.

Quoting an earlier post of mine in another thread:

> Many CPUs, e,g. Intel, have an instruction that gives random numbers. Som=
e systems have another hardware RNG. Some can add one using a USB device or=
 Denker's Turbid (https://www.av8n.com/turbid/). Many Linux instances run o=
n VMs so they have an emulated HWRNG using the host's /dev/random.

There may be other choices. Stephan has proposed one, Havege have one & so =
on.

> None of those is necessarily 100% trustworthy, though the published analy=
sis for Turbid & for (one version of) the Intel device seem adequate to me.=
 However, if you use any of them to scribble over the entire 4k-bit input p=
ool and/or
a 512-bit Salsa context during initialisation, then it seems almost
certain you'll get enough entropy to block attacks.

> They are all dirt cheap so doing that, and using them again later for inc=
remental squirts of randomness, looks reasonable.

Assuming you can inilialise with 4k or more reasonably random bits and
throw in more of those bits as required (perhaps 640 whenever you
extract 512?), you no longer need any run-time entropy estimation. The
driver gets simpler.& faster.

Analysis gets easier too; given that we have plausible input entropy,
all the driver needs to be is an adequate mixer. Given that we are
both hashing with SHA and mixing with Salsa, it seems obvious that it
is.

The big problem then is evaluating the sources to ensure they are
indeed "reasonably random". The criteria need not be remarkably
stringent, though. It would take an amazingly bad (deliberately
compromised?) source to give 4k of "random" data without enough
entropy for security.

You do still need the code to extract entropy from interrupts, if only
to make an attack by someone who has compromised a source harder (NSA
getting to Intel's designers, Chinese Intelligence in their factories,
etc.) This does not need run-time entropy estimation either, just
design-time analysis.

Mike has suggested getting rid of the locks in the driver, again
making it faster & simpler. I'm not at all certain that would be a
good idea in the current driver. In the simplified one suggested here,
though, it would seem to make sense.
