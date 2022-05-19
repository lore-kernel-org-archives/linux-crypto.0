Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777E2C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 19 May 2022 05:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiESFSw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 May 2022 01:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiESFSv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 May 2022 01:18:51 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FA0AFB27
        for <linux-crypto@vger.kernel.org>; Wed, 18 May 2022 22:18:50 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j4so1159958edq.6
        for <linux-crypto@vger.kernel.org>; Wed, 18 May 2022 22:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=zd+xBMGWQyFVUBHoyvcV9OHW2rTl/3bxnxYaYG1AMXU=;
        b=gcW/5VODU2e5UxLTuRB0sOf3ztZD/dSEWHWVy+JIdaiqpAwlyG3C3kHgKZa5ALISyl
         vqTcfJcdSOWrq8EpOHY1miw5AJKIy8IQSp/WyWKpWz42lz4FlkgzMdjnX2BofIxfL255
         TrQl2qAufqef0Iw8/0u2b7u6BIWUC1Ix3Br9D57VAZIQDo5XzSCRItaOAnPO9++UWaq7
         sBiKgTquwfR2lwo/OskYoKi06yxG9E5iporkNx8b9arX4UhkGR+OzCrUoPy+t70MFG+l
         XK3RAeEua55C5FUPWhRTMh5t913CS/XjnYBRTBtk8VpSRCqthsnRAkUFNr9g5R7wq2T1
         vppQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=zd+xBMGWQyFVUBHoyvcV9OHW2rTl/3bxnxYaYG1AMXU=;
        b=HvyJYwIVKex/pFTi9n2Dh+PRZM2LBRUNJDita0WydUc0BStGmz83bkW3BNHPlTROgQ
         NEVQ0XeWmH5UfJ1GE+bPlXR7gzfwWO2MLuaoIxz03fSM+h8lh9pY+zCLQixiwo5krqlD
         MCNIXosbTbbHRop8V+nzm7VQnyuTCl1VeRyB03yS7ZPJMXti7iG/BlJGrYwpuMIj6Tq5
         G5Pp6n5y4Tub+dx8AAUYMs+t+6KFR2iQhfev2wUXBJeHl2Am2j6P/LOjssiX7M5C97mC
         upf0ZcHFz2z7pnG0KRFaRgYEAv677oC2nsyP+CJiMcofHueJCH/4LcCyIx1obxS6362U
         DPqg==
X-Gm-Message-State: AOAM532cHNHfmh3KoS96ujBHjadZ5y1+ltUv2I1k8KFOfHZ5j8pd75fK
        VVCtMEc4hHG6Wt7e8muj/Y1fuG55CjqtETG4ZmBHoRn5/nk=
X-Google-Smtp-Source: ABdhPJz0cRknLuv9epDrhwU/3snLCCxmLSYnA6p1+H3VU6ByD1bFMlZj/cxoQG6gcMNSQBXpTdnn9LSNBoVmvvzbiuY=
X-Received: by 2002:a50:ee18:0:b0:42a:b57c:2532 with SMTP id
 g24-20020a50ee18000000b0042ab57c2532mr3349344eds.169.1652937528576; Wed, 18
 May 2022 22:18:48 -0700 (PDT)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 19 May 2022 13:18:36 +0800
Message-ID: <CACXcFm=y9dR5DONeoLq1OQZp7fiFTEYTn_ir=c4S=UfyxTGWpQ@mail.gmail.com>
Subject: [RFC] random: use blake2b instead of blake2s?
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ted Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The original random.c used a 4k-bit input pool, I think mainly because
sometimes (e.g. for a large RSA key) we might need up to 4k of
high-grade output. The current driver uses only a 512-bit hash
context, basically a Yarrow-like design. This is quite plausible since
we trust both the hash and the chacha output mechanism, but it seems
to me there are open questions.

One is that the Yarrow designers no longer support it; they have moved
on to a more complex design called Fortuna, so one might wonder if the
driver should use some Fortuna-like design. I'd say no; we do not need
extra complexity in the kernel & it is not clear there'd be a large
advantage.

Similarly, there's a Blake 3 that might replace Blake 2 in the driver;
the designers say it is considerably faster. I regard that as an open
question, but will not address it here.

What I do want to address is that the Yarrow paper says the
cryptographic strength of the output is at most the size of the hash
context, 160 bits for them & 512 for our current driver. Or, since we
use only 256 bits to rekey, our strength might be only 256. These
numbers are likely adequate, but if we can increase them easily, why
not?

Blake comes in two variants, blake2s and blake2b; presumably b and s
are for big & small. The kernel crypto library has both & the driver
currently uses 2s. 2s has 512-bit context (16 32-bit words) and can
give up to 256-bit output. 2b has 1024 (16 64-bit words) and can do
512 out.

To me, it looks like switching to 2b would be an obvious improvement,
though not at all urgent. Benchmarks I've seen seem to say it is
faster on 64-bit CPUs and slower on 32-bit ones, but neither
difference is huge.
