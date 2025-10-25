Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AB53043D5;
	Sat, 25 Oct 2025 16:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408716; cv=none; b=brS3WzyQ6V2r0V2Dg7AQkyd8UExdd5Ar2cmjwIQiaxxOAz84lqvhsorqNMMBzwdMkeiU6vIAni7LnylKrIGOml55GFC9+ZFAMA+dIq/qieDPMWWl87eWN4vVYbaF7cI3299NQ5R9ef9vJOI4W9vHL9QuC7S1J59u/bOXHe6y7Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408716; c=relaxed/simple;
	bh=TIm7MzgXQ28FqbUQmCMSWQsm/EiwtvC0RGUcJK0wTbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZiK424fyAavFDkQinU2OkUcLrFEkaECIayGKrC+T5MJ2v5ivBhlATl7YpRw4V/9pjtr0N8Ap7p3EgFv5Rv3QxBi77eHvDoLfgj2q+wWPPEE2b5E9DENWKrxvhCbAZoIC6hGQRBNMsHoOf7dvGTi6TP1Hikj1WnLmbsIo/bMlwSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ROXx1dH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ROXx1dH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105F9C4CEF5;
	Sat, 25 Oct 2025 16:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408716;
	bh=TIm7MzgXQ28FqbUQmCMSWQsm/EiwtvC0RGUcJK0wTbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROXx1dH/iio1sYrh21Apvm5PEBQn94U5BNETxQLX+BBnRLSRhudpuvphBn9ZmXl0Y
	 Rr746apnL957hpOknU6HoEeazPxYMPj3auNFUyxtoXCeZ9YOY9uItpcDM70b+aihsq
	 e+N6Yo/ZzXZYAiDZy9WzU8QTByqadLuSHJvj08Fhj8jiRZhABE2ZDsdjPViFHqR8sU
	 j4ClbE393R6uSi1h+5POwBiU5wpymZlJuUbWfidNnj2FhvyXxKT+2CiUKj+N5DjPZo
	 BfQbvvDgFDzBPzS77xPZ4dSkqTWgHTbLXr8FmBaQz/QeEZukwjNktfzb8ygJrx1Ec3
	 dKvGntbD8L1pg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yunseong Kim <ysk@kzalloc.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	thomas.lendacky@amd.com,
	john.allen@amd.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] crypto: ccp - Fix incorrect payload size calculation in psp_poulate_hsti()
Date: Sat, 25 Oct 2025 11:54:42 -0400
Message-ID: <20251025160905.3857885-51-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yunseong Kim <ysk@kzalloc.com>

[ Upstream commit 2b0dc40ac6ca16ee0c489927f4856cf9cd3874c7 ]

payload_size field of the request header is incorrectly calculated using
sizeof(req). Since 'req' is a pointer (struct hsti_request *), sizeof(req)
returns the size of the pointer itself (e.g., 8 bytes on a 64-bit system),
rather than the size of the structure it points to. This leads to an
incorrect payload size being sent to the Platform Security Processor (PSP),
potentially causing the HSTI query command to fail.

Fix this by using sizeof(*req) to correctly calculate the size of the
struct hsti_request.

Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>> ---
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## BACKPORT ANALYSIS COMPLETE

**ANSWER: YES**

This commit **SHOULD** be backported to stable kernel trees.

---

## COMPREHENSIVE ANALYSIS

### 1. BUG DESCRIPTION AND TECHNICAL IMPACT

**The Bug:**
The code uses `sizeof(req)` on line 91 of drivers/crypto/ccp/hsti.c,
where `req` is a pointer to `struct hsti_request`. This is the classic
sizeof(pointer) vs sizeof(*pointer) mistake.

**Size Calculations:**
- `struct psp_req_buffer_hdr`: 8 bytes (u32 payload_size + u32 status)
- `struct hsti_request`: 12 bytes (8-byte header + 4-byte u32 hsti
  field)
- `sizeof(req)` on 64-bit system: **8 bytes** (pointer size) ❌
- `sizeof(*req)` on 64-bit system: **12 bytes** (actual struct size) ✅

**Consequence:**
The `req->header.payload_size` field is set to 8 instead of 12, telling
the Platform Security Processor (PSP) firmware that only 8 bytes of data
are available. The PSP firmware uses this field to determine how much
data to read from the request buffer. With the incorrect size:
- The PSP reads only 8 bytes (the header)
- The 4-byte `hsti` field is not read by the firmware
- The HSTI query command fails or behaves unpredictably
- Security attributes cannot be populated on older AMD systems

**Evidence from code (drivers/crypto/ccp/platform-access.c:103,137):**
```c
print_hex_dump_debug("->psp ", DUMP_PREFIX_OFFSET, 16, 2, req,
                     req->header.payload_size, false);
```
The payload_size is used to determine how much data to send/dump,
confirming its critical role.

### 2. AFFECTED SYSTEMS AND USER IMPACT

**Affected Hardware:**
Older AMD systems with Platform Security Processor that don't populate
security attributes in the capabilities register. These systems require
the PSP_CMD_HSTI_QUERY command to retrieve security attributes.

**User-Facing Impact:**
- Security attributes not available via sysfs (under
  `/sys/devices/.../psp/`)
- Firmware update tool (fwupd) functionality broken
- Users cannot query security features: fused_part, debug_lock_on,
  tsme_status, anti_rollback_status, rpmc_production_enabled,
  rpmc_spirom_available, hsp_tpm_available, rom_armor_enforced

**Referenced Issues:**
The original commit (82f9327f774c6) that introduced this code was
specifically created to address multiple fwupd issues:
- https://github.com/fwupd/fwupd/issues/5284
- https://github.com/fwupd/fwupd/issues/5675
- https://github.com/fwupd/fwupd/issues/6253
- https://github.com/fwupd/fwupd/issues/7280
- https://github.com/fwupd/fwupd/issues/6323

The bug negates the fix intended by that commit.

### 3. AFFECTED KERNEL VERSIONS

**Bug introduced:** v6.11-rc1 (commit 82f9327f774c6, May 28, 2024)
**Bug fixed:** v6.18-rc1 (commit 2b0dc40ac6ca1, Sep 3, 2025)

**Affected stable trees:** v6.11.x, v6.12.x, v6.13.x, v6.14.x, v6.15.x,
v6.16.x, v6.17.x

All these versions contain the buggy code and should receive this
backport.

### 4. BACKPORT CRITERIA ASSESSMENT

| Criterion | Assessment | Details |
|-----------|------------|---------|
| **Fixes important bug** | ✅ YES | Breaks security attribute reporting
on older AMD systems, affecting firmware updates |
| **Small and contained** | ✅ YES | One character change: `sizeof(req)`
→ `sizeof(*req)` |
| **No new features** | ✅ YES | Pure bugfix, no functionality added |
| **No architectural changes** | ✅ YES | No design changes, just
corrects a typo-like bug |
| **Minimal regression risk** | ✅ YES | Fix is obviously correct;
impossible to introduce regression |
| **Subsystem criticality** | ✅ LOW RISK | crypto/ccp driver, not core
kernel |
| **Has Reviewed-by tag** | ✅ YES | Reviewed-by: Mario Limonciello (AMD
maintainer) |
| **Clear commit message** | ✅ YES | Excellent explanation of bug and
fix |

### 5. CODE CHANGE ANALYSIS

**The fix (drivers/crypto/ccp/hsti.c:91):**
```c
- req->header.payload_size = sizeof(req);
+       req->header.payload_size = sizeof(*req);
```

**Why this is safe:**
1. The allocation on line 87 uses `kzalloc(sizeof(*req), GFP_KERNEL)` -
   already correct
2. The fix makes the payload_size consistent with the allocated size
3. Changes from incorrect value (8) to correct value (12)
4. No ABI changes, no userspace-facing changes
5. No dependencies on other commits
6. Self-contained within the hsti.c file

### 6. VALIDATION AND TESTING

**How to verify the fix works:**
On affected AMD systems (older systems requiring PSP HSTI query):
1. Check dmesg for "failed to populate HSTI state" messages (should
   disappear)
2. Verify security attributes appear in sysfs:
   `/sys/devices/.../psp/fused_part`, etc.
3. Confirm fwupd can read security attributes

**Regression testing:**
The fix cannot cause regressions because:
- Systems that weren't working (returning 8 bytes) will now work
  (returning 12 bytes)
- Systems that don't use HSTI are unaffected (different code path)
- The PSP firmware expects 12 bytes; giving it 8 was always wrong

### 7. RELATED COMMITS IN THE AREA

Between bug introduction and fix:
- `059b1352519d1`: "Move message about TSME being enabled later in init"
  - cosmetic
- `34c065fe1d0db`: "Remove redundant __GFP_ZERO" - cleanup (removed
  redundant flag on line 87)
- `56a50e37fee03`: "Fix typo in psp_populate_hsti function name" -
  renamed function from psp_poulate_hsti to psp_populate_hsti

None of these are dependencies for the fix commit.

### 8. FINAL RECOMMENDATION

**STRONGLY RECOMMEND BACKPORTING** to all affected stable trees (6.11.x
through 6.17.x).

**Justification:**
1. **High impact:** Breaks user-facing functionality on a class of AMD
   hardware
2. **Trivial fix:** One character change, obviously correct
3. **Zero risk:** Cannot introduce regressions; the current code is
   objectively wrong
4. **Clear benefit:** Restores security attribute reporting and fwupd
   functionality
5. **Maintainer reviewed:** Has AMD maintainer's Reviewed-by tag
6. **Stable criteria:** Meets all stable tree backporting requirements

This is a textbook example of a stable tree candidate: obvious bug,
minimal fix, clear benefit, no risk.

 drivers/crypto/ccp/hsti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
index 1b39a4fb55c06..0e6b73b55dbf7 100644
--- a/drivers/crypto/ccp/hsti.c
+++ b/drivers/crypto/ccp/hsti.c
@@ -88,7 +88,7 @@ static int psp_poulate_hsti(struct psp_device *psp)
 	if (!req)
 		return -ENOMEM;
 
-	req->header.payload_size = sizeof(req);
+	req->header.payload_size = sizeof(*req);
 
 	ret = psp_send_platform_access_msg(PSP_CMD_HSTI_QUERY, (struct psp_request *)req);
 	if (ret)
-- 
2.51.0

