From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v1 15/27] compiler: Option to default to hidden symbols
Date: Wed, 18 Oct 2017 16:15:10 -0700
Message-ID: <CAJcbSZEJ-kjcRQD3uHm0QZuOvbHpg9FV=wn7v4-RweDG7J3uqg@mail.gmail.com>
References: <20171011203027.11248-1-thgarnie@google.com> <20171011203027.11248-16-thgarnie@google.com>
 <20171012200201.GW11645@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Guenter Roeck <linux@roeck-us.net>, Nicholas Piggin <npiggin@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>,
	Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>,
	"Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>,
	Alok Kataria <akataria@vmware.com>, Rusty Russell <rust
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Return-path: <kernel-hardening-return-10187-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20171012200201.GW11645@wotan.suse.de>
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 12, 2017 at 1:02 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Wed, Oct 11, 2017 at 01:30:15PM -0700, Thomas Garnier wrote:
>> Provide an option to default visibility to hidden except for key
>> symbols. This option is disabled by default and will be used by x86_64
>> PIE support to remove errors between compilation units.
>>
>> The default visibility is also enabled for external symbols that are
>> compared as they maybe equals (start/end of sections). In this case,
>> older versions of GCC will remove the comparison if the symbols are
>> hidden. This issue exists at least on gcc 4.9 and before.
>>
>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>
> <-- snip -->
>
>> diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
>> index 86e8f0b2537b..8f021783a929 100644
>> --- a/arch/x86/kernel/cpu/microcode/core.c
>> +++ b/arch/x86/kernel/cpu/microcode/core.c
>> @@ -144,8 +144,8 @@ static bool __init check_loader_disabled_bsp(void)
>>       return *res;
>>  }
>>
>> -extern struct builtin_fw __start_builtin_fw[];
>> -extern struct builtin_fw __end_builtin_fw[];
>> +extern struct builtin_fw __start_builtin_fw[] __default_visibility;
>> +extern struct builtin_fw __end_builtin_fw[] __default_visibility;
>>
>>  bool get_builtin_firmware(struct cpio_data *cd, const char *name)
>>  {
>
> <-- snip -->
>
>> diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
>> index e5da44eddd2f..1aa5d6dac9e1 100644
>> --- a/include/asm-generic/sections.h
>> +++ b/include/asm-generic/sections.h
>> @@ -30,6 +30,9 @@
>>   *   __irqentry_text_start, __irqentry_text_end
>>   *   __softirqentry_text_start, __softirqentry_text_end
>>   */
>> +#ifdef CONFIG_DEFAULT_HIDDEN
>> +#pragma GCC visibility push(default)
>> +#endif
>>  extern char _text[], _stext[], _etext[];
>>  extern char _data[], _sdata[], _edata[];
>>  extern char __bss_start[], __bss_stop[];
>> @@ -46,6 +49,9 @@ extern char __softirqentry_text_start[], __softirqentry_text_end[];
>>
>>  /* Start and end of .ctors section - used for constructor calls. */
>>  extern char __ctors_start[], __ctors_end[];
>> +#ifdef CONFIG_DEFAULT_HIDDEN
>> +#pragma GCC visibility pop
>> +#endif
>>
>>  extern __visible const void __nosave_begin, __nosave_end;
>>
>> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
>> index e95a2631e545..6997716f73bf 100644
>> --- a/include/linux/compiler.h
>> +++ b/include/linux/compiler.h
>> @@ -78,6 +78,14 @@ extern void __chk_io_ptr(const volatile void __iomem *);
>>  #include <linux/compiler-clang.h>
>>  #endif
>>
>> +/* Useful for Position Independent Code to reduce global references */
>> +#ifdef CONFIG_DEFAULT_HIDDEN
>> +#pragma GCC visibility push(hidden)
>> +#define __default_visibility  __attribute__((visibility ("default")))
>
> Does this still work with CONFIG_LD_DEAD_CODE_DATA_ELIMINATION ?

I cannot make it work with or without this change. How is it supposed
to be used?

For me with, it crashes with a bad consdev at:
http://elixir.free-electrons.com/linux/latest/source/drivers/tty/tty_io.c#L3194

>
>> +#else
>> +#define __default_visibility
>> +#endif
>> +
>>  /*
>>   * Generic compiler-dependent macros required for kernel
>>   * build go below this comment. Actual compiler/compiler version
>> diff --git a/init/Kconfig b/init/Kconfig
>> index ccb1d8daf241..b640201fcff7 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -1649,6 +1649,13 @@ config PROFILING
>>  config TRACEPOINTS
>>       bool
>>
>> +#
>> +# Default to hidden visibility for all symbols.
>> +# Useful for Position Independent Code to reduce global references.
>> +#
>> +config DEFAULT_HIDDEN
>> +     bool
>
> Note it is default.
>
> Has 0-day ran through this git tree? It should be easy to get it added for
> testing. Also, even though most changes are x86 based there are some generic
> changes and I'd love a warm fuzzy this won't break odd / random builds.
> Although 0-day does cover a lot of test cases, it only has limited run time
> tests. There are some other test beds which also cover some more obscure
> architectures. Having a test pass on Guenter's test bed would be nice to
> see. For that please coordinate with Guenter if he's willing to run this
> a test for you.

Not yet, plan to give a v1.5 to Kees Cook to keep in one of his tree
for couple weeks. I expect it will identify interesting issues.

>
>   Luis



-- 
Thomas
