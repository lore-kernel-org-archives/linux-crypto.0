From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC v3 20/27] x86/ftrace: Adapt function tracing for PIE support
Date: Thu, 5 Oct 2017 12:11:32 -0400
Message-ID: <20171005121132.7c1f4855@gandalf.local.home>
References: <20171004212003.28296-1-thgarnie@google.com>
	<20171004212003.28296-21-thgarnie@google.com>
	<20171005090633.5a6ce840@gandalf.local.home>
	<CAJcbSZHa3SyCR8zEm-Yor9CmBUfcjr0eE_6HMnaeq83gitdJNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Michal Hocko <mhocko@suse.com>,
	Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	linux-doc@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>,
	Len Brown <len.brown@intel.com>, Peter Zijlstra <peterz@infradead.org>,
	Christopher Li <sparse@chrisli.org>, "Jan H .
	=?UTF-8?B?U2Now7ZuaGVycg==?=" <jschoenh@amazon.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Matthew Wilcox <mawilcox@microsoft.com>,
	virtualization@lists.linux-foundation.org,
	David Howells <dhowells@redhat.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
	Chris Metcalf <cmetcalf@mellanox.com>,
	the arch/x86 maintainers <x86@kernel.or
To: Thomas Garnier <thgarnie@google.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <CAJcbSZHa3SyCR8zEm-Yor9CmBUfcjr0eE_6HMnaeq83gitdJNQ@mail.gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 5 Oct 2017 09:01:14 -0700
Thomas Garnier <thgarnie@google.com> wrote:

> On Thu, Oct 5, 2017 at 6:06 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Wed,  4 Oct 2017 14:19:56 -0700
> > Thomas Garnier <thgarnie@google.com> wrote:
> >  
> >> When using -fPIE/PIC with function tracing, the compiler generates a
> >> call through the GOT (call *__fentry__@GOTPCREL). This instruction
> >> takes 6 bytes instead of 5 on the usual relative call.
> >>
> >> With this change, function tracing supports 6 bytes on traceable
> >> function and can still replace relative calls on the ftrace assembly
> >> functions.
> >>
> >> Position Independent Executable (PIE) support will allow to extended the
> >> KASLR randomization range below the -2G memory limit.  
> >
> > Question: This 6 bytes is only the initial call that gcc creates. When
> > function tracing is enabled, the calls are back to the normal call to
> > the ftrace trampoline?  
> 
> That is correct.
> 

Then I think a better idea is to simply nop them out at compile time,
and have the code that updates them to nops to know about it.

See scripts/recordmcount.c

Could we simply add a 5 byte nop followed by a 1 byte nop, and treat it
the same as if it didn't exist? This code can be a little complex, and
can cause really nasty side effects if things go wrong. I would like to
keep from adding more variables to the changes here.

-- Steve
