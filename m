From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v11 00/13] Intel SGX1 support
Date: Fri,  8 Jun 2018 19:09:35 +0200
Message-ID: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Cc: dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        intel-sgx-kernel-dev@lists.01.org (open list:INTEL SGX),
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        kvm@vger.kernel.org (open list:
To: x86@kernel.org, platform-driver-x86@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Intel(R) SGX is a set of CPU instructions that can be used by applications
to set aside private regions of code and data. The code outside the enclave
is disallowed to access the memory inside the enclave by the CPU access
control.  In a way you can think that SGX provides inverted sandbox. It
protects the application from a malicious host.

There is a new hardware unit in the processor called Memory Encryption
Engine (MEE) starting from the Skylake microacrhitecture. BIOS can define
one or many MEE regions that can hold enclave data by configuring them with
PRMRR registers.

The MEE automatically encrypts the data leaving the processor package to
the MEE regions. The data is encrypted using a random key whose life-time
is exactly one power cycle.

You can tell if your CPU supports SGX by looking into /proc/cpuinfo:

	cat /proc/cpuinfo  | grep sgx

v11:
* Polished ENCLS wrappers with refined exception handling.
* ksgxswapd was not stopped (regression in v5) in
  sgx_page_cache_teardown(), which causes a leaked kthread after driver
  deinitialization.
* Shutdown sgx_le_proxy when going to suspend because its EPC pages will be
  invalidated when resuming, which will cause it not function properly
  anymore.
* Set EINITTOKEN.VALID to zero for a token that is passed when
  SGXLEPUBKEYHASH matches MRSIGNER as alloc_page() does not give a zero
  page.
* Fixed the check in sgx_edbgrd() for a TCS page. Allowed to read offsets
  around the flags field, which causes a #GP. Only flags read is readable.
* On read access memcpy() call inside sgx_vma_access() had src and dest
  parameters in wrong order.
* The build issue with CONFIG_KASAN is now fixed. Added undefined symbols
  to LE even if “KASAN_SANITIZE := false” was set in the makefile. 
* Fixed a regression in the #PF handler. If a page has
  SGX_ENCL_PAGE_RESERVED flag the #PF handler should unconditionally fail.
  It did not, which caused weird races when trying to change other parts of
  swapping code.
* EPC management has been refactored to a flat LRU cache and moved to
  arch/x86. The swapper thread reads a cluster of EPC pages and swaps all
  of them. It can now swap from multiple enclaves in the same round.
* For the sake of consistency with SGX_IOC_ENCLAVE_ADD_PAGE, return -EINVAL
  when an enclave is already initialized or dead instead of zero.

v10:
* Cleaned up anon inode based IPC between the ring-0 and ring-3 parts
  of the driver.
* Unset the reserved flag from an enclave page if EDBGRD/WR fails
  (regression in v6).
* Close the anon inode when LE is stopped (regression in v9).
* Update the documentation with a more detailed description of SGX.

v9:
* Replaced kernel-LE IPC based on pipes with an anonymous inode.
  The driver does not require anymore new exports.

v8:
* Check that public key MSRs match the LE public key hash in the
  driver initialization when the MSRs are read-only.
* Fix the race in VA slot allocation by checking the fullness
  immediately after succeesful allocation.
* Fix the race in hash mrsigner calculation between the launch
  enclave and user enclaves by having a separate lock for hash
  calculation.

v7:
* Fixed offset calculation in sgx_edbgr/wr(). Address was masked with PAGE_MASK
  when it should have been masked with ~PAGE_MASK.
* Fixed a memory leak in sgx_ioc_enclave_create().
* Simplified swapping code by using a pointer array for a cluster
  instead of a linked list.
* Squeezed struct sgx_encl_page to 32 bytes.
* Fixed deferencing of an RSA key on OpenSSL 1.1.0.
* Modified TC's CMAC to use kernel AES-NI. Restructured the code
  a bit in order to better align with kernel conventions.

v6:
* Fixed semaphore underrun when accessing /dev/sgx from the launch enclave.
* In sgx_encl_create() s/IS_ERR(secs)/IS_ERR(encl)/.
* Removed virtualization chapter from the documentation.
* Changed the default filename for the signing key as signing_key.pem.
* Reworked EPC management in a way that instead of a linked list of
  struct sgx_epc_page instances there is an array of integers that
  encodes address and bank of an EPC page (the same data as 'pa' field
  earlier). The locking has been moved to the EPC bank level instead
  of a global lock.
* Relaxed locking requirements for EPC management. EPC pages can be
  released back to the EPC bank concurrently.
* Cleaned up ptrace() code.
* Refined commit messages for new architectural constants.
* Sorted includes in every source file.
* Sorted local variable declarations according to the line length in
  every function.
* Style fixes based on Darren's comments to sgx_le.c.

v5:
* Described IPC between the Launch Enclave and kernel in the commit messages.
* Fixed all relevant checkpatch.pl issues that I have forgot fix in earlier
  versions except those that exist in the imported TinyCrypt code.
* Fixed spelling mistakes in the documentation.
* Forgot to check the return value of sgx_drv_subsys_init().
* Encapsulated properly page cache init and teardown.
* Collect epc pages to a temp list in sgx_add_epc_bank
* Removed SGX_ENCLAVE_INIT_ARCH constant.

v4:
* Tied life-cycle of the sgx_le_proxy process to /dev/sgx.
* Removed __exit annotation from sgx_drv_subsys_exit().
* Fixed a leak of a backing page in sgx_process_add_page_req() in the
  case when vm_insert_pfn() fails.
* Removed unused symbol exports for sgx_page_cache.c.
* Updated sgx_alloc_page() to require encl parameter and documented the
  behavior (Sean Christopherson).
* Refactored a more lean API for sgx_encl_find() and documented the behavior.
* Moved #PF handler to sgx_fault.c.
* Replaced subsys_system_register() with plain bus_register().
* Retry EINIT 2nd time only if MSRs are not locked.

v3:
* Check that FEATURE_CONTROL_LOCKED and FEATURE_CONTROL_SGX_ENABLE are set.
* Return -ERESTARTSYS in __sgx_encl_add_page() when sgx_alloc_page() fails.
* Use unused bits in epc_page->pa to store the bank number.
* Removed #ifdef for WQ_NONREENTRANT.
* If mmu_notifier_register() fails with -EINTR, return -ERESTARTSYS.
* Added --remove-section=.got.plt to objcopy flags in order to prevent a
  dummy .got.plt, which will cause an inconsistent size for the LE.
* Documented sgx_encl_* functions.
* Added remark about AES implementation used inside the LE.
* Removed redundant sgx_sys_exit() from le/main.c.
* Fixed struct sgx_secinfo alignment from 128 to 64 bytes.
* Validate miscselect in sgx_encl_create().
* Fixed SSA frame size calculation to take the misc region into account.
* Implemented consistent exception handling to __encls() and __encls_ret().
* Implemented a proper device model in order to allow sysfs attributes
  and in-kernel API.
* Cleaned up various "find enclave" implementations to the unified
  sgx_encl_find().
* Validate that vm_pgoff is zero.
* Discard backing pages with shmem_truncate_range() after EADD.
* Added missing EEXTEND operations to LE signing and launch.
* Fixed SSA size for GPRS region from 168 to 184 bytes.
* Fixed the checks for TCS flags. Now DBGOPTIN is allowed.
* Check that TCS addresses are in ELRANGE and not just page aligned.
* Require kernel to be compiled with X64_64 and CPU_SUP_INTEL.
* Fixed an incorrect value for SGX_ATTR_DEBUG from 0x01 to 0x02.

v2:
* get_rand_uint32() changed the value of the pointer instead of value
  where it is pointing at.
* Launch enclave incorrectly used sigstruct attributes-field instead of
  enclave attributes-field.
* Removed unused struct sgx_add_page_req from sgx_ioctl.c
* Removed unused sgx_has_sgx2.
* Updated arch/x86/include/asm/sgx.h so that it provides stub
  implementations when sgx in not enabled.
* Removed cruft rdmsr-calls from sgx_set_pubkeyhash_msrs().
* return -ENOMEM in sgx_alloc_page() when VA pages consume too much space
* removed unused global sgx_nr_pids
* moved sgx_encl_release to sgx_encl.c
* return -ERESTARTSYS instead of -EINTR in sgx_encl_init()


Jarkko Sakkinen (7):
  x86, sgx: updated MAINTAINERS
  x86, sgx: added ENCLS wrappers
  x86, sgx: basic routines for enclave page cache
  intel_sgx: driver for Intel Software Guard Extensions
  intel_sgx: ptrace() support
  intel_sgx: driver documentation
  intel_sgx: in-kernel launch enclave

Kai Huang (1):
  x86, sgx: add SGX definitions to cpufeature

Sean Christopherson (5):
  compiler.h, kasan: add __SANITIZE_ADDRESS__ check for
    __no_kasan_or_inline
  x86, sgx: add SGX definitions to msr-index.h
  x86, cpufeatures: add Intel-defined SGX leaf CPUID_12_EAX
  crypto: aesni: add minimal build option for SGX LE
  x86, sgx: detect Intel SGX

 Documentation/index.rst                       |   1 +
 Documentation/x86/intel_sgx.rst               | 195 ++++
 MAINTAINERS                                   |   7 +
 arch/x86/Kconfig                              |  19 +
 arch/x86/crypto/aesni-intel_asm.S             |  11 +
 arch/x86/include/asm/cpufeature.h             |   7 +-
 arch/x86/include/asm/cpufeatures.h            |  10 +-
 arch/x86/include/asm/disabled-features.h      |   3 +-
 arch/x86/include/asm/msr-index.h              |   8 +
 arch/x86/include/asm/required-features.h      |   3 +-
 arch/x86/include/asm/sgx.h                    | 289 +++++
 arch/x86/include/asm/sgx_arch.h               | 224 ++++
 arch/x86/include/asm/sgx_le.h                 |  17 +
 arch/x86/include/asm/sgx_pr.h                 |  36 +
 arch/x86/include/uapi/asm/sgx.h               | 138 +++
 arch/x86/kernel/cpu/Makefile                  |   1 +
 arch/x86/kernel/cpu/common.c                  |   7 +
 arch/x86/kernel/cpu/intel_sgx.c               | 492 +++++++++
 arch/x86/kvm/cpuid.h                          |   1 +
 drivers/platform/x86/Kconfig                  |   2 +
 drivers/platform/x86/Makefile                 |   1 +
 drivers/platform/x86/intel_sgx/Kconfig        |  34 +
 drivers/platform/x86/intel_sgx/Makefile       |  32 +
 drivers/platform/x86/intel_sgx/le/Makefile    |  34 +
 .../x86/intel_sgx/le/enclave/Makefile         |  54 +
 .../intel_sgx/le/enclave/aesni-intel_asm.S    |   1 +
 .../x86/intel_sgx/le/enclave/cmac_mode.c      | 209 ++++
 .../x86/intel_sgx/le/enclave/cmac_mode.h      |  54 +
 .../x86/intel_sgx/le/enclave/encl_bootstrap.S | 116 ++
 .../platform/x86/intel_sgx/le/enclave/main.c  | 146 +++
 .../platform/x86/intel_sgx/le/enclave/main.h  |  19 +
 .../x86/intel_sgx/le/enclave/sgx_le.lds       |  33 +
 .../x86/intel_sgx/le/enclave/sgxsign.c        | 551 ++++++++++
 .../x86/intel_sgx/le/enclave/string.c         |   1 +
 drivers/platform/x86/intel_sgx/le/entry.S     |  70 ++
 .../x86/intel_sgx/le/include/sgx_asm.h        |  15 +
 drivers/platform/x86/intel_sgx/le/main.c      | 140 +++
 drivers/platform/x86/intel_sgx/le/main.h      |  30 +
 .../platform/x86/intel_sgx/le/sgx_le_piggy.S  |  22 +
 drivers/platform/x86/intel_sgx/le/string.c    |  39 +
 drivers/platform/x86/intel_sgx/sgx.h          | 181 ++++
 drivers/platform/x86/intel_sgx/sgx_encl.c     | 988 ++++++++++++++++++
 .../platform/x86/intel_sgx/sgx_encl_page.c    | 294 ++++++
 drivers/platform/x86/intel_sgx/sgx_fault.c    | 159 +++
 drivers/platform/x86/intel_sgx/sgx_ioctl.c    | 235 +++++
 drivers/platform/x86/intel_sgx/sgx_le.c       | 303 ++++++
 .../x86/intel_sgx/sgx_le_proxy_piggy.S        |  22 +
 drivers/platform/x86/intel_sgx/sgx_main.c     | 373 +++++++
 drivers/platform/x86/intel_sgx/sgx_vma.c      | 182 ++++
 include/linux/compiler.h                      |   2 +-
 50 files changed, 5805 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/x86/intel_sgx.rst
 create mode 100644 arch/x86/include/asm/sgx.h
 create mode 100644 arch/x86/include/asm/sgx_arch.h
 create mode 100644 arch/x86/include/asm/sgx_le.h
 create mode 100644 arch/x86/include/asm/sgx_pr.h
 create mode 100644 arch/x86/include/uapi/asm/sgx.h
 create mode 100644 arch/x86/kernel/cpu/intel_sgx.c
 create mode 100644 drivers/platform/x86/intel_sgx/Kconfig
 create mode 100644 drivers/platform/x86/intel_sgx/Makefile
 create mode 100644 drivers/platform/x86/intel_sgx/le/Makefile
 create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/Makefile
 create mode 120000 drivers/platform/x86/intel_sgx/le/enclave/aesni-intel_asm.S
 create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/cmac_mode.c
 create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/cmac_mode.h
 create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/encl_bootstrap.S
 create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/main.c
 create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/main.h
 create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/sgx_le.lds
 create mode 100644 drivers/platform/x86/intel_sgx/le/enclave/sgxsign.c
 create mode 120000 drivers/platform/x86/intel_sgx/le/enclave/string.c
 create mode 100644 drivers/platform/x86/intel_sgx/le/entry.S
 create mode 100644 drivers/platform/x86/intel_sgx/le/include/sgx_asm.h
 create mode 100644 drivers/platform/x86/intel_sgx/le/main.c
 create mode 100644 drivers/platform/x86/intel_sgx/le/main.h
 create mode 100644 drivers/platform/x86/intel_sgx/le/sgx_le_piggy.S
 create mode 100644 drivers/platform/x86/intel_sgx/le/string.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx.h
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_encl.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_encl_page.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_fault.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_ioctl.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_le.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_le_proxy_piggy.S
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_main.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_vma.c

-- 
2.17.0
