Return-Path: <SRS0=WlNz=3A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDF4C282DD
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 00:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BCB4206ED
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 00:17:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="3ZFX7eJQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgAKARM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 19:17:12 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:41161 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbgAKARM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 19:17:12 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 63d7c969;
        Fri, 10 Jan 2020 23:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=8rcos00mpgiRgNOZRS7kR9yv6aU=; b=3ZFX7e
        JQz0q1Reo4TNVsXrYcB2CvEEem6Lb3wEyjS9clPkpnZ0Is6Hk+VG0cqQxK/plTau
        nbLvcRR9nMmsVSKvznc3+ZosjQLz1c1BbkK1Vu+HdBYaZi9dxJh93SGu40p9uqYY
        iVz5NyjkLClLYlkBjVKSv2Uqj2YT4sNQG7+cmtnwGspJnZKEUHvjzI/ZoD9qJE4s
        6Zrs1TIuN/5xi0QI5Y6IK8WhrOaODxFY0AGXefRIoONyI9mc9QnAve6rh3psG6Dt
        tLWg1sDG4wC2d9CN2b3d/h+6SGbIVwxuv8JUncT1Wcm9yRDyCb36BcbqVxSEqE+Y
        DeZacrrIGVn0kZuQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4971434f (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 10 Jan 2020 23:17:33 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id a15so3716687otf.1;
        Fri, 10 Jan 2020 16:17:08 -0800 (PST)
X-Gm-Message-State: APjAAAVUBp7jDkXp8GYlZICWL6yexG3jeiGxeMJhx4pPhFGWlxO/eRHp
        IZauBlutsY6UsTIW46DpcL5CZSS61cDbMVzSnHo=
X-Google-Smtp-Source: APXvYqy7XgL1zSl8e2cFgPv6d1rIDwTEU7p9SGp27oiQ68yGfUA9pFOWs9Go7vhAr4VtyzD/DJj20B/NMxGZEd6UjlM=
X-Received: by 2002:a05:6830:1141:: with SMTP id x1mr5050155otq.120.1578701827660;
 Fri, 10 Jan 2020 16:17:07 -0800 (PST)
MIME-Version: 1.0
References: <20200107133547.44000-1-yuehaibing@huawei.com> <CAHmME9pg4KWw1zNVybxn1WLGusyGCjqeAHLQXY=Dr4zznUM82g@mail.gmail.com>
 <20200108043735.hkhkyq47neatatt4@gondor.apana.org.au>
In-Reply-To: <20200108043735.hkhkyq47neatatt4@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 10 Jan 2020 19:16:56 -0500
X-Gmail-Original-Message-ID: <CAHmME9pOq8DCpvozendC0NTBct9EQgFzJaNP1xzRbkcWtcXYWA@mail.gmail.com>
Message-ID: <CAHmME9pOq8DCpvozendC0NTBct9EQgFzJaNP1xzRbkcWtcXYWA@mail.gmail.com>
Subject: Re: [v2 PATCH] crypto: curve25519 - Fix selftest build error
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks for the analysis.

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
