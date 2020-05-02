Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713DFC47258
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 21:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D3C820757
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 21:06:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="yoDjO/be"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgEBVGE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 17:06:04 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:47671 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728472AbgEBVGE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 17:06:04 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bcf3d9cb;
        Sat, 2 May 2020 20:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=OMy6OqY10ehs479MElnvca/O1bE=; b=yoDjO/
        be+oyUCShp4ZVLh4bPBUDlMzJ381RWsGyzIpE1hzbTBjllfAwEuYsCABvqau8hbi
        5dmW11+dq0k4bAMiLm5uczDpn89mVsWbU2NXf3odIashJvLoOIqKrnP39XRaAKax
        NN0am5x4sJ6S+u6pbvSy5o/r6zW6XAT40WtD6sfTDZ/iUybbrewr2AymtptJg8XI
        DbjQ+pe05O1q2SKWDoAPP/IJ8K8V+DSWFKiiIc3x/2GhsFb1s5i73SssFvHdmHKw
        9fpK7wPbHaB2N4pENA7n6CaqbU4UEsHiopaTqAfnodmoTFZPI5c5U4yLq87FSD74
        VW+NkN3yOcyPQ92w==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 27513ec7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 2 May 2020 20:53:47 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id i16so7629837ils.12;
        Sat, 02 May 2020 14:05:58 -0700 (PDT)
X-Gm-Message-State: AGi0PuaqsbzFGwCzAXma9DaTVlIhbjp2Hy3bEP4CwlqnBimHdctLcvc3
        5cBx35rTilVi+8TB822JoN6wEVznfPrkXhTDod0=
X-Google-Smtp-Source: APiQypKSzW4iIdGBa55HbjRTCDEbI2+eoByi/qgW5rc/uPvsaHpDBAI1P1dPctYeyAYkAyWYUinKdqXT86JVKoxUnpE=
X-Received: by 2002:a92:5c82:: with SMTP id d2mr9968866ilg.231.1588453557814;
 Sat, 02 May 2020 14:05:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200502182427.104383-1-ebiggers@kernel.org>
In-Reply-To: <20200502182427.104383-1-ebiggers@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 2 May 2020 15:05:46 -0600
X-Gmail-Original-Message-ID: <CAHmME9oPqWfTwTtawM-29Lqck-N-kYo4nGr1-4hCW975DhB0Uw@mail.gmail.com>
Message-ID: <CAHmME9oPqWfTwTtawM-29Lqck-N-kYo4nGr1-4hCW975DhB0Uw@mail.gmail.com>
Subject: Re: [PATCH 0/7] sha1 library cleanup
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Paolo Abeni <pabeni@redhat.com>,
        mptcp@lists.01.org, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks for this series. I like the general idea. I think it might make
sense, though, to separate things out into sha1.h and sha256.h. That
will be nice preparation work for when we eventually move obsolete
primitives into some <crypto/dangerous/> subdirectory.
