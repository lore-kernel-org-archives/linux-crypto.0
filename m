Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCB430100E;
	Tue,  9 Dec 2025 01:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765245490; cv=none; b=d5sEPs4qKOq14TLw576VyvuMptrevbMTiyi3Ptfs07ksI3sPvspWvdaPqdCXYMaJciwfr00I0D4g74iTu0lEWZDFbeSJo10gk0PjrGNYSKTZt8x5qpe2i0afqviWQImy6RrzkPUmt7WR1zeMVzJluHsm9pV2IF6JL969oKzEYxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765245490; c=relaxed/simple;
	bh=lBZr6D2e5n0xBHE1F51j1RsG0jR805ve81yaxuG4wgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTC3xXQt7x+7VOV2FDj5Hi7q5sm4HPbJskbIVTvo3dS4KyQEc048qF2jJjry94BeSN3FseZY+g49gSBr8g9OHJnii86y8CTGvsb4ye9oMYAeXq8Ev1BJcgLj3SYwdp6VoWjFGELiAzcaSEdjdx6GNEjKsz//le/RArRIOP1i1jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fuZfdhDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fuZfdhDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8D5C19422;
	Tue,  9 Dec 2025 01:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765245489;
	bh=lBZr6D2e5n0xBHE1F51j1RsG0jR805ve81yaxuG4wgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuZfdhDbNAwsAyMOHDCUfzqXfQzFmezNl8aRFiEphNlIX1gW2MSc257JGc4FGrPQc
	 giMvZ1WQxw9hpQJcYsTHYCv7uNrxHI/WUdZU3utxzpyrIa5FGxupSvQ/l3urp0eKj5
	 D+7tTfZggmvDryLUKIFisxHtMX5AgfhpxgORfeBvy+xntmiwuy3YCjiOJCCJaB/Su/
	 JGQt9iaFjruNqK36eBXLnuSRvSkUnbe/rhd8XyHDy2D6TfNYrTetnojX5b683OP1n2
	 R2EQZTLHIXkbLYdJ+kSTkZMpAwsKD0vjAkUba7uKFggwNolXSDi2OPSY857jDozVsp
	 GvOn2UCndbNMw==
From: Eric Biggers <ebiggers@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Fangrui Song <maskray@sourceware.org>,
	Pablo Galindo <pablogsal@gmail.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 2/3] perf genelf: Switch from SHA-1 to BLAKE2s for build ID generation
Date: Mon,  8 Dec 2025 17:57:28 -0800
Message-ID: <20251209015729.23253-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251209015729.23253-1-ebiggers@kernel.org>
References: <20251209015729.23253-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recent patches [1] [2] added an implementation of SHA-1 to perf and made
it be used for build ID generation.

I had understood the choice of SHA-1, which is a legacy algorithm, to be
for backwards compatibility.

It turns out, though, that there's no backwards compatibility
requirement here other than the size of the build ID field, which is
fixed at 20 bytes.  Not only did the hash algorithm already change (from
MD5 to SHA-1), but the inputs to the hash changed too: from
'load_addr || code' to just 'code', and now again to
'code || symtab || strsym' [3].  Different linkers generate different
build IDs, with the LLVM linker using BLAKE3 hashes for example [4].

Therefore, we might as well switch to a more modern algorithm.  Let's go
with BLAKE2s.  It's faster than SHA-1, isn't cryptographically broken,
is easier to implement than BLAKE3, and the kernel's implementation in
lib/crypto/blake2s.c is easily borrowed.  It also natively supports
variable-length hashes, so it can directly produce the needed 20 bytes.

Also make the following additional improvements:

- Hash the three inputs incrementally, so they don't all have to be
  concatenated into one buffer.

- Add tag/length prefixes to each of the three inputs, so that distinct
  input tuples reliably result in distinct hashes.

[1] https://lore.kernel.org/linux-perf-users/20250521225307.743726-1-yuzhuo@google.com/
[2] https://lore.kernel.org/linux-perf-users/20250625202311.23244-1-ebiggers@kernel.org/
[3] https://lore.kernel.org/linux-perf-users/20251125080748.461014-1-namhyung@kernel.org/
[4] https://github.com/llvm/llvm-project/commit/d3e5b6f7539b86995aef6e2075c1edb3059385ce

Tested-by: Ian Rogers <irogers@google.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 tools/perf/util/genelf.c | 58 +++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/tools/perf/util/genelf.c b/tools/perf/util/genelf.c
index a1cd5196f4ec..14882def9704 100644
--- a/tools/perf/util/genelf.c
+++ b/tools/perf/util/genelf.c
@@ -16,12 +16,12 @@
 #include <err.h>
 #ifdef HAVE_LIBDW_SUPPORT
 #include <dwarf.h>
 #endif
 
+#include "blake2s.h"
 #include "genelf.h"
-#include "sha1.h"
 #include "../util/jitdump.h"
 #include <linux/compiler.h>
 
 #ifndef NT_GNU_BUILD_ID
 #define NT_GNU_BUILD_ID 3
@@ -49,11 +49,11 @@ static char shd_string_table[] = {
 };
 
 static struct buildid_note {
 	Elf_Note desc;		/* descsz: size of build-id, must be multiple of 4 */
 	char	 name[4];	/* GNU\0 */
-	u8	 build_id[SHA1_DIGEST_SIZE];
+	u8	 build_id[20];
 } bnote;
 
 static Elf_Sym symtab[]={
 	/* symbol 0 MUST be the undefined symbol */
 	{ .st_name  = 0, /* index in sym_string table */
@@ -150,13 +150,32 @@ jit_add_eh_frame_info(Elf *e, void* unwinding, uint64_t unwinding_header_size,
 	shdr->sh_entsize = 0;
 
 	return 0;
 }
 
+enum {
+	TAG_CODE = 0,
+	TAG_SYMTAB = 1,
+	TAG_STRSYM = 2,
+};
+
+/*
+ * Update the hash using the given data, also prepending a (tag, len) prefix to
+ * ensure that distinct input tuples reliably result in distinct hashes.
+ */
+static void blake2s_update_tagged(struct blake2s_ctx *ctx, int tag,
+				  const void *data, size_t len)
+{
+	u64 prefix = ((u64)tag << 56) | len;
+
+	blake2s_update(ctx, (const u8 *)&prefix, sizeof(prefix));
+	blake2s_update(ctx, data, len);
+}
+
 /*
  * fd: file descriptor open for writing for the output file
- * load_addr: code load address (could be zero, just used for buildid)
+ * load_addr: code load address (could be zero)
  * sym: function name (for native code - used as the symbol)
  * code: the native code
  * csize: the code size in bytes
  */
 int
@@ -171,12 +190,11 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	Elf_Ehdr *ehdr;
 	Elf_Phdr *phdr;
 	Elf_Shdr *shdr;
 	uint64_t eh_frame_base_offset;
 	char *strsym = NULL;
-	void *build_id_data = NULL, *tmp;
-	int build_id_data_len;
+	struct blake2s_ctx ctx;
 	int symlen;
 	int retval = -1;
 
 	if (elf_version(EV_CURRENT) == EV_NONE) {
 		warnx("ELF initialization failed");
@@ -251,17 +269,12 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	shdr->sh_type = SHT_PROGBITS;
 	shdr->sh_addr = GEN_ELF_TEXT_OFFSET;
 	shdr->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
 	shdr->sh_entsize = 0;
 
-	build_id_data = malloc(csize);
-	if (build_id_data == NULL) {
-		warnx("cannot allocate build-id data");
-		goto error;
-	}
-	memcpy(build_id_data, code, csize);
-	build_id_data_len = csize;
+	blake2s_init(&ctx, sizeof(bnote.build_id));
+	blake2s_update_tagged(&ctx, TAG_CODE, code, csize);
 
 	/*
 	 * Setup .eh_frame_hdr and .eh_frame
 	 */
 	if (unwinding) {
@@ -342,18 +355,11 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	shdr->sh_type = SHT_SYMTAB;
 	shdr->sh_flags = 0;
 	shdr->sh_entsize = sizeof(Elf_Sym);
 	shdr->sh_link = unwinding ? 6 : 4; /* index of .strtab section */
 
-	tmp = realloc(build_id_data, build_id_data_len + sizeof(symtab));
-	if (tmp == NULL) {
-		warnx("cannot allocate build-id data");
-		goto error;
-	}
-	memcpy(tmp + build_id_data_len, symtab, sizeof(symtab));
-	build_id_data = tmp;
-	build_id_data_len += sizeof(symtab);
+	blake2s_update_tagged(&ctx, TAG_SYMTAB, symtab, sizeof(symtab));
 
 	/*
 	 * setup symbols string table
 	 * 2 = 1 for 0 in 1st entry, 1 for the 0 at end of symbol for 2nd entry
 	 */
@@ -393,18 +399,11 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	shdr->sh_name = 25; /* offset in shd_string_table */
 	shdr->sh_type = SHT_STRTAB;
 	shdr->sh_flags = 0;
 	shdr->sh_entsize = 0;
 
-	tmp = realloc(build_id_data, build_id_data_len + symlen);
-	if (tmp == NULL) {
-		warnx("cannot allocate build-id data");
-		goto error;
-	}
-	memcpy(tmp + build_id_data_len, strsym, symlen);
-	build_id_data = tmp;
-	build_id_data_len += symlen;
+	blake2s_update_tagged(&ctx, TAG_STRSYM, strsym, symlen);
 
 	/*
 	 * setup build-id section
 	 */
 	scn = elf_newscn(e);
@@ -420,11 +419,11 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	}
 
 	/*
 	 * build-id generation
 	 */
-	sha1(build_id_data, build_id_data_len, bnote.build_id);
+	blake2s_final(&ctx, bnote.build_id);
 	bnote.desc.namesz = sizeof(bnote.name); /* must include 0 termination */
 	bnote.desc.descsz = sizeof(bnote.build_id);
 	bnote.desc.type   = NT_GNU_BUILD_ID;
 	strcpy(bnote.name, "GNU");
 
@@ -465,9 +464,8 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	retval = 0;
 error:
 	(void)elf_end(e);
 
 	free(strsym);
-	free(build_id_data);
 
 	return retval;
 }
-- 
2.52.0

