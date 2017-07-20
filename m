From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC 16/22] x86/percpu: Adapt percpu for PIE support
Date: Wed, 19 Jul 2017 20:03:16 -0700
Message-ID: <b9bb87ee-7c85-3f94-3ef5-a3ca432f302d@zytor.com>
References: <20170718223333.110371-1-thgarnie@google.com>
 <20170718223333.110371-17-thgarnie@google.com>
 <CAMzpN2g5YkFZTY7yfvG03QUKc-=asKMZbqke9g4e2oT_pgg7Yw@mail.gmail.com>
 <CAJcbSZFXrDZikh9P5M81ztkiMv7EhO4x0bzBdYE8RYC=HMZgqg@mail.gmail.com>
 <25a2974a-fbb4-ea4b-d090-582d6d0de7fd@zytor.com>
 <9b152d55-8a1a-75b5-58df-0fe33458107a@zytor.com>
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
        Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Christian Borntraeger
 <borntraeger@de.ibm.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.
To: Thomas Garnier <thgarnie@google.com>, Brian Gerst <brgerst@gmail.com>
Return-path: <kernel-hardening-return-9083-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <9b152d55-8a1a-75b5-58df-0fe33458107a@zytor.com>
Content-Language: en-US
List-Id: linux-crypto.vger.kernel.org

On 07/19/17 19:21, H. Peter Anvin wrote:
> On 07/19/17 16:33, H. Peter Anvin wrote:
>>>
>>> I agree that it is odd but that's how the compiler generates code. I
>>> will re-explore PIC options with mcmodel=small or medium, as mentioned
>>> on other threads.
>>
>> Why should the way compiler generates code affect the way we do things
>> in assembly?
>>
>> That being said, the compiler now has support for generating this kind
>> of code explicitly via the __seg_gs pointer modifier.  That should let
>> us drop the __percpu_prefix and just use variables directly.  I suspect
>> we want to declare percpu variables as "volatile __seg_gs" to account
>> for the possibility of CPU switches.
>>
>> Older compilers won't be able to work with this, of course, but I think
>> that it is acceptable for those older compilers to not be able to
>> support PIE.
>>
> 
> Grump.  It turns out that the compiler doesn't do the right thing for
> symbols marked with the __seg_[fg]s markers.  __thread does the right
> thing, but __thread a) has %fs: hard-coded, still, and b) I believe can
> still cache %seg:0 arbitrarily long.

I filed this bug report for gcc:

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81490

It might still be possible to work around this by playing really ugly
games with __thread, but I haven't yet figured out how best to do that.

	-hpa
