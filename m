Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E36C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Feb 2022 16:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383563AbiBHQwO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Feb 2022 11:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352392AbiBHQwO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Feb 2022 11:52:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7ADC061576
        for <linux-crypto@vger.kernel.org>; Tue,  8 Feb 2022 08:52:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73937B81B7B
        for <linux-crypto@vger.kernel.org>; Tue,  8 Feb 2022 16:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3688C340EC
        for <linux-crypto@vger.kernel.org>; Tue,  8 Feb 2022 16:52:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gE7PlIEo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1644339129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=cfFEZsWfFFwoegrHeg4ibUL0t7aDoN6UJjhXUucF38U=;
        b=gE7PlIEo1BMcXjrHYXDkRbA9EAn52wY+zw61xHqdX7zMYAyHqICYMkRKm+d2EK00cRqXr2
        Ajoytr/fTcefjy+LNrwiHwFedTa+5cdGvvqq9/T5G586FTJT3BTMVB8h4pmI1ag49z226Y
        Qv6T2R9oBtuhdTVS+24oGJX3DwPVq3Y=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3a5f1ebe (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Tue, 8 Feb 2022 16:52:09 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id p19so5109541ybc.6
        for <linux-crypto@vger.kernel.org>; Tue, 08 Feb 2022 08:52:08 -0800 (PST)
X-Gm-Message-State: AOAM531cfsDpjVPQ4PCsEjiKJrLtEADRVlu8xJKnMceRoVrgVj+cGmA1
        F0kOoYH26fcDHp2m71EEuHdJ6nqLn7OY1fsVoGk=
X-Google-Smtp-Source: ABdhPJxIIfxi+gvDbHLhR1AufJZ4H+Yh0cJyAoUSvRHV0Se1SG15QPtxdA25D4UlOe/N5WYxqYhMuIRANRRI+BUdHzQ=
X-Received: by 2002:a05:6902:14d:: with SMTP id p13mr5458313ybh.638.1644339128268;
 Tue, 08 Feb 2022 08:52:08 -0800 (PST)
MIME-Version: 1.0
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 8 Feb 2022 17:51:57 +0100
X-Gmail-Original-Message-ID: <CAHmME9rkTP7bJBDvnejQ6BGPu13qpHKbtnjt3h33NEaTnYLirg@mail.gmail.com>
Message-ID: <CAHmME9rkTP7bJBDvnejQ6BGPu13qpHKbtnjt3h33NEaTnYLirg@mail.gmail.com>
Subject: ath9k should perhaps use hw_random api?
To:     miaoqing@codeaurora.org
Cc:     Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Miaoqing,

I'm emailing you because I've noticed that ath9k's rng.c is the *only*
driver in the whole of the tree that calls
add_hwgenerator_randomness() directly, rather than going through
Herbert's hw_random API, as every single other hardware RNG does.

I'm wondering if you'd consider converting your driver into something
suitable for the hw_random API (in drivers/char/hw_random/), rather
than adhoc rolling your own ath9k rng kthread. Is this something
you're actively maintaining and would be interested in doing?

Regards,
Jason
