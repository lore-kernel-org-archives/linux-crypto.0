From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography
 library
Date: Tue, 11 Sep 2018 15:08:50 -0700
Message-ID: <20180911220849.GC81235@gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com>
 <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 11, 2018 at 12:08:56PM +0200, Ard Biesheuvel wrote:
> 
> I won't go into the 1000s lines of generated assembly again - you
> already know my position on that topic.
> 

I'd strongly prefer the assembly to be readable too.  Jason, I'm not sure if
you've actually read through the asm from the OpenSSL implementations, but the
generated .S files actually do lose a lot of semantic information that was in
the original .pl scripts.  For example, in the Poly1305 NEON implementation
which I'm especially interested in (but you could check any of the other
generated files too), the original .pl script has register aliases showing the
meaning of each register.  Just grabbing a random hunk:

        vshr.u64    $T0,$D3,#26
        vmovn.i64   $D3#lo,$D3
         vshr.u64   $T1,$D0,#26
         vmovn.i64  $D0#lo,$D0
        vadd.i64    $D4,$D4,$T0     @ h3 -> h4
        vbic.i32    $D3#lo,#0xfc000000
          vsri.u32  $H4,$H3,#8      @ base 2^32 -> base 2^26
         vadd.i64   $D1,$D1,$T1     @ h0 -> h1
          vshl.u32  $H3,$H3,#18
         vbic.i32   $D0#lo,#0xfc000000

(Yes, it's still not *that* readable, but D0-D4 and H0-H4 map directly to d0-d4
and h0-h4 in the C implementation.  So someone familiar with Poly1305
implementations can figure it out.)

In contrast, the generated .S file just has the raw registers.  It's difficult
to remember what each register is used for.  In fact, someone who actually
wanted to figure it out would probably find themselves referring to the .pl
script -- which raises the question of why the .S file is the "source" and not
the .pl script...

        vshr.u64        q15,q8,#26
        vmovn.i64       d16,q8
         vshr.u64       q4,q5,#26
         vmovn.i64      d10,q5
        vadd.i64        q9,q9,q15               @ h3 -> h4
        vbic.i32        d16,#0xfc000000
          vsri.u32      q14,q13,#8              @ base 2^32 -> base 2^26
         vadd.i64       q6,q6,q4                @ h0 -> h1
          vshl.u32      q13,q13,#18
         vbic.i32       d10,#0xfc000000

- Eric
