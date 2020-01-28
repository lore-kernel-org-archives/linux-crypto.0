Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBACBC33CB3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 08:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DD2024684
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 08:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgA1IaR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 03:30:17 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40066 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgA1IaR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 03:30:17 -0500
Received: by mail-ot1-f66.google.com with SMTP id i6so7353904otr.7;
        Tue, 28 Jan 2020 00:30:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F8IiVdfZ3rxPkzrseqHvTR0l5JtOng4PGW9CTdvaeUQ=;
        b=KbjID6+wbMhXqkAH7mN5IhpPRWgTGNmroMCYkP9BsE/iLlixjW574jjwOPi7ssJCOk
         RD2pMMu9jVn2oPiRySVEtJwvsOlPnwmz8mC/AwZT/2QWedpycwRxU0PLs3NQhJ1DVLDK
         eMVrvcGDafUeVRTTxmbYNP6GOsYqaGa0yJmx9KleAyhAGAX18oahzxG0z9Hx6TT9NzzG
         hmWH6uYUBG+RupiJNnQQeDiHOQ671pLqpboYaZ8KaAlhXWsOw9+LXGLw7OIvJGwYcXu8
         6UDnwt2zfzm4uMTPPI9dEJhc2moIZho5yrFxtQcFUpt6lF6damcHqrhLM2wAhg3mIcRn
         Rqqg==
X-Gm-Message-State: APjAAAVwAMth3pcUCccZ2jYnUJrM+mLpMQw0jxPW4p10c1IoeDuMDCQQ
        WN88iClW5NMjU3M3ueNoTVDskSBk31UaZFqRNDp+HdSK
X-Google-Smtp-Source: APXvYqwvHhGpMbqSfvaqpuFUfwon2iALEDQc/288ki4ctcaLHbZI45R6Rqnyw3kOvyDGdIGB0ouzXTGbnmsx65QKRhk=
X-Received: by 2002:a9d:146:: with SMTP id 64mr10914414otu.39.1580200215995;
 Tue, 28 Jan 2020 00:30:15 -0800 (PST)
MIME-Version: 1.0
References: <20200127150822.12126-1-gilad@benyossef.com> <CAMuHMdVFcsS9K=7+LfT_Tmmpz4LMS69=+EO+8_BkJoXCOfPzPA@mail.gmail.com>
 <20200128030107.GF960@sol.localdomain>
In-Reply-To: <20200128030107.GF960@sol.localdomain>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 28 Jan 2020 09:30:04 +0100
Message-ID: <CAMuHMdWjUoHrqLqUV9F4LfRfSOxBoFONxjH=2HYMFfjf6cSZ6A@mail.gmail.com>
Subject: Re: [RFC v3] crypto: ccree - protect against short scatterlists
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On Tue, Jan 28, 2020 at 4:01 AM Eric Biggers <ebiggers@kernel.org> wrote:
> On Mon, Jan 27, 2020 at 04:22:53PM +0100, Geert Uytterhoeven wrote:
> > On Mon, Jan 27, 2020 at 4:08 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > > Deal gracefully with the event of being handed a scatterlist
> > > which is shorter than expected.
> > >
> > > This mitigates a crash in some cases due to
> > > attempt to map empty (but not NULL) scatterlists with none
> > > zero lengths.
> > >
> > > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >
> > Thank you, boots fine on Salvator-XS with R-Car H3ES2.0, and
> > CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y.
> >
> > Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Note that you need to *unset* CONFIG_CRYPTO_MANAGER_DISABLE_TESTS to enable the
> self-tests.

Sorry, that's what I meant (too used to type "=y" to enable something ;-)

> So to run the full tests, the following is needed:
>
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set

With just this, it no longer crashes.

> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y

With the extra tests enabled, it still crashes :-(

+alg: hash: skipping comparison tests for ghash-neon because
ghash-generic is unavailable
+alg: hash: skipping comparison tests for ghash-ce because
ghash-generic is unavailable
+alg: aead: skipping comparison tests for gcm-aes-ce because
gcm_base(ctr(aes-generic),ghash-generic) is unavailable
+alg: aead: skipping comparison tests for ccm-aes-ce because
ccm_base(ctr(aes-generic),cbcmac(aes-generic)) is unavailable
+alg: hash: skipping comparison tests for cmac-aes-ce because
cmac(aes-generic) is unavailable
+alg: hash: skipping comparison tests for xcbc-aes-ce because
xcbc(aes-generic) is unavailable
+alg: hash: skipping comparison tests for cbcmac-aes-ce because
cbcmac(aes-generic) is unavailable
+alg: skcipher: skipping comparison tests for cts-cbc-aes-ce because
cts(cbc(aes-generic)) is unavailable
+alg: skcipher: skipping comparison tests for essiv-cbc-aes-sha256-ce
because essiv(cbc(aes-generic),sha256-generic) is unavailable
 [...]
 ccree e6601000.crypto: ARM CryptoCell 630P Driver: HW version
0xAF400001/0xDCC63000, Driver version 5.0
+alg: skcipher: blocksize for xts-aes-ccree (1) doesn't match generic impl (16)
+alg: skcipher: skipping comparison tests for ofb-aes-ccree because
ofb(aes-generic) is unavailable
+alg: skcipher: skipping comparison tests for cts-cbc-aes-ccree
because cts(cbc(aes-generic)) is unavailable
+alg: skcipher: skipping comparison tests for cbc-3des-ccree because
cbc(des3_ede-generic) is unavailable
+alg: skcipher: skipping comparison tests for ecb-3des-ccree because
ecb(des3_ede-generic) is unavailable
+alg: skcipher: skipping comparison tests for cbc-des-ccree because
cbc(des-generic) is unavailable
+alg: skcipher: skipping comparison tests for ecb-des-ccree because
ecb(des-generic) is unavailable
+random: crng init done
+alg: hash: skipping comparison tests for xcbc-aes-ccree because
xcbc(aes-generic) is unavailable
+alg: hash: skipping comparison tests for cmac-aes-ccree because
cmac(aes-generic) is unavailable
+alg: aead: blocksize for authenc-hmac-sha1-cbc-aes-ccree (0) doesn't
match generic impl (16)
+alg: aead: skipping comparison tests for
authenc-hmac-sha1-cbc-des3-ccree because
authenc(hmac(sha1-generic),cbc(des3_ede-generic)) is unavailable
+alg: aead: blocksize for authenc-hmac-sha256-cbc-aes-ccree (0)
doesn't match generic impl (16)
+alg: aead: skipping comparison tests for
authenc-hmac-sha256-cbc-des3-ccree because
authenc(hmac(sha256-generic),cbc(des3_ede-generic)) is unavailable
 alg: No test for authenc(xcbc(aes),cbc(aes)) (authenc-xcbc-aes-cbc-aes-ccree)
 alg: No test for authenc(xcbc(aes),rfc3686(ctr(aes)))
(authenc-xcbc-aes-rfc3686-ctr-aes-ccree)
-ccree e6601000.crypto: ARM ccree device initialized
 [...]
+------------[ cut here ]------------
+kernel BUG at kernel/dma/swiotlb.c:497!
+Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
+CPU: 1 PID: 270 Comm: cryptomgr_test Not tainted
5.5.0-rc6-arm64-renesas-00814-g967bcc92bb54b957 #525
+Hardware name: Renesas Salvator-X 2nd version board based on r8a77951 (DT)
+pstate: 80000005 (Nzcv daif -PAN -UAO)
+pc : swiotlb_tbl_map_single+0x30c/0x380
+lr : swiotlb_map+0xb0/0x300
+sp : ffff80000a7e3500
+x29: ffff80000a7e3500 x28: 0000000000000000
+x27: 0000000000000000 x26: 0000800048000000
+x25: ffff0006fa648010 x24: 0000000000000000
+x23: ffff800009b1d000 x22: 0000000000000000
+x21: 0000000000000000 x20: 00000000000e8000
+x19: ffff80000908f000 x18: ffffffffffffffff
+x17: 0000000000000007 x16: 0000000000000001
+x15: ffff800008f8f908 x14: 019a33cc65fe9730
+x13: c962fb942dc65ff8 x12: 912ac35cf58e27c0
+x11: 59f28b24bd56ef88 x10: 0000000000200000
+x9 : 0000000000000000 x8 : 0000000000000001
+x7 : ffff800009b1d9e0 x6 : 0000000000000000
+x5 : 0000000000000000 x4 : 0000000000000000
+x3 : 0000000000000000 x2 : 0000000000000000
+x1 : 0000000074000000 x0 : 0000000000000000
+Call trace:
+ swiotlb_tbl_map_single+0x30c/0x380
+ swiotlb_map+0xb0/0x300
+ dma_direct_map_page+0xb8/0x140
+ dma_direct_map_sg+0x78/0xe0
+ cc_map_sg+0x7c/0xd8
+ cc_map_aead_request+0x160/0x990
+ cc_proc_aead+0x140/0xeb0
+ cc_aead_encrypt+0x48/0x68
+ crypto_aead_encrypt+0x20/0x30
+ generate_aead_message+0x158/0x338
+ generate_random_aead_testvec.constprop.43+0x110/0x1c8
+ alg_test_aead+0x350/0x400
+ alg_test+0x108/0x410
+ cryptomgr_test+0x40/0x48
+ kthread+0x11c/0x120
+ ret_from_fork+0x10/0x18
+Code: f9402fbc 17ffffa0 f9000bb3 f9002fbc (d4210000)
+---[ end trace 42a5d23b5191edbc ]---
+note: cryptomgr_test[270] exited with preempt_count 1
+------------[ cut here ]------------

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
