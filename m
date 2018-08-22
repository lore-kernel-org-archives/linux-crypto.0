From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: KASAN: use-after-free Read in sha512_ctx_mgr_resubmit
Date: Wed, 22 Aug 2018 14:20:36 +0800
Message-ID: <20180822062036.mdq4q5o5zdzuxh7s@gondor.apana.org.au>
References: <00000000000072d64d05737b6b8c@google.com>
 <20180820073119.GA14931@sol.localdomain>
 <CAKv+Gu9Y0TLOuMba43HPihYqy-kk0nttBfPj1_UukiYy1cBcFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@kernel.org>,
        Megha Dey <megha.dey@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot <syzbot+d5455bac3ba1ee9114e5@syzkaller.appspotmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        the arch/x86 maintainers <x86@kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9Y0TLOuMba43HPihYqy-kk0nttBfPj1_UukiYy1cBcFw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 21, 2018 at 02:43:56PM +0200, Ard Biesheuvel wrote:
>
> I agree. The code is obviously broken in a way that would have been
> noticed if it were in wide use, and it is too complicated for mere
> mortals to fix or maintain. I suggest we simply remove it for now, and
> if anyone wants to reintroduce it, we can review the code *and* the
> justification for the approach from scratch (in which case we should
> consider factoring out the algo agnostics plumbing in a way that
> allows it to be reused by other architectures as well)

I agree too.  Could one of you guys send me a patch to remove
them?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
