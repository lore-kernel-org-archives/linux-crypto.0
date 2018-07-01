From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] x86/crypto: Add missing RETs
Date: Sun, 1 Jul 2018 23:45:09 +0800
Message-ID: <20180701154509.2drdk6bhromkf3d7@gondor.apana.org.au>
References: <tip-51bad67ffbce0aaa44579f84ef5d05597054ec6a@git.kernel.org>
 <1529235613.4572.7.camel@gmx.de>
 <20180617120012.GB16877@zn.tnic>
 <1529242717.4472.3.camel@gmx.de>
 <1529244178.4674.1.camel@gmx.de>
 <20180617194747.GA21160@zn.tnic>
 <1529289279.31745.3.camel@gmx.de>
 <20180623103622.GA2760@zn.tnic>
 <20180701131941.2dqkzg7az25qpc6b@gondor.apana.org.au>
 <CAAUqJDt+DyRj_Q1D05d0D7pJQYjCZas6uz8aZ0xsQVE=vSETxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: bp@alien8.de, linux-crypto@vger.kernel.org, efault@gmx.de,
        Alexey Dobriyan <adobriyan@gmail.com>,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, jpoimboe@redhat.com, luto@kernel.org,
        peterz@infradead.org, brgerst@gmail.com, hpa@zytor.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dvlasenk@redhat.com, h.peter.anvin@intel.com,
        linux-tip-commits@vger.kernel.org
To: Ondrej =?utf-8?B?TW9zbsOhxI1law==?=
        <omosnacek+linux-crypto@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAUqJDt+DyRj_Q1D05d0D7pJQYjCZas6uz8aZ0xsQVE=vSETxA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jul 01, 2018 at 05:24:39PM +0200, Ondrej Mosnáček wrote:
>
> I can see you applied this patch to your cryptodev-2.6 tree (which I
> believe is for the next release). Shouldn't this go into the
> crypto-2.6 tree so it gets into 4.18-rcX? I'm not sure, but it seems
> to me that it qualifies as a (potentially serious?) bug fix.
> 
> Also, I think you accidentally extracted the wrong part of the e-mail
> as the commit message...

Thanks, it should all be fixed now.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
