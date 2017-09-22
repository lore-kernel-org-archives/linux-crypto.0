From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Fri, 22 Sep 2017 11:27:07 -0700
Message-ID: <c830ba59-65d3-187f-3868-732059269f28@zytor.com>
References: <20170810172615.51965-1-thgarnie@google.com>
 <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com>
 <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com>
 <20170821133222.2ek6bhqgdeoymxsg@hirez.programming.kicks-ass.net>
 <20170821142854.dmuusnbc2tsrai3v@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Thomas Garnier <thgarnie@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Matthias Kaehlcke <mka@chromium.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross
 <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>,
        Brian Gerst <brgerst@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Mache
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Return-path: <kernel-hardening-return-9936-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170821142854.dmuusnbc2tsrai3v@hirez.programming.kicks-ass.net>
Content-Language: en-US
List-Id: linux-crypto.vger.kernel.org

On 08/21/17 07:28, Peter Zijlstra wrote:
> 
> Ah, I see, this is large mode and that needs to use MOVABS to load 64bit
> immediates. Still, small RIP relative should be able to live at any
> point as long as everything lives inside the same 2G relative range, so
> would still allow the goal of increasing the KASLR range.
> 
> So I'm not seeing how we need large mode for that. That said, after
> reading up on all this, RIP relative will not be too pretty either,
> while CALL is naturally RIP relative, data still needs an explicit %rip
> offset, still loads better than the large model.
> 

The large model makes no sense whatsoever.  I think what we're actually
looking for is the small-PIC model.

Ingo asked:
> I.e. is there no GCC code generation mode where code can be placed anywhere in the 
> canonical address space, yet call and jump distance is within 31 bits so that the 
> generated code is fast?

That's the small-PIC model.  I think if all symbols are forced to hidden
then it won't even need a GOT/PLT.

We do need to consider how we want modules to fit into whatever model we
choose, though.  They can be adjacent, or we could go with a more
traditional dynamic link model where the modules can be separate, and
chained together with the main kernel via the GOT.

	-hpa
