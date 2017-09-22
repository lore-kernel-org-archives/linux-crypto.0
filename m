From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Fri, 22 Sep 2017 11:38:05 -0700
Message-ID: <b65e912f-eeb3-5f1e-bb4a-2dffc0b6481e@zytor.com>
References: <20170816151235.oamkdva6cwpc4cex@gmail.com>
 <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com>
 <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
 <20170825080443.tvvr6wzs362cjcuu@gmail.com>
 <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
 <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com>
 <20170921155919.skpyt7dutod5ul4t@gmail.com>
 <CAJcbSZHOuxy5BVxD0xJUdQfB-OMgbvfiP-2CJzf52K-7JZAy-A@mail.gmail.com>
 <20170922163225.bfrd5myl6d7deiim@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Len Brown <len.brown@intel.com>, Pavel Mach
To: Ingo Molnar <mingo@kernel.org>, Thomas Garnier <thgarnie@google.com>
Return-path: <kernel-hardening-return-9939-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170922163225.bfrd5myl6d7deiim@gmail.com>
Content-Language: en-US
List-Id: linux-crypto.vger.kernel.org

On 09/22/17 09:32, Ingo Molnar wrote:
> 
> BTW., I think things improved with ORC because with ORC we have RBP as an extra 
> register and with PIE we lose RBX - so register pressure in code generation is 
> lower.
> 

We lose EBX on 32 bits, but we don't lose RBX on 64 bits - since x86-64
has RIP-relative addressing there is no need for a dedicated PIC register.

I'm somewhat confused how we can have as much as almost 1% overhead.  I
suspect that we end up making a GOT and maybe even a PLT for no good reason.

	-hpa
