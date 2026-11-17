Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794890118;
	b=eK2I3vrIeQYX+5R/QXb832IsEcbj1GzROgTr+lIC9InGr9+iMmNK1s+gA8Vvus0mzV8t
	 iVAMvrKSzKdekXXedBwB4jVIz1SRESmpTFOynGUnYX58OD+5yvKZ6e3YFppaEaQnAMc4E
	 agQOJGQoH9Vqy3o5mARRJZLsmjumMMycWOE6EEnX5B0OhDI45uVZsWw+vjImQkL4RlR+t
	 a+S+ykzwuXA5eR6yzczbzf7UFmDVTgFPXXwlnJ+2moq+PZ0FtmP9CpwBGQ7kWl/kXS9mh
	 WHJ12/f4mqVbul+08HMGk9JslaYpxOu/4dHweJsGYKeP9cPc3hMLTagqSQsg2GEYUVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794890118;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=z05eBXZtj33QVuPoWyFJ9ACiczNoA+RtpuXMjmRS3N8=;
	b=OeaUIm1DplWLK6fGc+7CZXFJrJJcytZVQwTErFRRJT4yvb6vB/gwwKKz2PE2YG/ith30
	 sPxo8YrQOwBVxhnGvCJ57JpDIMCB560akHDGsLViXsO0bF65PbDtrv2p74UMHPjhHz9Pq
	 OOWyzP2hRugTbqbdp9ACahW9RdDm3h7PBapvpx+/b/onYHo8XjKxunG/T1kqjoy5gQXoa
	 MX0KX+Z9InLlEzwna+BAkcxKKWl6iaKwct5RoHYfnXdbeUmB/zspVoM2WeBH8u4hSOUAZ
	 vf88CdcwOWdu8ycfjmMongphJQcpb714dv/OED3MkeY1YXuzjXPYB0CmMoWJ0FrXK2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fJrzxayv;
	arc=none smtp.remote-ip=209.85.214.198
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B4760A262A
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 04:35:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37B4760A262A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fJrzxayv
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ed08904845so27012745ad.3
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 20:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794890118; x=1795494918; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z05eBXZtj33QVuPoWyFJ9ACiczNoA+RtpuXMjmRS3N8=;
        b=fJrzxayvCXLh44qDh2coaxjtXD3JvyBGnxrfqiZPx0ZAgm5vf0sOxnhvSDh3KzOv41
         GLE0m1s+WZi+GdmKOzcnGS+uE92ogIiCY/0HB0uVyoBSfX4Roa2D4pz6jBJ70ql/sZr4
         jf9fVkDvv2aUAMwzwc0NPuT3wWtTZmEsz2VjvlPUBYLAGgKR2wT2vVg0Y5QiB38iTvtZ
         bOn+8YEq7F50eGNT2gKIZoKKJvgKuQyRNxKVKTIm+vzPCyEKuVtf0mo9AtSSA4Mf+78L
         8Y4aOkdJSFByB9+Y4zLwh7KLzmdFE9toDRj+caN12M2dVw1eOchIbE1mEFAJuaEPpjm/
         XPdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794890118; x=1795494918;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z05eBXZtj33QVuPoWyFJ9ACiczNoA+RtpuXMjmRS3N8=;
        b=BJQd5EIDAEv2B21QVOrspTQk7SxwgMR9N81rLGpLomYyV7NxqT4nG/6gPFEAafO9fv
         RWZxA4IjfvuiJxM2JS1TnNjhEmcyo96TWJK2Rxj7DyeFcoIPWKYLzpkX9rouXONFSVkd
         yJcCQ/kuHNzVdlc/T333R3rlvGpLBDR1x7c8bB/XGbnNLiSm+XgqWwvMxxhWpvB6I59C
         zkCYALqOsoRvwAYsFA6biiRElkksCkstwS2Borj04dvEY/0Una4I5wJQpaGJAa9N8OqF
         XIRXEKItMB88qF6exmFPZy2XSZorma+3ju77L/YxJUvVGgvQEk0gD2DblHLjqztiKqWY
         hItQ==
X-Forwarded-Encrypted: i=1; AL+hErEB+2Mu/Co8+XRtg0dKic0HvQU7syNCwTHj7RDYMWair3i+Nrc56tsOJ8XK7RRJhcaViDYTHmemadccQr8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8vhvtH03JURhOQVG7S3OYg+y8nwM1J+fSOQ+J7ih37nqX3wY84
	Y4ty2JK2o0WeeA+fV7zdJQMYlDFnyCnbRT7S25LGuboyJ0qKWLI8X1ZNdQztSstFPwTCBFDY2JS
	Y4upJn4ABbnTGbohSGry1jNWGfg==
X-Received: from plbju12.prod.google.com ([2002:a17:903:428c:b0:2e8:44b9:5c18])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1b50:b0:2ee:1f51:32ea with SMTP id d9443c01a7336-2ee1f513339mr100649615ad.25.1794890117329;
 Mon, 16 Nov 2026 20:35:17 -0800 (PST)
Date: Tue, 17 Nov 2026 04:34:59 +0000
In-Reply-To: <20261117043504.1021063-1-dylanbhatch@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261117043504.1021063-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
Message-ID: <20261117043504.1021063-8-dylanbhatch@google.com>
Subject: [RFC PATCH 07/12] scripts/sorttable: sort .lr_unwind_fde by start_offset
From: Dylan Hatch <dylanbhatch@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Weinan Liu <wnliu@google.com>, 
	Jens Remus <jremus@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-crypto@vger.kernel.org, llvm@lists.linux.dev, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Indu Bhagat <ibhagatgnu@gmail.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, live-patching@vger.kernel.org, 
	Dylan Hatch <dylanbhatch@google.com>
Content-Type: text/plain; charset="UTF-8"

Normalize the PC-relative start_offset word of each 8-byte struct lr_fde
entry in .lr_unwind_fde, qsort by virtual address, and denormalize back
to PC-relative offsets without modifying range_desc.

Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 scripts/sorttable.c | 50 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/scripts/sorttable.c b/scripts/sorttable.c
index 88e49a5c42512..38495c39e404b 100644
--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -600,6 +600,37 @@ static void get_mcount_loc(struct elf_mcount_loc *emloc, Elf_Shdr *symtab_sec,
 static inline int parse_symbols(const char *fname) { return 0; }
 #endif
 
+static int compare_relative_table(const void *a, const void *b)
+{
+	int32_t av = (int32_t)elf_parser.r(a);
+	int32_t bv = (int32_t)elf_parser.r(b);
+
+	if (av < bv)
+		return -1;
+	if (av > bv)
+		return 1;
+	return 0;
+}
+
+static void sort_lr_unwind_fde(char *fde_image, int image_size)
+{
+	int i;
+
+	for (i = 0; i < image_size; i += 8) {
+		uint32_t *loc = (uint32_t *)(fde_image + i);
+
+		elf_parser.w(elf_parser.r(loc) + i, loc);
+	}
+
+	qsort(fde_image, image_size / 8, 8, compare_relative_table);
+
+	for (i = 0; i < image_size; i += 8) {
+		uint32_t *loc = (uint32_t *)(fde_image + i);
+
+		elf_parser.w(elf_parser.r(loc) - i, loc);
+	}
+}
+
 static int do_sort(Elf_Ehdr *ehdr,
 		   char const *const fname,
 		   table_sort_t custom_sort)
@@ -609,6 +640,7 @@ static int do_sort(Elf_Ehdr *ehdr,
 	Elf_Shdr *strtab_sec = NULL;
 	Elf_Shdr *symtab_sec = NULL;
 	Elf_Shdr *extab_sec = NULL;
+	Elf_Shdr *lr_fde_sec = NULL;
 	Elf_Shdr *string_sec;
 	Elf_Sym *sym;
 	const Elf_Sym *symtab;
@@ -656,6 +688,8 @@ static int do_sort(Elf_Ehdr *ehdr,
 		idx = shdr_name(shdr);
 		if (!strcmp(secstrings + idx, "__ex_table"))
 			extab_sec = shdr;
+		if (!strcmp(secstrings + idx, ".lr_unwind_fde"))
+			lr_fde_sec = shdr;
 		if (!strcmp(secstrings + idx, ".symtab"))
 			symtab_sec = shdr;
 		if (!strcmp(secstrings + idx, ".strtab"))
@@ -759,6 +793,10 @@ static int do_sort(Elf_Ehdr *ehdr,
 		      extable_ent_size, compare_extable);
 	}
 
+	if (lr_fde_sec)
+		sort_lr_unwind_fde((char *)ehdr + shdr_offset(lr_fde_sec),
+				   shdr_size(lr_fde_sec));
+
 	/* find the flag main_extable_sort_needed */
 	sym_start = (void *)ehdr + shdr_offset(symtab_sec);
 	sym_end = sym_start + shdr_size(symtab_sec);
@@ -833,18 +871,6 @@ static int do_sort(Elf_Ehdr *ehdr,
 	return rc;
 }
 
-static int compare_relative_table(const void *a, const void *b)
-{
-	int32_t av = (int32_t)elf_parser.r(a);
-	int32_t bv = (int32_t)elf_parser.r(b);
-
-	if (av < bv)
-		return -1;
-	if (av > bv)
-		return 1;
-	return 0;
-}
-
 static void sort_relative_table(char *extab_image, int image_size)
 {
 	int i = 0;
-- 
2.56.0.679.gc527c65306-goog

