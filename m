From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [RFC v3 20/27] x86/ftrace: Adapt function tracing for PIE support
Date: Thu, 5 Oct 2017 09:01:14 -0700
Message-ID: <CAJcbSZHa3SyCR8zEm-Yor9CmBUfcjr0eE_6HMnaeq83gitdJNQ@mail.gmail.com>
References: <20171004212003.28296-1-thgarnie@google.com> <20171004212003.28296-21-thgarnie@google.com>
 <20171005090633.5a6ce840@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
	Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
	Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>,
	Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@orac
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <kernel-hardening-return-10086-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20171005090633.5a6ce840@gandalf.local.home>
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 5, 2017 at 6:06 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed,  4 Oct 2017 14:19:56 -0700
> Thomas Garnier <thgarnie@google.com> wrote:
>
>> When using -fPIE/PIC with function tracing, the compiler generates a
>> call through the GOT (call *__fentry__@GOTPCREL). This instruction
>> takes 6 bytes instead of 5 on the usual relative call.
>>
>> With this change, function tracing supports 6 bytes on traceable
>> function and can still replace relative calls on the ftrace assembly
>> functions.
>>
>> Position Independent Executable (PIE) support will allow to extended the
>> KASLR randomization range below the -2G memory limit.
>
> Question: This 6 bytes is only the initial call that gcc creates. When
> function tracing is enabled, the calls are back to the normal call to
> the ftrace trampoline?

That is correct.

>
> -- Steve
>



-- 
Thomas
