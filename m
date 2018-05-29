From: Thomas Garnier via Virtualization
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH v4 00/27] x86: PIE support and option to extend KASLR
	randomization
Date: Tue, 29 May 2018 15:15:01 -0700
Message-ID: <20180529221625.33541-1-thgarnie@google.com>
Reply-To: Thomas Garnier <thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Pavel Machek <pavel@ucw.cz>,
	Christoph Lameter <cl@linux.com>, linux-arch@vger.kernel.org,
	linux-sparse@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
	xen-devel@lists.xenproject.org, Petr Mladek <pmladek@suse.com>,
	linux-pm@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
	Cao jin <caoj.fnst@cn.fujitsu.com>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, nixiaoming <nixiaoming@huawei.com>,
	Skip Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
	Jia Zhang <qianyue.zj@alibaba-inc.com>,
	"Luis R. Rodriguez" <mcgrof@kernel.org>, linux-crypto@vger.kernel.org,
	Greg Kroah-Hartman <gre
To: kernel-hardening@lists.openwall.com
Return-path: <virtualization-bounces@lists.linux-foundation.org>
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

Changes:
 - patch v4:
   - Simplify early boot by removing global variables.
   - Modify the mcount location script for __mcount_loc intead of the address
     read in the ftrace implementation.
   - Edit commit description to explain better where the kernel can be located.
   - Streamlined the testing done on each patch proposal. Always testing
     hibernation, suspend, ftrace and kprobe to ensure no regressions.
 - patch v3:
   - Update on message to describe longer term PIE goal.
   - Minor change on ftrace if condition.
   - Changed code using xchgq.
 - patch v2:
   - Adapt patch to work post KPTI and compiler changes
   - Redo all performance testing with latest configs and compilers
   - Simplify mov macro on PIE (MOVABS now)
   - Reduce GOT footprint
 - patch v1:
   - Simplify ftrace implementation.
   - Use gcc mstack-protector-guard-reg=%gs with PIE when possible.
 - rfc v3:
   - Use --emit-relocs instead of -pie to reduce dynamic relocation space on
     mapped memory. It also simplifies the relocation process.
   - Move the start the module section next to the kernel. Remove the need for
     -mcmodel=large on modules. Extends module space from 1 to 2G maximum.
   - Support for XEN PVH as 32-bit relocations can be ignored with
     --emit-relocs.
   - Support for GOT relocations previously done automatically with -pie.
   - Remove need for dynamic PLT in modules.
   - Support dymamic GOT for modules.
 - rfc v2:
   - Add support for global stack cookie while compiler default to fs without
     mcmodel=kernel
   - Change patch 7 to correctly jump out of the identity mapping on kexec load
     preserve.

These patches make the changes necessary to build the kernel as Position
Independent Executable (PIE) on x86_64. A PIE kernel can be relocated below
the top 2G of the virtual address space. It allows to optionally extend the
KASLR randomization range from 1G to 3G. The chosen range is the one currently
available, future changes will allow the kernel module to have a wider
randomization range.

Thanks a lot to Ard Biesheuvel & Kees Cook on their feedback on compiler
changes, PIE support and KASLR in general. Thanks to Roland McGrath on his
feedback for using -pie versus --emit-relocs and details on compiler code
generation.

The patches:
 - 1-3, 5-13, 18-19: Change in assembly code to be PIE compliant.
 - 4: Add a new _ASM_MOVABS macro to fetch a symbol address generically.
 - 14: Adapt percpu design to work correctly when PIE is enabled.
 - 15: Provide an option to default visibility to hidden except for key symbols.
       It removes errors between compilation units.
 - 16: Add PROVIDE_HIDDEN replacement on the linker script for weak symbols to
       reduce GOT footprint.
 - 17: Adapt relocation tool to handle PIE binary correctly.
 - 20: Add support for global cookie.
 - 21: Support ftrace with PIE (used on Ubuntu config).
 - 22: Add option to move the module section just after the kernel.
 - 23: Adapt module loading to support PIE with dynamic GOT.
 - 24: Make the GOT read-only.
 - 25: Add the CONFIG_X86_PIE option (off by default).
 - 26: Adapt relocation tool to generate a 64-bit relocation table.
 - 27: Add the CONFIG_RANDOMIZE_BASE_LARGE option to increase relocation range
       from 1G to 3G (off by default).

Performance/Size impact:

Size of vmlinux (Default configuration):
 File size:
 - PIE disabled: +0.18%
 - PIE enabled: -1.977% (less relocations)
 .text section:
 - PIE disabled: same
 - PIE enabled: same

Size of vmlinux (Ubuntu configuration):
 File size:
 - PIE disabled: +0.21%
 - PIE enabled: +10%
 .text section:
 - PIE disabled: same
 - PIE enabled: +0.001%

The size increase is mainly due to not having access to the 32-bit signed
relocation that can be used with mcmodel=kernel. A small part is due to reduced
optimization for PIE code. This bug [1] was opened with gcc to provide a better
code generation for kernel PIE.

Hackbench (50% and 1600% on thread/process for pipe/sockets):
 - PIE disabled: no significant change (avg -/+ 0.5% on latest test).
 - PIE enabled: between -1% to +1% in average (default and Ubuntu config).

Kernbench (average of 10 Half and Optimal runs):
 Elapsed Time:
 - PIE disabled: no significant change (avg -0.5%)
 - PIE enabled: average -0.5% to +0.5%
 System Time:
 - PIE disabled: no significant change (avg -0.1%)
 - PIE enabled: average -0.4% to +0.4%.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82303

diffstat:
 Documentation/x86/x86_64/mm.txt              |    3 
 arch/x86/Kconfig                             |   45 ++++++
 arch/x86/Makefile                            |   58 ++++++++
 arch/x86/boot/boot.h                         |    2 
 arch/x86/boot/compressed/Makefile            |    5 
 arch/x86/boot/compressed/misc.c              |   10 +
 arch/x86/crypto/aes-x86_64-asm_64.S          |   45 ++++--
 arch/x86/crypto/aesni-intel_asm.S            |    8 -
 arch/x86/crypto/aesni-intel_avx-x86_64.S     |    6 
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  |   42 +++---
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S |   44 +++---
 arch/x86/crypto/camellia-x86_64-asm_64.S     |    8 -
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S    |   50 ++++---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |   44 +++---
 arch/x86/crypto/des3_ede-asm_64.S            |   96 +++++++++-----
 arch/x86/crypto/ghash-clmulni-intel_asm.S    |    4 
 arch/x86/crypto/glue_helper-asm-avx.S        |    4 
 arch/x86/crypto/glue_helper-asm-avx2.S       |    6 
 arch/x86/crypto/sha256-avx2-asm.S            |   23 ++-
 arch/x86/entry/calling.h                     |    2 
 arch/x86/entry/entry_32.S                    |    3 
 arch/x86/entry/entry_64.S                    |   25 ++-
 arch/x86/include/asm/asm.h                   |    1 
 arch/x86/include/asm/bug.h                   |    2 
 arch/x86/include/asm/ftrace.h                |    4 
 arch/x86/include/asm/jump_label.h            |    8 -
 arch/x86/include/asm/kvm_host.h              |    8 -
 arch/x86/include/asm/module.h                |   11 +
 arch/x86/include/asm/page_64_types.h         |    9 +
 arch/x86/include/asm/paravirt_types.h        |   12 +
 arch/x86/include/asm/percpu.h                |   25 ++-
 arch/x86/include/asm/pgtable_64_types.h      |    6 
 arch/x86/include/asm/pm-trace.h              |    2 
 arch/x86/include/asm/processor.h             |   16 +-
 arch/x86/include/asm/sections.h              |    8 +
 arch/x86/include/asm/setup.h                 |    2 
 arch/x86/include/asm/stackprotector.h        |   19 ++
 arch/x86/kernel/Makefile                     |    6 
 arch/x86/kernel/acpi/wakeup_64.S             |   31 ++--
 arch/x86/kernel/asm-offsets.c                |    3 
 arch/x86/kernel/asm-offsets_32.c             |    3 
 arch/x86/kernel/asm-offsets_64.c             |    3 
 arch/x86/kernel/cpu/common.c                 |    3 
 arch/x86/kernel/cpu/microcode/core.c         |    4 
 arch/x86/kernel/ftrace.c                     |   42 +++++-
 arch/x86/kernel/head64.c                     |   23 ++-
 arch/x86/kernel/head_32.S                    |    3 
 arch/x86/kernel/head_64.S                    |   31 +++-
 arch/x86/kernel/kvm.c                        |    6 
 arch/x86/kernel/module.c                     |  181 ++++++++++++++++++++++++++-
 arch/x86/kernel/module.lds                   |    3 
 arch/x86/kernel/process.c                    |    5 
 arch/x86/kernel/relocate_kernel_64.S         |   16 +-
 arch/x86/kernel/setup_percpu.c               |    5 
 arch/x86/kernel/vmlinux.lds.S                |   13 +
 arch/x86/kvm/svm.c                           |    4 
 arch/x86/lib/cmpxchg16b_emu.S                |    8 -
 arch/x86/mm/dump_pagetables.c                |    3 
 arch/x86/power/hibernate_asm_64.S            |    4 
 arch/x86/tools/relocs.c                      |  169 +++++++++++++++++++++++--
 arch/x86/tools/relocs.h                      |    4 
 arch/x86/tools/relocs_common.c               |   15 +-
 arch/x86/xen/xen-asm.S                       |   12 -
 arch/x86/xen/xen-head.S                      |   11 -
 arch/x86/xen/xen-pvh.S                       |   13 +
 drivers/base/firmware_loader/main.c          |    4 
 include/asm-generic/sections.h               |    6 
 include/asm-generic/vmlinux.lds.h            |   12 +
 include/linux/compiler.h                     |    7 +
 init/Kconfig                                 |   16 ++
 kernel/kallsyms.c                            |   16 +-
 kernel/trace/trace.h                         |    4 
 lib/dynamic_debug.c                          |    4 
 scripts/link-vmlinux.sh                      |   14 ++
 scripts/recordmcount.c                       |   79 +++++++----
 75 files changed, 1109 insertions(+), 343 deletions(-)
