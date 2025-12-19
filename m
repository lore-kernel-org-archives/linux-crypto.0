Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB3F21C163
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 08:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766134312; cv=none; b=PqOMAzTB25+KkpWZ8N8POEGyWDfrYa8w+GHyK3PR+yTE6X7BtJygDKttkdtE0Gex0251W2hu3xyGtxMmQW0mrHBGvQ+COH8O/sjPLRt2U7DYgRPMjZj3AZnhZGkwvogXNc4OHZttNCw7JSn3B7BUDHf5bahpEKZ1+KQsB4Ae23c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766134312; c=relaxed/simple;
	bh=ecq8bqhVdV9cK8MEsLyMUO2l9TkGGc5XrfJctuTcCkk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mtGxIDEmNY1t+wq4MCgR3MXoZBaO79EaGwDEyW3jn9gl8U/+Uaj92kUYatQjMSQ9mQY3XsFXFKpoOZE7t3vaojWyz5kCeIKBnZAL+Uqe6NwZsOK7EEreCwwPPoI6v+bY9bgx6Qm2QQtqi2UFR0zXK6DIZYqKzEoHK3+POzjCfDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1766134276-1eb14e3d89fb300002-Xm9f1P
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id 4v3ZK2DTwu9Gi4ef (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 19 Dec 2025 16:51:44 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Fri, 19 Dec
 2025 16:51:20 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Fri, 19 Dec 2025 16:51:20 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from DESKTOP-A4I8D8T.zhaoxin.com (10.32.65.156) by
 ZXBJMBX02.zhaoxin.com (10.29.252.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.59; Fri, 19 Dec 2025 16:03:19 +0800
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
To: <herbert@gondor.apana.org.au>, <ebiggers@kernel.org>, <Jason@zx2c4.com>,
	<ardb@kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <CobeChen@zhaoxin.com>, <TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>,
	<GeorgeXue@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>,
	AlanSong-oc <AlanSong-oc@zhaoxin.com>
Subject: [PATCH v2 0/2] lib/crypto: x86/sha: Add PHE Extensions support
Date: Fri, 19 Dec 2025 16:03:04 +0800
X-ASG-Orig-Subj: [PATCH v2 0/2] lib/crypto: x86/sha: Add PHE Extensions support
Message-ID: <cover.1766131281.git.AlanSong-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 12/19/2025 4:51:18 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1766134276
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2214
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.62
X-Barracuda-Spam-Status: No, SCORE=-1.62 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA085b
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.151782
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.40 BSF_SC0_SA085b         Custom Rule SA085b

For Zhaoxin processors, the XSHA1 instruction requires the total memory
allocated at %rdi register must be 32 bytes, while the XSHA1 and
XSHA256 instruction doesn't perform any operation when %ecx is zero.

Due to these requirements, the current padlock-sha driver does not work
correctly with Zhaoxin processors. It cannot pass the self-tests and
therefore does not activate the driver on Zhaoxin processors. This issue
has been reported in Debian [1]. The self-tests fail with the
following messages [2]:

alg: shash: sha1-padlock-nano test failed (wrong result) on test vector 0, =
cfg=3D"init+update+final aligned buffer"
alg: self-tests for sha1 using sha1-padlock-nano failed (rc=3D-22)
------------[ cut here ]------------

alg: shash: sha256-padlock-nano test failed (wrong result) on test vector 0=
, cfg=3D"init+update+final aligned buffer"
alg: self-tests for sha256 using sha256-padlock-nano failed (rc=3D-22)
------------[ cut here ]------------

To enable XSHA1 and XSHA256 instruction support on Zhaoxin processors,
this series adds PHE Extensions support to lib/crypto for SHA-1 and
SHA-256, following the suggestion in [3].

v1 link is below:
https://lore.kernel.org/linux-crypto/20250611101750.6839-1-AlanSong-oc@zhao=
xin.com/

---
v1->v2: Add Zhaoxin support to lib/crypto instead of extending
        the existing padlock-sha driver

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1103397
[2] https://linux-hardware.org/?probe=3D271fabb7a4&log=3Ddmesg
[3] https://lore.kernel.org/linux-crypto/aUI4CGp6kK7mxgEr@gondor.apana.org.=
au/

AlanSong-oc (2):
  lib/crypto: x86/sha1: PHE Extensions optimized SHA1 transform function
  lib/crypto: x86/sha256: PHE Extensions optimized SHA256 transform
    function

 lib/crypto/Makefile             |  6 ++-
 lib/crypto/x86/sha1-phe-asm.S   | 71 +++++++++++++++++++++++++++++++++
 lib/crypto/x86/sha1.h           | 20 ++++++++++
 lib/crypto/x86/sha256-phe-asm.S | 70 ++++++++++++++++++++++++++++++++
 lib/crypto/x86/sha256.h         | 20 ++++++++++
 5 files changed, 185 insertions(+), 2 deletions(-)
 create mode 100644 lib/crypto/x86/sha1-phe-asm.S
 create mode 100644 lib/crypto/x86/sha256-phe-asm.S

--=20
2.34.1

