From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] crypto: x86/twofish-3way - Fix %rbp usage
Date: Tue, 19 Dec 2017 08:54:43 +0100
Message-ID: <20171219075443.tdpt2l72eelhpi7j@gmail.com>
References: <001a113f2cd26f3532055f0f4a79@google.com>
 <20171219004026.170565-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, x86@kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Eric Biggers <ebiggers@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:43189 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966514AbdLSHyr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Dec 2017 02:54:47 -0500
Content-Disposition: inline
In-Reply-To: <20171219004026.170565-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* Eric Biggers <ebiggers3@gmail.com> wrote:

> There may be a small overhead caused by replacing 'xchg REG, REG' with
> the needed sequence 'mov MEM, REG; mov REG, MEM; mov REG, REG' once per
> round.  But, counterintuitively, when I tested "ctr-twofish-3way" on a
> Haswell processor, the new version was actually about 2% faster.
> (Perhaps 'xchg' is not as well optimized as plain moves.)

XCHG has implicit LOCK semantics on all x86 CPUs, so that's not a surprising 
result I think.

Thanks,

	Ingo
