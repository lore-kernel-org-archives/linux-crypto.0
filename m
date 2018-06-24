From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86/crypto: Add missing RETs
Date: Sun, 24 Jun 2018 12:15:03 +0200
Message-ID: <20180624101503.GA26953@zn.tnic>
References: <tip-51bad67ffbce0aaa44579f84ef5d05597054ec6a@git.kernel.org>
 <1529235613.4572.7.camel@gmx.de>
 <20180617120012.GB16877@zn.tnic>
 <1529242717.4472.3.camel@gmx.de>
 <1529244178.4674.1.camel@gmx.de>
 <20180617194747.GA21160@zn.tnic>
 <1529289279.31745.3.camel@gmx.de>
 <20180623103622.GA2760@zn.tnic>
 <20180624071105.GA29407@gmail.com>
 <alpine.DEB.2.21.1806240911520.8650@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Ingo Molnar <mingo@kernel.org>, linux-crypto@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        torvalds@linux-foundation.org, jpoimboe@redhat.com,
        luto@kernel.org, peterz@infradead.org, brgerst@gmail.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, dvlasenk@redhat.com,
        h.peter.anvin@intel.com,
        linux-tip-commits <linux-tip-commits@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1806240911520.8650@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jun 24, 2018 at 09:12:35AM +0200, Thomas Gleixner wrote:
> We should really have something like that exactly to catch cases like this.

Sounds like a good use case for the snake language.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
