Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723DFC4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24B7A2133F
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:17:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ori2vBVu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388417AbfJDORu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:17:50 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:40347 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388197AbfJDORu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:17:50 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 158b662e
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=EAr6O07r3jxwtSepFJR5scbGjRk=; b=ori2vB
        VuNCA2N1AZ8kQh225GWsooizLT79dARjynKN+p5QjzhjB3MAeLEhRiaOsYdNeYy2
        uAAhSxdJStQQHlaW3v3XKMYhaPX4m+EDPd+xcko5sMgFRW+cjLOt4iwnpDUCbiMH
        OT1PkZY0rVLsG5Ghrq+p8IOYbIRmKdO/4YbF2vr3e6n0L/+vvAKJvoKSWQemHIpb
        i9gs8xLGnPBhxz2lFmV8G6rB5nCeSbZIasKhjjEE9sVgkxws9yCfZ3ISLg8rbbSI
        oGgvbKq1R6xttYplrpPijpo4XoLzKoSm4tk9OE2nNGo6nYaGEjjANSJD/K92jsaa
        EBLdu8FUe8cA/mGQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dcba27e1 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 13:30:53 +0000 (UTC)
Received: by mail-oi1-x229.google.com with SMTP id i16so5883242oie.4
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:17:47 -0700 (PDT)
X-Gm-Message-State: APjAAAWkW4o4/KBg/Cy7rSq+YvB9aAEzv5bBb02+KiMF3UWukBdI7I8C
        R8SHshCrSRHhVEykZyqF8/8+TKfQKHgo74W7mvU=
X-Google-Smtp-Source: APXvYqzfB++3fm4bGg/a1U7erCHOAwXwG3iXPdKNgN+7PEKGkSo7k8K0IdFzeFpHphVWzCHN6OYQ9q7/e9j+85uPYlA=
X-Received: by 2002:a05:6808:b0d:: with SMTP id s13mr7475975oij.52.1570198366835;
 Fri, 04 Oct 2019 07:12:46 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 4 Oct 2019 16:12:35 +0200
X-Gmail-Original-Message-ID: <CAHmME9piZC8ZTAqxhQqT_zWkM28+2yYChc0S8-WsmYTT-xjMzg@mail.gmail.com>
Message-ID: <CAHmME9piZC8ZTAqxhQqT_zWkM28+2yYChc0S8-WsmYTT-xjMzg@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
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
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 2, 2019 at 4:17 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> This is a followup to RFC 'crypto: wireguard with crypto API library interface'
> [0]. Since no objections were raised to my approach, I've proceeded to fix up
> some minor issues, and incorporate [most of] the missing MIPS code.

Could you get the mips64 code into the next version? WireGuard is
widely used on the Ubiquiti EdgeRouter, which runs on the Octeon, a
64-bit mips chips.
