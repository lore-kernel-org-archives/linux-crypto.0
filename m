Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE4CC43460
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD49F61460
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhENUVw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 16:21:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:16076 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232930AbhENUVt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 16:21:49 -0400
IronPort-SDR: GkQ7ql11/hW13GCqnD0s1pUEs5EgyFpJU3EG4bEydd5DI+NHjFJenCDKQ7lmQMR7iGELw0jGlK
 oxIcBK64R/Dg==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="199921579"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="199921579"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 13:20:34 -0700
IronPort-SDR: M2gl9988+3rPvzmwlFWhI0P2l+8QUngvrP3jErN5kWk9xrFfGFQ7Tp2P355thZqCzyMGdv6ZMI
 xV5RWy36AkKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="438147159"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 14 May 2021 13:20:33 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: [RFC PATCH v2 02/11] x86/insn: Add Key Locker instructions to the opcode map
Date:   Fri, 14 May 2021 13:14:59 -0700
Message-Id: <20210514201508.27967-3-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210514201508.27967-1-chang.seok.bae@intel.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the following Key Locker instructions to the opcode map:

LOADIWKEY:
	Load an CPU-internal wrapping key.

ENCODEKEY128:
	Wrap a 128-bit AES key to a key handle.

ENCODEKEY256:
	Wrap a 256-bit AES key to a key handle.

AESENC128KL:
	Encrypt a 128-bit block of data using a 128-bit AES key indicated
	by a key handle.

AESENC256KL:
	Encrypt a 128-bit block of data using a 256-bit AES key indicated
	by a key handle.

AESDEC128KL:
	Decrypt a 128-bit block of data using a 128-bit AES key indicated
	by a key handle.

AESDEC256KL:
	Decrypt a 128-bit block of data using a 256-bit AES key indicated
	by a key handle.

AESENCWIDE128KL:
	Encrypt 8 128-bit blocks of data using a 128-bit AES key indicated
	by a key handle.

AESENCWIDE256KL:
	Encrypt 8 128-bit blocks of data using a 256-bit AES key indicated
	by a key handle.

AESDECWIDE128KL:
	Decrypt 8 128-bit blocks of data using a 128-bit AES key indicated
	by a key handle.

AESDECWIDE256KL:
	Decrypt 8 128-bit blocks of data using a 256-bit AES key indicated
	by a key handle.

Details of these instructions can be found in Intel Software Developer's
Manual.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from RFC v1:
* Separated out the LOADIWKEY addition in a new patch.
* Included AES instructions to avoid warning messages when the AES Key
  Locker module is built.
---
 arch/x86/lib/x86-opcode-map.txt       | 11 +++++++----
 tools/arch/x86/lib/x86-opcode-map.txt | 11 +++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index ec31f5b60323..eb702fc6572e 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -794,11 +794,12 @@ cb: sha256rnds2 Vdq,Wdq | vrcp28ss/d Vx,Hx,Wx (66),(ev)
 cc: sha256msg1 Vdq,Wdq | vrsqrt28ps/d Vx,Wx (66),(ev)
 cd: sha256msg2 Vdq,Wdq | vrsqrt28ss/d Vx,Hx,Wx (66),(ev)
 cf: vgf2p8mulb Vx,Wx (66)
+d8: AESENCWIDE128KL Qpi (F3),(000),(00B) | AESENCWIDE256KL Qpi (F3),(000),(10B) | AESDECWIDE128KL Qpi (F3),(000),(01B) | AESDECWIDE256KL Qpi (F3),(000),(11B)
 db: VAESIMC Vdq,Wdq (66),(v1)
-dc: vaesenc Vx,Hx,Wx (66)
-dd: vaesenclast Vx,Hx,Wx (66)
-de: vaesdec Vx,Hx,Wx (66)
-df: vaesdeclast Vx,Hx,Wx (66)
+dc: vaesenc Vx,Hx,Wx (66) | LOADIWKEY Vx,Hx (F3) | AESENC128KL Vpd,Qpi (F3)
+dd: vaesenclast Vx,Hx,Wx (66) | AESDEC128KL Vpd,Qpi (F3)
+de: vaesdec Vx,Hx,Wx (66) | AESENC256KL Vpd,Qpi (F3)
+df: vaesdeclast Vx,Hx,Wx (66) | AESDEC256KL Vpd,Qpi (F3)
 f0: MOVBE Gy,My | MOVBE Gw,Mw (66) | CRC32 Gd,Eb (F2) | CRC32 Gd,Eb (66&F2)
 f1: MOVBE My,Gy | MOVBE Mw,Gw (66) | CRC32 Gd,Ey (F2) | CRC32 Gd,Ew (66&F2)
 f2: ANDN Gy,By,Ey (v)
@@ -808,6 +809,8 @@ f6: ADCX Gy,Ey (66) | ADOX Gy,Ey (F3) | MULX By,Gy,rDX,Ey (F2),(v) | WRSSD/Q My,
 f7: BEXTR Gy,Ey,By (v) | SHLX Gy,Ey,By (66),(v) | SARX Gy,Ey,By (F3),(v) | SHRX Gy,Ey,By (F2),(v)
 f8: MOVDIR64B Gv,Mdqq (66) | ENQCMD Gv,Mdqq (F2) | ENQCMDS Gv,Mdqq (F3)
 f9: MOVDIRI My,Gy
+fa: ENCODEKEY128 Ew,Ew (F3)
+fb: ENCODEKEY256 Ew,Ew (F3)
 EndTable
 
 Table: 3-byte opcode 2 (0x0f 0x3a)
diff --git a/tools/arch/x86/lib/x86-opcode-map.txt b/tools/arch/x86/lib/x86-opcode-map.txt
index ec31f5b60323..eb702fc6572e 100644
--- a/tools/arch/x86/lib/x86-opcode-map.txt
+++ b/tools/arch/x86/lib/x86-opcode-map.txt
@@ -794,11 +794,12 @@ cb: sha256rnds2 Vdq,Wdq | vrcp28ss/d Vx,Hx,Wx (66),(ev)
 cc: sha256msg1 Vdq,Wdq | vrsqrt28ps/d Vx,Wx (66),(ev)
 cd: sha256msg2 Vdq,Wdq | vrsqrt28ss/d Vx,Hx,Wx (66),(ev)
 cf: vgf2p8mulb Vx,Wx (66)
+d8: AESENCWIDE128KL Qpi (F3),(000),(00B) | AESENCWIDE256KL Qpi (F3),(000),(10B) | AESDECWIDE128KL Qpi (F3),(000),(01B) | AESDECWIDE256KL Qpi (F3),(000),(11B)
 db: VAESIMC Vdq,Wdq (66),(v1)
-dc: vaesenc Vx,Hx,Wx (66)
-dd: vaesenclast Vx,Hx,Wx (66)
-de: vaesdec Vx,Hx,Wx (66)
-df: vaesdeclast Vx,Hx,Wx (66)
+dc: vaesenc Vx,Hx,Wx (66) | LOADIWKEY Vx,Hx (F3) | AESENC128KL Vpd,Qpi (F3)
+dd: vaesenclast Vx,Hx,Wx (66) | AESDEC128KL Vpd,Qpi (F3)
+de: vaesdec Vx,Hx,Wx (66) | AESENC256KL Vpd,Qpi (F3)
+df: vaesdeclast Vx,Hx,Wx (66) | AESDEC256KL Vpd,Qpi (F3)
 f0: MOVBE Gy,My | MOVBE Gw,Mw (66) | CRC32 Gd,Eb (F2) | CRC32 Gd,Eb (66&F2)
 f1: MOVBE My,Gy | MOVBE Mw,Gw (66) | CRC32 Gd,Ey (F2) | CRC32 Gd,Ew (66&F2)
 f2: ANDN Gy,By,Ey (v)
@@ -808,6 +809,8 @@ f6: ADCX Gy,Ey (66) | ADOX Gy,Ey (F3) | MULX By,Gy,rDX,Ey (F2),(v) | WRSSD/Q My,
 f7: BEXTR Gy,Ey,By (v) | SHLX Gy,Ey,By (66),(v) | SARX Gy,Ey,By (F3),(v) | SHRX Gy,Ey,By (F2),(v)
 f8: MOVDIR64B Gv,Mdqq (66) | ENQCMD Gv,Mdqq (F2) | ENQCMDS Gv,Mdqq (F3)
 f9: MOVDIRI My,Gy
+fa: ENCODEKEY128 Ew,Ew (F3)
+fb: ENCODEKEY256 Ew,Ew (F3)
 EndTable
 
 Table: 3-byte opcode 2 (0x0f 0x3a)
-- 
2.17.1

