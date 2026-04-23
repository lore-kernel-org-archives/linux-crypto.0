Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAFC3E5588
	for <linux-crypto@vger.kernel.org>; Thu, 23 Apr 2026 09:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776937165; cv=none; b=hLSUpILylMBN290Tw8ZNumarwHF//x0G+18XMQeNbAZeIWVV4AlOY8IduQLpDv+SNkQCVFJHry8qjpr0v3sq4UXbsTJsW7SzAald3cqmJJa2XxLvKhgXDZeSyM82d4tTLFhVviVt9IekY6fxWntTi3CG58cYRrtG1csA6w5FnUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776937165; c=relaxed/simple;
	bh=Zv+zi39YWEoIcSrpR5yR8Neri1QzHS072eZSKtdvi3I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type; b=BDivnJCoGufBR6FmN0v8RnlR1gN/czBreIQoSveN2Zh5+riQQ9S1Gp4b4qtqyfwnwmVf2xsBbR2E1FXU35H3ICd2I2yTYnttscLOitjZAxC7dTdz6NOO1VuVkwzK6+T5yObGURMpO2tVeb7x4XRDr/dyugCLg0Ms/axy4nm09p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N+mtJQsL; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N+mtJQsL"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8ee9ec26edaso297217985a.2
        for <linux-crypto@vger.kernel.org>; Thu, 23 Apr 2026 02:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776937159; x=1777541959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:in-reply-to:organization
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Msu5S5MWS9uVX1FRIpydP8TAPit9IbpaT0gdrUfGcqo=;
        b=N+mtJQsLwY5SYdfcaFdXIW4sXf4jnWOa2AY94UeHm8xUPuX9ZXkIvGs+jaoaT3x+Fm
         7958O1ltqM/xns9gQM5Z8rWxXQSk8nKDNqxa8YzYwr3vqOzuBh/WrW+Rlr95VFXLgXoG
         bi1a6XjAG/OBBUbkzldrZxuFIfkrAmiLIX9NzgajUqFZN5J0FbQvNp8QEqN6T3qUrVRp
         0H0WUgCdHPtIvrITrtX9fsqePgbynAnqF3pTvoSZcGk1bIBVOW1Nv7gHY5PImhoM00V4
         zzmj60RtnO3+oi+vkTgPwDsRBa4e9yrkAs0Yl+TqSRwrcJGyK/dSq5kW6SaMfBMW5sdC
         /h6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776937159; x=1777541959;
        h=content-transfer-encoding:mime-version:in-reply-to:organization
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Msu5S5MWS9uVX1FRIpydP8TAPit9IbpaT0gdrUfGcqo=;
        b=DGlUdzoWMdRWebb7jKivu52X6j7lyDuYsOjLcBrfOWBOHNqldftnMVfCyQJLql9nTB
         bmfnH+IrGVZmKLLDJ+YTn49O2z7IRtq4ViCdQXzPiTYZ17fwIqQbVkeaSuF8poCRp7L/
         e8NakV9bDO/npwfrPmZbhPRrG8NLgbACtfdP/nhPaeWuTwiF7rMk+ivC2I/GJrJv0paG
         zL2YvgSJ/dZC1Lk11o+xDqfXTEzYIhv+HMoMxoGOuzWlTJ3Nm3qv4FDUtUlSi80VOBox
         81oKikl+quQu4J2IsdDNcWjHbOUmsEg8ZE/LYrm3d3lHgKZ+5lmR7HcBuMrfF2aPKl8Q
         jopg==
X-Forwarded-Encrypted: i=1; AFNElJ+SC21jIBDIg0zayrpgozgY5A9ovJA61kaCbfY4/iXQDnplJ0it3G5u+F+tecFz8J4MJ9S8o3FZfYyd1HI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDGzaZ29S0P0ziDQOLM3BPCN+WZ0ikDV7lSUmmGnTjADmTwojd
	oZlW2/5tL3joEUs7C9kABNbSferuL3aq0enAleHjR7TJl64n5259z/wk
X-Gm-Gg: AeBDietc+aH/oEaa+ok1MctTjnfvHP/+V34+G357SY8hBd8WuJ14qMzV5arY9knebBN
	L3Tc0MVmj+8SFfi12IaCERzqLQMtOqEuCv9qwdLpEMtDogNgHq28I2FPolpYUXwFLSx3Mikw+uk
	cMBa0DsVZ5tlV27qGicA+yWegC5fVMHef2e7x1j+OARt0UNtOwDFpoy54tMl05Akn4kMCHwfdzQ
	WS18uhqO5FZqFS89WXRPcVSOxVUMYJHQgGSRM+eLO8zb9B7Q7ZnAZOi9wjqrEZeio1Qi5Ptz3dj
	Ajhh6HqWRlT29F9IVY9LvVepYs0HYvCZd6h4K5MT8kkZZY1CFG2vOPRE0EGP6ZxeO/Em4XOvdrN
	QIMsK53b94HaGS+1YgFasK2ab8gtN0lTboz9G6QcLaHHCCwEJlNeXF43JiaWOneHVAZK4nICV9I
	A1LKmlKTUovqtpv/pCvYrTp7bEFoicY3nlhoQpvKXXtAG75QkdT6bNKf3eykixY0y+NQ==
X-Received: by 2002:a05:6a00:1c96:b0:82f:1aeb:fd60 with SMTP id d2e1a72fcca58-82f8c838f93mr26003235b3a.16.1776930310778;
        Thu, 23 Apr 2026 00:45:10 -0700 (PDT)
Received: from localhost (vpngw1.cse.cuhk.edu.hk. [137.189.90.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec23b19sm22551767b3a.59.2026.04.23.00.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 00:45:10 -0700 (PDT)
Date: Thu, 23 Apr 2026 15:44:55 +0800
From: XIAO WU <shawdoxwu@gmail.com>
To: bot+bpf-ci@kernel.org
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, clm@meta.com,
 daniel@iogearbox.net, davem@davemloft.net, eddyz87@gmail.com,
 git@danielhodges.dev, haoluo@google.com, herbert@gondor.apana.org.au,
 ihor.solodrai@linux.dev, john.fastabend@gmail.com, jolsa@kernel.org,
 kpsingh@kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 martin.lau@kernel.org, martin.lau@linux.dev, sdf@fomichev.me,
 song@kernel.org, vadim.fedorenko@linux.dev, yatsenko@meta.com,
 yonghong.song@linux.dev
Subject: Re: [PATCH bpf-next v5 2/7] crypto: Add BPF hash algorithm type
 registration module
Message-ID: <20260423154455.000021e2@gmail.com>
Organization: The Chinese University of Hong Kong
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
In-Reply-To: <e3277b8c7dfe09fae49d0ea7caacc2327f37a18261176964b0be6a67da50c6be@mail.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi,

> Can this cause a NULL pointer dereference when a BPF program calls
> bpf_crypto_ctx_create() with type="hash"?
>
> The bpf_crypto_ctx_create() function in kernel/bpf/crypto.c
> unconditionally calls type->setkey(), type->ivsize(), and
> type->statesize():
>
>     *err = type->setkey(ctx->tfm, params->key, params->key_len);
>     ...
>     ctx->siv_len = type->ivsize(ctx->tfm) + type->statesize(ctx->tfm);
>
> But bpf_crypto_shash_type does not implement these callbacks, leaving
> them as NULL.
>
> Note: This appears to be fixed later in the series by commit
> 76d771a64b50 ("bpf: Add hash kfunc for cryptographic hashing") which
> adds NULL checks before calling these function pointers. Should this
> commit be squashed with 76d771a64b50 to ensure each patch in the
> series is bisectable without introducing crashes?

Yes, confirmed.

I reproduced this on x86_64 with a sleepable BPF syscall program that
calls bpf_crypto_ctx_create() with:
- type = "hash"
- algo = "sha256"
- key_len = 1

That reaches the path where type->setkey/type->ivsize/type->statesize
are used without NULL checks for the hash type, and triggers the NULL
dereference as pointed out.

Below is the reproducer (inlined, no attachment):

--8<--
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <linux/bpf.h>
#include <linux/btf.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <unistd.h>

#ifndef __NR_bpf
#define __NR_bpf 321
#endif

#define LOG_BUF_SIZE (1 << 20)

static int bpf_sys(enum bpf_cmd cmd, union bpf_attr *attr, unsigned int
size) {
	return syscall(__NR_bpf, cmd, attr, size);
}

static size_t btf_type_size(const struct btf_type *t)
{
	__u16 vlen = BTF_INFO_VLEN(t->info);
	__u32 kind = BTF_INFO_KIND(t->info);
	size_t sz = sizeof(*t);

	switch (kind) {
	case BTF_KIND_INT: sz += sizeof(__u32); break;
	case BTF_KIND_ARRAY: sz += sizeof(struct btf_array); break;
	case BTF_KIND_STRUCT:
	case BTF_KIND_UNION: sz += (size_t)vlen * sizeof(struct
	btf_member); break; case BTF_KIND_ENUM: sz += (size_t)vlen *
	sizeof(struct btf_enum); break; case BTF_KIND_FUNC_PROTO: sz +=
	(size_t)vlen * sizeof(struct btf_param); break; case
	BTF_KIND_VAR: sz += sizeof(struct btf_var); break; case
	BTF_KIND_DATASEC: sz += (size_t)vlen * sizeof(struct
	btf_var_secinfo); break; case BTF_KIND_DECL_TAG: sz +=
	sizeof(struct btf_decl_tag); break; case BTF_KIND_ENUM64: sz +=
	(size_t)vlen * sizeof(struct btf_enum64); break; default:
	break; } return sz;
}

static int find_vmlinux_func_btf_id(const char *func_name)
{
	int fd = -1, ret = -1;
	struct stat st;
	unsigned char *blob = NULL;
	struct btf_header *hdr;
	char *types, *strs;
	__u32 off, id;
	ssize_t n;
	size_t got = 0;

	fd = open("/sys/kernel/btf/vmlinux", O_RDONLY);
	if (fd < 0) goto out;
	if (fstat(fd, &st) < 0 || st.st_size <= 0) goto out;

	blob = malloc(st.st_size);
	if (!blob) goto out;

	while (got < (size_t)st.st_size) {
		n = read(fd, blob + got, (size_t)st.st_size - got);
		if (n < 0) {
			if (errno == EINTR) continue;
			goto out;
		}
		if (n == 0) break;
		got += (size_t)n;
	}
	if (got < sizeof(*hdr)) goto out;

	hdr = (struct btf_header *)blob;
	if (hdr->magic != BTF_MAGIC || hdr->version != BTF_VERSION)
	goto out; if ((size_t)hdr->hdr_len + hdr->type_off +
	hdr->type_len > got) goto out; if ((size_t)hdr->hdr_len +
	hdr->str_off + hdr->str_len > got) goto out;

	types = (char *)blob + hdr->hdr_len + hdr->type_off;
	strs = (char *)blob + hdr->hdr_len + hdr->str_off;

	for (off = 0, id = 1; off < hdr->type_len; id++) {
		struct btf_type *t = (struct btf_type *)(types + off);
		const char *name = t->name_off ? (strs + t->name_off) :
	""; size_t sz = btf_type_size(t);

		if (sz == 0 || off + sz > hdr->type_len) goto out;
		if (BTF_INFO_KIND(t->info) == BTF_KIND_FUNC &&
		strcmp(name, func_name) == 0) { ret = (int)id;
			goto out;
		}
		off += sz;
	}

out:
	free(blob);
	if (fd >= 0) close(fd);
	return ret;
}

int main(void)
{
	int create_id =
find_vmlinux_func_btf_id("bpf_crypto_ctx_create"); int release_id =
find_vmlinux_func_btf_id("bpf_crypto_ctx_release"); if (create_id <= 0
|| release_id <= 0) { fprintf(stderr, "failed resolving BTF IDs:
create=%d release=%d\n", create_id, release_id); return 1;
	}

	enum { PARAMS_BASE = 424, ERR_BASE = 16, PARAMS_SIZE = 408 };

	struct bpf_insn insn[128];
	int pc = 0, off;

	for (off = -8; off >= -424; off -= 8)
		insn[pc++] = (struct bpf_insn){
			.code = BPF_ST | BPF_MEM | BPF_DW,
			.dst_reg = BPF_REG_10,
			.off = off,
			.imm = 0,
		};

	insn[pc++] = (struct bpf_insn){ .code = BPF_ST | BPF_MEM |
	BPF_W, .dst_reg = BPF_REG_10, .off = -PARAMS_BASE + 0, .imm =
	0x68736168 }; insn[pc++] = (struct bpf_insn){ .code = BPF_ST |
	BPF_MEM | BPF_W, .dst_reg = BPF_REG_10, .off = -PARAMS_BASE +
	16, .imm = 0x32616873 }; insn[pc++] = (struct bpf_insn){ .code
	= BPF_ST | BPF_MEM | BPF_W, .dst_reg = BPF_REG_10, .off =
	-PARAMS_BASE + 20, .imm = 0x00003635 }; insn[pc++] = (struct
	bpf_insn){ .code = BPF_ST | BPF_MEM | BPF_B, .dst_reg =
	BPF_REG_10, .off = -PARAMS_BASE + 144, .imm = 0x11 };
	insn[pc++] = (struct bpf_insn){ .code = BPF_ST | BPF_MEM |
	BPF_W, .dst_reg = BPF_REG_10, .off = -PARAMS_BASE + 400, .imm =
	1 };

	insn[pc++] = (struct bpf_insn){ .code = BPF_ALU64 | BPF_MOV |
	BPF_X, .dst_reg = BPF_REG_1, .src_reg = BPF_REG_10 };
	insn[pc++] = (struct bpf_insn){ .code = BPF_ALU64 | BPF_ADD |
	BPF_K, .dst_reg = BPF_REG_1, .imm = -PARAMS_BASE }; insn[pc++]
	= (struct bpf_insn){ .code = BPF_ALU64 | BPF_MOV | BPF_K,
	.dst_reg = BPF_REG_2, .imm = PARAMS_SIZE }; insn[pc++] =
	(struct bpf_insn){ .code = BPF_ALU64 | BPF_MOV | BPF_X,
	.dst_reg = BPF_REG_3, .src_reg = BPF_REG_10 }; insn[pc++] =
	(struct bpf_insn){ .code = BPF_ALU64 | BPF_ADD | BPF_K,
	.dst_reg = BPF_REG_3, .imm = -ERR_BASE };

	insn[pc++] = (struct bpf_insn){ .code = BPF_JMP | BPF_CALL,
	.src_reg = BPF_PSEUDO_KFUNC_CALL, .imm = create_id };

	insn[pc++] = (struct bpf_insn){ .code = BPF_JMP | BPF_JEQ |
	BPF_K, .dst_reg = BPF_REG_0, .off = 2, .imm = 0 }; insn[pc++] =
	(struct bpf_insn){ .code = BPF_ALU64 | BPF_MOV | BPF_X,
	.dst_reg = BPF_REG_1, .src_reg = BPF_REG_0 }; insn[pc++] =
	(struct bpf_insn){ .code = BPF_JMP | BPF_CALL, .src_reg =
	BPF_PSEUDO_KFUNC_CALL, .imm = release_id };

	insn[pc++] = (struct bpf_insn){ .code = BPF_ALU64 | BPF_MOV |
	BPF_K, .dst_reg = BPF_REG_0, .imm = 0 }; insn[pc++] = (struct
	bpf_insn){ .code = BPF_JMP | BPF_EXIT };

	char logbuf[LOG_BUF_SIZE];
	char lic[] = "GPL";
	union bpf_attr attr;
	memset(logbuf, 0, sizeof(logbuf));
	memset(&attr, 0, sizeof(attr));

	attr.prog_type = BPF_PROG_TYPE_SYSCALL;
	attr.prog_flags = BPF_F_SLEEPABLE;
	attr.insn_cnt = pc;
	attr.insns = (uint64_t)(uintptr_t)insn;
	attr.license = (uint64_t)(uintptr_t)lic;
	attr.log_level = 1;
	attr.log_size = sizeof(logbuf);
	attr.log_buf = (uint64_t)(uintptr_t)logbuf;
	memcpy(attr.prog_name, "poc_hash_bug", 12);

	int prog_fd = bpf_sys(BPF_PROG_LOAD, &attr, sizeof(attr));
	if (prog_fd < 0) {
		fprintf(stderr, "BPF_PROG_LOAD failed: errno=%d
	(%s)\n", errno, strerror(errno)); fprintf(stderr, "Verifier
	log:\n%s\n", logbuf); return 2;
	}

	union bpf_attr run;
	memset(&run, 0, sizeof(run));
	run.test.prog_fd = prog_fd;
	(void)bpf_sys(BPF_PROG_TEST_RUN, &run, sizeof(run));
	close(prog_fd);
	return 0;
}
--8<--

I agree this should be fixed at the patch granularity level. I will
squash the NULL-check fix into patch 2 in v6 so each patch remains
bisectable and does not introduce a crash window.

As this issue is already publicly discussed on bpf-next and raised by
CI review, replying on-list is appropriate.

Signed-off-by: XIAO WU <shawdoxwu@gmail.com>

Thanks
