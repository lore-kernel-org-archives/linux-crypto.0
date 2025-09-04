Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701EE21638D;
	Thu,  4 Sep 2025 15:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001321; cv=none; b=Hidupmy7lxRS5p6kcNfWQBJ7mkNMEhPhg27Iyi/YsrLObeitC2S8RRygmbaoWUNsykez1EpLpVyg4YOpamna9wwAdT+dd9kbQ9TMP+Gby1yTgq1fX+IuX4kiZl8O1V50bVyMeD2VUZESvejuLiwIkOz79nJSFdHiI/6rpBhJJHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001321; c=relaxed/simple;
	bh=aznA3Ed6Fij5AX0A+tNv6Te2jms9kSiQDiaAoygnu4k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rVLmHwV/WNz9ncpQlIrrru2s/f5iuO+I3RX8YTFhndI8HUKCmRpCvD/9R4Q5ZQU6yORzVYpPAanBoDFhBA+B5Xd6WYiNnSD57JwlZcuy5j0JHgJ7PTubtp5Jd6qRBQiEHVidGe9phOq+hpxdHD8fNXaDrTimZVVqj3ZlVBZSWPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CYtesHhQ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CYtesHhQ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fjed3006289;
	Thu, 4 Sep 2025 15:55:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=5IksDINEeY8fB4YstZjb/lcmsy9a9
	Z/FQO0giENrwvs=; b=CYtesHhQsb/eeluetQ8HQhJdBNN2HriSEifbgkkampexr
	S7KgrB4MTq15pdQxSmCVWvmMgoWYrJbp3pq1OnHXFa/enkYBPdW8TlJgdU5uGrNl
	1I386ujU7qOZcDemFIN6sLAyMTtRHunttlHFWXFjnhGMuNI+9wWVRI4Q12UW3DjP
	9ZZLzsuKGaKcFyQdZ5qUZRQQkY5JZYlgJB6y2w6j2352xZLFH71dVoRmtUnZMV/h
	E5txWkC0Uax5Rrtw6p5gIjWxLcLfGyOHQCfHcR7bcuN+rTQh1iZU/jTOJCaOnt9e
	sffS7ROVdLiOxooWmUUXEdU+SqGGvlYMnmIo2qx3g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd01x6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FG6vV040116;
	Thu, 4 Sep 2025 15:55:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtkf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:00 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx4k000707;
	Thu, 4 Sep 2025 15:54:59 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-1;
	Thu, 04 Sep 2025 15:54:59 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [RFC] crypto: support for a standalone FIPS 140 module
Date: Thu,  4 Sep 2025 17:50:32 +0200
Message-Id: <20250904155216.460962-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040156
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX0kl/Fef2e0GD
 22i7bRf6GFp2dQ4RqeMeC9SIuD3nZoPS0PFbHLhifj6cR3cSO9VobaR1KzXwwejCPLFjiA26BYG
 EomoSBvdTFSYuSVEG5kzBU7NMdMJ7VBYtfPZh4c8c8QOqfs9xFHFabLysgxNd9y4rfbQwyJuI6p
 7mGtgiU2cmuEf4na3p+qO63IcvsrO8acGkHPEpTUAa5trWOzqXQBfQPqN6Lq5yud1HZ20a4N8VC
 GN5t7A1pJhg4cX4TZX8++Saioyi8ZpI4ICCPTSTiF877ukiE13zxyz/f/UQdk/6Jr2T0IMycr7Z
 hUOU6d/dW6EYRNhf9xtt+HljelPWaGxDjVJb2VARb4BbZz6XDmCVP9wtBJ5dSV6rWWw1J88c79X
 +6Sw/fcKhxkITqo2WU112PRd7Qd6ew==
X-Proofpoint-GUID: g4jWfzizap6I7C_V2HeyBlV9OCYfKdhT
X-Proofpoint-ORIG-GUID: g4jWfzizap6I7C_V2HeyBlV9OCYfKdhT
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b655 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=MVnHpdygcmFajYWqugQA:9
 cc=ntf awl=host:12068

Hi all,

This patch set adds support for building and loading a standalone FIPS
140 module. This is mostly useful for distributions that want to certify
their kernel's crypto code with NIST. Please see
Documentation/crypto/fips140.rst for more details.

I apologize for the large patch series. I could have squashed
it down to fewer commits but it would really make it harder to see
what's going on.

A note on terminology, since this is a source of confusion: a "FIPS
module" in NIST jargon means the binary blob submitted for FIPS
certification (i.e. typically the entire kernel), and has nothing to do
with kernel modules per se. However, in this proposal, the "FIPS module"
does actually also correspond to a singular kernel module, fips140.ko.

FIPS certifications validate a specific binary, not the source code used
to build it. Currently, most if not all distros submit the entire kernel
for certification, and the binary certification is invalidated if any
part of the kernel changes -- even if those changes are unrelated to
cryptography. Fortunately the FIPS process allows for vendors to "attest"
that the changes don't affect cryptographic operations within the kernel,
but the fact remains that the binary certification is technically
obsolete as soon as any bug or security fix is applied to the kernel.

This proposal attempts to separate the crypto part of the FIPS module
from the rest of the kernel. This allows us to freeze the binary FIPS
module and reuse it in newer versions of the kernel without invalidating
the certificate on the FIPS module.

There are a few different challenges in such a separation:

- The kernel has no stable internal API and the mere idea of having
  stable internal APIs (or ABIs) has already been strongly rebuked.

  In practice, most kernel APIs tend to be relatively stable over
  multiple years and especially within stable releases, and most
  general-purpose distros do freeze at least parts of the kernel API
  for the lifetime of their product in order to support third party
  (out-of-tree) modules.

- FIPS mandates that certified crypto code must not be used before
  it has been self-tested, i.e. the FIPS module needs to run a set of
  self-tests before it can be used by the rest of the kernel. Combined
  with the fact that the kernel uses crypto code during boot (e.g. for
  TPMs) and during module loading, this presents a chicken-and-egg
  problem where crypto code cannot be used before it's loaded, but it
  cannot be loaded without being used.

- The crypto API provides a way to combine basic algorithms into
  composite algorithms, e.g. hmac + sha256 => hmac(sha256). In this
  case, ALL of the code involved must be part of the FIPS module.

- Built-in kernel code (e.g. vmlinux code) may call the crypto API,
  which means it cannot simply be built as a regular kernel module,
  since you would get linker errors if the crypto API functions are
  defined in modules.

This patch set provides a solution to all of the above challenges:

- We do not require the upstream kernel to maintain an internal stable
  API. The API can change freely and the burden is entirely on
  individual distros to ensure they don't change APIs in their own
  kernels between two versions that are supposed to use the same binary
  FIPS module.

- We build the individual crypto algorithms AND the entire kernel
  crypto API into a single binary kernel module, fips140.ko. Using C
  macros and the "static calls" mechanism, every crypto API entry point
  is turned into a static call so that the entire crypto API can be
  swapped out at runtime with the implementation from the FIPS module.

  This solves the problem of crypto templates and composite algorithms,
  since all the code necessary to use a composite algorithm will exist
  within the FIPS module.

  This also solves the problem of built-in code calling functions
  provided by a module, since the callers are linked with the non-FIPS
  versions of the functions by default, thus avoiding linker errors.

- fips140.ko is embedded into vmlinux as a byte array and loaded during
  early boot to ensure all cryptographic operations are performed by
  code from the FIPS module -- this also obviates the need to perform
  module signature verification on fips140.ko, as everything in vmlinux
  is already trusted by definition.

Moving on to the actual implementation, it should be noted that the
kernel already has a notion of FIPS compliance -- it has infrastructure
in place to annotate which algorithms are approved or allowed by NIST, for
example, and to ensure all implementations are self-tested before use. We
make use of this existing infrastructure to a large degree.

Here is an overview of the changes we make:

- We add a new top-level directory, fips140/, which mirrors the
  structure of the kernel itself: fips140/crypto/, fips/lib/crypto,
  etc. All of the source files here are symlinks to the respective
  files in the kernel tree (e.g. fips140/crypto/rng.c is a symlink to
  crypto/rng.c).

  This way we can build the code twice without having to maintain a
  separate copy of the source. Again, it will be the responsibility of
  individual distros to ensure compatibility between their binary FIPS
  module and the rest of the kernel.

- We add a new header, include/crypto/api.h, which defines a number of
  C macro wrappers to annotate the part of the kernel crypto API that
  is be considered part of the FIPS module.

  A lot of the code under crypto/ needs to be converted to use these
  macros. For example, instead of:

    // in .h
    int crypto_foo(const char *name);

    // in .c
    int crypto_foo(const char *name)
    {
        ...
    }
    EXPORT_SYMBOL_GPL(crypto_foo);

  You need to write:

    // in .h
    DECLARE_CRYPTO_API(crypto_foo, int, (const char *name), (name));

    // in .c
    int CRYPTO_API(crypto_foo)(const char *name)
    {
        ...
    }
    DEFINE_CRYPTO_API(crypto_foo);

  This is unfortunate as it generates a lot of churn and makes the code
  harder to read. We've tried to make it as lightweight as possible.

  On kernels configured to use a standalone FIPS module, these
  definitions will do the work of declaring and defining static call
  keys for every function. Otherwise, they will just fall back to their
  original forms (plain functions + exports).

  There are a few more helpers, for example module_init(fn) needs to be
  written as crypto_module_init(fn). We could have chosen to #undef and
  redefine module_init() so that no source-level change would be
  necessary, but we considered that being explicit about what is going
  on is actually clearer (less confusing) in the end, even if it
  results in more patches/changes.

- We add a new helper function to the kernel's module loader,
  load_module_mem(), which can load a kernel module (i.e. fips140.ko)
  from a byte array.

- A new file, crypto/fips140-loader.c, which is a fairly thin wrapper
  around load_module_mem(), only built when the kernel is compiled with
  standalone FIPS module support.

- We also change the module loader to automatically update the static
  calls of the crypto API (the static call keys are stored in the
  __crypto_api_keys section of the module).

- The module and its HMAC are stored in two new sections in vmlinux,
  __fips140_module and __fips140_digest. (The HMAC/digest is needed for
  the FIPS module's own integrity test -- another FIPS requirement.)
  This also makes it easy to extract the binary FIPS module from a
  vmlinux file for offline/external verification if necessary.

- We change the crypto API slightly to track which templates and
  algorithms are provided by the FIPS module. This ensures e.g. that
  no other kernel module can register their own implementation of AES
  and trick the kernel into supplying it as a FIPS approved and
  certified implementation. Each 'struct crypto_alg' carries a new
  flag which signals whether it is provided by the FIPS module or not.

To build this, you need to ensure CONFIG_CRYPTO_FIPS140_EXTMOD is
enabled and then run:

  # prepare for building out-of-tree module
  make modules_prepare

  # build fips140.ko as an out-of-tree module
  make M=fips140 KBUILD_MODPOST_WARN=1

  # generate fips140.hmac
  cp fips140/fips140.ko crypto/
  openssl dgst -sha256 -hmac "$(awk -F'"' '/^CONFIG_CRYPTO_FIPS140_HMAC_KEY=/{print $2}' .config)" -binary -out crypto/fips140.hmac crypto/fips140.ko

  # build the rest of the kernel
  make

This patch set borrows a small amount of code from Android's FIPS
module and was also partly inspired by prototype code shared by Amazon;
attributions are marked in the individual patches.

Let me also thank all my colleagues who contributed in some way to the
current version of this patch set:

- Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
- Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
- Sherry Yang <sherry.yang@oracle.com>
- Sriharsha Yadagudde <sriharsha.devdas@oracle.com>
- Ilya Okomin <ilya.okomin@oracle.com>
- John Haxby <john.haxby@oracle.com>
- Jose Marchesi <jose.marchesi@oracle.com>
- Hunter Barton <hunter.barton@oracle.com>
- Aleksandr Burmashev <alexander.burmashev@oracle.com>
- Todd Vierling <todd.vierling@oracle.com>
- Chuck Anderson <chuck.anderson@oracle.com>
- Stephan Mueller <smueller@chronox.de>

I have pushed a branch here which I will maintain going forwards:

  https://git.kernel.org/pub/scm/linux/kernel/git/vegard/linux-fips140.git/log/?h=fips140

Some of these patches are general improvements that could be useful
even without merging the whole branch, e.g. some of the testmgr
changes. I've put these at the start of the branch so they can be
applied independently -- depending on feedback here, I may send them
out as independent patches as well.


Vegard

--

Vegard Nossum (104):
  params: use arch_initcall to initialize params sysfs earlier
  Revert "Revert "crypto: shash - avoid comparing pointers to exported
    functions under CFI""
  crypto/jitterentropy: remove linux/fips.h include
  crypto: api - Disallow identical template names
  crypto: hide crypto_default_rng variable
  KEYS: trusted: eat -ENOENT from the crypto API
  testmgr: standardize alg/driver output in logs
  arch/x86/boot/string.h: override memmove()/strlen()
  certs/system_keyring: export restrict_link_by_builtin_*trusted
  crypto/testmgr: make fips_allowed a bit set
  crypto/testmgr: mark non-crypto algorithms
  crypto/algapi: don't init algapi in fips mode
  crypto/algapi.c: disable crypto_check_module_sig() for FIPS module
  crypto/testmgr: add helper to alg_test()
  crypto: pass struct crypto_alg directly to alg_test()
  crypto: alg - add CRYPTO_ALG_FIPS_PROVIDED flag
  crypto: testmgr: check that we got the expected alg
  crypto: make sure crypto_alg_tested() finds the correct algorithm
  module: add load_module_mem() helper
  module: add a mechanism for pluggable crypto APIs
  crypto: fips140: include crypto/api.h in a few places
  crypto: fips140: convert lib/crypto/aes.c to using crypto API wrappers
  crypto: fips140: convert lib/crypto/aesgcm.c to using crypto API
    wrappers
  crypto: fips140: convert lib/crypto/gf128mul.c to using crypto API
    wrappers
  crypto: fips140: convert lib/crypto/memneq.c to using crypto API
    wrappers
  crypto: fips140: convert lib/crypto/sha256.c to using crypto API
    wrappers
  crypto: fips140: convert lib/crypto/sha512.c to using crypto API
    wrappers
  crypto: fips140: convert lib/crypto/utils.c to using crypto API
    wrappers
  crypto: fips140: convert crypto/aead.c to using crypto API wrappers
  crypto: fips140: convert crypto/aes_generic.c to using crypto API
    wrappers
  crypto: fips140: convert crypto/ahash.c to using crypto API wrappers
  crypto: fips140: convert crypto/akcipher.c to using crypto API
    wrappers
  crypto: fips140: convert crypto/algapi.c to using crypto API wrappers
  crypto: fips140: convert crypto/algboss.c to using crypto API wrappers
  crypto: fips140: convert crypto/api.c to using crypto API wrappers
  crypto: fips140: convert crypto/authenc.c to using crypto API wrappers
  crypto: fips140: convert crypto/authencesn.c to using crypto API
    wrappers
  crypto: fips140: convert crypto/cbc.c to using crypto API wrappers
  crypto: fips140: convert crypto/ccm.c to using crypto API wrappers
  crypto: fips140: convert crypto/cipher.c to using crypto API wrappers
  crypto: fips140: convert crypto/cmac.c to using crypto API wrappers
  crypto: fips140: convert crypto/cryptd.c to using crypto API wrappers
  crypto: fips140: convert crypto/ctr.c to using crypto API wrappers
  crypto: fips140: convert crypto/dh.c to using crypto API wrappers
  crypto: fips140: convert crypto/dh_helper.c to using crypto API
    wrappers
  crypto: fips140: convert crypto/drbg.c to using crypto API wrappers
  crypto: fips140: convert crypto/ecb.c to using crypto API wrappers
  crypto: fips140: convert crypto/ecc.c to using crypto API wrappers
  crypto: fips140: convert crypto/ecdh.c to using crypto API wrappers
  crypto: fips140: convert crypto/ecdh_helper.c to using crypto API
    wrappers
  crypto: fips140: convert crypto/ecdsa.c to using crypto API wrappers
  crypto: fips140: convert crypto/echainiv.c to using crypto API
    wrappers
  crypto: fips140: convert crypto/essiv.c to using crypto API wrappers
  crypto: fips140: convert crypto/gcm.c to using crypto API wrappers
  crypto: fips140: convert crypto/geniv.c to using crypto API wrappers
  crypto: fips140: convert crypto/ghash-generic.c to using crypto API
    wrappers
  crypto: fips140: convert crypto/hmac.c to using crypto API wrappers
  crypto: fips140: convert crypto/jitterentropy-kcapi.c to using crypto
    API wrappers
  crypto: fips140: convert crypto/kpp.c to using crypto API wrappers
  crypto: fips140: convert crypto/lskcipher.c to using crypto API
    wrappers
  crypto: fips140: convert crypto/pcrypt.c to using crypto API wrappers
  crypto: fips140: convert crypto/rng.c to using crypto API wrappers
  crypto: fips140: convert crypto/rsa.c to using crypto API wrappers
  crypto: fips140: convert crypto/rsa_helper.c to using crypto API
    wrappers
  crypto: fips140: convert crypto/seqiv.c to using crypto API wrappers
  crypto: fips140: convert crypto/sha1.c to using crypto API wrappers
  crypto: fips140: convert crypto/sha256.c to using crypto API wrappers
  crypto: fips140: convert crypto/sha3_generic.c to using crypto API
    wrappers
  crypto: fips140: convert crypto/sha512.c to using crypto API wrappers
  crypto: fips140: convert crypto/shash.c to using crypto API wrappers
  crypto: fips140: convert crypto/sig.c to using crypto API wrappers
  crypto: fips140: convert crypto/simd.c to using crypto API wrappers
  crypto: fips140: convert crypto/skcipher.c to using crypto API
    wrappers
  crypto: fips140: convert crypto/tcrypt.c to using crypto API wrappers
  crypto: fips140: convert crypto/testmgr.c to using crypto API wrappers
  crypto: fips140: convert crypto/xts.c to using crypto API wrappers
  crypto: fips140: convert crypto/asymmetric_keys/asymmetric_type.c to
    using crypto API wrappers
  crypto: fips140: convert crypto/asymmetric_keys/pkcs7_key_type.c to
    using crypto API wrappers
  crypto: fips140: convert crypto/asymmetric_keys/pkcs7_parser.c to
    using crypto API wrappers
  crypto: fips140: convert crypto/asymmetric_keys/pkcs7_trust.c to using
    crypto API wrappers
  crypto: fips140: convert crypto/asymmetric_keys/pkcs7_verify.c to
    using crypto API wrappers
  crypto: fips140: convert crypto/asymmetric_keys/pkcs8_parser.c to
    using crypto API wrappers
  crypto: fips140: convert crypto/asymmetric_keys/public_key.c to using
    crypto API wrappers
  crypto: fips140: convert crypto/asymmetric_keys/selftest.c to using
    crypto API wrappers
  crypto: fips140: convert crypto/asymmetric_keys/signature.c to using
    crypto API wrappers
  crypto: fips140: convert crypto/asymmetric_keys/x509_cert_parser.c to
    using crypto API wrappers
  crypto: fips140: convert crypto/asymmetric_keys/x509_loader.c to using
    crypto API wrappers
  crypto: fips140: convert crypto/asymmetric_keys/x509_public_key.c to
    using crypto API wrappers
  crypto: fips140: manual fixups for include/keys/asymmetric-type.h
  crypto: fips140: manual fixups for include/crypto/sha2.h
  crypto: fips140: manual fixups for include/crypto/public_key.h
  crypto: fips140: manual fixups for include/crypto/aes.h
  crypto: fips140: manual fixups for crypto/internal.h
  crypto: fips140: manual fixups for include/crypto/internal/ecc.h
  crypto: fips140: manual fixups for include/crypto/internal/rsa.h
  crypto: fips140: manual fixups for include/crypto/aes.h
  crypto: fips140: manual fixups for lib/crypto/sha256.c
  crypto: fips140: manual fixups for lib/crypto/sha512.c
  crypto: fips140: add symlinks to kernel sources
  crypto: fips140: add standalone FIPS 140 module
  crypto: fips140: add FIPS 140 module loader
  scripts/extract-fips140: new script
  Documentation/crypto: add fips140.rst
  MAINTAINERS: add myself as FIPS140 standalone module maintainer

 Documentation/crypto/fips140.rst              | 231 ++++++
 Documentation/crypto/index.rst                |   1 +
 MAINTAINERS                                   |  10 +
 arch/arm64/kernel/vmlinux.lds.S               |   1 +
 arch/x86/boot/string.h                        |   4 +
 certs/system_keyring.c                        |   2 +
 crypto/Kconfig                                |   2 +
 crypto/Makefile                               |  24 +
 crypto/aead.c                                 |  48 +-
 crypto/aes_generic.c                          |   8 +-
 crypto/ahash.c                                | 108 +--
 crypto/akcipher.c                             |  28 +-
 crypto/algapi.c                               | 193 +++--
 crypto/algboss.c                              |  36 +-
 crypto/api.c                                  |  76 +-
 crypto/asymmetric_keys/asymmetric_type.c      |  30 +-
 crypto/asymmetric_keys/pkcs7_key_type.c       |   5 +-
 crypto/asymmetric_keys/pkcs7_parser.c         |  12 +-
 crypto/asymmetric_keys/pkcs7_trust.c          |   4 +-
 crypto/asymmetric_keys/pkcs7_verify.c         |   8 +-
 crypto/asymmetric_keys/pkcs8_parser.c         |   4 +-
 crypto/asymmetric_keys/public_key.c           |   8 +-
 crypto/asymmetric_keys/selftest.c             |   2 +-
 crypto/asymmetric_keys/signature.c            |  12 +-
 crypto/asymmetric_keys/x509_cert_parser.c     |  12 +-
 crypto/asymmetric_keys/x509_loader.c          |   4 +-
 crypto/asymmetric_keys/x509_parser.h          |  15 +-
 crypto/asymmetric_keys/x509_public_key.c      |   4 +-
 crypto/authenc.c                              |   8 +-
 crypto/authencesn.c                           |   4 +-
 crypto/cbc.c                                  |   4 +-
 crypto/ccm.c                                  |   4 +-
 crypto/cipher.c                               |  16 +-
 crypto/cmac.c                                 |   4 +-
 crypto/cryptd.c                               |  58 +-
 crypto/ctr.c                                  |   4 +-
 crypto/dh.c                                   |  12 +-
 crypto/dh_helper.c                            |  12 +-
 crypto/drbg.c                                 |   4 +-
 crypto/ecb.c                                  |   4 +-
 crypto/ecc.c                                  |  92 +--
 crypto/ecdh.c                                 |   4 +-
 crypto/ecdh_helper.c                          |  12 +-
 crypto/ecdsa.c                                |   4 +-
 crypto/echainiv.c                             |   4 +-
 crypto/essiv.c                                |   4 +-
 crypto/fips140-api.c                          | 726 ++++++++++++++++++
 crypto/fips140-loader.c                       |  96 +++
 crypto/gcm.c                                  |   4 +-
 crypto/geniv.c                                |  20 +-
 crypto/ghash-generic.c                        |   4 +-
 crypto/hmac.c                                 |   4 +-
 crypto/internal.h                             | 103 ++-
 crypto/jitterentropy-kcapi.c                  |   4 +-
 crypto/jitterentropy.c                        |   3 +-
 crypto/kpp.c                                  |  24 +-
 crypto/lskcipher.c                            |  44 +-
 crypto/pcrypt.c                               |   4 +-
 crypto/rng.c                                  |  41 +-
 crypto/rsa.c                                  |   4 +-
 crypto/rsa_helper.c                           |   8 +-
 crypto/seqiv.c                                |   4 +-
 crypto/sha1.c                                 |   4 +-
 crypto/sha256.c                               |   4 +-
 crypto/sha3_generic.c                         |   8 +-
 crypto/sha512.c                               |   4 +-
 crypto/shash.c                                |  94 ++-
 crypto/sig.c                                  |  20 +-
 crypto/simd.c                                 |  24 +-
 crypto/skcipher.c                             |  72 +-
 crypto/tcrypt.c                               |  22 +-
 crypto/testmgr.c                              | 419 ++++++----
 crypto/xts.c                                  |   4 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c   |   8 +-
 .../crypto/intel/keembay/keembay-ocs-ecc.c    |  14 +-
 fips140/Kconfig                               | 174 +++++
 fips140/Makefile                              | 183 +++++
 fips140/crypto/aead.c                         |   1 +
 fips140/crypto/aes_generic.c                  |   1 +
 fips140/crypto/ahash.c                        |   1 +
 fips140/crypto/akcipher.c                     |   1 +
 fips140/crypto/algapi.c                       |   1 +
 fips140/crypto/algboss.c                      |   1 +
 fips140/crypto/api.c                          |   1 +
 .../crypto/asymmetric_keys/asymmetric_keys.h  |   1 +
 .../crypto/asymmetric_keys/asymmetric_type.c  |   1 +
 .../crypto/asymmetric_keys/mscode_parser.c    |   1 +
 fips140/crypto/asymmetric_keys/pkcs7.asn1     |   1 +
 .../crypto/asymmetric_keys/pkcs7_key_type.c   |   1 +
 fips140/crypto/asymmetric_keys/pkcs7_parser.c |   1 +
 fips140/crypto/asymmetric_keys/pkcs7_parser.h |   1 +
 fips140/crypto/asymmetric_keys/pkcs7_trust.c  |   1 +
 fips140/crypto/asymmetric_keys/pkcs7_verify.c |   1 +
 fips140/crypto/asymmetric_keys/pkcs8.asn1     |   1 +
 fips140/crypto/asymmetric_keys/pkcs8_parser.c |   1 +
 fips140/crypto/asymmetric_keys/public_key.c   |   1 +
 fips140/crypto/asymmetric_keys/restrict.c     |   1 +
 fips140/crypto/asymmetric_keys/selftest.c     |   1 +
 fips140/crypto/asymmetric_keys/selftest.h     |   1 +
 .../crypto/asymmetric_keys/selftest_ecdsa.c   |   1 +
 fips140/crypto/asymmetric_keys/selftest_rsa.c |   1 +
 fips140/crypto/asymmetric_keys/signature.c    |   1 +
 .../crypto/asymmetric_keys/verify_pefile.c    |   1 +
 .../crypto/asymmetric_keys/verify_pefile.h    |   1 +
 fips140/crypto/asymmetric_keys/x509.asn1      |   1 +
 fips140/crypto/asymmetric_keys/x509_akid.asn1 |   1 +
 .../crypto/asymmetric_keys/x509_cert_parser.c |   1 +
 fips140/crypto/asymmetric_keys/x509_loader.c  |   1 +
 fips140/crypto/asymmetric_keys/x509_parser.h  |   1 +
 .../crypto/asymmetric_keys/x509_public_key.c  |   1 +
 fips140/crypto/authenc.c                      |   1 +
 fips140/crypto/authencesn.c                   |   1 +
 fips140/crypto/cbc.c                          |   1 +
 fips140/crypto/ccm.c                          |   1 +
 fips140/crypto/cipher.c                       |   1 +
 fips140/crypto/cmac.c                         |   1 +
 fips140/crypto/cryptd.c                       |   1 +
 fips140/crypto/ctr.c                          |   1 +
 fips140/crypto/dh.c                           |   1 +
 fips140/crypto/dh_helper.c                    |   1 +
 fips140/crypto/drbg.c                         |   1 +
 fips140/crypto/ecb.c                          |   1 +
 fips140/crypto/ecc.c                          |   1 +
 fips140/crypto/ecc_curve_defs.h               |   1 +
 fips140/crypto/ecdh.c                         |   1 +
 fips140/crypto/ecdh_helper.c                  |   1 +
 fips140/crypto/ecdsa-p1363.c                  |   1 +
 fips140/crypto/ecdsa-x962.c                   |   1 +
 fips140/crypto/ecdsa.c                        |   1 +
 fips140/crypto/ecdsasignature.asn1            |   1 +
 fips140/crypto/echainiv.c                     |   1 +
 fips140/crypto/essiv.c                        |   1 +
 fips140/crypto/gcm.c                          |   1 +
 fips140/crypto/geniv.c                        |   1 +
 fips140/crypto/ghash-generic.c                |   1 +
 fips140/crypto/hash.h                         |   1 +
 fips140/crypto/hmac.c                         |   1 +
 fips140/crypto/internal.h                     |   1 +
 fips140/crypto/jitterentropy-kcapi.c          |   1 +
 fips140/crypto/jitterentropy.c                |   1 +
 fips140/crypto/jitterentropy.h                |   1 +
 fips140/crypto/kpp.c                          |   1 +
 fips140/crypto/lskcipher.c                    |   1 +
 fips140/crypto/pcrypt.c                       |   1 +
 fips140/crypto/proc.c                         |   1 +
 fips140/crypto/rng.c                          |   1 +
 fips140/crypto/rsa-pkcs1pad.c                 |   1 +
 fips140/crypto/rsa.c                          |   1 +
 fips140/crypto/rsa_helper.c                   |   1 +
 fips140/crypto/rsaprivkey.asn1                |   1 +
 fips140/crypto/rsapubkey.asn1                 |   1 +
 fips140/crypto/rsassa-pkcs1.c                 |   1 +
 fips140/crypto/seqiv.c                        |   1 +
 fips140/crypto/sha256.c                       |   1 +
 fips140/crypto/sha3_generic.c                 |   1 +
 fips140/crypto/sha512.c                       |   1 +
 fips140/crypto/shash.c                        |   1 +
 fips140/crypto/sig.c                          |   1 +
 fips140/crypto/simd.c                         |   1 +
 fips140/crypto/skcipher.c                     |   1 +
 fips140/crypto/skcipher.h                     |   1 +
 fips140/crypto/tcrypt.c                       |   1 +
 fips140/crypto/tcrypt.h                       |   1 +
 fips140/crypto/testmgr.c                      |   1 +
 fips140/crypto/testmgr.h                      |   1 +
 fips140/crypto/xts.c                          |   1 +
 fips140/fips140-glue.c                        | 216 ++++++
 fips140/fips140.lds                           |   9 +
 fips140/lib/crypto/aes.c                      |   1 +
 fips140/lib/crypto/aesgcm.c                   |   1 +
 fips140/lib/crypto/gf128mul.c                 |   1 +
 fips140/lib/crypto/memneq.c                   |   1 +
 fips140/lib/crypto/sha256.c                   |   1 +
 fips140/lib/crypto/sha512.c                   |   1 +
 fips140/lib/crypto/utils.c                    |   1 +
 include/asm-generic/vmlinux.lds.h             |  38 +-
 include/crypto/aead.h                         |  26 +-
 include/crypto/aes.h                          |  39 +-
 include/crypto/akcipher.h                     |  18 +-
 include/crypto/algapi.h                       | 125 ++-
 include/crypto/api.h                          | 154 ++++
 include/crypto/authenc.h                      |   6 +-
 include/crypto/cryptd.h                       |  56 +-
 include/crypto/dh.h                           |  14 +-
 include/crypto/ecc_curve.h                    |   9 +-
 include/crypto/ecdh.h                         |  14 +-
 include/crypto/gcm.h                          |  19 +-
 include/crypto/gf128mul.h                     |  29 +-
 include/crypto/hash.h                         |  97 ++-
 include/crypto/internal/aead.h                |  28 +-
 include/crypto/internal/akcipher.h            |  21 +-
 include/crypto/internal/cipher.h              |  20 +-
 include/crypto/internal/ecc.h                 | 101 ++-
 include/crypto/internal/geniv.h               |  14 +-
 include/crypto/internal/hash.h                | 120 ++-
 include/crypto/internal/kpp.h                 |  21 +-
 include/crypto/internal/rng.h                 |  21 +-
 include/crypto/internal/rsa.h                 |  22 +-
 include/crypto/internal/sig.h                 |  20 +-
 include/crypto/internal/simd.h                |  32 +-
 include/crypto/internal/skcipher.h            |  89 ++-
 include/crypto/kpp.h                          |   9 +-
 include/crypto/pkcs7.h                        |  31 +-
 include/crypto/public_key.h                   |  32 +-
 include/crypto/rng.h                          |  20 +-
 include/crypto/sha2.h                         | 181 +++--
 include/crypto/sha3.h                         |   5 +-
 include/crypto/sig.h                          |   5 +-
 include/crypto/skcipher.h                     |  56 +-
 include/crypto/utils.h                        |   9 +-
 include/keys/asymmetric-parser.h              |   8 +-
 include/keys/asymmetric-type.h                |  39 +-
 include/linux/crypto.h                        |  31 +-
 include/linux/fips.h                          |  17 +
 include/linux/module.h                        |   2 +
 include/uapi/linux/module.h                   |   5 +
 kernel/module/main.c                          | 121 ++-
 kernel/params.c                               |   2 +-
 lib/crypto/aes.c                              |  12 +-
 lib/crypto/aesgcm.c                           |  16 +-
 lib/crypto/gf128mul.c                         |  28 +-
 lib/crypto/memneq.c                           |   4 +-
 lib/crypto/sha256.c                           |  78 +-
 lib/crypto/sha512.c                           |  78 +-
 lib/crypto/utils.c                            |   4 +-
 net/tipc/crypto.c                             |   8 +-
 scripts/extract-fips140                       |  53 ++
 security/keys/trusted-keys/trusted_core.c     |  18 +-
 228 files changed, 4243 insertions(+), 1396 deletions(-)
 create mode 100644 Documentation/crypto/fips140.rst
 create mode 100644 crypto/fips140-api.c
 create mode 100644 crypto/fips140-loader.c
 create mode 100644 fips140/Kconfig
 create mode 100644 fips140/Makefile
 create mode 120000 fips140/crypto/aead.c
 create mode 120000 fips140/crypto/aes_generic.c
 create mode 120000 fips140/crypto/ahash.c
 create mode 120000 fips140/crypto/akcipher.c
 create mode 120000 fips140/crypto/algapi.c
 create mode 120000 fips140/crypto/algboss.c
 create mode 120000 fips140/crypto/api.c
 create mode 120000 fips140/crypto/asymmetric_keys/asymmetric_keys.h
 create mode 120000 fips140/crypto/asymmetric_keys/asymmetric_type.c
 create mode 120000 fips140/crypto/asymmetric_keys/mscode_parser.c
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs7.asn1
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs7_key_type.c
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs7_parser.c
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs7_parser.h
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs7_trust.c
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs7_verify.c
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs8.asn1
 create mode 120000 fips140/crypto/asymmetric_keys/pkcs8_parser.c
 create mode 120000 fips140/crypto/asymmetric_keys/public_key.c
 create mode 120000 fips140/crypto/asymmetric_keys/restrict.c
 create mode 120000 fips140/crypto/asymmetric_keys/selftest.c
 create mode 120000 fips140/crypto/asymmetric_keys/selftest.h
 create mode 120000 fips140/crypto/asymmetric_keys/selftest_ecdsa.c
 create mode 120000 fips140/crypto/asymmetric_keys/selftest_rsa.c
 create mode 120000 fips140/crypto/asymmetric_keys/signature.c
 create mode 120000 fips140/crypto/asymmetric_keys/verify_pefile.c
 create mode 120000 fips140/crypto/asymmetric_keys/verify_pefile.h
 create mode 120000 fips140/crypto/asymmetric_keys/x509.asn1
 create mode 120000 fips140/crypto/asymmetric_keys/x509_akid.asn1
 create mode 120000 fips140/crypto/asymmetric_keys/x509_cert_parser.c
 create mode 120000 fips140/crypto/asymmetric_keys/x509_loader.c
 create mode 120000 fips140/crypto/asymmetric_keys/x509_parser.h
 create mode 120000 fips140/crypto/asymmetric_keys/x509_public_key.c
 create mode 120000 fips140/crypto/authenc.c
 create mode 120000 fips140/crypto/authencesn.c
 create mode 120000 fips140/crypto/cbc.c
 create mode 120000 fips140/crypto/ccm.c
 create mode 120000 fips140/crypto/cipher.c
 create mode 120000 fips140/crypto/cmac.c
 create mode 120000 fips140/crypto/cryptd.c
 create mode 120000 fips140/crypto/ctr.c
 create mode 120000 fips140/crypto/dh.c
 create mode 120000 fips140/crypto/dh_helper.c
 create mode 120000 fips140/crypto/drbg.c
 create mode 120000 fips140/crypto/ecb.c
 create mode 120000 fips140/crypto/ecc.c
 create mode 120000 fips140/crypto/ecc_curve_defs.h
 create mode 120000 fips140/crypto/ecdh.c
 create mode 120000 fips140/crypto/ecdh_helper.c
 create mode 120000 fips140/crypto/ecdsa-p1363.c
 create mode 120000 fips140/crypto/ecdsa-x962.c
 create mode 120000 fips140/crypto/ecdsa.c
 create mode 120000 fips140/crypto/ecdsasignature.asn1
 create mode 120000 fips140/crypto/echainiv.c
 create mode 120000 fips140/crypto/essiv.c
 create mode 120000 fips140/crypto/gcm.c
 create mode 120000 fips140/crypto/geniv.c
 create mode 120000 fips140/crypto/ghash-generic.c
 create mode 120000 fips140/crypto/hash.h
 create mode 120000 fips140/crypto/hmac.c
 create mode 120000 fips140/crypto/internal.h
 create mode 120000 fips140/crypto/jitterentropy-kcapi.c
 create mode 120000 fips140/crypto/jitterentropy.c
 create mode 120000 fips140/crypto/jitterentropy.h
 create mode 120000 fips140/crypto/kpp.c
 create mode 120000 fips140/crypto/lskcipher.c
 create mode 120000 fips140/crypto/pcrypt.c
 create mode 120000 fips140/crypto/proc.c
 create mode 120000 fips140/crypto/rng.c
 create mode 120000 fips140/crypto/rsa-pkcs1pad.c
 create mode 120000 fips140/crypto/rsa.c
 create mode 120000 fips140/crypto/rsa_helper.c
 create mode 120000 fips140/crypto/rsaprivkey.asn1
 create mode 120000 fips140/crypto/rsapubkey.asn1
 create mode 120000 fips140/crypto/rsassa-pkcs1.c
 create mode 120000 fips140/crypto/seqiv.c
 create mode 120000 fips140/crypto/sha256.c
 create mode 120000 fips140/crypto/sha3_generic.c
 create mode 120000 fips140/crypto/sha512.c
 create mode 120000 fips140/crypto/shash.c
 create mode 120000 fips140/crypto/sig.c
 create mode 120000 fips140/crypto/simd.c
 create mode 120000 fips140/crypto/skcipher.c
 create mode 120000 fips140/crypto/skcipher.h
 create mode 120000 fips140/crypto/tcrypt.c
 create mode 120000 fips140/crypto/tcrypt.h
 create mode 120000 fips140/crypto/testmgr.c
 create mode 120000 fips140/crypto/testmgr.h
 create mode 120000 fips140/crypto/xts.c
 create mode 100644 fips140/fips140-glue.c
 create mode 100644 fips140/fips140.lds
 create mode 120000 fips140/lib/crypto/aes.c
 create mode 120000 fips140/lib/crypto/aesgcm.c
 create mode 120000 fips140/lib/crypto/gf128mul.c
 create mode 120000 fips140/lib/crypto/memneq.c
 create mode 120000 fips140/lib/crypto/sha256.c
 create mode 120000 fips140/lib/crypto/sha512.c
 create mode 120000 fips140/lib/crypto/utils.c
 create mode 100644 include/crypto/api.h
 create mode 100755 scripts/extract-fips140

-- 
2.39.3

