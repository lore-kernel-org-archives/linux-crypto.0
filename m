Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA06C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Mar 2022 22:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiCPWU0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Mar 2022 18:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbiCPWUX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Mar 2022 18:20:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F70025EAE
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 15:19:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35F2A61599
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 22:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA4AC340EE
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 22:19:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FBor0JFH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1647469145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SauEBXZB34PiIy+YfRRxIke6bZwXnS9rAFjJet79nZA=;
        b=FBor0JFHXeDX8fam098LNEyoJv9pVVZSz9UuUWf0qgwLFtl91tnbNMONrevsuik0OxkIgQ
        oPXRyL1RjXTQ5WLBf5WZZ2Fls0aiNMGVvidpPZPjiIaUZFmfMf7WqpSmKwATkwDjAPAuLf
        i1glTtP2FJYdh5jawbnF1VCI47cYJHg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ffd2be8d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Wed, 16 Mar 2022 22:19:05 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id z8so6989714ybh.7
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 15:19:05 -0700 (PDT)
X-Gm-Message-State: AOAM531y1pIJv7sG9TX/KHm0TH0iHsz31Dpq44quPgpEML9+oACiClqe
        khSdPVHLCGcWLQRcEn0kaq78I1xbGlB+3EbEAiE=
X-Google-Smtp-Source: ABdhPJyS6px1jw46AVWzb3kZEV2FnmOoaxHio3LOzbhhhtYCOuEaEZAohPJlv6OpM9tMa/oT/BTdnD/cRBW4UYe+uSc=
X-Received: by 2002:a5b:6cf:0:b0:61e:1371:3cda with SMTP id
 r15-20020a5b06cf000000b0061e13713cdamr2309757ybq.235.1647469143874; Wed, 16
 Mar 2022 15:19:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220314031101.663883-1-Jason@zx2c4.com> <YjIbiX5swxfO6B43@gmail.com>
In-Reply-To: <YjIbiX5swxfO6B43@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 16 Mar 2022 16:18:53 -0600
X-Gmail-Original-Message-ID: <CAHmME9pkB+Mjyxpp0+LPExkX8_NX3Yq9G9YuatRg9A_BQNMEgQ@mail.gmail.com>
Message-ID: <CAHmME9pkB+Mjyxpp0+LPExkX8_NX3Yq9G9YuatRg9A_BQNMEgQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: move sm3 and sm4 into crypto directory
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

I guess I could do that, but I think that might partially weaken the
argument for moving this out of lib/. Can we do that in a subsequent
patch, so that this one stays hermetic to its purpose?

Jason
