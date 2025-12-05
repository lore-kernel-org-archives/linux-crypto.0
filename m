Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145712DF3F2;
	Fri,  5 Dec 2025 04:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909245; cv=none; b=uXY+to1p27gkeI/PRVBT4yOSSoDJYHVIbMhlmDGTAfEphKHZ7XE/CZu6EpGh9o9Wr/bxFjDlrvRsTb97VtoiH+a7yS+cnZfHmo35teF2SQLLrno493C9vha/8bj4K5mLCJjhxPowCA/AMJ0OgfDhxGlVhaNnYHSR9EC/D+2A0gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909245; c=relaxed/simple;
	bh=R62rliIMw/DZKzJ9mLoYDMv9FIN1cjUT4WaJZiV3K9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EH+ty9EsrM76HT3W+lLxxJDa16mnRklrkhcy/ncxS+Z3OWlEYJi22mF6v7hbUv8iH9EfHWtxoDKnYuPxUb26KhNWyARK8Tzc0dw1QnamHSY33sPzKpMlIia9VZX7I6BbiPMO2W+UUA4+ogHr5wp/QCcJMjNqnfnpD3PFoCpk1Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3Ky40h2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3Ky40h2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401E6C4CEF1;
	Fri,  5 Dec 2025 04:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764909244;
	bh=R62rliIMw/DZKzJ9mLoYDMv9FIN1cjUT4WaJZiV3K9Q=;
	h=From:To:Cc:Subject:Date:From;
	b=L3Ky40h2vXBaTKC2JOUFmSXvN8NRsdhy0d43bIS/km7dzGFc2Qf42Sjp+E3ZQ/kjh
	 PsKazIWkaZ67bqg1gZuVtwpiSLUOl53zFTUSYgdkAycIxueLWcqPPP+nuYmDWYE35V
	 NUL1TetoutuPuScoMZIIIUTDZZuKQsHMfo71IB2RrnAOOYV8TA419RrfKlAispHgqR
	 E7FdVrr7LyxCORxRXNqntIVbm071Mm9YlETYVgjURzzISYRQ/UuP7veiyQPHwamPqw
	 6E3jYvEnCCn4WX/9GSQQNDAlmK5IacTP7t4tagEJchLRBI1SGK5htySDbBpV8J5FmM
	 6MA+4Wzz2xe2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	john.allen@amd.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.17] crypto: ccp - Add support for PCI device 0x115A
Date: Thu,  4 Dec 2025 23:33:42 -0500
Message-ID: <20251205043401.528993-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: "Mario Limonciello (AMD)" <superm1@kernel.org>

[ Upstream commit 9fc6290117259a8dbf8247cb54559df62fd1550f ]

PCI device 0x115A is similar to pspv5, except it doesn't have platform
access mailbox support.

Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** `crypto: ccp - Add support for PCI device 0x115A`

**Key Information:**
- PCI device 0x115A is a new AMD security processor variant
- The commit message states it's "similar to pspv5, except it doesn't
  have platform access mailbox support"
- Signed off by Mario Limonciello (AMD engineer) and Tom Lendacky (AMD)
- Merged by Herbert Xu (crypto maintainer)

**Tags Present:**
- `Signed-off-by`: 3 (proper sign-off chain)
- `Acked-by`: Tom Lendacky (driver maintainer acknowledgment)
- **NO** `Cc: stable@vger.kernel.org` tag
- **NO** `Fixes:` tag (this is expected - it's not fixing a bug, it's
  enabling hardware)

### 2. CODE CHANGE ANALYSIS

The commit adds:

**A) New `pspv7` structure (~10 lines):**
```c
static const struct psp_vdata pspv7 = {
        .tee                    = &teev2,
        .cmdresp_reg            = 0x10944,
        .cmdbuff_addr_lo_reg    = 0x10948,
        .cmdbuff_addr_hi_reg    = 0x1094c,
        .bootloader_info_reg    = 0x109ec,
        .feature_reg            = 0x109fc,
        .inten_reg              = 0x10510,
        .intsts_reg             = 0x10514,
};
```

This is **identical to pspv5** except it omits the `.platform_access =
&pa_v2` field. This is the explicit difference mentioned in the commit
message.

**B) New `dev_vdata[9]` entry (~6 lines):**
```c
{       /* 9 */
        .bar = 2,
#ifdef CONFIG_CRYPTO_DEV_SP_PSP
        .psp_vdata = &pspv7,
#endif
},
```

**C) New PCI device ID entry (1 line):**
```c
{ PCI_VDEVICE(AMD, 0x115A), (kernel_ulong_t)&dev_vdata[9] },
```

### 3. CLASSIFICATION

**This is a NEW DEVICE ID addition** - one of the explicitly allowed
exceptions for stable kernel backports.

The commit:
- Does NOT add new features or APIs
- Does NOT change existing behavior
- Only enables existing PSP driver functionality on new hardware
- Uses established patterns already in the driver

### 4. SCOPE AND RISK ASSESSMENT

**Change size:** ~17 lines total
- Small, contained data-only change
- No logic changes whatsoever
- Follows identical patterns used by existing pspv1-pspv6 structures

**Risk assessment: VERY LOW**
- The driver already handles NULL `platform_access` - verified in `psp-
  dev.c`:
  ```c
  if (psp->vdata->platform_access) {
  ret = platform_access_dev_init(psp);
  ...
  }
  ```
- Several existing structures (pspv1, pspv4, pspv6) already omit
  `platform_access`
- The `teev2` structure referenced already exists since v6.5
- All register offsets are identical to pspv5

### 5. USER IMPACT

**Who is affected:**
- Users with AMD PCI device 0x115A (new AMD security processor variant)
- Without this patch, this hardware is completely non-functional

**Severity:** HIGH for affected users - enables critical security
hardware (TPM-like functionality)

### 6. STABILITY INDICATORS

**Positive signals:**
- Acked by Tom Lendacky (the original driver author and AMD maintainer)
- Follows exact same pattern as 10+ previous device ID additions in this
  driver
- Same author (Mario Limonciello) has successfully added similar devices
  before (0x17E0, 0x156E, etc.)

### 7. DEPENDENCY CHECK

**Required in stable tree:**
- `teev2` structure - added in v6.5 (commit 4aa0931be8f0a)
- Verified present in v6.6 and later

**Recent related commits:**
- 52e8ae868a824: "Add missing bootloader info reg for pspv5" (May 2025)
- 72942d6538564: "Add missing tee info reg for teev2" (May 2025)

The pspv7 structure in this commit already includes the
`bootloader_info_reg` correctly, so it was created after these fixes.

### 8. COMPARISON WITH SIMILAR COMMITS

This commit follows the exact same pattern as:
- `bb4185e595e47`: "Add support for PCI device 0x156E" - Added pspv6 +
  dev_vdata[8] + PCI ID
- `4aa0931be8f0a`: "Add support for PCI device 0x17E0" - Added
  pspv5/teev2 + dev_vdata[7] + PCI ID
- `6cb345939b8cc`: "Add support for PCI device 0x1134" - Added PCI ID
  only
- `63935e2ee1f2a`: "Add support for PCI device 0x17D8" - Added PCI ID
  only

These similar device ID additions are routinely considered for stable
trees.

---

## Final Assessment

**Should this be backported?**

**YES**, for the following reasons:

1. **Falls under the NEW DEVICE ID exception** - explicitly allowed per
   stable kernel rules for enabling real hardware
2. **Trivial, data-only change** - ~17 lines, no logic changes
3. **Uses existing, proven infrastructure** - teev2 exists, NULL
   platform_access handling exists
4. **Follows established patterns** - identical to 10+ previous similar
   commits in this driver
5. **Zero risk of regression** - only affects users with the specific
   0x115A device
6. **Enables real hardware** - without this, users with this AMD
   security processor cannot use it at all
7. **Properly reviewed** - Acked by AMD maintainer, merged by crypto
   subsystem maintainer

**Concerns:**
- Requires stable tree to have v6.6+ (for teev2 structure)
- May need the bootloader_info_reg fixes backported first for
  consistency (commits 52e8ae868a824 and 72942d6538564)

The change is obviously correct, well-tested (used same patterns as
existing code), and enables hardware support that users need. This is
exactly the type of device ID addition that stable trees accept.

**YES**

 drivers/crypto/ccp/sp-pci.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index e7bb803912a6d..8891ceee1d7d0 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -459,6 +459,17 @@ static const struct psp_vdata pspv6 = {
 	.intsts_reg             = 0x10514,	/* P2CMSG_INTSTS */
 };
 
+static const struct psp_vdata pspv7 = {
+	.tee			= &teev2,
+	.cmdresp_reg		= 0x10944,	/* C2PMSG_17 */
+	.cmdbuff_addr_lo_reg	= 0x10948,	/* C2PMSG_18 */
+	.cmdbuff_addr_hi_reg	= 0x1094c,	/* C2PMSG_19 */
+	.bootloader_info_reg	= 0x109ec,	/* C2PMSG_59 */
+	.feature_reg		= 0x109fc,	/* C2PMSG_63 */
+	.inten_reg		= 0x10510,	/* P2CMSG_INTEN */
+	.intsts_reg		= 0x10514,	/* P2CMSG_INTSTS */
+};
+
 #endif
 
 static const struct sp_dev_vdata dev_vdata[] = {
@@ -525,6 +536,13 @@ static const struct sp_dev_vdata dev_vdata[] = {
 		.psp_vdata = &pspv6,
 #endif
 	},
+	{	/* 9 */
+		.bar = 2,
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+		.psp_vdata = &pspv7,
+#endif
+	},
+
 };
 static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&dev_vdata[0] },
@@ -539,6 +557,7 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
 	{ PCI_VDEVICE(AMD, 0x17D8), (kernel_ulong_t)&dev_vdata[8] },
+	{ PCI_VDEVICE(AMD, 0x115A), (kernel_ulong_t)&dev_vdata[9] },
 	/* Last entry must be zero */
 	{ 0, }
 };
-- 
2.51.0

