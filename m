From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] crypto: x86/twofish-3way - Fix %rbp usage
Date: Tue, 19 Dec 2017 09:04:56 +0100
Message-ID: <44b42058-c465-4d1e-7710-198754efabe4@suse.com>
References: <001a113f2cd26f3532055f0f4a79@google.com>
 <20171219004026.170565-1-ebiggers3@gmail.com>
 <20171219075443.tdpt2l72eelhpi7j@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, x86@kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Eric Biggers <ebiggers@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>, Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38521 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758294AbdLSIE7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Dec 2017 03:04:59 -0500
In-Reply-To: <20171219075443.tdpt2l72eelhpi7j@gmail.com>
Content-Language: de-DE
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 19/12/17 08:54, Ingo Molnar wrote:
> 
> * Eric Biggers <ebiggers3@gmail.com> wrote:
> 
>> There may be a small overhead caused by replacing 'xchg REG, REG' with
>> the needed sequence 'mov MEM, REG; mov REG, MEM; mov REG, REG' once per
>> round.  But, counterintuitively, when I tested "ctr-twofish-3way" on a
>> Haswell processor, the new version was actually about 2% faster.
>> (Perhaps 'xchg' is not as well optimized as plain moves.)
> 
> XCHG has implicit LOCK semantics on all x86 CPUs, so that's not a surprising 
> result I think.

Exchanging 2 registers can be done without memory access via:

xor reg1, reg2
xor reg2, reg1
xor reg1, reg2


Juergen
