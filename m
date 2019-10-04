Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2260FC4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEA6E2084D
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:59:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="3SRA1hxa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389556AbfJDO7Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:59:16 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:54461 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389547AbfJDO7P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:59:15 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2fb4cf1e
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=eBPyNtJsbfkG
        C241+EIvbNMYYDg=; b=3SRA1hxaTJbwQOVz/in5mj3w6FJN1H24Xsk6ttZPw/O8
        LZGiNPRDO6zirVpfnZ9fOIYF7xj4JqxTEkpt582x1EOUJ5fkg07+a9EhA1CkZ+rb
        NyM/JcAZaM4BovY6i36/18OC0u4EhnBtGqzpqfRDWW/hNLDYZOyXMNwJtDN1lpBQ
        koWSxT2wcpR3/XlnP6yCgbPLufMkvx4fWgHM6TEwnXHCK0EHa+31e1tb3AAhJzx6
        hs/z6pbgz4UpCzUT2lFTUcTpF8ia+5g6CLmKwiEu7CRDTJH5LuemkjWRvTYUQJlh
        12e1RQcnqMPzy0e+rZ6W1X3tA1nWl/aBeeKdO1QDNw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dec44d92 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 14:12:18 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id z6so5555294otb.2
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:59:13 -0700 (PDT)
X-Gm-Message-State: APjAAAVogfHHbjPtOPyo0obb50dtfsXJY2839Ns3fGxWPm/ifO3YgwTA
        DROvVohQ0QCiyxf8Q4cxPV8mqTEtZ1fFqf9BxLY=
X-Google-Smtp-Source: APXvYqw5KLNYbRPI7jdXd5zaptBWmYPL89VV5GWuqZTDops4yLWa+HWwpU0QQMQK06t+xCfB0t0TSZKusDaL6yVcmtQ=
X-Received: by 2002:a9d:ec2:: with SMTP id 60mr11399099otj.369.1570201151885;
 Fri, 04 Oct 2019 07:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-6-ard.biesheuvel@linaro.org> <20191004134644.GE112631@zx2c4.com>
 <CAKv+Gu_X9DBgUiPqcyJ2hOQqi_FEBVpHOr9uG1ZAh-RWv6-z9Q@mail.gmail.com>
In-Reply-To: <CAKv+Gu_X9DBgUiPqcyJ2hOQqi_FEBVpHOr9uG1ZAh-RWv6-z9Q@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 4 Oct 2019 16:59:00 +0200
X-Gmail-Original-Message-ID: <CAHmME9ojUTysb2kHKbSWaR+2Qat3qF1cNrVtphu3V+C+P_g8yQ@mail.gmail.com>
Message-ID: <CAHmME9ojUTysb2kHKbSWaR+2Qat3qF1cNrVtphu3V+C+P_g8yQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/20] crypto: mips/chacha - import accelerated 32r2
 code from Zinc
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 4, 2019 at 4:44 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> w=
rote:
> The round count is passed via the fifth function parameter, so it is
> already on the stack. Reloading it for every block doesn't sound like
> a huge deal to me.

Please benchmark it to indicate that, if it really isn't a big deal. I
recall finding that memory accesses on common mips32r2 commodity
router hardware was extremely inefficient. The whole thing is designed
to minimize memory accesses, which are the primary bottleneck on that
platform.

Seems like this thing might be best deferred for after this all lands.
IOW, let's get this in with the 20 round original now, and later you
can submit a change for the 12 round and Ren=C3=A9 and I can spend time
dusting off our test rigs and seeing which strategy works best. I very
nearly tossed out a bunch of old router hardware last night when
cleaning up. Glad I saved it!
