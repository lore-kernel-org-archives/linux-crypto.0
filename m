From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v4 23/27] x86_64: assembly, change all ENTRY+ENDPROC to SYM_FUNC_*
Date: Mon, 02 Oct 2017 14:30:44 +0200
Message-ID: <2385272.r5rgpIyQDx@aspire.rjw.lan>
References: <20171002091246.28432-1-jslaby@suse.cz> <20171002091246.28432-23-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>, linux-crypto@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-efi@vger.kernel.org,
        xen-devel@lists.xenproject.org
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171002091246.28432-23-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Monday, October 2, 2017 11:12:42 AM CEST Jiri Slaby wrote:
> These are all functions which are invoked from elsewhere, so we annotate
> them as global using the new SYM_FUNC_START. And their ENDPROC's by
> SYM_FUNC_END.
> 
> And make sure ENTRY/ENDPROC is not defined on X86_64, given these were
> the last users.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: x86@kernel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-efi@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org
> ---
>  arch/x86/boot/compressed/efi_thunk_64.S            |  4 +-
>  arch/x86/boot/compressed/head_64.S                 | 16 ++++----
>  arch/x86/crypto/aes-i586-asm_32.S                  |  8 ++--
>  arch/x86/crypto/aes-x86_64-asm_64.S                |  4 +-
>  arch/x86/crypto/aes_ctrby8_avx-x86_64.S            | 12 +++---
>  arch/x86/crypto/aesni-intel_asm.S                  | 44 +++++++++++-----------
>  arch/x86/crypto/aesni-intel_avx-x86_64.S           | 24 ++++++------
>  arch/x86/crypto/blowfish-x86_64-asm_64.S           | 16 ++++----
>  arch/x86/crypto/camellia-aesni-avx-asm_64.S        | 24 ++++++------
>  arch/x86/crypto/camellia-aesni-avx2-asm_64.S       | 24 ++++++------
>  arch/x86/crypto/camellia-x86_64-asm_64.S           | 16 ++++----
>  arch/x86/crypto/cast5-avx-x86_64-asm_64.S          | 16 ++++----
>  arch/x86/crypto/cast6-avx-x86_64-asm_64.S          | 24 ++++++------
>  arch/x86/crypto/chacha20-avx2-x86_64.S             |  4 +-
>  arch/x86/crypto/chacha20-ssse3-x86_64.S            |  8 ++--
>  arch/x86/crypto/crc32-pclmul_asm.S                 |  4 +-
>  arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |  4 +-
>  arch/x86/crypto/crct10dif-pcl-asm_64.S             |  4 +-
>  arch/x86/crypto/des3_ede-asm_64.S                  |  8 ++--
>  arch/x86/crypto/ghash-clmulni-intel_asm.S          |  8 ++--
>  arch/x86/crypto/poly1305-avx2-x86_64.S             |  4 +-
>  arch/x86/crypto/poly1305-sse2-x86_64.S             |  8 ++--
>  arch/x86/crypto/salsa20-x86_64-asm_64.S            | 12 +++---
>  arch/x86/crypto/serpent-avx-x86_64-asm_64.S        | 24 ++++++------
>  arch/x86/crypto/serpent-avx2-asm_64.S              | 24 ++++++------
>  arch/x86/crypto/serpent-sse2-x86_64-asm_64.S       |  8 ++--
>  arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S   |  8 ++--
>  arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S  |  4 +-
>  arch/x86/crypto/sha1-mb/sha1_x8_avx2.S             |  4 +-
>  arch/x86/crypto/sha1_avx2_x86_64_asm.S             |  4 +-
>  arch/x86/crypto/sha1_ni_asm.S                      |  4 +-
>  arch/x86/crypto/sha1_ssse3_asm.S                   |  4 +-
>  arch/x86/crypto/sha256-avx-asm.S                   |  4 +-
>  arch/x86/crypto/sha256-avx2-asm.S                  |  4 +-
>  .../crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S    |  8 ++--
>  .../crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S   |  4 +-
>  arch/x86/crypto/sha256-mb/sha256_x8_avx2.S         |  4 +-
>  arch/x86/crypto/sha256-ssse3-asm.S                 |  4 +-
>  arch/x86/crypto/sha256_ni_asm.S                    |  4 +-
>  arch/x86/crypto/sha512-avx-asm.S                   |  4 +-
>  arch/x86/crypto/sha512-avx2-asm.S                  |  4 +-
>  .../crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S    |  8 ++--
>  .../crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S   |  4 +-
>  arch/x86/crypto/sha512-mb/sha512_x4_avx2.S         |  4 +-
>  arch/x86/crypto/sha512-ssse3-asm.S                 |  4 +-
>  arch/x86/crypto/twofish-avx-x86_64-asm_64.S        | 24 ++++++------
>  arch/x86/crypto/twofish-x86_64-asm_64-3way.S       |  8 ++--
>  arch/x86/crypto/twofish-x86_64-asm_64.S            |  8 ++--
>  arch/x86/entry/entry_64.S                          | 10 ++---
>  arch/x86/entry/entry_64_compat.S                   |  8 ++--
>  arch/x86/kernel/acpi/wakeup_64.S                   |  8 ++--
>  arch/x86/kernel/head_64.S                          | 12 +++---
>  arch/x86/lib/checksum_32.S                         |  8 ++--
>  arch/x86/lib/clear_page_64.S                       | 12 +++---
>  arch/x86/lib/cmpxchg16b_emu.S                      |  4 +-
>  arch/x86/lib/cmpxchg8b_emu.S                       |  4 +-
>  arch/x86/lib/copy_page_64.S                        |  4 +-
>  arch/x86/lib/copy_user_64.S                        | 16 ++++----
>  arch/x86/lib/csum-copy_64.S                        |  4 +-
>  arch/x86/lib/getuser.S                             | 16 ++++----
>  arch/x86/lib/hweight.S                             |  8 ++--
>  arch/x86/lib/iomap_copy_64.S                       |  4 +-
>  arch/x86/lib/memcpy_64.S                           |  4 +-
>  arch/x86/lib/memmove_64.S                          |  4 +-
>  arch/x86/lib/memset_64.S                           |  4 +-
>  arch/x86/lib/msr-reg.S                             |  8 ++--
>  arch/x86/lib/putuser.S                             | 16 ++++----
>  arch/x86/lib/rwsem.S                               | 20 +++++-----
>  arch/x86/mm/mem_encrypt_boot.S                     |  8 ++--
>  arch/x86/platform/efi/efi_stub_64.S                |  4 +-
>  arch/x86/platform/efi/efi_thunk_64.S               |  4 +-
>  arch/x86/power/hibernate_asm_64.S                  |  8 ++--

For the hibernate changes:

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
