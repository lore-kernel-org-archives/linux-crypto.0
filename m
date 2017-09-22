From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Fri, 22 Sep 2017 12:06:16 -0700
Message-ID: <0c04349a-b9f1-5aae-517b-bd057705ae2e@zytor.com>
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
 <b65e912f-eeb3-5f1e-bb4a-2dffc0b6481e@zytor.com>
 <CAGXu5jKGTYVAKW7yA+ghsb=FYjjfh8MfOiRSEDSw883VN4KUMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Garnier <thgarnie@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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
        "Rafael J . Wys
To: Kees Cook <keescook@chromium.org>
Return-path: <kernel-hardening-return-9940-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAGXu5jKGTYVAKW7yA+ghsb=FYjjfh8MfOiRSEDSw883VN4KUMg@mail.gmail.com>
Content-Language: en-US
List-Id: linux-crypto.vger.kernel.org

On 09/22/17 11:57, Kees Cook wrote:
> On Fri, Sep 22, 2017 at 11:38 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> We lose EBX on 32 bits, but we don't lose RBX on 64 bits - since x86-64
>> has RIP-relative addressing there is no need for a dedicated PIC register.
> 
> FWIW, since gcc 5, the PIC register isn't totally lost. It is now
> reusable, and that seems to have improved performance:
> https://gcc.gnu.org/gcc-5/changes.html

It still talks about a PIC register on x86-64, which confuses me.
Perhaps older gcc's would allocate a PIC register under certain
circumstances, and then lose it for the entire function?

For i386, the PIC register is required by the ABI to be %ebx at the
point any PLT entry is called.  Not an issue with -mno-plt which goes
straight to the GOT, although in most cases there needs to be a PIC
register to find the GOT unless load-time relocation is permitted.

	-hpa
