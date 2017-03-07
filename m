From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3] MIPS: Fix build breakage caused by header file changes
Date: Tue, 7 Mar 2017 08:38:05 +0100
Message-ID: <20170307073805.GB15693@gmail.com>
References: <1488827635-7708-1-git-send-email-linux@roeck-us.net>
 <20170306232019.GG2878@jhogan-linux.le.imgtec.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Guenter Roeck <linux@roeck-us.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
To: James Hogan <james.hogan@imgtec.com>
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <20170306232019.GG2878@jhogan-linux.le.imgtec.org>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
List-Id: linux-crypto.vger.kernel.org


* James Hogan <james.hogan@imgtec.com> wrote:

> Hi Guenter,
> 
> On Mon, Mar 06, 2017 at 11:13:55AM -0800, Guenter Roeck wrote:
> > Since commit f3ac60671954 ("sched/headers: Move task-stack related
> > APIs from <linux/sched.h> to <linux/sched/task_stack.h>") and commit
> > f780d89a0e82 ("sched/headers: Remove <asm/ptrace.h> from
> > <linux/sched.h>"), various mips builds fail as follows.
> > 
> > arch/mips/kernel/smp-mt.c: In function ‘vsmp_boot_secondary’:
> > arch/mips/include/asm/processor.h:384:41: error:
> > 	implicit declaration of function ‘task_stack_page’
> > 
> > In file included from
> > 	/opt/buildbot/slave/hwmon-testing/build/arch/mips/kernel/pm.c:
> > arch/mips/include/asm/fpu.h: In function '__own_fpu':
> > arch/mips/include/asm/processor.h:385:31: error:
> > 	invalid application of 'sizeof' to incomplete type 'struct pt_regs'
> 
> This one is in an inline function, so I think it'd affect multiple
> includes of <asm/fpu.h> even if __own_fpu isn't used, so I think the
> following patch which adds the include ptrace.h in fpu.h is more robust
> than adding to the individual c files affected:
> https://patchwork.linux-mips.org/patch/15386/
> 
> Admitedly it could probably have a more specific subject line since
> there are more similar errors.

Just a quick question: is your MIPS build fix going to be merged and sent to 
Linus? I can apply it too, and send it to Linus later today, together with a few 
other sched.h header related build fixes.

Assuming it's all properly tested - my limited MIPS defconfig builds worked fine - 
but MIPS has a lot of build variations.

Either way is fine to me.

Thanks,

	Ingo
