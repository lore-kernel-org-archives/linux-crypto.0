Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B7E2857F9;
	Thu,  4 Sep 2025 16:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001724; cv=none; b=j6tzHmc3J0AhS6GO+67ABRbAnGbJx/mizYqAaC7QSh+8rFDbVOLSdcBLjp+gR/asg7PetGRJn8UuH2VNszSRQK2FMzI0cYhynBEO1qGP1GcaTV/IZjDOgOKEcDBGVsdJ9WfFol+kT2UiRBtELuFwZML+aOuWOfItR3MN11QS8Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001724; c=relaxed/simple;
	bh=GWYHt3hWCszOTW+pJuUsAm+YAelIM6J5V/iqsnATWvU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EifHdqeObhfOJey19g2P5HNObFZRh3/g759rpANbPRcrtlj+wdJq6tfyWvrXC8vdslfnClYBq236jX9HQBR7ssogxeJW1tB5eKIrUrqjukEEHMunYK6vqB7ed6godE5IwryKU/QtmaUV9Q5ha71yR6Jj05cZDqW1Wam/CwXDpxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qTQ4D45/; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qTQ4D45/"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtiU7023828;
	Thu, 4 Sep 2025 16:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=puDhj
	7AOd6F632Hw1n4QDGTLmJpzWRZR3HmzEkQgY+o=; b=qTQ4D45/OgOb/dQy649k+
	pLrOfug6dswQ4ufNlnZOeuc1WiAwLPn2cD2pAt0shx1sRZ/5ufckKE/wh9hfOnrT
	nYi01MZ768BjkQze974eTrvw/wAUdQTEBAIYMZnj0R0UCNBj5Gh0tcKfCgTSsouQ
	JscnxNgyolEEIM9UpoxxQokwDtXkusE4X1dxk/4mLbyciscibmd2kxG0tkUai+oJ
	ijKNssAX6T4IiZJo3fXD57QtYkBIgcWXlOJFrlo7XIe/4iwF3S48P4qjFTBn4tlK
	/8Dyahl5FHTipO1R33Hwf5PO1UJ0NYjO9b+RFA73YWdIcQSUVsi/ohmum3JTD34k
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd02f1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584F46sG040015;
	Thu, 4 Sep 2025 16:01:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtub5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:45 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx8E000707;
	Thu, 4 Sep 2025 16:01:44 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-104;
	Thu, 04 Sep 2025 16:01:44 +0000
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
        Vegard Nossum <vegard.nossum@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH RFC 103/104] Documentation/crypto: add fips140.rst
Date: Thu,  4 Sep 2025 17:52:15 +0200
Message-Id: <20250904155216.460962-104-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
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
 definitions=main-2509040157
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX91h8H68lGGls
 bIIdppBShf4K9+Mb+SuEHq+PHPGORQeszI4qMgjFJUETEpuSyji/4rOAKtq0RGyaxkM5Yl9sU/1
 wP3skXDgMLa/B7xgvzjzEVkO3j9FfUEumB5ATEOlgHuKuZ+7rduOseVEfX2LskGIQ67lJkEZyIU
 MMOrgLrzMhYKgiCXGcKQGtZqF3oY5m2+9SzTv6PQZ2UqJAEW+SNLEjNGhMHuckp1Y5EvCq/A1jt
 gU+oFPiepS3eLurfCG9zxSEeUx6OXdzCUKWUjc2vsAsjt5LofM+KGJ44kEo107q/QDJ5N6ZYYbp
 K0d8fIjJ7ubf+f/+uw4iOlwOJ0YrJ3VyJf0RIx46N2IKZGeXccyMVjLqbTqzwUvZha8TCzJPnhO
 2RVwtuZTjJSJ+BVGBDYfSjeLG80p7Q==
X-Proofpoint-GUID: g2hjg_0CavlCpo2UHD_DBfGuey_IBOMt
X-Proofpoint-ORIG-GUID: g2hjg_0CavlCpo2UHD_DBfGuey_IBOMt
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b7ea b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=PYnjg3YJAAAA:8 a=07d9gI8wAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=0xFrEbagEDTAMB6QI5oA:9 a=e2CUPOnPG4QKp8I52DXD:22 cc=ntf
 awl=host:12068

Add documentation for the FIPS140 standalone module.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 Documentation/crypto/fips140.rst | 231 +++++++++++++++++++++++++++++++
 Documentation/crypto/index.rst   |   1 +
 2 files changed, 232 insertions(+)
 create mode 100644 Documentation/crypto/fips140.rst

diff --git a/Documentation/crypto/fips140.rst b/Documentation/crypto/fips140.rst
new file mode 100644
index 000000000000..14a7fb7a69ed
--- /dev/null
+++ b/Documentation/crypto/fips140.rst
@@ -0,0 +1,231 @@
+=========================
+FIPS140 standalone module
+=========================
+
+:Author: Vegard Nossum <vegard.nossum@oracle.com>
+
+
+Target audience
+===============
+
+This document is primarily meant for Linux distribution developers and
+maintainers. It may also be interesting for kernel developers
+contributing to the kernel's crypto code as it explains some of the
+concepts and rationale behind the architecture of the crypto code and
+how FIPS support is implemented.
+
+
+Introduction
+============
+
+FIPS 140-3 is a Federal Information Protection Standard, "Security
+Requirements for Cryptographic Modules", maintained by the US National
+Institute of Standards and Technology (NIST). [#fips140]_
+
+Binary implementation of specific approved cryptographic algorithms
+can be certified as part of the Cryptographic Module Validation
+Program (CMVP). In practice, the certification process includes both
+source and binary code, though the end result is a certification
+attached to the binary code.
+
+Having FIPS 140-3 certification is a requirement for running in many
+secure contexts -- many Linux distros certify their kernels in order
+to satisfy these requirements.
+
+Many distros have certified the entire kernel as a "FIPS module" (not
+to be confused with kernel modules). Unfortunately, this means that
+one cannot change any part of the kernel without invalidating the
+certification. Moreover, certification is a costly process that can
+last up to or even more than 12 months.
+
+The FIPS 140 standalone module (AKA ``fips140.ko``) fixes this situation
+by allowing one to build the kernel's crypto code once and reuse it in
+subsequent builds, thus enabling the rest of the kernel to receive bug
+fixes and updates without invalidating the certification of the FIPS
+module.
+
+
+Design
+======
+
+Requirements:
+
+- the FIPS module must not impose a stable internal kernel API on
+  mainline or stable kernels
+- the FIPS module must be a single, contiguous binary file and its HMAC
+  (for easy verification)
+- all crypto algorithms and code must reside within the FIPS module
+- no crypto code in the FIPS module can be used before the FIPS module
+  has executed its self-tests
+- the FIPS module only comes into play when the kernel is booted with
+  ``fips=1``
+- source code should be shared between the kernel and the FIPS module
+  where possible
+
+In order to satisfy these requirements, we have settled on a design
+where the FIPS module duplicates the crypto API and all the algorithm
+implementations that are part of the FIPS module. To avoid source code
+duplication, we use symlinks from ``fips140/`` to the rest of the kernel
+tree and build this directory as an external module -- in other words,
+all the code and algorithms is built twice; once as part of vmlinux
+and/or regular (non-FIPS) kernel modules, and once as part of
+``fips140.ko``.
+
+To allow hot-swapping the crypto code (API + algorithms) at runtime
+(i.e. when ``fips=1`` is detected during boot), we wrap any exported
+symbols in C macros. These macros use static calls (see [#static_call]_)
+to patch any and all users of the crypto code to call the FIPS module's
+version of these functions instead of the functions in vmlinux.
+
+``fips140.ko`` is not really an ordinary kernel module -- it is not
+meant to be loaded with ``modprobe`` or ``insmod``; instead, it is
+embedded into the ``vmlinux`` image at build time. This avoid any
+chicken-and-egg issues around how to verify cryptographic signatures
+without using unverified crypto code. ``fips140.ko`` is loaded during
+early boot -- before any crypto code is used by the kernel.
+
+The code for the FIPS 140 standalone module is therefore split into
+two parts: the module itself (``fips140.ko``) and the loader
+(``crypto/fips140-loader.c``). The loader is **NOT** part of the module
+itself and is not covered by the certification; however, it is
+essentially just a wrapper around the kernel module loader that runs
+during early boot.
+
+We provide no explicit mechanisms to ensure compatibility between a
+precompiled FIPS module and the rest of the kernel; this is the
+responsibility of distros that choose to use the standalone FIPS module.
+
+
+Building
+========
+
+First off, ensure that ``CONFIG_CRYPTO_FIPS140_EXTMOD`` is enabled.
+
+Prepare for building out-of-tree module::
+
+  make modules_prepare
+
+Build fips140.ko as an out-of-tree module::
+
+  make M=fips140/ KBUILD_MODPOST_WARN=1
+  cp fips140/fips140.ko crypto/
+
+Generate fips140.hmac::
+
+  hmac_key=$(awk -F'"' '/^CONFIG_CRYPTO_FIPS140_HMAC_KEY=/{print $2}' .config)
+  openssl dgst -sha256 -hmac $hmac_key -binary -out crypto/fips140.hmac crypto/fips140.ko
+
+Build the rest of the kernel::
+
+  make
+
+
+Adopting a standaline FIPS module for your distro
+=================================================
+
+1. Carefully select which algorithms you want your FIPS module to
+   provide (``CONFIG_FIPS140_*`` and ``CONFIG_CRYPTO_FIPS140_*``
+   options)
+
+2. Integrate building ``fips140/`` as an out-of-tree module with the
+   build system used by your distro's package manager.
+
+   - You may want to strip and separate out debuginfo before copying
+     ``fips140.ko`` into ``crypto/``.
+   - You need a mechanism to save and reintroduce the precompiled
+     ``fips140.ko`` between builds.
+   - All of this "build support" infrastructure is out of scope for
+     mainline.
+
+3. Verify that the FIPS module satisfies your specific operational
+   requirements.
+
+4. Submit the FIPS module to the certifying lab.
+
+.. warning::
+   Mainline developers cannot and will not assist in getting a specific
+   FIPS module certified. The code provided in the mainline source tree
+   is intended to make certification of standalone FIPS modules easier,
+   but we do not guarantee that a build will be certifiable as-is out of
+   the box. Moreover, different distributions have different use cases,
+   different requirements, etc. and all of this influences the specifics
+   of any given FIPS module. Mainline developers will not be responsible
+   for the certification or certifiability of your FIPS module.
+
+
+Useful commands
+===============
+
+
+Extracting ``fips140.ko`` from ``vmlinux``
+------------------------------------------
+
+To extract ``fips140.ko`` and ``fips140.hmac`` from an existing
+``vmlinux`` build, use::
+
+  $ scripts/extract-fips140 /path/to/vmlinux
+  extracted fips140.ko
+  extracted fips140.hmac
+
+
+Verifying the ``fips140.ko`` HMAC digest
+----------------------------------------
+
+To verify the HMAC digest of ``fips140.ko``, use::
+
+  $ key="Sphinx of black quartz, judge my vow"
+  $ openssl dgst -sha256 -hmac "$key" -binary fips140.ko > fips140.hmac-computed
+  $ cmp -s fips140.hmac fips140.hmac-computed && echo ok
+  ok
+
+
+List the symbols used by ``fips140.ko``
+---------------------------------------
+
+To list the kernel symbols used by ``fips140.ko`` (useful for checking
+whether all the necessary crypto functions have been included in the
+module), use::
+
+  $ nm --undefined-only fips140.ko
+
+
+Quick crypto verification using AF_ALG
+--------------------------------------
+
+Testing whether the code works properly is fairly easy using Python
+and the ``AF_ALG`` interface, e.g.::
+
+  import socket
+
+  ALG_SET_KEY = 1
+
+  s = socket.socket(socket.AF_ALG, socket.SOCK_SEQPACKET, 0)
+  s.bind(('hash', 'hmac(sha256)'))
+  s.setsockopt(socket.SOL_ALG, ALG_SET_KEY, b'x' * 16)
+
+  op, _ = s.accept()
+  op.sendall(b'x' * 32)
+  print(op.recv(32))
+
+
+Tracing the crypto code
+-----------------------
+
+Testing whether the FIPS module is used correctly can also be done
+using a combination of Python (as above) and ``trace-cmd`` like this::
+
+  $ sudo trace-cmd record -p function_graph -g __sys_bind python hmac.py
+  $ trace-cmd report
+
+
+Contributing
+============
+
+Patches welcome.
+
+
+References
+==========
+
+.. [#fips140] <https://csrc.nist.gov/pubs/fips/140-3/final>
+.. [#static_call] <https://lwn.net/Articles/815908/>
diff --git a/Documentation/crypto/index.rst b/Documentation/crypto/index.rst
index 100b47d049c0..e755ffd08d4f 100644
--- a/Documentation/crypto/index.rst
+++ b/Documentation/crypto/index.rst
@@ -27,3 +27,4 @@ for cryptographic use cases, as well as programming examples.
    descore-readme
    device_drivers/index
    krb5
+   fips140
-- 
2.39.3

