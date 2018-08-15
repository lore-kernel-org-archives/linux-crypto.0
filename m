From: Alexander Popov <alex.popov@linux.com>
Subject: Re: [GIT PULL] gcc-plugin updates for v4.19-rc1
Date: Thu, 16 Aug 2018 00:18:56 +0300
Message-ID: <90a49b4e-7b17-0262-e358-27343549d990@linux.com>
References: <20180813214328.GA15137@beast>
 <CA+55aFw5Tkn6DgkAZS-UGOjJpYp2R4rFAm9ixu_=FONeqRyofg@mail.gmail.com>
 <CAGXu5jK_w7JRywdQ78FfQxeLSMmXbvyDDnaYzj27=y8wnAzKxQ@mail.gmail.com>
 <CA+55aFyFCWH3YJnRUKtSzs9Mvny0eU+=QANxoPTE+9B9CkUWDw@mail.gmail.com>
 <CAGXu5jJ1JNSxJABUTAO85z_hXjSkjD=nWEho7KrYJTqqVGivig@mail.gmail.com>
 <CA+55aFy6jNLsywVYdGp83AMrXBo_P-pkjkphPGrO=82SPKCpLQ@mail.gmail.com>
 <CAGXu5j+Yv9Bu4mJPOfkpxrom91kSKaUESHR-Tn1CAJCTTZy_8w@mail.gmail.com>
Reply-To: alex.popov@linux.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Mark Rutland <mark.rutland@arm.com>,
        Laura Abbott <labbott@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto <linux-crypto@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+Yv9Bu4mJPOfkpxrom91kSKaUESHR-Tn1CAJCTTZy_8w@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 15.08.2018 23:56, Kees Cook wrote:
> On Wed, Aug 15, 2018 at 1:18 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> I absolutely refuse to take any hardening patches at all that have
>> BUG() or panic() or similar machine-killing in it.
> 
> Okay, mental model adjusted. :) It was only "strong discouraged" until now.

I've just got the insight, how to avoid having BUG_ON() in stackleak_erase().
If 'task_struct.lowest_stack' is corrupted, we can erase once starting from the
stack bottom and reset the 'lowest_stack' value.

>> I care not one whit about the reason for them. In fact, if the reason
>> is stated as "it makes debugging easiler", then I fart in your general
>> direction and call your mother a hamster.

That is plain harassment. I ask to *stop* it!

--
Alexander
