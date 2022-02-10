Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B8CC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 14:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238098AbiBJO2k (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:28:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242901AbiBJO2j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 09:28:39 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C8821C
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:28:39 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id cz16so11171976edb.8
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=rbs0lLP9RZzJE2r4csi0yLh+4W1OkWH7RJI55o8FZNA=;
        b=cTJLK79A2fbaO/6529z1ftMxx8PoYIGkD9ErzRka7CLnBUF4nhqk33IASmVLsVHJM0
         j02LnSI6oivLVlnGOIG6taZhsYIcUAqLHZ1hVEeoDTZu0MwufJWOsT3aA4to1SlxiPC7
         9GUdbHFWW86moDneo9F9HtDGcmVmuceQWFWKeLlY/1FajJOmmna63+xpjMpy4uFEbfgL
         D1vm6Xc4eAxBew+YEc/Q3Db3c2Jza6/E1CbIqJ8yKAVCDzeldcWMrn5TzsXWACsR8fIo
         9s1BxctAgGdD3+BOjw/ys3IUFRqiR5OZiyzX+byrN+h7Reu97tEX7QE1iDolSb+K9QaY
         iAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=rbs0lLP9RZzJE2r4csi0yLh+4W1OkWH7RJI55o8FZNA=;
        b=5aY43S/Na4QjyUksNynvkpn2ZzaT1XalCNFsfoAmFPStxr9UFRicAWCfPBHTKEOQUt
         t8Mw+pa5frbqlS3rOzRXfaeCS4AI4s/Cjl3g+gGT/n2XOMbp1KAuzZ5fvzuEgkPdgFRd
         xNvLMAZbF337jJ31XSSGMDCCC3qoKJOJyXZfp8HImcEjIrYl563me/abgaavsPg9sJkF
         zSAdZJQs/HZAhCVRCFzuuc9V3RuGBR/cYUMoATnRG+AvNNCNHJbJcGAB2J5AzW7wfv64
         94jzPCnaO0RZX1h37dmdDFbC1+K9XEThMnsLJeB4QWsvge/mVu2z9FcipSVp23v1PMNx
         OY5g==
X-Gm-Message-State: AOAM532LEfU85g/6Z2ZAhn6eGw2cywNTsLlxZK5FIQ8zQcSAaBPebIUR
        Ar4eVHXga2SuJafJjF/Qhom3D/LNW0Pxo5Ub+YkJoet4QHQ=
X-Google-Smtp-Source: ABdhPJyeY+e5rab0b6i5ffWdDKktmROu9NedZOGuIlG/q7gNMwnwGFADj8BkL5vDQqql0zqJlxJUnd/ZwV/iDchpmEc=
X-Received: by 2002:a05:6402:1601:: with SMTP id f1mr8599720edv.165.1644503317954;
 Thu, 10 Feb 2022 06:28:37 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 10 Feb 2022 22:28:26 +0800
Message-ID: <CACXcFmkC=6DsDiTbtnu=LMSsg00Lxz7jvcWNV=yDibz8suoVgw@mail.gmail.com>
Subject: [PATCH 0/4] random: change usage of arch_get_random_long()
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series of patches is not strictly necessary, but it is a
significant improvement.

The current code has a sequence in several places that calls one or
more of arch_get_random_long() or related functions, checks the return
value(s) and on failure falls back to random_get_entropy(). These
patches provide get_source_long(), which is intended to replace all
such sequences.

This is better in several ways. It never wastes effort by calling
arch_get_random_long() et al. when the relevant config variables are
not set. If config variables for a hardware rng or the latent entropy
plugin are set, then it uses those instead. It does not deliver raw
output from any of these sources, but masks it by mixing with stored
random data. In the fallback case it gives much more random output

In the cases where a good source is available, this adds a little
overhead, but not much. It also saves some by not trying
arch_get-random_long() unnecessarily.

If no better source is available, get_source_long() falls back to
get_xtea_long(), an internal-use-only pseudorandom generator based on
the xtea block cipher. In general, that is considerably more expensive
than random_get_entropy(), but also provably much stronger.

With no good source, there is still a problem at boot; xtea cannot
become secure until it is properly keyed. It does become safe
eventually, and in the meanwhile it is certainly no worse than
random_get_entropy().
