From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 21/27] x86/ftrace: Adapt function tracing for PIE
	support
Date: Thu, 24 May 2018 16:16:22 -0400
Message-ID: <20180524161622.4202319f@gandalf.local.home>
References: <20180523195421.180248-1-thgarnie@google.com>
	<20180523195421.180248-22-thgarnie@google.com>
	<20180524114024.pa67zjipy5qcg4tm@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Kate Stewart <kstewart@linuxfoundation.org>,
	Nicolas Pitre <nicolas.pitre@linaro.org>, x86@kernel.org,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	kvm@vger.kernel.org, Len Brown <len.brown@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Yonghong Song <yhs@fb.com>, Christopher Li <sparse@chrisli.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Jan Beulich <JBeulich@suse.com>, Pavel Machek <pavel@ucw.cz>, "H .
	Peter Anvin" <hpa@zytor.com>, kernel-hardening@lists.openwall.com,
	Christoph Lameter <cl@linux.com>,
	Alok Kataria <akataria@vmware.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Baoquan He <bhe@redhat.com>, David Woodhouse <dwmw@amazon.
To: Petr Mladek <pmladek@suse.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180524114024.pa67zjipy5qcg4tm@pathway.suse.cz>
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

On Thu, 24 May 2018 13:40:24 +0200
Petr Mladek <pmladek@suse.com> wrote:

> On Wed 2018-05-23 12:54:15, Thomas Garnier wrote:
> > When using -fPIE/PIC with function tracing, the compiler generates a
> > call through the GOT (call *__fentry__@GOTPCREL). This instruction
> > takes 6 bytes instead of 5 on the usual relative call.
> > 
> > If PIE is enabled, replace the 6th byte of the GOT call by a 1-byte nop
> > so ftrace can handle the previous 5-bytes as before.
> > 
> > Position Independent Executable (PIE) support will allow to extended the
> > KASLR randomization range below the -2G memory limit.
> > 
> > Signed-off-by: Thomas Garnier <thgarnie@google.com>
> > ---
> >  arch/x86/include/asm/ftrace.h   |  6 +++--
> >  arch/x86/include/asm/sections.h |  4 ++++
> >  arch/x86/kernel/ftrace.c        | 42 +++++++++++++++++++++++++++++++--
> >  3 files changed, 48 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> > index c18ed65287d5..8f2decce38d8 100644
> > --- a/arch/x86/include/asm/ftrace.h
> > +++ b/arch/x86/include/asm/ftrace.h
> > @@ -25,9 +25,11 @@ extern void __fentry__(void);
> >  static inline unsigned long ftrace_call_adjust(unsigned long addr)
> >  {
> >  	/*
> > -	 * addr is the address of the mcount call instruction.
> > -	 * recordmcount does the necessary offset calculation.
> > +	 * addr is the address of the mcount call instruction. PIE has always a
> > +	 * byte added to the start of the function.
> >  	 */
> > +	if (IS_ENABLED(CONFIG_X86_PIE))
> > +		addr -= 1;  
> 
> This seems to modify the address even for modules that are _not_ compiled with
> PIE, see below.

Can one load a module not compiled for PIE in a kernel with PIE?

> 
> >  	return addr;
> >  }
> >  
> > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > index 01ebcb6f263e..73b3c30cb7a3 100644
> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > @@ -135,6 +135,44 @@ ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
> >  	return 0;
> >  }
> >  
> > +/* Bytes before call GOT offset */
> > +const unsigned char got_call_preinsn[] = { 0xff, 0x15 };
> > +
> > +static int
> > +ftrace_modify_initial_code(unsigned long ip, unsigned const char *old_code,
> > +			   unsigned const char *new_code)
> > +{
> > +	unsigned char replaced[MCOUNT_INSN_SIZE + 1];
> > +
> > +	ftrace_expected = old_code;
> > +
> > +	/*
> > +	 * If PIE is not enabled or no GOT call was found, default to the
> > +	 * original approach to code modification.
> > +	 */
> > +	if (!IS_ENABLED(CONFIG_X86_PIE) ||
> > +	    probe_kernel_read(replaced, (void *)ip, sizeof(replaced)) ||
> > +	    memcmp(replaced, got_call_preinsn, sizeof(got_call_preinsn)))
> > +		return ftrace_modify_code_direct(ip, old_code, new_code);  
> 
> And this looks like an attempt to handle modules compiled without
> PIE. Does it works with the right ip in that case?

I'm guessing the || is for the "or no GOT call was found", but it
doesn't explain why no GOT would be found.

> 
> I wonder if a better solution would be to update
> scripts/recordmcount.c to store the incremented location into the module.

If recordmcount.c can handle this, then I think that's the preferred
approach. Thanks!

-- Steve

> 
> IMPORTANT: I have only vague picture about how this all works. It is
> possible that I am completely wrong. The code might be correct,
> especially if you tested this situation.
> 
> Best Regards,
> Petr
