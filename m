From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH v5 23/27] x86_64: assembly, change all ENTRY+ENDPROC to SYM_FUNC_*
Date: Thu, 30 Nov 2017 15:46:49 +0100
Message-ID: <20171130144653.23688-24-jslaby@suse.cz>
References: <20171130144653.23688-1-jslaby@suse.cz>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>,
        Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>,
        Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
        Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>,
        Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
To: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171130144653.23688-1-jslaby-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

These are all functions which are invoked from elsewhere, so we annotate
them as global using the new SYM_FUNC_START. And their ENDPROC's by
SYM_FUNC_END.

And make sure ENTRY/ENDPROC is not defined on X86_64, given these were
the last users.

Signed-off-by: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> [hibernate]
Reviewed-by: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> [xen bits]
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
---
 arch/x86/boot/compressed/efi_thunk_64.S            |  4 +-
 arch/x86/boot/compressed/head_64.S                 | 16 ++++----
 arch/x86/boot/compressed/mem_encrypt.S             |  8 ++--
 arch/x86/crypto/aes-i586-asm_32.S                  |  8 ++--
 arch/x86/crypto/aes-x86_64-asm_64.S                |  4 +-
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S            | 12 +++---
 arch/x86/crypto/aesni-intel_asm.S                  | 44 +++++++++++-----------
 arch/x86/crypto/aesni-intel_avx-x86_64.S           | 24 ++++++------
 arch/x86/crypto/blowfish-x86_64-asm_64.S           | 16 ++++----
 arch/x86/crypto/camellia-aesni-avx-asm_64.S        | 24 ++++++------
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S       | 24 ++++++------
 arch/x86/crypto/camellia-x86_64-asm_64.S           | 16 ++++----
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S          | 16 ++++----
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S          | 24 ++++++------
 arch/x86/crypto/chacha20-avx2-x86_64.S             |  4 +-
 arch/x86/crypto/chacha20-ssse3-x86_64.S            |  8 ++--
 arch/x86/crypto/crc32-pclmul_asm.S                 |  4 +-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |  4 +-
 arch/x86/crypto/crct10dif-pcl-asm_64.S             |  4 +-
 arch/x86/crypto/des3_ede-asm_64.S                  |  8 ++--
 arch/x86/crypto/ghash-clmulni-intel_asm.S          |  8 ++--
 arch/x86/crypto/poly1305-avx2-x86_64.S             |  4 +-
 arch/x86/crypto/poly1305-sse2-x86_64.S             |  8 ++--
 arch/x86/crypto/salsa20-x86_64-asm_64.S            | 12 +++---
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S        | 24 ++++++------
 arch/x86/crypto/serpent-avx2-asm_64.S              | 24 ++++++------
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S       |  8 ++--
 arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S   |  8 ++--
 arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S  |  4 +-
 arch/x86/crypto/sha1-mb/sha1_x8_avx2.S             |  4 +-
 arch/x86/crypto/sha1_avx2_x86_64_asm.S             |  4 +-
 arch/x86/crypto/sha1_ni_asm.S                      |  4 +-
 arch/x86/crypto/sha1_ssse3_asm.S                   |  4 +-
 arch/x86/crypto/sha256-avx-asm.S                   |  4 +-
 arch/x86/crypto/sha256-avx2-asm.S                  |  4 +-
 .../crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S    |  8 ++--
 .../crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S   |  4 +-
 arch/x86/crypto/sha256-mb/sha256_x8_avx2.S         |  4 +-
 arch/x86/crypto/sha256-ssse3-asm.S                 |  4 +-
 arch/x86/crypto/sha256_ni_asm.S                    |  4 +-
 arch/x86/crypto/sha512-avx-asm.S                   |  4 +-
 arch/x86/crypto/sha512-avx2-asm.S                  |  4 +-
 .../crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S    |  8 ++--
 .../crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S   |  4 +-
 arch/x86/crypto/sha512-mb/sha512_x4_avx2.S         |  4 +-
 arch/x86/crypto/sha512-ssse3-asm.S                 |  4 +-
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S        | 24 ++++++------
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S       |  8 ++--
 arch/x86/crypto/twofish-x86_64-asm_64.S            |  8 ++--
 arch/x86/entry/entry_64.S                          | 10 ++---
 arch/x86/entry/entry_64_compat.S                   |  8 ++--
 arch/x86/kernel/acpi/wakeup_64.S                   |  8 ++--
 arch/x86/kernel/head_64.S                          | 12 +++---
 arch/x86/lib/checksum_32.S                         |  8 ++--
 arch/x86/lib/clear_page_64.S                       | 12 +++---
 arch/x86/lib/cmpxchg16b_emu.S                      |  4 +-
 arch/x86/lib/cmpxchg8b_emu.S                       |  4 +-
 arch/x86/lib/copy_page_64.S                        |  4 +-
 arch/x86/lib/copy_user_64.S                        | 16 ++++----
 arch/x86/lib/csum-copy_64.S                        |  4 +-
 arch/x86/lib/getuser.S                             | 16 ++++----
 arch/x86/lib/hweight.S                             |  8 ++--
 arch/x86/lib/iomap_copy_64.S                       |  4 +-
 arch/x86/lib/memcpy_64.S                           |  4 +-
 arch/x86/lib/memmove_64.S                          |  4 +-
 arch/x86/lib/memset_64.S                           |  4 +-
 arch/x86/lib/msr-reg.S                             |  8 ++--
 arch/x86/lib/putuser.S                             | 16 ++++----
 arch/x86/lib/rwsem.S                               | 24 ++++++------
 arch/x86/mm/mem_encrypt_boot.S                     |  8 ++--
 arch/x86/platform/efi/efi_stub_64.S                |  4 +-
 arch/x86/platform/efi/efi_thunk_64.S               |  4 +-
 arch/x86/power/hibernate_asm_64.S                  |  8 ++--
 arch/x86/xen/xen-asm.S                             | 20 +++++-----
 arch/x86/xen/xen-asm_64.S                          | 16 ++++----
 include/linux/linkage.h                            |  4 ++
 76 files changed, 367 insertions(+), 363 deletions(-)

diff --git a/arch/x86/boot/compressed/efi_thunk_64.S b/arch/x86/boot/compressed/efi_thunk_64.S
index 31312070db22..593913692d16 100644
--- a/arch/x86/boot/compressed/efi_thunk_64.S
+++ b/arch/x86/boot/compressed/efi_thunk_64.S
@@ -23,7 +23,7 @@
 
 	.code64
 	.text
-ENTRY(efi64_thunk)
+SYM_FUNC_START(efi64_thunk)
 	push	%rbp
 	push	%rbx
 
@@ -97,7 +97,7 @@ ENTRY(efi64_thunk)
 	pop	%rbx
 	pop	%rbp
 	ret
-ENDPROC(efi64_thunk)
+SYM_FUNC_END(efi64_thunk)
 
 SYM_FUNC_START_LOCAL(efi_exit32)
 	movq	func_rt_ptr(%rip), %rax
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 647be777b5cc..23712b54cc21 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -44,7 +44,7 @@
 
 	__HEAD
 	.code32
-ENTRY(startup_32)
+SYM_FUNC_START(startup_32)
 	/*
 	 * 32bit entry is 0 and it is ABI so immutable!
 	 * If we come here directly from a bootloader,
@@ -221,11 +221,11 @@ ENTRY(startup_32)
 
 	/* Jump from 32bit compatibility mode into 64bit mode. */
 	lret
-ENDPROC(startup_32)
+SYM_FUNC_END(startup_32)
 
 #ifdef CONFIG_EFI_MIXED
 	.org 0x190
-ENTRY(efi32_stub_entry)
+SYM_FUNC_START(efi32_stub_entry)
 	add	$0x4, %esp		/* Discard return address */
 	popl	%ecx
 	popl	%edx
@@ -244,7 +244,7 @@ ENTRY(efi32_stub_entry)
 	movl	%eax, efi_config(%ebp)
 
 	jmp	startup_32
-ENDPROC(efi32_stub_entry)
+SYM_FUNC_END(efi32_stub_entry)
 #endif
 
 	.code64
@@ -374,7 +374,7 @@ SYM_CODE_END(startup_64)
 #ifdef CONFIG_EFI_STUB
 
 /* The entry point for the PE/COFF executable is efi_pe_entry. */
-ENTRY(efi_pe_entry)
+SYM_FUNC_START(efi_pe_entry)
 	movq	%rcx, efi64_config(%rip)	/* Handle */
 	movq	%rdx, efi64_config+8(%rip) /* EFI System table pointer */
 
@@ -423,10 +423,10 @@ fail:
 	movl	BP_code32_start(%esi), %eax
 	leaq	startup_64(%rax), %rax
 	jmp	*%rax
-ENDPROC(efi_pe_entry)
+SYM_FUNC_END(efi_pe_entry)
 
 	.org 0x390
-ENTRY(efi64_stub_entry)
+SYM_FUNC_START(efi64_stub_entry)
 	movq	%rdi, efi64_config(%rip)	/* Handle */
 	movq	%rsi, efi64_config+8(%rip) /* EFI System table pointer */
 
@@ -435,7 +435,7 @@ ENTRY(efi64_stub_entry)
 
 	movq	%rdx, %rsi
 	jmp	handover_entry
-ENDPROC(efi64_stub_entry)
+SYM_FUNC_END(efi64_stub_entry)
 #endif
 
 	.text
diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
index 54f5f6625a73..a2b622e2bb5f 100644
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -18,7 +18,7 @@
 
 	.text
 	.code32
-ENTRY(get_sev_encryption_bit)
+SYM_FUNC_START(get_sev_encryption_bit)
 	xor	%eax, %eax
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
@@ -85,10 +85,10 @@ ENTRY(get_sev_encryption_bit)
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
 	ret
-ENDPROC(get_sev_encryption_bit)
+SYM_FUNC_END(get_sev_encryption_bit)
 
 	.code64
-ENTRY(get_sev_encryption_mask)
+SYM_FUNC_START(get_sev_encryption_mask)
 	xor	%rax, %rax
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
@@ -113,7 +113,7 @@ ENTRY(get_sev_encryption_mask)
 #endif
 
 	ret
-ENDPROC(get_sev_encryption_mask)
+SYM_FUNC_END(get_sev_encryption_mask)
 
 	.data
 enc_bit:
diff --git a/arch/x86/crypto/aes-i586-asm_32.S b/arch/x86/crypto/aes-i586-asm_32.S
index 2849dbc59e11..5b2636c58527 100644
--- a/arch/x86/crypto/aes-i586-asm_32.S
+++ b/arch/x86/crypto/aes-i586-asm_32.S
@@ -223,7 +223,7 @@
 .extern  crypto_ft_tab
 .extern  crypto_fl_tab
 
-ENTRY(aes_enc_blk)
+SYM_FUNC_START(aes_enc_blk)
 	push    %ebp
 	mov     ctx(%esp),%ebp
 
@@ -287,7 +287,7 @@ ENTRY(aes_enc_blk)
 	mov     %r0,(%ebp)
 	pop     %ebp
 	ret
-ENDPROC(aes_enc_blk)
+SYM_FUNC_END(aes_enc_blk)
 
 // AES (Rijndael) Decryption Subroutine
 /* void aes_dec_blk(struct crypto_aes_ctx *ctx, u8 *out_blk, const u8 *in_blk) */
@@ -295,7 +295,7 @@ ENDPROC(aes_enc_blk)
 .extern  crypto_it_tab
 .extern  crypto_il_tab
 
-ENTRY(aes_dec_blk)
+SYM_FUNC_START(aes_dec_blk)
 	push    %ebp
 	mov     ctx(%esp),%ebp
 
@@ -359,4 +359,4 @@ ENTRY(aes_dec_blk)
 	mov     %r0,(%ebp)
 	pop     %ebp
 	ret
-ENDPROC(aes_dec_blk)
+SYM_FUNC_END(aes_dec_blk)
diff --git a/arch/x86/crypto/aes-x86_64-asm_64.S b/arch/x86/crypto/aes-x86_64-asm_64.S
index 8739cf7795de..22c44ad3ef42 100644
--- a/arch/x86/crypto/aes-x86_64-asm_64.S
+++ b/arch/x86/crypto/aes-x86_64-asm_64.S
@@ -49,7 +49,7 @@
 #define R11	%r11
 
 #define prologue(FUNC,KEY,B128,B192,r1,r2,r5,r6,r7,r8,r9,r10,r11) \
-	ENTRY(FUNC);			\
+	SYM_FUNC_START(FUNC);		\
 	movq	r1,r2;			\
 	leaq	KEY+48(r8),r9;		\
 	movq	r10,r11;		\
@@ -75,7 +75,7 @@
 	movl	r7 ## E,8(r9);		\
 	movl	r8 ## E,12(r9);		\
 	ret;				\
-	ENDPROC(FUNC);
+	SYM_FUNC_END(FUNC);
 
 #define round(TAB,OFFSET,r1,r2,r3,r4,r5,r6,r7,r8,ra,rb,rc,rd) \
 	movzbl	r2 ## H,r5 ## E;	\
diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index 5f6a5af9c489..ec437db1fa54 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -544,11 +544,11 @@ ddq_add_8:
  * aes_ctr_enc_128_avx_by8(void *in, void *iv, void *keys, void *out,
  *			unsigned int num_bytes)
  */
-ENTRY(aes_ctr_enc_128_avx_by8)
+SYM_FUNC_START(aes_ctr_enc_128_avx_by8)
 	/* call the aes main loop */
 	do_aes_ctrmain KEY_128
 
-ENDPROC(aes_ctr_enc_128_avx_by8)
+SYM_FUNC_END(aes_ctr_enc_128_avx_by8)
 
 /*
  * routine to do AES192 CTR enc/decrypt "by8"
@@ -557,11 +557,11 @@ ENDPROC(aes_ctr_enc_128_avx_by8)
  * aes_ctr_enc_192_avx_by8(void *in, void *iv, void *keys, void *out,
  *			unsigned int num_bytes)
  */
-ENTRY(aes_ctr_enc_192_avx_by8)
+SYM_FUNC_START(aes_ctr_enc_192_avx_by8)
 	/* call the aes main loop */
 	do_aes_ctrmain KEY_192
 
-ENDPROC(aes_ctr_enc_192_avx_by8)
+SYM_FUNC_END(aes_ctr_enc_192_avx_by8)
 
 /*
  * routine to do AES256 CTR enc/decrypt "by8"
@@ -570,8 +570,8 @@ ENDPROC(aes_ctr_enc_192_avx_by8)
  * aes_ctr_enc_256_avx_by8(void *in, void *iv, void *keys, void *out,
  *			unsigned int num_bytes)
  */
-ENTRY(aes_ctr_enc_256_avx_by8)
+SYM_FUNC_START(aes_ctr_enc_256_avx_by8)
 	/* call the aes main loop */
 	do_aes_ctrmain KEY_256
 
-ENDPROC(aes_ctr_enc_256_avx_by8)
+SYM_FUNC_END(aes_ctr_enc_256_avx_by8)
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 426a22192d69..17445fe82660 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -1396,7 +1396,7 @@ _esb_loop_\@:
 * poly = x^128 + x^127 + x^126 + x^121 + 1
 *
 *****************************************************************************/
-ENTRY(aesni_gcm_dec)
+SYM_FUNC_START(aesni_gcm_dec)
 	push	%r12
 	push	%r13
 	push	%r14
@@ -1587,7 +1587,7 @@ _return_T_done_decrypt:
 	pop	%r13
 	pop	%r12
 	ret
-ENDPROC(aesni_gcm_dec)
+SYM_FUNC_END(aesni_gcm_dec)
 
 
 /*****************************************************************************
@@ -1673,7 +1673,7 @@ ENDPROC(aesni_gcm_dec)
 *
 * poly = x^128 + x^127 + x^126 + x^121 + 1
 ***************************************************************************/
-ENTRY(aesni_gcm_enc)
+SYM_FUNC_START(aesni_gcm_enc)
 	push	%r12
 	push	%r13
 	push	%r14
@@ -1868,7 +1868,7 @@ _return_T_done_encrypt:
 	pop	%r13
 	pop	%r12
 	ret
-ENDPROC(aesni_gcm_enc)
+SYM_FUNC_END(aesni_gcm_enc)
 
 #endif
 
@@ -1946,7 +1946,7 @@ SYM_FUNC_END(_key_expansion_256b)
  * int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
  *                   unsigned int key_len)
  */
-ENTRY(aesni_set_key)
+SYM_FUNC_START(aesni_set_key)
 	FRAME_BEGIN
 #ifndef __x86_64__
 	pushl KEYP
@@ -2055,12 +2055,12 @@ ENTRY(aesni_set_key)
 #endif
 	FRAME_END
 	ret
-ENDPROC(aesni_set_key)
+SYM_FUNC_END(aesni_set_key)
 
 /*
  * void aesni_enc(struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
  */
-ENTRY(aesni_enc)
+SYM_FUNC_START(aesni_enc)
 	FRAME_BEGIN
 #ifndef __x86_64__
 	pushl KEYP
@@ -2079,7 +2079,7 @@ ENTRY(aesni_enc)
 #endif
 	FRAME_END
 	ret
-ENDPROC(aesni_enc)
+SYM_FUNC_END(aesni_enc)
 
 /*
  * _aesni_enc1:		internal ABI
@@ -2249,7 +2249,7 @@ SYM_FUNC_END(_aesni_enc4)
 /*
  * void aesni_dec (struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
  */
-ENTRY(aesni_dec)
+SYM_FUNC_START(aesni_dec)
 	FRAME_BEGIN
 #ifndef __x86_64__
 	pushl KEYP
@@ -2269,7 +2269,7 @@ ENTRY(aesni_dec)
 #endif
 	FRAME_END
 	ret
-ENDPROC(aesni_dec)
+SYM_FUNC_END(aesni_dec)
 
 /*
  * _aesni_dec1:		internal ABI
@@ -2440,7 +2440,7 @@ SYM_FUNC_END(_aesni_dec4)
  * void aesni_ecb_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
  *		      size_t len)
  */
-ENTRY(aesni_ecb_enc)
+SYM_FUNC_START(aesni_ecb_enc)
 	FRAME_BEGIN
 #ifndef __x86_64__
 	pushl LEN
@@ -2494,13 +2494,13 @@ ENTRY(aesni_ecb_enc)
 #endif
 	FRAME_END
 	ret
-ENDPROC(aesni_ecb_enc)
+SYM_FUNC_END(aesni_ecb_enc)
 
 /*
  * void aesni_ecb_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
  *		      size_t len);
  */
-ENTRY(aesni_ecb_dec)
+SYM_FUNC_START(aesni_ecb_dec)
 	FRAME_BEGIN
 #ifndef __x86_64__
 	pushl LEN
@@ -2555,13 +2555,13 @@ ENTRY(aesni_ecb_dec)
 #endif
 	FRAME_END
 	ret
-ENDPROC(aesni_ecb_dec)
+SYM_FUNC_END(aesni_ecb_dec)
 
 /*
  * void aesni_cbc_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
  *		      size_t len, u8 *iv)
  */
-ENTRY(aesni_cbc_enc)
+SYM_FUNC_START(aesni_cbc_enc)
 	FRAME_BEGIN
 #ifndef __x86_64__
 	pushl IVP
@@ -2599,13 +2599,13 @@ ENTRY(aesni_cbc_enc)
 #endif
 	FRAME_END
 	ret
-ENDPROC(aesni_cbc_enc)
+SYM_FUNC_END(aesni_cbc_enc)
 
 /*
  * void aesni_cbc_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
  *		      size_t len, u8 *iv)
  */
-ENTRY(aesni_cbc_dec)
+SYM_FUNC_START(aesni_cbc_dec)
 	FRAME_BEGIN
 #ifndef __x86_64__
 	pushl IVP
@@ -2692,7 +2692,7 @@ ENTRY(aesni_cbc_dec)
 #endif
 	FRAME_END
 	ret
-ENDPROC(aesni_cbc_dec)
+SYM_FUNC_END(aesni_cbc_dec)
 
 #ifdef __x86_64__
 .pushsection .rodata
@@ -2754,7 +2754,7 @@ SYM_FUNC_END(_aesni_inc)
  * void aesni_ctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
  *		      size_t len, u8 *iv)
  */
-ENTRY(aesni_ctr_enc)
+SYM_FUNC_START(aesni_ctr_enc)
 	FRAME_BEGIN
 	cmp $16, LEN
 	jb .Lctr_enc_just_ret
@@ -2811,7 +2811,7 @@ ENTRY(aesni_ctr_enc)
 .Lctr_enc_just_ret:
 	FRAME_END
 	ret
-ENDPROC(aesni_ctr_enc)
+SYM_FUNC_END(aesni_ctr_enc)
 
 /*
  * _aesni_gf128mul_x_ble:		internal ABI
@@ -2835,7 +2835,7 @@ ENDPROC(aesni_ctr_enc)
  * void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
  *			 bool enc, u8 *iv)
  */
-ENTRY(aesni_xts_crypt8)
+SYM_FUNC_START(aesni_xts_crypt8)
 	FRAME_BEGIN
 	cmpb $0, %cl
 	movl $0, %ecx
@@ -2939,6 +2939,6 @@ ENTRY(aesni_xts_crypt8)
 
 	FRAME_END
 	ret
-ENDPROC(aesni_xts_crypt8)
+SYM_FUNC_END(aesni_xts_crypt8)
 
 #endif
diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index faecb1518bf8..ee056694e54d 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -1531,7 +1531,7 @@ _return_T_done\@:
 #        (gcm_data     *my_ctx_data,
 #        u8     *hash_subkey)# /* H, the Hash sub key input. Data starts on a 16-byte boundary. */
 #############################################################
-ENTRY(aesni_gcm_precomp_avx_gen2)
+SYM_FUNC_START(aesni_gcm_precomp_avx_gen2)
         #the number of pushes must equal STACK_OFFSET
         push    %r12
         push    %r13
@@ -1574,7 +1574,7 @@ ENTRY(aesni_gcm_precomp_avx_gen2)
         pop     %r13
         pop     %r12
         ret
-ENDPROC(aesni_gcm_precomp_avx_gen2)
+SYM_FUNC_END(aesni_gcm_precomp_avx_gen2)
 
 ###############################################################################
 #void   aesni_gcm_enc_avx_gen2(
@@ -1592,10 +1592,10 @@ ENDPROC(aesni_gcm_precomp_avx_gen2)
 #        u64     auth_tag_len)# /* Authenticated Tag Length in bytes.
 #				Valid values are 16 (most likely), 12 or 8. */
 ###############################################################################
-ENTRY(aesni_gcm_enc_avx_gen2)
+SYM_FUNC_START(aesni_gcm_enc_avx_gen2)
         GCM_ENC_DEC_AVX     ENC
 	ret
-ENDPROC(aesni_gcm_enc_avx_gen2)
+SYM_FUNC_END(aesni_gcm_enc_avx_gen2)
 
 ###############################################################################
 #void   aesni_gcm_dec_avx_gen2(
@@ -1613,10 +1613,10 @@ ENDPROC(aesni_gcm_enc_avx_gen2)
 #        u64     auth_tag_len)# /* Authenticated Tag Length in bytes.
 #				Valid values are 16 (most likely), 12 or 8. */
 ###############################################################################
-ENTRY(aesni_gcm_dec_avx_gen2)
+SYM_FUNC_START(aesni_gcm_dec_avx_gen2)
         GCM_ENC_DEC_AVX     DEC
 	ret
-ENDPROC(aesni_gcm_dec_avx_gen2)
+SYM_FUNC_END(aesni_gcm_dec_avx_gen2)
 #endif /* CONFIG_AS_AVX */
 
 #ifdef CONFIG_AS_AVX2
@@ -2855,7 +2855,7 @@ _return_T_done\@:
 #        u8     *hash_subkey)# /* H, the Hash sub key input.
 #				Data starts on a 16-byte boundary. */
 #############################################################
-ENTRY(aesni_gcm_precomp_avx_gen4)
+SYM_FUNC_START(aesni_gcm_precomp_avx_gen4)
         #the number of pushes must equal STACK_OFFSET
         push    %r12
         push    %r13
@@ -2898,7 +2898,7 @@ ENTRY(aesni_gcm_precomp_avx_gen4)
         pop     %r13
         pop     %r12
         ret
-ENDPROC(aesni_gcm_precomp_avx_gen4)
+SYM_FUNC_END(aesni_gcm_precomp_avx_gen4)
 
 
 ###############################################################################
@@ -2917,10 +2917,10 @@ ENDPROC(aesni_gcm_precomp_avx_gen4)
 #        u64     auth_tag_len)# /* Authenticated Tag Length in bytes.
 #				Valid values are 16 (most likely), 12 or 8. */
 ###############################################################################
-ENTRY(aesni_gcm_enc_avx_gen4)
+SYM_FUNC_START(aesni_gcm_enc_avx_gen4)
         GCM_ENC_DEC_AVX2     ENC
 	ret
-ENDPROC(aesni_gcm_enc_avx_gen4)
+SYM_FUNC_END(aesni_gcm_enc_avx_gen4)
 
 ###############################################################################
 #void   aesni_gcm_dec_avx_gen4(
@@ -2938,9 +2938,9 @@ ENDPROC(aesni_gcm_enc_avx_gen4)
 #        u64     auth_tag_len)# /* Authenticated Tag Length in bytes.
 #				Valid values are 16 (most likely), 12 or 8. */
 ###############################################################################
-ENTRY(aesni_gcm_dec_avx_gen4)
+SYM_FUNC_START(aesni_gcm_dec_avx_gen4)
         GCM_ENC_DEC_AVX2     DEC
 	ret
-ENDPROC(aesni_gcm_dec_avx_gen4)
+SYM_FUNC_END(aesni_gcm_dec_avx_gen4)
 
 #endif /* CONFIG_AS_AVX2 */
diff --git a/arch/x86/crypto/blowfish-x86_64-asm_64.S b/arch/x86/crypto/blowfish-x86_64-asm_64.S
index 8c1fcb6bad21..70c34850ee0b 100644
--- a/arch/x86/crypto/blowfish-x86_64-asm_64.S
+++ b/arch/x86/crypto/blowfish-x86_64-asm_64.S
@@ -118,7 +118,7 @@
 	bswapq 			RX0; \
 	xorq RX0, 		(RIO);
 
-ENTRY(__blowfish_enc_blk)
+SYM_FUNC_START(__blowfish_enc_blk)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -154,9 +154,9 @@ ENTRY(__blowfish_enc_blk)
 .L__enc_xor:
 	xor_block();
 	ret;
-ENDPROC(__blowfish_enc_blk)
+SYM_FUNC_END(__blowfish_enc_blk)
 
-ENTRY(blowfish_dec_blk)
+SYM_FUNC_START(blowfish_dec_blk)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -186,7 +186,7 @@ ENTRY(blowfish_dec_blk)
 	movq %r11, %r12;
 
 	ret;
-ENDPROC(blowfish_dec_blk)
+SYM_FUNC_END(blowfish_dec_blk)
 
 /**********************************************************************
   4-way blowfish, four blocks parallel
@@ -298,7 +298,7 @@ ENDPROC(blowfish_dec_blk)
 	bswapq 			RX3; \
 	xorq RX3,		24(RIO);
 
-ENTRY(__blowfish_enc_blk_4way)
+SYM_FUNC_START(__blowfish_enc_blk_4way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -345,9 +345,9 @@ ENTRY(__blowfish_enc_blk_4way)
 	popq %rbx;
 	popq %r12;
 	ret;
-ENDPROC(__blowfish_enc_blk_4way)
+SYM_FUNC_END(__blowfish_enc_blk_4way)
 
-ENTRY(blowfish_dec_blk_4way)
+SYM_FUNC_START(blowfish_dec_blk_4way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -380,4 +380,4 @@ ENTRY(blowfish_dec_blk_4way)
 	popq %r12;
 
 	ret;
-ENDPROC(blowfish_dec_blk_4way)
+SYM_FUNC_END(blowfish_dec_blk_4way)
diff --git a/arch/x86/crypto/camellia-aesni-avx-asm_64.S b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
index 8b6a65524067..c055e844203f 100644
--- a/arch/x86/crypto/camellia-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
@@ -892,7 +892,7 @@ SYM_FUNC_START_LOCAL(__camellia_dec_blk16)
 	jmp .Ldec_max24;
 SYM_FUNC_END(__camellia_dec_blk16)
 
-ENTRY(camellia_ecb_enc_16way)
+SYM_FUNC_START(camellia_ecb_enc_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -915,9 +915,9 @@ ENTRY(camellia_ecb_enc_16way)
 
 	FRAME_END
 	ret;
-ENDPROC(camellia_ecb_enc_16way)
+SYM_FUNC_END(camellia_ecb_enc_16way)
 
-ENTRY(camellia_ecb_dec_16way)
+SYM_FUNC_START(camellia_ecb_dec_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -945,9 +945,9 @@ ENTRY(camellia_ecb_dec_16way)
 
 	FRAME_END
 	ret;
-ENDPROC(camellia_ecb_dec_16way)
+SYM_FUNC_END(camellia_ecb_dec_16way)
 
-ENTRY(camellia_cbc_dec_16way)
+SYM_FUNC_START(camellia_cbc_dec_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -996,7 +996,7 @@ ENTRY(camellia_cbc_dec_16way)
 
 	FRAME_END
 	ret;
-ENDPROC(camellia_cbc_dec_16way)
+SYM_FUNC_END(camellia_cbc_dec_16way)
 
 #define inc_le128(x, minus_one, tmp) \
 	vpcmpeqq minus_one, x, tmp; \
@@ -1004,7 +1004,7 @@ ENDPROC(camellia_cbc_dec_16way)
 	vpslldq $8, tmp, tmp; \
 	vpsubq tmp, x, x;
 
-ENTRY(camellia_ctr_16way)
+SYM_FUNC_START(camellia_ctr_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -1109,7 +1109,7 @@ ENTRY(camellia_ctr_16way)
 
 	FRAME_END
 	ret;
-ENDPROC(camellia_ctr_16way)
+SYM_FUNC_END(camellia_ctr_16way)
 
 #define gf128mul_x_ble(iv, mask, tmp) \
 	vpsrad $31, iv, tmp; \
@@ -1255,7 +1255,7 @@ SYM_FUNC_START_LOCAL(camellia_xts_crypt_16way)
 	ret;
 SYM_FUNC_END(camellia_xts_crypt_16way)
 
-ENTRY(camellia_xts_enc_16way)
+SYM_FUNC_START(camellia_xts_enc_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -1267,9 +1267,9 @@ ENTRY(camellia_xts_enc_16way)
 	leaq __camellia_enc_blk16, %r9;
 
 	jmp camellia_xts_crypt_16way;
-ENDPROC(camellia_xts_enc_16way)
+SYM_FUNC_END(camellia_xts_enc_16way)
 
-ENTRY(camellia_xts_dec_16way)
+SYM_FUNC_START(camellia_xts_dec_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -1285,4 +1285,4 @@ ENTRY(camellia_xts_dec_16way)
 	leaq __camellia_dec_blk16, %r9;
 
 	jmp camellia_xts_crypt_16way;
-ENDPROC(camellia_xts_dec_16way)
+SYM_FUNC_END(camellia_xts_dec_16way)
diff --git a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
index 96b44ad85c59..0c1af357c86d 100644
--- a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
@@ -935,7 +935,7 @@ SYM_FUNC_START_LOCAL(__camellia_dec_blk32)
 	jmp .Ldec_max24;
 SYM_FUNC_END(__camellia_dec_blk32)
 
-ENTRY(camellia_ecb_enc_32way)
+SYM_FUNC_START(camellia_ecb_enc_32way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (32 blocks)
@@ -962,9 +962,9 @@ ENTRY(camellia_ecb_enc_32way)
 
 	FRAME_END
 	ret;
-ENDPROC(camellia_ecb_enc_32way)
+SYM_FUNC_END(camellia_ecb_enc_32way)
 
-ENTRY(camellia_ecb_dec_32way)
+SYM_FUNC_START(camellia_ecb_dec_32way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (32 blocks)
@@ -996,9 +996,9 @@ ENTRY(camellia_ecb_dec_32way)
 
 	FRAME_END
 	ret;
-ENDPROC(camellia_ecb_dec_32way)
+SYM_FUNC_END(camellia_ecb_dec_32way)
 
-ENTRY(camellia_cbc_dec_32way)
+SYM_FUNC_START(camellia_cbc_dec_32way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (32 blocks)
@@ -1064,7 +1064,7 @@ ENTRY(camellia_cbc_dec_32way)
 
 	FRAME_END
 	ret;
-ENDPROC(camellia_cbc_dec_32way)
+SYM_FUNC_END(camellia_cbc_dec_32way)
 
 #define inc_le128(x, minus_one, tmp) \
 	vpcmpeqq minus_one, x, tmp; \
@@ -1080,7 +1080,7 @@ ENDPROC(camellia_cbc_dec_32way)
 	vpslldq $8, tmp1, tmp1; \
 	vpsubq tmp1, x, x;
 
-ENTRY(camellia_ctr_32way)
+SYM_FUNC_START(camellia_ctr_32way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (32 blocks)
@@ -1204,7 +1204,7 @@ ENTRY(camellia_ctr_32way)
 
 	FRAME_END
 	ret;
-ENDPROC(camellia_ctr_32way)
+SYM_FUNC_END(camellia_ctr_32way)
 
 #define gf128mul_x_ble(iv, mask, tmp) \
 	vpsrad $31, iv, tmp; \
@@ -1373,7 +1373,7 @@ SYM_FUNC_START_LOCAL(camellia_xts_crypt_32way)
 	ret;
 SYM_FUNC_END(camellia_xts_crypt_32way)
 
-ENTRY(camellia_xts_enc_32way)
+SYM_FUNC_START(camellia_xts_enc_32way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (32 blocks)
@@ -1386,9 +1386,9 @@ ENTRY(camellia_xts_enc_32way)
 	leaq __camellia_enc_blk32, %r9;
 
 	jmp camellia_xts_crypt_32way;
-ENDPROC(camellia_xts_enc_32way)
+SYM_FUNC_END(camellia_xts_enc_32way)
 
-ENTRY(camellia_xts_dec_32way)
+SYM_FUNC_START(camellia_xts_dec_32way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (32 blocks)
@@ -1404,4 +1404,4 @@ ENTRY(camellia_xts_dec_32way)
 	leaq __camellia_dec_blk32, %r9;
 
 	jmp camellia_xts_crypt_32way;
-ENDPROC(camellia_xts_dec_32way)
+SYM_FUNC_END(camellia_xts_dec_32way)
diff --git a/arch/x86/crypto/camellia-x86_64-asm_64.S b/arch/x86/crypto/camellia-x86_64-asm_64.S
index 95ba6956a7f6..4d77c9dcddbd 100644
--- a/arch/x86/crypto/camellia-x86_64-asm_64.S
+++ b/arch/x86/crypto/camellia-x86_64-asm_64.S
@@ -190,7 +190,7 @@
 	bswapq				RAB0; \
 	movq RAB0,			4*2(RIO);
 
-ENTRY(__camellia_enc_blk)
+SYM_FUNC_START(__camellia_enc_blk)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -235,9 +235,9 @@ ENTRY(__camellia_enc_blk)
 
 	movq RR12, %r12;
 	ret;
-ENDPROC(__camellia_enc_blk)
+SYM_FUNC_END(__camellia_enc_blk)
 
-ENTRY(camellia_dec_blk)
+SYM_FUNC_START(camellia_dec_blk)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -273,7 +273,7 @@ ENTRY(camellia_dec_blk)
 
 	movq RR12, %r12;
 	ret;
-ENDPROC(camellia_dec_blk)
+SYM_FUNC_END(camellia_dec_blk)
 
 /**********************************************************************
   2-way camellia
@@ -424,7 +424,7 @@ ENDPROC(camellia_dec_blk)
 		bswapq				RAB1; \
 		movq RAB1,			12*2(RIO);
 
-ENTRY(__camellia_enc_blk_2way)
+SYM_FUNC_START(__camellia_enc_blk_2way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -471,9 +471,9 @@ ENTRY(__camellia_enc_blk_2way)
 	movq RR12, %r12;
 	popq %rbx;
 	ret;
-ENDPROC(__camellia_enc_blk_2way)
+SYM_FUNC_END(__camellia_enc_blk_2way)
 
-ENTRY(camellia_dec_blk_2way)
+SYM_FUNC_START(camellia_dec_blk_2way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -511,4 +511,4 @@ ENTRY(camellia_dec_blk_2way)
 	movq RR12, %r12;
 	movq RXOR, %rbx;
 	ret;
-ENDPROC(camellia_dec_blk_2way)
+SYM_FUNC_END(camellia_dec_blk_2way)
diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
index b26df120413c..3789c61f6166 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -374,7 +374,7 @@ SYM_FUNC_START_LOCAL(__cast5_dec_blk16)
 	jmp .L__dec_tail;
 SYM_FUNC_END(__cast5_dec_blk16)
 
-ENTRY(cast5_ecb_enc_16way)
+SYM_FUNC_START(cast5_ecb_enc_16way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -409,9 +409,9 @@ ENTRY(cast5_ecb_enc_16way)
 	popq %r15;
 	FRAME_END
 	ret;
-ENDPROC(cast5_ecb_enc_16way)
+SYM_FUNC_END(cast5_ecb_enc_16way)
 
-ENTRY(cast5_ecb_dec_16way)
+SYM_FUNC_START(cast5_ecb_dec_16way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -447,9 +447,9 @@ ENTRY(cast5_ecb_dec_16way)
 	popq %r15;
 	FRAME_END
 	ret;
-ENDPROC(cast5_ecb_dec_16way)
+SYM_FUNC_END(cast5_ecb_dec_16way)
 
-ENTRY(cast5_cbc_dec_16way)
+SYM_FUNC_START(cast5_cbc_dec_16way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -499,9 +499,9 @@ ENTRY(cast5_cbc_dec_16way)
 	popq %r12;
 	FRAME_END
 	ret;
-ENDPROC(cast5_cbc_dec_16way)
+SYM_FUNC_END(cast5_cbc_dec_16way)
 
-ENTRY(cast5_ctr_16way)
+SYM_FUNC_START(cast5_ctr_16way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -575,4 +575,4 @@ ENTRY(cast5_ctr_16way)
 	popq %r12;
 	FRAME_END
 	ret;
-ENDPROC(cast5_ctr_16way)
+SYM_FUNC_END(cast5_ctr_16way)
diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
index 0a68e42a00f9..e38ab4571a6b 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -356,7 +356,7 @@ SYM_FUNC_START_LOCAL(__cast6_dec_blk8)
 	ret;
 SYM_FUNC_END(__cast6_dec_blk8)
 
-ENTRY(cast6_ecb_enc_8way)
+SYM_FUNC_START(cast6_ecb_enc_8way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -377,9 +377,9 @@ ENTRY(cast6_ecb_enc_8way)
 	popq %r15;
 	FRAME_END
 	ret;
-ENDPROC(cast6_ecb_enc_8way)
+SYM_FUNC_END(cast6_ecb_enc_8way)
 
-ENTRY(cast6_ecb_dec_8way)
+SYM_FUNC_START(cast6_ecb_dec_8way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -400,9 +400,9 @@ ENTRY(cast6_ecb_dec_8way)
 	popq %r15;
 	FRAME_END
 	ret;
-ENDPROC(cast6_ecb_dec_8way)
+SYM_FUNC_END(cast6_ecb_dec_8way)
 
-ENTRY(cast6_cbc_dec_8way)
+SYM_FUNC_START(cast6_cbc_dec_8way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -426,9 +426,9 @@ ENTRY(cast6_cbc_dec_8way)
 	popq %r12;
 	FRAME_END
 	ret;
-ENDPROC(cast6_cbc_dec_8way)
+SYM_FUNC_END(cast6_cbc_dec_8way)
 
-ENTRY(cast6_ctr_8way)
+SYM_FUNC_START(cast6_ctr_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -454,9 +454,9 @@ ENTRY(cast6_ctr_8way)
 	popq %r12;
 	FRAME_END
 	ret;
-ENDPROC(cast6_ctr_8way)
+SYM_FUNC_END(cast6_ctr_8way)
 
-ENTRY(cast6_xts_enc_8way)
+SYM_FUNC_START(cast6_xts_enc_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -481,9 +481,9 @@ ENTRY(cast6_xts_enc_8way)
 	popq %r15;
 	FRAME_END
 	ret;
-ENDPROC(cast6_xts_enc_8way)
+SYM_FUNC_END(cast6_xts_enc_8way)
 
-ENTRY(cast6_xts_dec_8way)
+SYM_FUNC_START(cast6_xts_dec_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -508,4 +508,4 @@ ENTRY(cast6_xts_dec_8way)
 	popq %r15;
 	FRAME_END
 	ret;
-ENDPROC(cast6_xts_dec_8way)
+SYM_FUNC_END(cast6_xts_dec_8way)
diff --git a/arch/x86/crypto/chacha20-avx2-x86_64.S b/arch/x86/crypto/chacha20-avx2-x86_64.S
index f3cd26f48332..72c96a6aec8f 100644
--- a/arch/x86/crypto/chacha20-avx2-x86_64.S
+++ b/arch/x86/crypto/chacha20-avx2-x86_64.S
@@ -28,7 +28,7 @@ CTRINC:	.octa 0x00000003000000020000000100000000
 
 .text
 
-ENTRY(chacha20_8block_xor_avx2)
+SYM_FUNC_START(chacha20_8block_xor_avx2)
 	# %rdi: Input state matrix, s
 	# %rsi: 8 data blocks output, o
 	# %rdx: 8 data blocks input, i
@@ -445,4 +445,4 @@ ENTRY(chacha20_8block_xor_avx2)
 	vzeroupper
 	lea		-8(%r10),%rsp
 	ret
-ENDPROC(chacha20_8block_xor_avx2)
+SYM_FUNC_END(chacha20_8block_xor_avx2)
diff --git a/arch/x86/crypto/chacha20-ssse3-x86_64.S b/arch/x86/crypto/chacha20-ssse3-x86_64.S
index 512a2b500fd1..950dea7c92d1 100644
--- a/arch/x86/crypto/chacha20-ssse3-x86_64.S
+++ b/arch/x86/crypto/chacha20-ssse3-x86_64.S
@@ -23,7 +23,7 @@ CTRINC:	.octa 0x00000003000000020000000100000000
 
 .text
 
-ENTRY(chacha20_block_xor_ssse3)
+SYM_FUNC_START(chacha20_block_xor_ssse3)
 	# %rdi: Input state matrix, s
 	# %rsi: 1 data block output, o
 	# %rdx: 1 data block input, i
@@ -143,9 +143,9 @@ ENTRY(chacha20_block_xor_ssse3)
 	movdqu		%xmm3,0x30(%rsi)
 
 	ret
-ENDPROC(chacha20_block_xor_ssse3)
+SYM_FUNC_END(chacha20_block_xor_ssse3)
 
-ENTRY(chacha20_4block_xor_ssse3)
+SYM_FUNC_START(chacha20_4block_xor_ssse3)
 	# %rdi: Input state matrix, s
 	# %rsi: 4 data blocks output, o
 	# %rdx: 4 data blocks input, i
@@ -627,4 +627,4 @@ ENTRY(chacha20_4block_xor_ssse3)
 
 	lea		-8(%r10),%rsp
 	ret
-ENDPROC(chacha20_4block_xor_ssse3)
+SYM_FUNC_END(chacha20_4block_xor_ssse3)
diff --git a/arch/x86/crypto/crc32-pclmul_asm.S b/arch/x86/crypto/crc32-pclmul_asm.S
index 1c099dc08cc3..9fd28ff65bc2 100644
--- a/arch/x86/crypto/crc32-pclmul_asm.S
+++ b/arch/x86/crypto/crc32-pclmul_asm.S
@@ -103,7 +103,7 @@
  *	                     size_t len, uint crc32)
  */
 
-ENTRY(crc32_pclmul_le_16) /* buffer and buffer size are 16 bytes aligned */
+SYM_FUNC_START(crc32_pclmul_le_16) /* buffer and buffer size are 16 bytes aligned */
 	movdqa  (BUF), %xmm1
 	movdqa  0x10(BUF), %xmm2
 	movdqa  0x20(BUF), %xmm3
@@ -238,4 +238,4 @@ fold_64:
 	PEXTRD  0x01, %xmm1, %eax
 
 	ret
-ENDPROC(crc32_pclmul_le_16)
+SYM_FUNC_END(crc32_pclmul_le_16)
diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 7a7de27c6f41..344ec8d9670b 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -73,7 +73,7 @@
 # unsigned int crc_pcl(u8 *buffer, int len, unsigned int crc_init);
 
 .text
-ENTRY(crc_pcl)
+SYM_FUNC_START(crc_pcl)
 #define    bufp		%rdi
 #define    bufp_dw	%edi
 #define    bufp_w	%di
@@ -310,7 +310,7 @@ do_return:
 	popq    %rdi
 	popq    %rbx
         ret
-ENDPROC(crc_pcl)
+SYM_FUNC_END(crc_pcl)
 
 .section	.rodata, "a", @progbits
         ################################################################
diff --git a/arch/x86/crypto/crct10dif-pcl-asm_64.S b/arch/x86/crypto/crct10dif-pcl-asm_64.S
index de04d3e98d8d..f56b499541e0 100644
--- a/arch/x86/crypto/crct10dif-pcl-asm_64.S
+++ b/arch/x86/crypto/crct10dif-pcl-asm_64.S
@@ -68,7 +68,7 @@
 
 #define        arg1_low32 %edi
 
-ENTRY(crc_t10dif_pcl)
+SYM_FUNC_START(crc_t10dif_pcl)
 .align 16
 
 	# adjust the 16-bit initial_crc value, scale it to 32 bits
@@ -552,7 +552,7 @@ _only_less_than_2:
 
 	jmp	_barrett
 
-ENDPROC(crc_t10dif_pcl)
+SYM_FUNC_END(crc_t10dif_pcl)
 
 .section	.rodata, "a", @progbits
 .align 16
diff --git a/arch/x86/crypto/des3_ede-asm_64.S b/arch/x86/crypto/des3_ede-asm_64.S
index 8e49ce117494..82779c08029b 100644
--- a/arch/x86/crypto/des3_ede-asm_64.S
+++ b/arch/x86/crypto/des3_ede-asm_64.S
@@ -171,7 +171,7 @@
 	movl   left##d,   (io); \
 	movl   right##d, 4(io);
 
-ENTRY(des3_ede_x86_64_crypt_blk)
+SYM_FUNC_START(des3_ede_x86_64_crypt_blk)
 	/* input:
 	 *	%rdi: round keys, CTX
 	 *	%rsi: dst
@@ -253,7 +253,7 @@ ENTRY(des3_ede_x86_64_crypt_blk)
 	popq %rbx;
 
 	ret;
-ENDPROC(des3_ede_x86_64_crypt_blk)
+SYM_FUNC_END(des3_ede_x86_64_crypt_blk)
 
 /***********************************************************************
  * 3-way 3DES
@@ -427,7 +427,7 @@ ENDPROC(des3_ede_x86_64_crypt_blk)
 #define __movq(src, dst) \
 	movq src, dst;
 
-ENTRY(des3_ede_x86_64_crypt_blk_3way)
+SYM_FUNC_START(des3_ede_x86_64_crypt_blk_3way)
 	/* input:
 	 *	%rdi: ctx, round keys
 	 *	%rsi: dst (3 blocks)
@@ -538,7 +538,7 @@ ENTRY(des3_ede_x86_64_crypt_blk_3way)
 	popq %rbx;
 
 	ret;
-ENDPROC(des3_ede_x86_64_crypt_blk_3way)
+SYM_FUNC_END(des3_ede_x86_64_crypt_blk_3way)
 
 .section	.rodata, "a", @progbits
 .align 16
diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index c3db86842578..12e3a850257b 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -93,7 +93,7 @@ SYM_FUNC_START_LOCAL(__clmul_gf128mul_ble)
 SYM_FUNC_END(__clmul_gf128mul_ble)
 
 /* void clmul_ghash_mul(char *dst, const u128 *shash) */
-ENTRY(clmul_ghash_mul)
+SYM_FUNC_START(clmul_ghash_mul)
 	FRAME_BEGIN
 	movups (%rdi), DATA
 	movups (%rsi), SHASH
@@ -104,13 +104,13 @@ ENTRY(clmul_ghash_mul)
 	movups DATA, (%rdi)
 	FRAME_END
 	ret
-ENDPROC(clmul_ghash_mul)
+SYM_FUNC_END(clmul_ghash_mul)
 
 /*
  * void clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
  *			   const u128 *shash);
  */
-ENTRY(clmul_ghash_update)
+SYM_FUNC_START(clmul_ghash_update)
 	FRAME_BEGIN
 	cmp $16, %rdx
 	jb .Lupdate_just_ret	# check length
@@ -133,4 +133,4 @@ ENTRY(clmul_ghash_update)
 .Lupdate_just_ret:
 	FRAME_END
 	ret
-ENDPROC(clmul_ghash_update)
+SYM_FUNC_END(clmul_ghash_update)
diff --git a/arch/x86/crypto/poly1305-avx2-x86_64.S b/arch/x86/crypto/poly1305-avx2-x86_64.S
index 3b6e70d085da..68b0f4386dc4 100644
--- a/arch/x86/crypto/poly1305-avx2-x86_64.S
+++ b/arch/x86/crypto/poly1305-avx2-x86_64.S
@@ -83,7 +83,7 @@ ORMASK:	.octa 0x00000000010000000000000001000000
 #define d3 %r12
 #define d4 %r13
 
-ENTRY(poly1305_4block_avx2)
+SYM_FUNC_START(poly1305_4block_avx2)
 	# %rdi: Accumulator h[5]
 	# %rsi: 64 byte input block m
 	# %rdx: Poly1305 key r[5]
@@ -385,4 +385,4 @@ ENTRY(poly1305_4block_avx2)
 	pop		%r12
 	pop		%rbx
 	ret
-ENDPROC(poly1305_4block_avx2)
+SYM_FUNC_END(poly1305_4block_avx2)
diff --git a/arch/x86/crypto/poly1305-sse2-x86_64.S b/arch/x86/crypto/poly1305-sse2-x86_64.S
index c88c670cb5fc..66715fbedc18 100644
--- a/arch/x86/crypto/poly1305-sse2-x86_64.S
+++ b/arch/x86/crypto/poly1305-sse2-x86_64.S
@@ -50,7 +50,7 @@ ORMASK:	.octa 0x00000000010000000000000001000000
 #define d3 %r11
 #define d4 %r12
 
-ENTRY(poly1305_block_sse2)
+SYM_FUNC_START(poly1305_block_sse2)
 	# %rdi: Accumulator h[5]
 	# %rsi: 16 byte input block m
 	# %rdx: Poly1305 key r[5]
@@ -276,7 +276,7 @@ ENTRY(poly1305_block_sse2)
 	pop		%r12
 	pop		%rbx
 	ret
-ENDPROC(poly1305_block_sse2)
+SYM_FUNC_END(poly1305_block_sse2)
 
 
 #define u0 0x00(%r8)
@@ -301,7 +301,7 @@ ENDPROC(poly1305_block_sse2)
 #undef d0
 #define d0 %r13
 
-ENTRY(poly1305_2block_sse2)
+SYM_FUNC_START(poly1305_2block_sse2)
 	# %rdi: Accumulator h[5]
 	# %rsi: 16 byte input block m
 	# %rdx: Poly1305 key r[5]
@@ -581,4 +581,4 @@ ENTRY(poly1305_2block_sse2)
 	pop		%r12
 	pop		%rbx
 	ret
-ENDPROC(poly1305_2block_sse2)
+SYM_FUNC_END(poly1305_2block_sse2)
diff --git a/arch/x86/crypto/salsa20-x86_64-asm_64.S b/arch/x86/crypto/salsa20-x86_64-asm_64.S
index 10db30d58006..2fb52ca4da39 100644
--- a/arch/x86/crypto/salsa20-x86_64-asm_64.S
+++ b/arch/x86/crypto/salsa20-x86_64-asm_64.S
@@ -2,7 +2,7 @@
 #include <linux/linkage.h>
 
 # enter salsa20_encrypt_bytes
-ENTRY(salsa20_encrypt_bytes)
+SYM_FUNC_START(salsa20_encrypt_bytes)
 	mov	%rsp,%r11
 	and	$31,%r11
 	add	$256,%r11
@@ -802,10 +802,10 @@ ENTRY(salsa20_encrypt_bytes)
 	# comment:fp stack unchanged by jump
 	# goto bytesatleast1
 	jmp	._bytesatleast1
-ENDPROC(salsa20_encrypt_bytes)
+SYM_FUNC_END(salsa20_encrypt_bytes)
 
 # enter salsa20_keysetup
-ENTRY(salsa20_keysetup)
+SYM_FUNC_START(salsa20_keysetup)
 	mov	%rsp,%r11
 	and	$31,%r11
 	add	$256,%r11
@@ -891,10 +891,10 @@ ENTRY(salsa20_keysetup)
 	mov	%rdi,%rax
 	mov	%rsi,%rdx
 	ret
-ENDPROC(salsa20_keysetup)
+SYM_FUNC_END(salsa20_keysetup)
 
 # enter salsa20_ivsetup
-ENTRY(salsa20_ivsetup)
+SYM_FUNC_START(salsa20_ivsetup)
 	mov	%rsp,%r11
 	and	$31,%r11
 	add	$256,%r11
@@ -916,4 +916,4 @@ ENTRY(salsa20_ivsetup)
 	mov	%rdi,%rax
 	mov	%rsi,%rdx
 	ret
-ENDPROC(salsa20_ivsetup)
+SYM_FUNC_END(salsa20_ivsetup)
diff --git a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
index c2d4a1fc9ee8..72de86a8091e 100644
--- a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
@@ -677,7 +677,7 @@ SYM_FUNC_START_LOCAL(__serpent_dec_blk8_avx)
 	ret;
 SYM_FUNC_END(__serpent_dec_blk8_avx)
 
-ENTRY(serpent_ecb_enc_8way_avx)
+SYM_FUNC_START(serpent_ecb_enc_8way_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -693,9 +693,9 @@ ENTRY(serpent_ecb_enc_8way_avx)
 
 	FRAME_END
 	ret;
-ENDPROC(serpent_ecb_enc_8way_avx)
+SYM_FUNC_END(serpent_ecb_enc_8way_avx)
 
-ENTRY(serpent_ecb_dec_8way_avx)
+SYM_FUNC_START(serpent_ecb_dec_8way_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -711,9 +711,9 @@ ENTRY(serpent_ecb_dec_8way_avx)
 
 	FRAME_END
 	ret;
-ENDPROC(serpent_ecb_dec_8way_avx)
+SYM_FUNC_END(serpent_ecb_dec_8way_avx)
 
-ENTRY(serpent_cbc_dec_8way_avx)
+SYM_FUNC_START(serpent_cbc_dec_8way_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -729,9 +729,9 @@ ENTRY(serpent_cbc_dec_8way_avx)
 
 	FRAME_END
 	ret;
-ENDPROC(serpent_cbc_dec_8way_avx)
+SYM_FUNC_END(serpent_cbc_dec_8way_avx)
 
-ENTRY(serpent_ctr_8way_avx)
+SYM_FUNC_START(serpent_ctr_8way_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -749,9 +749,9 @@ ENTRY(serpent_ctr_8way_avx)
 
 	FRAME_END
 	ret;
-ENDPROC(serpent_ctr_8way_avx)
+SYM_FUNC_END(serpent_ctr_8way_avx)
 
-ENTRY(serpent_xts_enc_8way_avx)
+SYM_FUNC_START(serpent_xts_enc_8way_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -771,9 +771,9 @@ ENTRY(serpent_xts_enc_8way_avx)
 
 	FRAME_END
 	ret;
-ENDPROC(serpent_xts_enc_8way_avx)
+SYM_FUNC_END(serpent_xts_enc_8way_avx)
 
-ENTRY(serpent_xts_dec_8way_avx)
+SYM_FUNC_START(serpent_xts_dec_8way_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -793,4 +793,4 @@ ENTRY(serpent_xts_dec_8way_avx)
 
 	FRAME_END
 	ret;
-ENDPROC(serpent_xts_dec_8way_avx)
+SYM_FUNC_END(serpent_xts_dec_8way_avx)
diff --git a/arch/x86/crypto/serpent-avx2-asm_64.S b/arch/x86/crypto/serpent-avx2-asm_64.S
index 52c527ce4b18..b866f1632803 100644
--- a/arch/x86/crypto/serpent-avx2-asm_64.S
+++ b/arch/x86/crypto/serpent-avx2-asm_64.S
@@ -673,7 +673,7 @@ SYM_FUNC_START_LOCAL(__serpent_dec_blk16)
 	ret;
 SYM_FUNC_END(__serpent_dec_blk16)
 
-ENTRY(serpent_ecb_enc_16way)
+SYM_FUNC_START(serpent_ecb_enc_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -693,9 +693,9 @@ ENTRY(serpent_ecb_enc_16way)
 
 	FRAME_END
 	ret;
-ENDPROC(serpent_ecb_enc_16way)
+SYM_FUNC_END(serpent_ecb_enc_16way)
 
-ENTRY(serpent_ecb_dec_16way)
+SYM_FUNC_START(serpent_ecb_dec_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -715,9 +715,9 @@ ENTRY(serpent_ecb_dec_16way)
 
 	FRAME_END
 	ret;
-ENDPROC(serpent_ecb_dec_16way)
+SYM_FUNC_END(serpent_ecb_dec_16way)
 
-ENTRY(serpent_cbc_dec_16way)
+SYM_FUNC_START(serpent_cbc_dec_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -738,9 +738,9 @@ ENTRY(serpent_cbc_dec_16way)
 
 	FRAME_END
 	ret;
-ENDPROC(serpent_cbc_dec_16way)
+SYM_FUNC_END(serpent_cbc_dec_16way)
 
-ENTRY(serpent_ctr_16way)
+SYM_FUNC_START(serpent_ctr_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -763,9 +763,9 @@ ENTRY(serpent_ctr_16way)
 
 	FRAME_END
 	ret;
-ENDPROC(serpent_ctr_16way)
+SYM_FUNC_END(serpent_ctr_16way)
 
-ENTRY(serpent_xts_enc_16way)
+SYM_FUNC_START(serpent_xts_enc_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -789,9 +789,9 @@ ENTRY(serpent_xts_enc_16way)
 
 	FRAME_END
 	ret;
-ENDPROC(serpent_xts_enc_16way)
+SYM_FUNC_END(serpent_xts_enc_16way)
 
-ENTRY(serpent_xts_dec_16way)
+SYM_FUNC_START(serpent_xts_dec_16way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst (16 blocks)
@@ -815,4 +815,4 @@ ENTRY(serpent_xts_dec_16way)
 
 	FRAME_END
 	ret;
-ENDPROC(serpent_xts_dec_16way)
+SYM_FUNC_END(serpent_xts_dec_16way)
diff --git a/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S b/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
index acc066c7c6b2..bdeee900df63 100644
--- a/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
@@ -634,7 +634,7 @@
 	pxor t0,		x3; \
 	movdqu x3,		(3*4*4)(out);
 
-ENTRY(__serpent_enc_blk_8way)
+SYM_FUNC_START(__serpent_enc_blk_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -697,9 +697,9 @@ ENTRY(__serpent_enc_blk_8way)
 	xor_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
 	ret;
-ENDPROC(__serpent_enc_blk_8way)
+SYM_FUNC_END(__serpent_enc_blk_8way)
 
-ENTRY(serpent_dec_blk_8way)
+SYM_FUNC_START(serpent_dec_blk_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -751,4 +751,4 @@ ENTRY(serpent_dec_blk_8way)
 	write_blocks(%rax, RC2, RD2, RB2, RE2, RK0, RK1, RK2);
 
 	ret;
-ENDPROC(serpent_dec_blk_8way)
+SYM_FUNC_END(serpent_dec_blk_8way)
diff --git a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
index 7cfba738f104..a1be3b33990c 100644
--- a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
+++ b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
@@ -103,7 +103,7 @@ offset = \_offset
 
 # JOB* sha1_mb_mgr_flush_avx2(MB_MGR *state)
 # arg 1 : rcx : state
-ENTRY(sha1_mb_mgr_flush_avx2)
+SYM_FUNC_START(sha1_mb_mgr_flush_avx2)
 	FRAME_BEGIN
 	push	%rbx
 
@@ -220,13 +220,13 @@ return:
 return_null:
 	xor     job_rax, job_rax
 	jmp     return
-ENDPROC(sha1_mb_mgr_flush_avx2)
+SYM_FUNC_END(sha1_mb_mgr_flush_avx2)
 
 
 #################################################################
 
 .align 16
-ENTRY(sha1_mb_mgr_get_comp_job_avx2)
+SYM_FUNC_START(sha1_mb_mgr_get_comp_job_avx2)
 	push    %rbx
 
 	## if bit 32+3 is set, then all lanes are empty
@@ -279,7 +279,7 @@ ENTRY(sha1_mb_mgr_get_comp_job_avx2)
 	xor     job_rax, job_rax
 	pop     %rbx
 	ret
-ENDPROC(sha1_mb_mgr_get_comp_job_avx2)
+SYM_FUNC_END(sha1_mb_mgr_get_comp_job_avx2)
 
 .section	.rodata.cst16.clear_low_nibble, "aM", @progbits, 16
 .align 16
diff --git a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S
index 7a93b1c0d69a..a46e3b04385e 100644
--- a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S
+++ b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S
@@ -98,7 +98,7 @@ lane_data       = %r10
 # JOB* submit_mb_mgr_submit_avx2(MB_MGR *state, job_sha1 *job)
 # arg 1 : rcx : state
 # arg 2 : rdx : job
-ENTRY(sha1_mb_mgr_submit_avx2)
+SYM_FUNC_START(sha1_mb_mgr_submit_avx2)
 	FRAME_BEGIN
 	push	%rbx
 	push	%r12
@@ -201,7 +201,7 @@ return_null:
 	xor     job_rax, job_rax
 	jmp     return
 
-ENDPROC(sha1_mb_mgr_submit_avx2)
+SYM_FUNC_END(sha1_mb_mgr_submit_avx2)
 
 .section	.rodata.cst16.clear_low_nibble, "aM", @progbits, 16
 .align 16
diff --git a/arch/x86/crypto/sha1-mb/sha1_x8_avx2.S b/arch/x86/crypto/sha1-mb/sha1_x8_avx2.S
index 20f77aa633de..04d763520a82 100644
--- a/arch/x86/crypto/sha1-mb/sha1_x8_avx2.S
+++ b/arch/x86/crypto/sha1-mb/sha1_x8_avx2.S
@@ -294,7 +294,7 @@ W14  = TMP_
 # arg 1 : pointer to array[4] of pointer to input data
 # arg 2 : size (in blocks) ;; assumed to be >= 1
 #
-ENTRY(sha1_x8_avx2)
+SYM_FUNC_START(sha1_x8_avx2)
 
 	# save callee-saved clobbered registers to comply with C function ABI
 	push	%r12
@@ -458,7 +458,7 @@ lloop:
 	pop	%r12
 
 	ret
-ENDPROC(sha1_x8_avx2)
+SYM_FUNC_END(sha1_x8_avx2)
 
 
 .section	.rodata.cst32.K00_19, "aM", @progbits, 32
diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
index 9f712a7dfd79..6decc85ef7b7 100644
--- a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
+++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
@@ -634,7 +634,7 @@ _loop3:
  * param: function's name
  */
 .macro SHA1_VECTOR_ASM  name
-	ENTRY(\name)
+	SYM_FUNC_START(\name)
 
 	push	%rbx
 	push	%r12
@@ -676,7 +676,7 @@ _loop3:
 
 	ret
 
-	ENDPROC(\name)
+	SYM_FUNC_END(\name)
 .endm
 
 .section .rodata
diff --git a/arch/x86/crypto/sha1_ni_asm.S b/arch/x86/crypto/sha1_ni_asm.S
index ebbdba72ae07..11efe3a45a1f 100644
--- a/arch/x86/crypto/sha1_ni_asm.S
+++ b/arch/x86/crypto/sha1_ni_asm.S
@@ -95,7 +95,7 @@
  */
 .text
 .align 32
-ENTRY(sha1_ni_transform)
+SYM_FUNC_START(sha1_ni_transform)
 	mov		%rsp, RSPSAVE
 	sub		$FRAME_SIZE, %rsp
 	and		$~0xF, %rsp
@@ -291,7 +291,7 @@ ENTRY(sha1_ni_transform)
 	mov		RSPSAVE, %rsp
 
 	ret
-ENDPROC(sha1_ni_transform)
+SYM_FUNC_END(sha1_ni_transform)
 
 .section	.rodata.cst16.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 16
 .align 16
diff --git a/arch/x86/crypto/sha1_ssse3_asm.S b/arch/x86/crypto/sha1_ssse3_asm.S
index 6204bd53528c..c253255fd4c1 100644
--- a/arch/x86/crypto/sha1_ssse3_asm.S
+++ b/arch/x86/crypto/sha1_ssse3_asm.S
@@ -71,7 +71,7 @@
  * param: function's name
  */
 .macro SHA1_VECTOR_ASM  name
-	ENTRY(\name)
+	SYM_FUNC_START(\name)
 
 	push	%rbx
 	push	%r12
@@ -105,7 +105,7 @@
 	pop	%rbx
 	ret
 
-	ENDPROC(\name)
+	SYM_FUNC_END(\name)
 .endm
 
 /*
diff --git a/arch/x86/crypto/sha256-avx-asm.S b/arch/x86/crypto/sha256-avx-asm.S
index 001bbcf93c79..22e14c8dd2e4 100644
--- a/arch/x86/crypto/sha256-avx-asm.S
+++ b/arch/x86/crypto/sha256-avx-asm.S
@@ -347,7 +347,7 @@ a = TMP_
 ## arg 3 : Num blocks
 ########################################################################
 .text
-ENTRY(sha256_transform_avx)
+SYM_FUNC_START(sha256_transform_avx)
 .align 32
 	pushq   %rbx
 	pushq   %r12
@@ -460,7 +460,7 @@ done_hash:
 	popq	%r12
 	popq    %rbx
 	ret
-ENDPROC(sha256_transform_avx)
+SYM_FUNC_END(sha256_transform_avx)
 
 .section	.rodata.cst256.K256, "aM", @progbits, 256
 .align 64
diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 1420db15dcdd..519b551ad576 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -526,7 +526,7 @@ STACK_SIZE	= _RSP      + _RSP_SIZE
 ## arg 3 : Num blocks
 ########################################################################
 .text
-ENTRY(sha256_transform_rorx)
+SYM_FUNC_START(sha256_transform_rorx)
 .align 32
 	pushq	%rbx
 	pushq	%r12
@@ -713,7 +713,7 @@ done_hash:
 	popq	%r12
 	popq	%rbx
 	ret
-ENDPROC(sha256_transform_rorx)
+SYM_FUNC_END(sha256_transform_rorx)
 
 .section	.rodata.cst512.K256, "aM", @progbits, 512
 .align 64
diff --git a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
index 16c4ccb1f154..11f00ee0a3a4 100644
--- a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
+++ b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
@@ -101,7 +101,7 @@ offset = \_offset
 
 # JOB_SHA256* sha256_mb_mgr_flush_avx2(MB_MGR *state)
 # arg 1 : rcx : state
-ENTRY(sha256_mb_mgr_flush_avx2)
+SYM_FUNC_START(sha256_mb_mgr_flush_avx2)
 	FRAME_BEGIN
         push    %rbx
 
@@ -220,12 +220,12 @@ return:
 return_null:
 	xor	job_rax, job_rax
 	jmp	return
-ENDPROC(sha256_mb_mgr_flush_avx2)
+SYM_FUNC_END(sha256_mb_mgr_flush_avx2)
 
 ##############################################################################
 
 .align 16
-ENTRY(sha256_mb_mgr_get_comp_job_avx2)
+SYM_FUNC_START(sha256_mb_mgr_get_comp_job_avx2)
 	push	%rbx
 
 	## if bit 32+3 is set, then all lanes are empty
@@ -282,7 +282,7 @@ ENTRY(sha256_mb_mgr_get_comp_job_avx2)
 	xor	job_rax, job_rax
 	pop	%rbx
 	ret
-ENDPROC(sha256_mb_mgr_get_comp_job_avx2)
+SYM_FUNC_END(sha256_mb_mgr_get_comp_job_avx2)
 
 .section	.rodata.cst16.clear_low_nibble, "aM", @progbits, 16
 .align 16
diff --git a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S
index b36ae7454084..2213c04a30dc 100644
--- a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S
+++ b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S
@@ -96,7 +96,7 @@ lane_data	= %r10
 # JOB* sha256_mb_mgr_submit_avx2(MB_MGR *state, JOB_SHA256 *job)
 # arg 1 : rcx : state
 # arg 2 : rdx : job
-ENTRY(sha256_mb_mgr_submit_avx2)
+SYM_FUNC_START(sha256_mb_mgr_submit_avx2)
 	FRAME_BEGIN
 	push	%rbx
 	push	%r12
@@ -206,7 +206,7 @@ return_null:
 	xor	job_rax, job_rax
 	jmp	return
 
-ENDPROC(sha256_mb_mgr_submit_avx2)
+SYM_FUNC_END(sha256_mb_mgr_submit_avx2)
 
 .section	.rodata.cst16.clear_low_nibble, "aM", @progbits, 16
 .align 16
diff --git a/arch/x86/crypto/sha256-mb/sha256_x8_avx2.S b/arch/x86/crypto/sha256-mb/sha256_x8_avx2.S
index 1687c80c5995..042d2381f435 100644
--- a/arch/x86/crypto/sha256-mb/sha256_x8_avx2.S
+++ b/arch/x86/crypto/sha256-mb/sha256_x8_avx2.S
@@ -280,7 +280,7 @@ a = TMP_
 	# general registers preserved in outer calling routine
 	# outer calling routine saves all the XMM registers
 	# save rsp, allocate 32-byte aligned for local variables
-ENTRY(sha256_x8_avx2)
+SYM_FUNC_START(sha256_x8_avx2)
 
 	# save callee-saved clobbered registers to comply with C function ABI
 	push    %r12
@@ -436,7 +436,7 @@ Lrounds_16_xx:
 	pop     %r12
 
 	ret
-ENDPROC(sha256_x8_avx2)
+SYM_FUNC_END(sha256_x8_avx2)
 
 .section	.rodata.K256_8, "a", @progbits
 .align 64
diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S
index c6c05ed2c16a..69cc2f91dc4c 100644
--- a/arch/x86/crypto/sha256-ssse3-asm.S
+++ b/arch/x86/crypto/sha256-ssse3-asm.S
@@ -353,7 +353,7 @@ a = TMP_
 ## arg 3 : Num blocks
 ########################################################################
 .text
-ENTRY(sha256_transform_ssse3)
+SYM_FUNC_START(sha256_transform_ssse3)
 .align 32
 	pushq   %rbx
 	pushq   %r12
@@ -471,7 +471,7 @@ done_hash:
 	popq    %rbx
 
 	ret
-ENDPROC(sha256_transform_ssse3)
+SYM_FUNC_END(sha256_transform_ssse3)
 
 .section	.rodata.cst256.K256, "aM", @progbits, 256
 .align 64
diff --git a/arch/x86/crypto/sha256_ni_asm.S b/arch/x86/crypto/sha256_ni_asm.S
index fb58f58ecfbc..7abade04a3a3 100644
--- a/arch/x86/crypto/sha256_ni_asm.S
+++ b/arch/x86/crypto/sha256_ni_asm.S
@@ -97,7 +97,7 @@
 
 .text
 .align 32
-ENTRY(sha256_ni_transform)
+SYM_FUNC_START(sha256_ni_transform)
 
 	shl		$6, NUM_BLKS		/*  convert to bytes */
 	jz		.Ldone_hash
@@ -327,7 +327,7 @@ ENTRY(sha256_ni_transform)
 .Ldone_hash:
 
 	ret
-ENDPROC(sha256_ni_transform)
+SYM_FUNC_END(sha256_ni_transform)
 
 .section	.rodata.cst256.K256, "aM", @progbits, 256
 .align 64
diff --git a/arch/x86/crypto/sha512-avx-asm.S b/arch/x86/crypto/sha512-avx-asm.S
index 39235fefe6f7..3704ddd7e5d5 100644
--- a/arch/x86/crypto/sha512-avx-asm.S
+++ b/arch/x86/crypto/sha512-avx-asm.S
@@ -277,7 +277,7 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
 # message blocks.
 # L is the message length in SHA512 blocks
 ########################################################################
-ENTRY(sha512_transform_avx)
+SYM_FUNC_START(sha512_transform_avx)
 	cmp $0, msglen
 	je nowork
 
@@ -365,7 +365,7 @@ updateblock:
 
 nowork:
 	ret
-ENDPROC(sha512_transform_avx)
+SYM_FUNC_END(sha512_transform_avx)
 
 ########################################################################
 ### Binary Data
diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index b16d56005162..80d830e7ee09 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -569,7 +569,7 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
 #   message blocks.
 # L is the message length in SHA512 blocks
 ########################################################################
-ENTRY(sha512_transform_rorx)
+SYM_FUNC_START(sha512_transform_rorx)
 	# Allocate Stack Space
 	mov	%rsp, %rax
 	sub	$frame_size, %rsp
@@ -682,7 +682,7 @@ done_hash:
 	# Restore Stack Pointer
 	mov	frame_RSPSAVE(%rsp), %rsp
 	ret
-ENDPROC(sha512_transform_rorx)
+SYM_FUNC_END(sha512_transform_rorx)
 
 ########################################################################
 ### Binary Data
diff --git a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S
index 7c629caebc05..8642f3a04388 100644
--- a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S
+++ b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S
@@ -107,7 +107,7 @@ offset = \_offset
 
 # JOB* sha512_mb_mgr_flush_avx2(MB_MGR *state)
 # arg 1 : rcx : state
-ENTRY(sha512_mb_mgr_flush_avx2)
+SYM_FUNC_START(sha512_mb_mgr_flush_avx2)
 	FRAME_BEGIN
 	push	%rbx
 
@@ -217,10 +217,10 @@ return:
 return_null:
         xor     job_rax, job_rax
         jmp     return
-ENDPROC(sha512_mb_mgr_flush_avx2)
+SYM_FUNC_END(sha512_mb_mgr_flush_avx2)
 .align 16
 
-ENTRY(sha512_mb_mgr_get_comp_job_avx2)
+SYM_FUNC_START(sha512_mb_mgr_get_comp_job_avx2)
         push    %rbx
 
 	mov     _unused_lanes(state), unused_lanes
@@ -279,7 +279,7 @@ ENTRY(sha512_mb_mgr_get_comp_job_avx2)
         xor     job_rax, job_rax
 	pop     %rbx
         ret
-ENDPROC(sha512_mb_mgr_get_comp_job_avx2)
+SYM_FUNC_END(sha512_mb_mgr_get_comp_job_avx2)
 
 .section	.rodata.cst8.one, "aM", @progbits, 8
 .align 8
diff --git a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S
index 4ba709ba78e5..62932723d6e9 100644
--- a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S
+++ b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S
@@ -98,7 +98,7 @@
 # JOB* sha512_mb_mgr_submit_avx2(MB_MGR *state, JOB *job)
 # arg 1 : rcx : state
 # arg 2 : rdx : job
-ENTRY(sha512_mb_mgr_submit_avx2)
+SYM_FUNC_START(sha512_mb_mgr_submit_avx2)
 	FRAME_BEGIN
 	push	%rbx
 	push	%r12
@@ -208,7 +208,7 @@ return:
 return_null:
 	xor     job_rax, job_rax
 	jmp     return
-ENDPROC(sha512_mb_mgr_submit_avx2)
+SYM_FUNC_END(sha512_mb_mgr_submit_avx2)
 
 /* UNUSED?
 .section	.rodata.cst16, "aM", @progbits, 16
diff --git a/arch/x86/crypto/sha512-mb/sha512_x4_avx2.S b/arch/x86/crypto/sha512-mb/sha512_x4_avx2.S
index e22e907643a6..504065d19e03 100644
--- a/arch/x86/crypto/sha512-mb/sha512_x4_avx2.S
+++ b/arch/x86/crypto/sha512-mb/sha512_x4_avx2.S
@@ -239,7 +239,7 @@ a = TMP_
 # void sha512_x4_avx2(void *STATE, const int INP_SIZE)
 # arg 1 : STATE    : pointer to input data
 # arg 2 : INP_SIZE : size of data in blocks (assumed >= 1)
-ENTRY(sha512_x4_avx2)
+SYM_FUNC_START(sha512_x4_avx2)
 	# general registers preserved in outer calling routine
 	# outer calling routine saves all the XMM registers
 	# save callee-saved clobbered registers to comply with C function ABI
@@ -359,7 +359,7 @@ Lrounds_16_xx:
 
 	# outer calling routine restores XMM and other GP registers
 	ret
-ENDPROC(sha512_x4_avx2)
+SYM_FUNC_END(sha512_x4_avx2)
 
 .section	.rodata.K512_4, "a", @progbits
 .align 64
diff --git a/arch/x86/crypto/sha512-ssse3-asm.S b/arch/x86/crypto/sha512-ssse3-asm.S
index 66bbd9058a90..838f984e95d9 100644
--- a/arch/x86/crypto/sha512-ssse3-asm.S
+++ b/arch/x86/crypto/sha512-ssse3-asm.S
@@ -275,7 +275,7 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
 #   message blocks.
 # L is the message length in SHA512 blocks.
 ########################################################################
-ENTRY(sha512_transform_ssse3)
+SYM_FUNC_START(sha512_transform_ssse3)
 
 	cmp $0, msglen
 	je nowork
@@ -364,7 +364,7 @@ updateblock:
 
 nowork:
 	ret
-ENDPROC(sha512_transform_ssse3)
+SYM_FUNC_END(sha512_transform_ssse3)
 
 ########################################################################
 ### Binary Data
diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
index 96ddfda4d7b2..16e53c98e6a0 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -330,7 +330,7 @@ SYM_FUNC_START_LOCAL(__twofish_dec_blk8)
 	ret;
 SYM_FUNC_END(__twofish_dec_blk8)
 
-ENTRY(twofish_ecb_enc_8way)
+SYM_FUNC_START(twofish_ecb_enc_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -348,9 +348,9 @@ ENTRY(twofish_ecb_enc_8way)
 
 	FRAME_END
 	ret;
-ENDPROC(twofish_ecb_enc_8way)
+SYM_FUNC_END(twofish_ecb_enc_8way)
 
-ENTRY(twofish_ecb_dec_8way)
+SYM_FUNC_START(twofish_ecb_dec_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -368,9 +368,9 @@ ENTRY(twofish_ecb_dec_8way)
 
 	FRAME_END
 	ret;
-ENDPROC(twofish_ecb_dec_8way)
+SYM_FUNC_END(twofish_ecb_dec_8way)
 
-ENTRY(twofish_cbc_dec_8way)
+SYM_FUNC_START(twofish_cbc_dec_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -393,9 +393,9 @@ ENTRY(twofish_cbc_dec_8way)
 
 	FRAME_END
 	ret;
-ENDPROC(twofish_cbc_dec_8way)
+SYM_FUNC_END(twofish_cbc_dec_8way)
 
-ENTRY(twofish_ctr_8way)
+SYM_FUNC_START(twofish_ctr_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -420,9 +420,9 @@ ENTRY(twofish_ctr_8way)
 
 	FRAME_END
 	ret;
-ENDPROC(twofish_ctr_8way)
+SYM_FUNC_END(twofish_ctr_8way)
 
-ENTRY(twofish_xts_enc_8way)
+SYM_FUNC_START(twofish_xts_enc_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -444,9 +444,9 @@ ENTRY(twofish_xts_enc_8way)
 
 	FRAME_END
 	ret;
-ENDPROC(twofish_xts_enc_8way)
+SYM_FUNC_END(twofish_xts_enc_8way)
 
-ENTRY(twofish_xts_dec_8way)
+SYM_FUNC_START(twofish_xts_dec_8way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -468,4 +468,4 @@ ENTRY(twofish_xts_dec_8way)
 
 	FRAME_END
 	ret;
-ENDPROC(twofish_xts_dec_8way)
+SYM_FUNC_END(twofish_xts_dec_8way)
diff --git a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
index 1c3b7ceb36d2..ece306e35298 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
@@ -216,7 +216,7 @@
 	rorq $32,			RAB2; \
 	outunpack3(mov, RIO, 2, RAB, 2);
 
-ENTRY(__twofish_enc_blk_3way)
+SYM_FUNC_START(__twofish_enc_blk_3way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -270,9 +270,9 @@ ENTRY(__twofish_enc_blk_3way)
 	popq %r14;
 	popq %r15;
 	ret;
-ENDPROC(__twofish_enc_blk_3way)
+SYM_FUNC_END(__twofish_enc_blk_3way)
 
-ENTRY(twofish_dec_blk_3way)
+SYM_FUNC_START(twofish_dec_blk_3way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -309,4 +309,4 @@ ENTRY(twofish_dec_blk_3way)
 	popq %r14;
 	popq %r15;
 	ret;
-ENDPROC(twofish_dec_blk_3way)
+SYM_FUNC_END(twofish_dec_blk_3way)
diff --git a/arch/x86/crypto/twofish-x86_64-asm_64.S b/arch/x86/crypto/twofish-x86_64-asm_64.S
index a350c990dc86..74ef6c55d75f 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64.S
@@ -215,7 +215,7 @@
 	xor	%r8d,		d ## D;\
 	ror	$1,		d ## D;
 
-ENTRY(twofish_enc_blk)
+SYM_FUNC_START(twofish_enc_blk)
 	pushq    R1
 
 	/* %rdi contains the ctx address */
@@ -266,9 +266,9 @@ ENTRY(twofish_enc_blk)
 	popq	R1
 	movl	$1,%eax
 	ret
-ENDPROC(twofish_enc_blk)
+SYM_FUNC_END(twofish_enc_blk)
 
-ENTRY(twofish_dec_blk)
+SYM_FUNC_START(twofish_dec_blk)
 	pushq    R1
 
 	/* %rdi contains the ctx address */
@@ -318,4 +318,4 @@ ENTRY(twofish_dec_blk)
 	popq	R1
 	movl	$1,%eax
 	ret
-ENDPROC(twofish_dec_blk)
+SYM_FUNC_END(twofish_dec_blk)
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index be1d53f3ac5f..018d89b06077 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -15,7 +15,7 @@
  *			at the top of the kernel process stack.
  *
  * Some macro usage:
- * - ENTRY/END:		Define functions in the symbol table.
+ * - SYM_FUNC_START/END:Define functions in the symbol table.
  * - TRACE_IRQ_*:	Trace hardirq state for lock debugging.
  * - idtentry:		Define exception entry points.
  */
@@ -1078,7 +1078,7 @@ idtentry simd_coprocessor_error		do_simd_coprocessor_error	has_error_code=0
 	 * Reload gs selector with exception handling
 	 * edi:  new selector
 	 */
-ENTRY(native_load_gs_index)
+SYM_FUNC_START(native_load_gs_index)
 	FRAME_BEGIN
 	pushfq
 	DISABLE_INTERRUPTS(CLBR_ANY & ~CLBR_RDI)
@@ -1092,7 +1092,7 @@ ENTRY(native_load_gs_index)
 	popfq
 	FRAME_END
 	ret
-ENDPROC(native_load_gs_index)
+SYM_FUNC_END(native_load_gs_index)
 EXPORT_SYMBOL(native_load_gs_index)
 
 	_ASM_EXTABLE(.Lgs_change, bad_gs)
@@ -1113,7 +1113,7 @@ SYM_CODE_END(bad_gs)
 	.previous
 
 /* Call softirq on interrupt stack. Interrupts are off. */
-ENTRY(do_softirq_own_stack)
+SYM_FUNC_START(do_softirq_own_stack)
 	pushq	%rbp
 	mov	%rsp, %rbp
 	ENTER_IRQ_STACK regs=0 old_rsp=%r11
@@ -1121,7 +1121,7 @@ ENTRY(do_softirq_own_stack)
 	LEAVE_IRQ_STACK regs=0
 	leaveq
 	ret
-ENDPROC(do_softirq_own_stack)
+SYM_FUNC_END(do_softirq_own_stack)
 
 #ifdef CONFIG_XEN
 idtentry hypervisor_callback xen_do_hypervisor_callback has_error_code=0
diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 38be8f5dcbef..90ab94811d1d 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -46,7 +46,7 @@
  * ebp  user stack
  * 0(%ebp) arg6
  */
-ENTRY(entry_SYSENTER_compat)
+SYM_FUNC_START(entry_SYSENTER_compat)
 	/* Interrupts are off on entry. */
 	SWAPGS
 
@@ -137,7 +137,7 @@ ENTRY(entry_SYSENTER_compat)
 	popfq
 	jmp	.Lsysenter_flags_fixed
 SYM_CODE_INNER_LABEL(__end_entry_SYSENTER_compat, SYM_L_GLOBAL)
-ENDPROC(entry_SYSENTER_compat)
+SYM_FUNC_END(entry_SYSENTER_compat)
 
 /*
  * 32-bit SYSCALL entry.
@@ -365,7 +365,7 @@ SYM_CODE_START(entry_INT80_compat)
 	jmp	swapgs_restore_regs_and_return_to_usermode
 SYM_CODE_END(entry_INT80_compat)
 
-ENTRY(stub32_clone)
+SYM_FUNC_START(stub32_clone)
 	/*
 	 * The 32-bit clone ABI is: clone(..., int tls_val, int *child_tidptr).
 	 * The 64-bit clone ABI is: clone(..., int *child_tidptr, int tls_val).
@@ -375,4 +375,4 @@ ENTRY(stub32_clone)
 	 */
 	xchg	%r8, %rcx
 	jmp	sys_clone
-ENDPROC(stub32_clone)
+SYM_FUNC_END(stub32_clone)
diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index 6c60fe346583..042fd30ac493 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -13,7 +13,7 @@
 	/*
 	 * Hooray, we are in Long 64-bit mode (but still running in low memory)
 	 */
-ENTRY(wakeup_long64)
+SYM_FUNC_START(wakeup_long64)
 	movq	saved_magic, %rax
 	movq	$0x123456789abcdef0, %rdx
 	cmpq	%rdx, %rax
@@ -34,13 +34,13 @@ ENTRY(wakeup_long64)
 
 	movq	saved_rip, %rax
 	jmp	*%rax
-ENDPROC(wakeup_long64)
+SYM_FUNC_END(wakeup_long64)
 
 SYM_CODE_START_LOCAL(bogus_64_magic)
 	jmp	bogus_64_magic
 SYM_CODE_END(bogus_64_magic)
 
-ENTRY(do_suspend_lowlevel)
+SYM_FUNC_START(do_suspend_lowlevel)
 	FRAME_BEGIN
 	subq	$8, %rsp
 	xorl	%eax, %eax
@@ -123,7 +123,7 @@ ENTRY(do_suspend_lowlevel)
 	addq	$8, %rsp
 	FRAME_END
 	jmp	restore_processor_state
-ENDPROC(do_suspend_lowlevel)
+SYM_FUNC_END(do_suspend_lowlevel)
 
 .data
 saved_rbp:		.quad	0
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index d12387882702..727ccf3aa83b 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -91,7 +91,7 @@ SYM_CODE_START_NOALIGN(startup_64)
 	jmp 1f
 SYM_CODE_END(startup_64)
 
-ENTRY(secondary_startup_64)
+SYM_CODE_START(secondary_startup_64)
 	UNWIND_HINT_EMPTY
 	/*
 	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 0,
@@ -237,7 +237,7 @@ ENTRY(secondary_startup_64)
 	pushq	%rax		# target address in negative space
 	lretq
 .Lafter_lret:
-END(secondary_startup_64)
+SYM_CODE_END(secondary_startup_64)
 
 #include "verify_cpu.S"
 
@@ -247,11 +247,11 @@ END(secondary_startup_64)
  * up already except stack. We just set up stack here. Then call
  * start_secondary() via .Ljump_to_C_code.
  */
-ENTRY(start_cpu0)
+SYM_FUNC_START(start_cpu0)
 	movq	initial_stack(%rip), %rsp
 	UNWIND_HINT_EMPTY
 	jmp	.Ljump_to_C_code
-ENDPROC(start_cpu0)
+SYM_FUNC_END(start_cpu0)
 #endif
 
 	/* Both SMP bootup and ACPI suspend change these variables */
@@ -268,7 +268,7 @@ SYM_DATA(initial_stack,
 	__FINITDATA
 
 	__INIT
-ENTRY(early_idt_handler_array)
+SYM_CODE_START(early_idt_handler_array)
 	i = 0
 	.rept NUM_EXCEPTION_VECTORS
 	.if ((EXCEPTION_ERRCODE_MASK >> i) & 1) == 0
@@ -284,7 +284,7 @@ ENTRY(early_idt_handler_array)
 	.fill early_idt_handler_array + i*EARLY_IDT_HANDLER_SIZE - ., 1, 0xcc
 	.endr
 	UNWIND_HINT_IRET_REGS offset=16
-END(early_idt_handler_array)
+SYM_CODE_END(early_idt_handler_array)
 
 SYM_CODE_START_LOCAL(early_idt_handler_common)
 	/*
diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
index 4d34bb548b41..a048436ce3ac 100644
--- a/arch/x86/lib/checksum_32.S
+++ b/arch/x86/lib/checksum_32.S
@@ -283,7 +283,7 @@ unsigned int csum_partial_copy_generic (const char *src, char *dst,
 #define ARGBASE 16		
 #define FP		12
 		
-ENTRY(csum_partial_copy_generic)
+SYM_FUNC_START(csum_partial_copy_generic)
 	subl  $4,%esp	
 	pushl %edi
 	pushl %esi
@@ -401,7 +401,7 @@ DST(	movb %cl, (%edi)	)
 	popl %edi
 	popl %ecx			# equivalent to addl $4,%esp
 	ret	
-ENDPROC(csum_partial_copy_generic)
+SYM_FUNC_END(csum_partial_copy_generic)
 
 #else
 
@@ -419,7 +419,7 @@ ENDPROC(csum_partial_copy_generic)
 
 #define ARGBASE 12
 		
-ENTRY(csum_partial_copy_generic)
+SYM_FUNC_START(csum_partial_copy_generic)
 	pushl %ebx
 	pushl %edi
 	pushl %esi
@@ -486,7 +486,7 @@ DST(	movb %dl, (%edi)         )
 	popl %edi
 	popl %ebx
 	ret
-ENDPROC(csum_partial_copy_generic)
+SYM_FUNC_END(csum_partial_copy_generic)
 				
 #undef ROUND
 #undef ROUND1		
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index 81b1635d67de..8c4c26c282fd 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -14,15 +14,15 @@
  * Zero a page.
  * %rdi	- page
  */
-ENTRY(clear_page_rep)
+SYM_FUNC_START(clear_page_rep)
 	movl $4096/8,%ecx
 	xorl %eax,%eax
 	rep stosq
 	ret
-ENDPROC(clear_page_rep)
+SYM_FUNC_END(clear_page_rep)
 EXPORT_SYMBOL_GPL(clear_page_rep)
 
-ENTRY(clear_page_orig)
+SYM_FUNC_START(clear_page_orig)
 	xorl   %eax,%eax
 	movl   $4096/64,%ecx
 	.p2align 4
@@ -41,13 +41,13 @@ ENTRY(clear_page_orig)
 	jnz	.Lloop
 	nop
 	ret
-ENDPROC(clear_page_orig)
+SYM_FUNC_END(clear_page_orig)
 EXPORT_SYMBOL_GPL(clear_page_orig)
 
-ENTRY(clear_page_erms)
+SYM_FUNC_START(clear_page_erms)
 	movl $4096,%ecx
 	xorl %eax,%eax
 	rep stosb
 	ret
-ENDPROC(clear_page_erms)
+SYM_FUNC_END(clear_page_erms)
 EXPORT_SYMBOL_GPL(clear_page_erms)
diff --git a/arch/x86/lib/cmpxchg16b_emu.S b/arch/x86/lib/cmpxchg16b_emu.S
index 9b330242e740..b6ba6360b3ca 100644
--- a/arch/x86/lib/cmpxchg16b_emu.S
+++ b/arch/x86/lib/cmpxchg16b_emu.S
@@ -19,7 +19,7 @@
  * %rcx : high 64 bits of new value
  * %al  : Operation successful
  */
-ENTRY(this_cpu_cmpxchg16b_emu)
+SYM_FUNC_START(this_cpu_cmpxchg16b_emu)
 
 #
 # Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in %al not
@@ -50,4 +50,4 @@ ENTRY(this_cpu_cmpxchg16b_emu)
 	xor %al,%al
 	ret
 
-ENDPROC(this_cpu_cmpxchg16b_emu)
+SYM_FUNC_END(this_cpu_cmpxchg16b_emu)
diff --git a/arch/x86/lib/cmpxchg8b_emu.S b/arch/x86/lib/cmpxchg8b_emu.S
index 03a186fc06ea..77aa18db3968 100644
--- a/arch/x86/lib/cmpxchg8b_emu.S
+++ b/arch/x86/lib/cmpxchg8b_emu.S
@@ -19,7 +19,7 @@
  * %ebx : low 32 bits of new value
  * %ecx : high 32 bits of new value
  */
-ENTRY(cmpxchg8b_emu)
+SYM_FUNC_START(cmpxchg8b_emu)
 
 #
 # Emulate 'cmpxchg8b (%esi)' on UP except we don't
@@ -48,5 +48,5 @@ ENTRY(cmpxchg8b_emu)
 	popfl
 	ret
 
-ENDPROC(cmpxchg8b_emu)
+SYM_FUNC_END(cmpxchg8b_emu)
 EXPORT_SYMBOL(cmpxchg8b_emu)
diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index f505870bd93b..2402d4c489d2 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -13,12 +13,12 @@
  * prefetch distance based on SMP/UP.
  */
 	ALIGN
-ENTRY(copy_page)
+SYM_FUNC_START(copy_page)
 	ALTERNATIVE "jmp copy_page_regs", "", X86_FEATURE_REP_GOOD
 	movl	$4096/8, %ecx
 	rep	movsq
 	ret
-ENDPROC(copy_page)
+SYM_FUNC_END(copy_page)
 EXPORT_SYMBOL(copy_page)
 
 SYM_FUNC_START_LOCAL(copy_page_regs)
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 020f75cc8cf6..5e9e80c05a97 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -29,7 +29,7 @@
  * Output:
  * eax uncopied bytes or 0 if successful.
  */
-ENTRY(copy_user_generic_unrolled)
+SYM_FUNC_START(copy_user_generic_unrolled)
 	ASM_STAC
 	cmpl $8,%edx
 	jb 20f		/* less then 8 bytes, go to byte copy loop */
@@ -112,7 +112,7 @@ ENTRY(copy_user_generic_unrolled)
 	_ASM_EXTABLE(19b,40b)
 	_ASM_EXTABLE(21b,50b)
 	_ASM_EXTABLE(22b,50b)
-ENDPROC(copy_user_generic_unrolled)
+SYM_FUNC_END(copy_user_generic_unrolled)
 EXPORT_SYMBOL(copy_user_generic_unrolled)
 
 /* Some CPUs run faster using the string copy instructions.
@@ -133,7 +133,7 @@ EXPORT_SYMBOL(copy_user_generic_unrolled)
  * Output:
  * eax uncopied bytes or 0 if successful.
  */
-ENTRY(copy_user_generic_string)
+SYM_FUNC_START(copy_user_generic_string)
 	ASM_STAC
 	cmpl $8,%edx
 	jb 2f		/* less than 8 bytes, go to byte copy loop */
@@ -158,7 +158,7 @@ ENTRY(copy_user_generic_string)
 
 	_ASM_EXTABLE(1b,11b)
 	_ASM_EXTABLE(3b,12b)
-ENDPROC(copy_user_generic_string)
+SYM_FUNC_END(copy_user_generic_string)
 EXPORT_SYMBOL(copy_user_generic_string)
 
 /*
@@ -173,7 +173,7 @@ EXPORT_SYMBOL(copy_user_generic_string)
  * Output:
  * eax uncopied bytes or 0 if successful.
  */
-ENTRY(copy_user_enhanced_fast_string)
+SYM_FUNC_START(copy_user_enhanced_fast_string)
 	ASM_STAC
 	cmpl $64,%edx
 	jb .L_copy_short_string	/* less then 64 bytes, avoid the costly 'rep' */
@@ -190,7 +190,7 @@ ENTRY(copy_user_enhanced_fast_string)
 	.previous
 
 	_ASM_EXTABLE(1b,12b)
-ENDPROC(copy_user_enhanced_fast_string)
+SYM_FUNC_END(copy_user_enhanced_fast_string)
 EXPORT_SYMBOL(copy_user_enhanced_fast_string)
 
 /*
@@ -202,7 +202,7 @@ EXPORT_SYMBOL(copy_user_enhanced_fast_string)
  *  - Require 8-byte alignment when size is 8 bytes or larger.
  *  - Require 4-byte alignment when size is 4 bytes.
  */
-ENTRY(__copy_user_nocache)
+SYM_FUNC_START(__copy_user_nocache)
 	ASM_STAC
 
 	/* If size is less than 8 bytes, go to 4-byte copy */
@@ -341,5 +341,5 @@ ENTRY(__copy_user_nocache)
 	_ASM_EXTABLE(31b,.L_fixup_4b_copy)
 	_ASM_EXTABLE(40b,.L_fixup_1b_copy)
 	_ASM_EXTABLE(41b,.L_fixup_1b_copy)
-ENDPROC(__copy_user_nocache)
+SYM_FUNC_END(__copy_user_nocache)
 EXPORT_SYMBOL(__copy_user_nocache)
diff --git a/arch/x86/lib/csum-copy_64.S b/arch/x86/lib/csum-copy_64.S
index 45a53dfe1859..523e4964078f 100644
--- a/arch/x86/lib/csum-copy_64.S
+++ b/arch/x86/lib/csum-copy_64.S
@@ -45,7 +45,7 @@
 	.endm
 
 
-ENTRY(csum_partial_copy_generic)
+SYM_FUNC_START(csum_partial_copy_generic)
 	cmpl	$3*64, %edx
 	jle	.Lignore
 
@@ -221,4 +221,4 @@ ENTRY(csum_partial_copy_generic)
 	jz   .Lende
 	movl $-EFAULT, (%rax)
 	jmp .Lende
-ENDPROC(csum_partial_copy_generic)
+SYM_FUNC_END(csum_partial_copy_generic)
diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index aa93a8eafc00..1e0a560c5909 100644
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -36,7 +36,7 @@
 #include <asm/export.h>
 
 	.text
-ENTRY(__get_user_1)
+SYM_FUNC_START(__get_user_1)
 	mov PER_CPU_VAR(current_task), %_ASM_DX
 	cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
@@ -45,10 +45,10 @@ ENTRY(__get_user_1)
 	xor %eax,%eax
 	ASM_CLAC
 	ret
-ENDPROC(__get_user_1)
+SYM_FUNC_END(__get_user_1)
 EXPORT_SYMBOL(__get_user_1)
 
-ENTRY(__get_user_2)
+SYM_FUNC_START(__get_user_2)
 	add $1,%_ASM_AX
 	jc bad_get_user
 	mov PER_CPU_VAR(current_task), %_ASM_DX
@@ -59,10 +59,10 @@ ENTRY(__get_user_2)
 	xor %eax,%eax
 	ASM_CLAC
 	ret
-ENDPROC(__get_user_2)
+SYM_FUNC_END(__get_user_2)
 EXPORT_SYMBOL(__get_user_2)
 
-ENTRY(__get_user_4)
+SYM_FUNC_START(__get_user_4)
 	add $3,%_ASM_AX
 	jc bad_get_user
 	mov PER_CPU_VAR(current_task), %_ASM_DX
@@ -73,10 +73,10 @@ ENTRY(__get_user_4)
 	xor %eax,%eax
 	ASM_CLAC
 	ret
-ENDPROC(__get_user_4)
+SYM_FUNC_END(__get_user_4)
 EXPORT_SYMBOL(__get_user_4)
 
-ENTRY(__get_user_8)
+SYM_FUNC_START(__get_user_8)
 #ifdef CONFIG_X86_64
 	add $7,%_ASM_AX
 	jc bad_get_user
@@ -101,7 +101,7 @@ ENTRY(__get_user_8)
 	ASM_CLAC
 	ret
 #endif
-ENDPROC(__get_user_8)
+SYM_FUNC_END(__get_user_8)
 EXPORT_SYMBOL(__get_user_8)
 
 
diff --git a/arch/x86/lib/hweight.S b/arch/x86/lib/hweight.S
index a14f9939c365..dbf8cc97b7f5 100644
--- a/arch/x86/lib/hweight.S
+++ b/arch/x86/lib/hweight.S
@@ -8,7 +8,7 @@
  * unsigned int __sw_hweight32(unsigned int w)
  * %rdi: w
  */
-ENTRY(__sw_hweight32)
+SYM_FUNC_START(__sw_hweight32)
 
 #ifdef CONFIG_X86_64
 	movl %edi, %eax				# w
@@ -33,10 +33,10 @@ ENTRY(__sw_hweight32)
 	shrl $24, %eax				# w = w_tmp >> 24
 	__ASM_SIZE(pop,) %__ASM_REG(dx)
 	ret
-ENDPROC(__sw_hweight32)
+SYM_FUNC_END(__sw_hweight32)
 EXPORT_SYMBOL(__sw_hweight32)
 
-ENTRY(__sw_hweight64)
+SYM_FUNC_START(__sw_hweight64)
 #ifdef CONFIG_X86_64
 	pushq   %rdi
 	pushq   %rdx
@@ -79,5 +79,5 @@ ENTRY(__sw_hweight64)
 	popl    %ecx
 	ret
 #endif
-ENDPROC(__sw_hweight64)
+SYM_FUNC_END(__sw_hweight64)
 EXPORT_SYMBOL(__sw_hweight64)
diff --git a/arch/x86/lib/iomap_copy_64.S b/arch/x86/lib/iomap_copy_64.S
index 33147fef3452..2246fbf32fa8 100644
--- a/arch/x86/lib/iomap_copy_64.S
+++ b/arch/x86/lib/iomap_copy_64.S
@@ -20,8 +20,8 @@
 /*
  * override generic version in lib/iomap_copy.c
  */
-ENTRY(__iowrite32_copy)
+SYM_FUNC_START(__iowrite32_copy)
 	movl %edx,%ecx
 	rep movsd
 	ret
-ENDPROC(__iowrite32_copy)
+SYM_FUNC_END(__iowrite32_copy)
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 728703c47d58..9bec63e212a8 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -188,7 +188,7 @@ SYM_FUNC_END(memcpy_orig)
  * Note that we only catch machine checks when reading the source addresses.
  * Writes to target are posted and don't generate machine checks.
  */
-ENTRY(memcpy_mcsafe_unrolled)
+SYM_FUNC_START(memcpy_mcsafe_unrolled)
 	cmpl $8, %edx
 	/* Less than 8 bytes? Go to byte copy loop */
 	jb .L_no_whole_words
@@ -276,7 +276,7 @@ ENTRY(memcpy_mcsafe_unrolled)
 .L_done_memcpy_trap:
 	xorq %rax, %rax
 	ret
-ENDPROC(memcpy_mcsafe_unrolled)
+SYM_FUNC_END(memcpy_mcsafe_unrolled)
 EXPORT_SYMBOL_GPL(memcpy_mcsafe_unrolled)
 
 	.section .fixup, "ax"
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 50c1648311b3..337830d7a59c 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -27,7 +27,7 @@
 .weak memmove
 
 SYM_FUNC_START_ALIAS(memmove)
-ENTRY(__memmove)
+SYM_FUNC_START(__memmove)
 
 	/* Handle more 32 bytes in loop */
 	mov %rdi, %rax
@@ -207,7 +207,7 @@ ENTRY(__memmove)
 	movb %r11b, (%rdi)
 13:
 	retq
-ENDPROC(__memmove)
+SYM_FUNC_END(__memmove)
 SYM_FUNC_END_ALIAS(memmove)
 EXPORT_SYMBOL(__memmove)
 EXPORT_SYMBOL(memmove)
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 564abf9ecedb..9ff15ee404a4 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -20,7 +20,7 @@
  * rax   original destination
  */
 SYM_FUNC_START_ALIAS(memset)
-ENTRY(__memset)
+SYM_FUNC_START(__memset)
 	/*
 	 * Some CPUs support enhanced REP MOVSB/STOSB feature. It is recommended
 	 * to use it when possible. If not available, use fast string instructions.
@@ -43,7 +43,7 @@ ENTRY(__memset)
 	rep stosb
 	movq %r9,%rax
 	ret
-ENDPROC(__memset)
+SYM_FUNC_END(__memset)
 SYM_FUNC_END_ALIAS(memset)
 EXPORT_SYMBOL(memset)
 EXPORT_SYMBOL(__memset)
diff --git a/arch/x86/lib/msr-reg.S b/arch/x86/lib/msr-reg.S
index ed33cbab3958..a2b9caa5274c 100644
--- a/arch/x86/lib/msr-reg.S
+++ b/arch/x86/lib/msr-reg.S
@@ -12,7 +12,7 @@
  *
  */
 .macro op_safe_regs op
-ENTRY(\op\()_safe_regs)
+SYM_FUNC_START(\op\()_safe_regs)
 	pushq %rbx
 	pushq %r12
 	movq	%rdi, %r10	/* Save pointer */
@@ -41,13 +41,13 @@ ENTRY(\op\()_safe_regs)
 	jmp     2b
 
 	_ASM_EXTABLE(1b, 3b)
-ENDPROC(\op\()_safe_regs)
+SYM_FUNC_END(\op\()_safe_regs)
 .endm
 
 #else /* X86_32 */
 
 .macro op_safe_regs op
-ENTRY(\op\()_safe_regs)
+SYM_FUNC_START(\op\()_safe_regs)
 	pushl %ebx
 	pushl %ebp
 	pushl %esi
@@ -83,7 +83,7 @@ ENTRY(\op\()_safe_regs)
 	jmp     2b
 
 	_ASM_EXTABLE(1b, 3b)
-ENDPROC(\op\()_safe_regs)
+SYM_FUNC_END(\op\()_safe_regs)
 .endm
 
 #endif
diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
index 8234d8559385..9ec0f34a8541 100644
--- a/arch/x86/lib/putuser.S
+++ b/arch/x86/lib/putuser.S
@@ -36,7 +36,7 @@
 		ret
 
 .text
-ENTRY(__put_user_1)
+SYM_FUNC_START(__put_user_1)
 	ENTER
 	cmp TASK_addr_limit(%_ASM_BX),%_ASM_CX
 	jae bad_put_user
@@ -44,10 +44,10 @@ ENTRY(__put_user_1)
 1:	movb %al,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
-ENDPROC(__put_user_1)
+SYM_FUNC_END(__put_user_1)
 EXPORT_SYMBOL(__put_user_1)
 
-ENTRY(__put_user_2)
+SYM_FUNC_START(__put_user_2)
 	ENTER
 	mov TASK_addr_limit(%_ASM_BX),%_ASM_BX
 	sub $1,%_ASM_BX
@@ -57,10 +57,10 @@ ENTRY(__put_user_2)
 2:	movw %ax,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
-ENDPROC(__put_user_2)
+SYM_FUNC_END(__put_user_2)
 EXPORT_SYMBOL(__put_user_2)
 
-ENTRY(__put_user_4)
+SYM_FUNC_START(__put_user_4)
 	ENTER
 	mov TASK_addr_limit(%_ASM_BX),%_ASM_BX
 	sub $3,%_ASM_BX
@@ -70,10 +70,10 @@ ENTRY(__put_user_4)
 3:	movl %eax,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
-ENDPROC(__put_user_4)
+SYM_FUNC_END(__put_user_4)
 EXPORT_SYMBOL(__put_user_4)
 
-ENTRY(__put_user_8)
+SYM_FUNC_START(__put_user_8)
 	ENTER
 	mov TASK_addr_limit(%_ASM_BX),%_ASM_BX
 	sub $7,%_ASM_BX
@@ -86,7 +86,7 @@ ENTRY(__put_user_8)
 #endif
 	xor %eax,%eax
 	EXIT
-ENDPROC(__put_user_8)
+SYM_FUNC_END(__put_user_8)
 EXPORT_SYMBOL(__put_user_8)
 
 SYM_CODE_START_LOCAL(bad_put_user)
diff --git a/arch/x86/lib/rwsem.S b/arch/x86/lib/rwsem.S
index dc2ab6ea6768..dcd5c997b068 100644
--- a/arch/x86/lib/rwsem.S
+++ b/arch/x86/lib/rwsem.S
@@ -86,7 +86,7 @@
 #endif
 
 /* Fix up special calling conventions */
-ENTRY(call_rwsem_down_read_failed)
+SYM_FUNC_START(call_rwsem_down_read_failed)
 	FRAME_BEGIN
 	save_common_regs
 	__ASM_SIZE(push,) %__ASM_REG(dx)
@@ -96,9 +96,9 @@ ENTRY(call_rwsem_down_read_failed)
 	restore_common_regs
 	FRAME_END
 	ret
-ENDPROC(call_rwsem_down_read_failed)
+SYM_FUNC_END(call_rwsem_down_read_failed)
 
-ENTRY(call_rwsem_down_read_failed_killable)
+SYM_FUNC_START(call_rwsem_down_read_failed_killable)
 	FRAME_BEGIN
 	save_common_regs
 	__ASM_SIZE(push,) %__ASM_REG(dx)
@@ -108,9 +108,9 @@ ENTRY(call_rwsem_down_read_failed_killable)
 	restore_common_regs
 	FRAME_END
 	ret
-ENDPROC(call_rwsem_down_read_failed_killable)
+SYM_FUNC_END(call_rwsem_down_read_failed_killable)
 
-ENTRY(call_rwsem_down_write_failed)
+SYM_FUNC_START(call_rwsem_down_write_failed)
 	FRAME_BEGIN
 	save_common_regs
 	movq %rax,%rdi
@@ -118,9 +118,9 @@ ENTRY(call_rwsem_down_write_failed)
 	restore_common_regs
 	FRAME_END
 	ret
-ENDPROC(call_rwsem_down_write_failed)
+SYM_FUNC_END(call_rwsem_down_write_failed)
 
-ENTRY(call_rwsem_down_write_failed_killable)
+SYM_FUNC_START(call_rwsem_down_write_failed_killable)
 	FRAME_BEGIN
 	save_common_regs
 	movq %rax,%rdi
@@ -128,9 +128,9 @@ ENTRY(call_rwsem_down_write_failed_killable)
 	restore_common_regs
 	FRAME_END
 	ret
-ENDPROC(call_rwsem_down_write_failed_killable)
+SYM_FUNC_END(call_rwsem_down_write_failed_killable)
 
-ENTRY(call_rwsem_wake)
+SYM_FUNC_START(call_rwsem_wake)
 	FRAME_BEGIN
 	/* do nothing if still outstanding active readers */
 	__ASM_HALF_SIZE(dec) %__ASM_HALF_REG(dx)
@@ -141,9 +141,9 @@ ENTRY(call_rwsem_wake)
 	restore_common_regs
 1:	FRAME_END
 	ret
-ENDPROC(call_rwsem_wake)
+SYM_FUNC_END(call_rwsem_wake)
 
-ENTRY(call_rwsem_downgrade_wake)
+SYM_FUNC_START(call_rwsem_downgrade_wake)
 	FRAME_BEGIN
 	save_common_regs
 	__ASM_SIZE(push,) %__ASM_REG(dx)
@@ -153,4 +153,4 @@ ENTRY(call_rwsem_downgrade_wake)
 	restore_common_regs
 	FRAME_END
 	ret
-ENDPROC(call_rwsem_downgrade_wake)
+SYM_FUNC_END(call_rwsem_downgrade_wake)
diff --git a/arch/x86/mm/mem_encrypt_boot.S b/arch/x86/mm/mem_encrypt_boot.S
index 730e6d541df1..4501765edff2 100644
--- a/arch/x86/mm/mem_encrypt_boot.S
+++ b/arch/x86/mm/mem_encrypt_boot.S
@@ -18,7 +18,7 @@
 
 	.text
 	.code64
-ENTRY(sme_encrypt_execute)
+SYM_FUNC_START(sme_encrypt_execute)
 
 	/*
 	 * Entry parameters:
@@ -67,9 +67,9 @@ ENTRY(sme_encrypt_execute)
 	pop	%rbp
 
 	ret
-ENDPROC(sme_encrypt_execute)
+SYM_FUNC_END(sme_encrypt_execute)
 
-ENTRY(__enc_copy)
+SYM_FUNC_START(__enc_copy)
 /*
  * Routine used to encrypt kernel.
  *   This routine must be run outside of the kernel proper since
@@ -146,4 +146,4 @@ ENTRY(__enc_copy)
 
 	ret
 .L__enc_copy_end:
-ENDPROC(__enc_copy)
+SYM_FUNC_END(__enc_copy)
diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 74628ec78f29..b1d2313fe3bf 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -39,7 +39,7 @@
 	mov %rsi, %cr0;			\
 	mov (%rsp), %rsp
 
-ENTRY(efi_call)
+SYM_FUNC_START(efi_call)
 	pushq %rbp
 	movq %rsp, %rbp
 	SAVE_XMM
@@ -55,4 +55,4 @@ ENTRY(efi_call)
 	RESTORE_XMM
 	popq %rbp
 	ret
-ENDPROC(efi_call)
+SYM_FUNC_END(efi_call)
diff --git a/arch/x86/platform/efi/efi_thunk_64.S b/arch/x86/platform/efi/efi_thunk_64.S
index 6e98ee1142cb..adab7d081774 100644
--- a/arch/x86/platform/efi/efi_thunk_64.S
+++ b/arch/x86/platform/efi/efi_thunk_64.S
@@ -25,7 +25,7 @@
 
 	.text
 	.code64
-ENTRY(efi64_thunk)
+SYM_FUNC_START(efi64_thunk)
 	push	%rbp
 	push	%rbx
 
@@ -60,7 +60,7 @@ ENTRY(efi64_thunk)
 	pop	%rbx
 	pop	%rbp
 	retq
-ENDPROC(efi64_thunk)
+SYM_FUNC_END(efi64_thunk)
 
 /*
  * We run this function from the 1:1 mapping.
diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
index 44755a847856..c87ae08f9312 100644
--- a/arch/x86/power/hibernate_asm_64.S
+++ b/arch/x86/power/hibernate_asm_64.S
@@ -23,7 +23,7 @@
 #include <asm/processor-flags.h>
 #include <asm/frame.h>
 
-ENTRY(swsusp_arch_suspend)
+SYM_FUNC_START(swsusp_arch_suspend)
 	movq	$saved_context, %rax
 	movq	%rsp, pt_regs_sp(%rax)
 	movq	%rbp, pt_regs_bp(%rax)
@@ -51,7 +51,7 @@ ENTRY(swsusp_arch_suspend)
 	call swsusp_save
 	FRAME_END
 	ret
-ENDPROC(swsusp_arch_suspend)
+SYM_FUNC_END(swsusp_arch_suspend)
 
 SYM_CODE_START(restore_image)
 	/* prepare to jump to the image kernel */
@@ -103,7 +103,7 @@ SYM_CODE_END(core_restore_code)
 
 	 /* code below belongs to the image kernel */
 	.align PAGE_SIZE
-ENTRY(restore_registers)
+SYM_FUNC_START(restore_registers)
 	/* go back to the original page tables */
 	movq    %r9, %cr3
 
@@ -145,4 +145,4 @@ ENTRY(restore_registers)
 	movq	%rax, in_suspend(%rip)
 
 	ret
-ENDPROC(restore_registers)
+SYM_FUNC_END(restore_registers)
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 8019edd0125c..d7bf6d5cfcb9 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -18,7 +18,7 @@
  * event status with one and operation.  If there are pending events,
  * then enter the hypervisor to get them handled.
  */
-ENTRY(xen_irq_enable_direct)
+SYM_FUNC_START(xen_irq_enable_direct)
 	FRAME_BEGIN
 	/* Unmask events */
 	movb $0, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
@@ -37,17 +37,17 @@ ENTRY(xen_irq_enable_direct)
 1:
 	FRAME_END
 	ret
-	ENDPROC(xen_irq_enable_direct)
+SYM_FUNC_END(xen_irq_enable_direct)
 
 
 /*
  * Disabling events is simply a matter of making the event mask
  * non-zero.
  */
-ENTRY(xen_irq_disable_direct)
+SYM_FUNC_START(xen_irq_disable_direct)
 	movb $1, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 	ret
-ENDPROC(xen_irq_disable_direct)
+SYM_FUNC_END(xen_irq_disable_direct)
 
 /*
  * (xen_)save_fl is used to get the current interrupt enable status.
@@ -58,12 +58,12 @@ ENDPROC(xen_irq_disable_direct)
  * undefined.  We need to toggle the state of the bit, because Xen and
  * x86 use opposite senses (mask vs enable).
  */
-ENTRY(xen_save_fl_direct)
+SYM_FUNC_START(xen_save_fl_direct)
 	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 	setz %ah
 	addb %ah, %ah
 	ret
-	ENDPROC(xen_save_fl_direct)
+SYM_FUNC_END(xen_save_fl_direct)
 
 
 /*
@@ -73,7 +73,7 @@ ENTRY(xen_save_fl_direct)
  * interrupt mask state, it checks for unmasked pending events and
  * enters the hypervisor to get them delivered if so.
  */
-ENTRY(xen_restore_fl_direct)
+SYM_FUNC_START(xen_restore_fl_direct)
 	FRAME_BEGIN
 #ifdef CONFIG_X86_64
 	testw $X86_EFLAGS_IF, %di
@@ -94,14 +94,14 @@ ENTRY(xen_restore_fl_direct)
 1:
 	FRAME_END
 	ret
-	ENDPROC(xen_restore_fl_direct)
+SYM_FUNC_END(xen_restore_fl_direct)
 
 
 /*
  * Force an event check by making a hypercall, but preserve regs
  * before making the call.
  */
-ENTRY(check_events)
+SYM_FUNC_START(check_events)
 	FRAME_BEGIN
 #ifdef CONFIG_X86_32
 	push %eax
@@ -134,4 +134,4 @@ ENTRY(check_events)
 #endif
 	FRAME_END
 	ret
-ENDPROC(check_events)
+SYM_FUNC_END(check_events)
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index 0f6c1348fb87..3ab54708fe31 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -109,7 +109,7 @@ SYM_CODE_END(xen_sysret64)
  */
 
 /* Normal 64-bit system call target */
-ENTRY(xen_syscall_target)
+SYM_FUNC_START(xen_syscall_target)
 	popq %rcx
 	popq %r11
 
@@ -122,12 +122,12 @@ ENTRY(xen_syscall_target)
 	movq $__USER_CS, 1*8(%rsp)
 
 	jmp entry_SYSCALL_64_after_hwframe
-ENDPROC(xen_syscall_target)
+SYM_FUNC_END(xen_syscall_target)
 
 #ifdef CONFIG_IA32_EMULATION
 
 /* 32-bit compat syscall target */
-ENTRY(xen_syscall32_target)
+SYM_FUNC_START(xen_syscall32_target)
 	popq %rcx
 	popq %r11
 
@@ -140,25 +140,25 @@ ENTRY(xen_syscall32_target)
 	movq $__USER32_CS, 1*8(%rsp)
 
 	jmp entry_SYSCALL_compat_after_hwframe
-ENDPROC(xen_syscall32_target)
+SYM_FUNC_END(xen_syscall32_target)
 
 /* 32-bit compat sysenter target */
-ENTRY(xen_sysenter_target)
+SYM_FUNC_START(xen_sysenter_target)
 	mov 0*8(%rsp), %rcx
 	mov 1*8(%rsp), %r11
 	mov 5*8(%rsp), %rsp
 	jmp entry_SYSENTER_compat
-ENDPROC(xen_sysenter_target)
+SYM_FUNC_END(xen_sysenter_target)
 
 #else /* !CONFIG_IA32_EMULATION */
 
 SYM_FUNC_START_ALIAS(xen_syscall32_target)
-ENTRY(xen_sysenter_target)
+SYM_FUNC_START(xen_sysenter_target)
 	lea 16(%rsp), %rsp	/* strip %rcx, %r11 */
 	mov $-ENOSYS, %rax
 	pushq $0
 	jmp hypercall_iret
-ENDPROC(xen_sysenter_target)
+SYM_FUNC_END(xen_sysenter_target)
 SYM_FUNC_END_ALIAS(xen_syscall32_target)
 
 #endif	/* CONFIG_IA32_EMULATION */
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 077c1e706908..7a560939eecd 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -105,11 +105,13 @@
 
 /* === DEPRECATED annotations === */
 
+#ifndef CONFIG_X86_64
 #ifndef ENTRY
 /* deprecated, use SYM_FUNC_START */
 #define ENTRY(name) \
 	SYM_FUNC_START(name)
 #endif
+#endif /* CONFIG_X86_64 */
 #endif /* LINKER_SCRIPT */
 
 #ifndef WEAK
@@ -124,6 +126,7 @@
 	.size name, .-name
 #endif
 
+#ifndef CONFIG_X86_64
 /* If symbol 'name' is treated as a subroutine (gets called, and returns)
  * then please use ENDPROC to mark 'name' as STT_FUNC for the benefit of
  * static analysis tools such as stack depth analyzer.
@@ -133,6 +136,7 @@
 #define ENDPROC(name) \
 	SYM_FUNC_END(name)
 #endif
+#endif /* CONFIG_X86_64 */
 
 /* === generic annotations === */
 
-- 
2.15.0
