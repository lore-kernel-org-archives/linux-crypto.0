Return-Path: <SRS0=/HXT=5R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B04C43331
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 22:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1DF5206E9
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 22:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389481AbgDAWxi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Apr 2020 18:53:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42412 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389479AbgDAWxi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Apr 2020 18:53:38 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jJmEK-0004Od-Hj; Thu, 02 Apr 2020 09:53:05 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Apr 2020 09:53:04 +1100
Date:   Thu, 2 Apr 2020 09:53:04 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+6a6bca8169ffda8ce77b@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        David Miller <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: KCSAN: data-race in glue_cbc_decrypt_req_128bit /
 glue_cbc_decrypt_req_128bit
Message-ID: <20200401225304.GA16019@gondor.apana.org.au>
References: <0000000000009d5cef05a22baa95@google.com>
 <20200331202706.GA127606@gmail.com>
 <CACT4Y+ZSTjPmPmiL_1JEdroNZXYgaKewDBEH6RugnhsDVd+bUQ@mail.gmail.com>
 <CANpmjNPkzTSwtJhRXWE0DYi8mToDufuOztjE4h9KopZ11T+q+w@mail.gmail.com>
 <20200401162028.GA201933@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401162028.GA201933@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 01, 2020 at 09:20:28AM -0700, Eric Biggers wrote:
>
> The issue is that fixing it would require adding READ_ONCE() / WRITE_ONCE() in
> hundreds of different places, affecting most crypto-related .c files.

I don't think we should be doing that.  This is exactly the same
as using sendfile(2) and modifying the data during the send.  As
long as you don't trigger behaviours such as crashes or uncontrolled
execution then it's fine.  The output is simply undefined.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
