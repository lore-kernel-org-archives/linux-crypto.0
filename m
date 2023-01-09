Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B299C61DB3
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Jan 2023 18:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbjAISiB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Jan 2023 13:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbjAISh0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2023 13:37:26 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80BE76822
        for <linux-crypto@vger.kernel.org>; Mon,  9 Jan 2023 10:35:30 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-4b718cab0e4so124562667b3.9
        for <linux-crypto@vger.kernel.org>; Mon, 09 Jan 2023 10:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Nq9gWaBeUb3bCr6q4HAhBECYLpCHapLzwerok5eiN2Y=;
        b=G8axkWXrmvGMpyYY7iWq/D3gWcV011ie03fgNpiWHWCcdGZEyrLYsm0zWgVDWZ1H51
         L4MdBXqSQ7tx/g1biERnpql7yz4Y1onoEJUEQpumgtsPC1f9fku0SV7xI1tyCBZ5Rbfr
         jBc7yyBhy6emGTnz6u2NbXNNwU18M6ZV9Gg7YFarKJkm4BByomsEfs6jtuNT4KRl2yKA
         Ew2pQBKeP8CEevgPapjxPl16kiFxhWrGwuNndzhp3H9O4Nhnig3KmsYQJO02d8YnaxVU
         B7aouANMrLMzq7y7+G69YvKeDr3DaqgHFtlOcjMNzS1BBVAtx3uahfiDyMDVXc2kZhYz
         RWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nq9gWaBeUb3bCr6q4HAhBECYLpCHapLzwerok5eiN2Y=;
        b=db4pEwXipL1u4SwrYt/qP1IQ6m2mTMOlPn+6qt4/2hHiVsDzqo5vbU4vTk8M6B3sXP
         WSsii+nmEidMAPLu4M7z8K3WBRpcDhqFK4qVnzw3sDl8JKql3N9xo8H/eS7aQrAQEsBP
         Nk3KW+Q5bQuRXUYv/sEFWjMLpenpayGf8pDpKvr+jcZImYk60UZsDTYX/oV5PNy1X2P1
         MuUnwl4uFyPdrZTVFLkSMNp5C0gdI7cT6LVT9nS4FYhHtMnsDIVtpS8ddzP5HlSPEcp5
         7T3cg41uzUZjLLEWBmoruIgPRitXsb6PYkFsxMZqwkyHO1GtIJR4ZW4GDBmgrD9Ga4q+
         rsIQ==
X-Gm-Message-State: AFqh2krug7Tw1GnVwpn3+ESVScHwG/OCwlbAbSvqlL+SYLE5V3G6ICmO
        mtmUGJyhvEt6H8L7o7Uu99uxbXHN39XNSyL/tChN+dTQrBk=
X-Google-Smtp-Source: AMrXdXueJv4082M/Di0PS7E8bsCoaI8+z4aUjJVBTUNoZvKsKu1/mCoT+L4r0Gb80LLtT09GN5eeDEFzMc4Rx/qIMlQ=
X-Received: by 2002:a05:690c:d96:b0:478:6ef2:da73 with SMTP id
 da22-20020a05690c0d9600b004786ef2da73mr185587ywb.488.1673289330041; Mon, 09
 Jan 2023 10:35:30 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Mon, 9 Jan 2023 19:35:19 +0100
Message-ID: <CAAUqJDsuFT0XBBkOH_OkhXpEJSaZCLP56-MvBMpde=OS-Dt8VQ@mail.gmail.com>
Subject: [BUG] It is possible to circumvent dh_check_params_length() in the
 generic implementation
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

While debugging an SELinux test that happens to use keyctl(2) with
KEYCTL_DH_COMPUTE, I noticed that mpi_read_raw_data() (used in
crypto/dh.c to import big numbers from byte strings) accepts any
number of leading zero bytes and discards them. This has a bad
implication for dh_set_params(), as it passes the original prime byte
string size to dh_check_params_length(), which means that it is
possible to get it to accept a prime of any size, simply by
left-padding it with zero bytes to the minimum accepted size.

I ran into this because the test was accidentally passing the prime
byte string with an extra zero byte at the beginning (an artifact from
the output of `openssl dhparam -text -2 2048`) and while this ran fine
when the generic "dh" implementation was used, it was failing on
machines where the intel_qat driver was used, which doesn't have this
validation bug.

For me the fix is simply to drop the extra zero byte from the test's
input, but I wanted to report this, so that someone with more vested
interest in the crypto subsystem can fix the prime length validation
issue as well.

Cheers,

Ondrej
