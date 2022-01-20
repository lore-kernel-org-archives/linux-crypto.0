Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF652C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jan 2022 10:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376343AbiATKjq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jan 2022 05:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376344AbiATKjp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jan 2022 05:39:45 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D9CC061574
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jan 2022 02:39:44 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id f21so26672897eds.11
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jan 2022 02:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=MQJvAvKBSt+L7ln5Xb4bvHfZ0heZR7NHwzocvUOgYDc=;
        b=FmbXdoJGX2F/fwJBGzMvkSJkUastSuYdwaYcqxqr1JTel1Kx5ikKDf/uNVsQuxxf3A
         0k8xYq9Q/5iWFpbhtI7ULGpPSKsM2hckfxJq+Iyc+1AHP93/8Bx3MaT+i33ILGakY1Ap
         hB5a1raLuaf6wJp6QdmjggCNoTJMZr31MNwUDbBdlMJFQLko/++gnU9pwGPF6n3Yu6ld
         eUvMIHgPnudYogkIpZlW4GmQGbSMTSIcNd3hSfcppAKlrLPYGqItzVvoNCvyJo8u0LWa
         vZa6Q3NvxK/L7Vov+yerJMcnnmsIbsTCZbdGWgvCUcCsbDhQC3BZDbVPwftNeLJ78lX4
         YcYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=MQJvAvKBSt+L7ln5Xb4bvHfZ0heZR7NHwzocvUOgYDc=;
        b=dczORxcDx0ByP70o7zMcSzVtaf6+RrpzjODEbDJhXd51ffr2JrhT2MxeFfDzlR83eZ
         40g/JyMKzl4Q1GLXQ+oveJRccGGC5fxZkwc9W95yoaICRGsMJRiSD5yTQKaZI/j2vP2+
         kUjG9OKLAml4Cp2wj5HVVzHeSeF0/Hz6X/Hkk9PLsMowFtcRho+NkNi9Sj82uYuPMnca
         JCLDjmz3yrh33BSROAm88UlEON0r4ve+RQ903Zu5aPCb3gcwlk5yUB8YHPSx/rCOvLgg
         xIaJK5tB7kk1/Eu1YkqTH7wf1FZecP3rdQDoquxHLNPUS0k+hXEE0hqxD09YCGL4zQWr
         v3cg==
X-Gm-Message-State: AOAM530ozLy/o14Vu5gN4Ksaquek/z+0KTZ1lVXnJvlrHRIIL/+V4JG7
        Klk6Rr1yXQQ45hCOf0Ew2Ryg4ZEfdE3H4H+O+kbNuzuF0dk=
X-Google-Smtp-Source: ABdhPJwlBqCeflXkthEeEQn5yjOYkdDJAqmk7TVVuzgiy9xOCVIt4h+PxP4Hs/OjwLJlcY3jEDEqCP/wNey05ZwCURE=
X-Received: by 2002:a17:906:7d97:: with SMTP id v23mr8969707ejo.128.1642675183248;
 Thu, 20 Jan 2022 02:39:43 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 20 Jan 2022 18:39:31 +0800
Message-ID: <CACXcFm=67TU=wy-WdkpiGnSm2M-E5__z=ACTzCmOkiGijrWNOg@mail.gmail.com>
Subject: random(4) question
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ted Ts'o" <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I see this in the current random.c

/* Note that EXTRACT_SIZE is half of hash size here, because above
 * we've dumped the full length back into mixer. By reducing the
  * amount that we emit, we retain a level of forward secrecy.
  */
   memcpy(out, hash, EXTRACT_SIZE);

Like the previous version based on SHA1, this produces an output half
the hash size which is likely a fine idea since we do not want to
expose the full hash output to an enemy. Unlike the older code,
though, this does expose some hash output.

The older code split the 160-bit hash in half and XORed the halves
together to get an 80-bit output. Should we do that here for 256-bit
output?

Dan Bernstein has something called "SURF: Simple Unpredictable Random
Function." that takes 384 bits in & gives 256 out.
https://cr.yp.to/papers.html#surf
I'm not sure that would work for us since it needs a 1024-bit key and
has 32 rounds, but it seems worth considering.
