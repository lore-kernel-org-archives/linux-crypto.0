Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF6A5A681A;
	Mon, 19 Oct 2026 13:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418391; cv=none; b=aB+5M1e6unP2Ubnjbr5ypIbs7z7oZWUA6Tb0vVsGXr5tXZeXsqf+6ZGSLvuyMhpa8BU6xc+RdJMww0xRg79M6CDnhGjPMe74AlV9VB4TVJAfQ+y1vbGAw6PoYUEl7W8CKFR3WYVhYPiKTWLEkl2b/exjNM4yCk9QVkps51tkOEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418391; c=relaxed/simple;
	bh=u8b9xUyqKxWbcf/9Z/3MgRdZdFL4wustq9U22fd38SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bKtxBGJ2boewyBaYvpFrb+fSv+P1H7mLoPUzRjqS9ooyboqpiCRKG2MSRdQJL7HUFXwDD0oRx4lUF7luUIl20H5yfk0JS5zryrq1gtczngjzwW5vPh2uc2SYkbXEUKBFLLCx4WZ1eR7AZ3Xa3ydE0ApmCabiS0LySzeT7TOjYAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hYOo4EAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hYOo4EAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3A41F000CB;
	Mon, 19 Oct 2026 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418388;
	bh=lJo+3unty6q0nZ5U5gtEIutsiG4UGZp9XR9qE1PIJDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYOo4EAFyGjZHQLJaiRQkDeSayexw8kV8UKAMpW/QWriW1W6rM32WopfhY/5HNbq2
	 MKO64dmoZYZuaoDgtHOTtRA1Pw79SB7PHxUUeDmKAYnG3ha3A9s+xZQO+7mFd5f39r
	 Z1K48FQ7O/jkIv6umoNLgQJXa+UR6OGGSwYqImj0Pw2Y3SVAYQkMx0lYbRHELYdwD+
	 xizS5TpRV/Y4863JLfu/nCBobiVkxfi34xoeG0nACVn9QreYgORwtfvgxtemtaM2E0
	 EPnwVEvhgUHqqn2QgUi4Ftq1MRNXP4mdrlaV3YivPTEp+ZFx+fGiJWS2iEYMalN8gj
	 GIuQwpJUa03lQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	prabhjot.khurana@intel.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] crypto: keembay - add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:48:25 -0400
Message-ID: <20261019135441.1420968-214-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit b73b71df4cb4ca241165ad31218c82dfe489147c ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Local tree

This checkout is **v7.3-rc4** (`7.3.0-rc4`, `git describe`:
`v7.3-rc4-27-gf0100363d8c37`). The candidate is `b73b71df4cb4c`
(`crypto: keembay - add missing MODULE_DEVICE_TABLE()`). The Keem Bay
OCS ECC driver is present here. The verdict is for this tree’s lineage:
does this one-line autoload fix meet stable rules given that the driver
and the missing alias exist in this code.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[crypto: keembay] [add] [missing MODULE_DEVICE_TABLE() for OF
module autoload]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- No `Fixes:` tag (expected for this review)
- No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, `Link:`,
  or `Cc: stable@vger.kernel.org`
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>` (crypto
  maintainer; applied the patch)
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  if present; they are not in this git object

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `kmb_ocs_ecc_of_match[]` is wired to `.of_match_table` but
  not exported with `MODULE_DEVICE_TABLE(of, ...)`.
- **Symptom:** OF `modules.alias` entries are not generated, so
  udev/kmod will not autoload `keembay-ocs-ecc` from the DT compatible
  `intel,keembay-ocs-ecc`.
- **Version info:** none in the message.
- **Root cause:** missing module-alias publication for an existing match
  table. Author states this is a source-level finding, not a live
  hardware repro.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised cleanup. It is an explicit autoload/enablement
fix. Same class as adding a device ID for modular builds.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/crypto/intel/keembay/keembay-ocs-ecc.c` — **+1 / −0**
- Function/scope: file-scope `kmb_ocs_ecc_of_match[]` (no function body
  change)
- Classification: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** match table exists and is used for bind-time matching if
  the driver is already loaded (built-in, or loaded some other way).
- **After:** `modpost`/`file2alias` also emit `of:` aliases from that
  table, so DT device appearance can load the module.
- Path affected: **module autoload / init**, not the probe runtime path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: **hardware enablement / missing device-ID publication** (OF
  module aliases)
- Mechanism: without `MODULE_DEVICE_TABLE`, `scripts/mod/file2alias.c`
  does not emit aliases for `intel,keembay-ocs-ecc`. Built-in still
  binds; **`CONFIG_CRYPTO_DEV_KEEMBAY_OCS_ECC=m` does not autoload from
  DT**.
- Confirmed in `include/linux/module.h`: `MODULE_DEVICE_TABLE` creates
  the alias symbol `file2alias` scans.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: one standard macro next to the existing table,
  matching sibling Keem Bay drivers (AES, HCU).
- Minimal; no locking, no API, no data-structure change.
- Regression risk: **very low**. Macro is a no-op for built-in; for
  modules it only adds aliases.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Match table introduced in **`c9f608c380090`** (“crypto: keembay-ocs-
  ecc - Add Keem Bay OCS ECC Driver”, Prabhjot Khurana, 2021-10-20).
- `git merge-base --is-ancestor c9f608c380090 v5.16` succeeded → first
  appeared in **v5.16**.
- Bug: table never had `MODULE_DEVICE_TABLE` until `b73b71df4cb4c`
  (2026-07-13). Long-lived.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introducer is `c9f608c380090`, ancestor of
HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `86c85d6657e47` (2024-08-24): **“crypto: keembay - fix module
  autoloading”** — same fix for HCU (`MODULE_DEVICE_TABLE(of,
  kmb_ocs_hcu_of_match)`).
- `0a94091e29f91`: same publication for OCS AES/SM4.
- `fbf31dd599875` (v6.4-rc1): moved driver to
  `drivers/crypto/intel/keembay/`.
- Standalone one-liner; not patch N/M.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou is a regular contributor of
missing-`MODULE_DEVICE_TABLE` and validation fixes (ixp4xx crypto,
several RTC/vdpa/watchdog/hwmon drivers). Not the Keem Bay maintainer.
Crypto maintainer Herbert Xu applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `of_device_id` table and
`MODULE_DEVICE_TABLE`. Applies standalone on this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c b73b71df4cb4c` →
  https://patch.msgid.link/20260704124609.16628-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only**; committed version is that v1.
- Thread (mbox): Herbert Xu: **“Patch applied. Thanks.”** No NAK, no
  requested changes, no `Cc: stable` from reviewers.
- Direct lore HTTP fetch returned 403/Anubis; discussion recovered via
  `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Prabhjot Khurana, Mark Gross,
**Herbert Xu**, David S. Miller, `linux-crypto@`, `linux-kernel@`.
Maintainer applied it. No extra Reviewed-by on the commit.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by / bugzilla / syzbot. Author calls it a source-
level finding. No user crash report found.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Same-day sibling `1e5004d5a3a80` (“crypto: ixp4xx - add missing
MODULE_DEVICE_TABLE()”), same commit-message template. Systematic scan,
still a real missing-alias bug.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** for lore.kernel.org/stable (Anubis bot-wall). No
in-tree evidence this was rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function body changed. Touches `kmb_ocs_ecc_of_match[]` used
by `kmb_ocs_ecc_driver` (`module_platform_driver`).

**Step 5.2: TRACE CALLERS**
Record: `kmb_ocs_ecc_probe()` is the platform `.probe`. Called by the
platform bus when a device matches `intel,keembay-ocs-ecc`. Autoload is
the missing step before probe for `=m`.

**Step 5.3: TRACE CALLEES**
Record: Probe ioremaps, requests IRQ, starts `crypto_engine`, registers
ECDH P-256/P-384. Unchanged.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable when `ARCH_KEEMBAY` (or `COMPILE_TEST`) and
`CRYPTO_DEV_KEEMBAY_OCS_ECC=m`, and DT has `intel,keembay-ocs-ecc`.
Kconfig: “Say Y or M if you are compiling for the Intel Keem Bay SoC.”
In-tree DTS (`arch/arm64/boot/dts/intel/`) has **no** `ocs-ecc` node
(only the binding example). Hardware is still a real SoC (`ARCH_KEEMBAY`
in `arch/arm64/Kconfig.platforms`). Userspace does not trigger this via
a generic syscall; DT device + modular driver does.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same omission later fixed in HCU (`86c85d6657e47`) and AES
(`0a94091e29f91`). This is the remaining ECC sibling.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** File and `kmb_ocs_ecc_of_match[]` are here. Pre-fix
parent of `b73b71df4cb4c` had the table and `.of_match_table` assignment
with no `MODULE_DEVICE_TABLE`. Introduced v5.16; this tree is 7.3-rc4.
`git merge-base --is-ancestor b73b71df4cb4c HEAD` is true (landed by
7.3-rc1). That does not make the fix unworthy of stable; it confirms the
driver/bug lived in this lineage.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** on this tree (already applied as +1 line). Older
stables before `fbf31dd599875` use `drivers/crypto/keembay/`; that is a
path tweak only, not a semantic dependency for this checkout.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: HCU and AES already publish OF aliases. No alternate ECC
autoload fix besides this commit. Driver also has
`MODULE_ALIAS_CRYPTO("ecdh-nist-p256")` etc., which can load the module
on crypto-API request, **not** on DT device appearance.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/crypto/intel/keembay/` — SoC crypto accelerator.
**PERIPHERAL** (Keem Bay / Movidius only), but an existing in-tree
driver, not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Moderate churn (crypto_engine API, remove-callback, directory
move). Match table itself unchanged since 2021 except this alias line.
Maintainer: Prabhjot Khurana; applied by Herbert Xu.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **platform-specific / config-specific** —
`CRYPTO_DEV_KEEMBAY_OCS_ECC=m` on Keem Bay with a DT node for OCS ECC.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Boot/enumeration when the OF device is created and the driver is
a module. Not a race. Unprivileged users do not trigger it directly.
Common on that SoC if the node exists; rare globally.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Hardware crypto module does not autoload from DT; ECDH offload
missing until manual `modprobe` or a crypto-alias load. Not
panic/UAF/corruption. **MEDIUM** functional/enablement (stable’s “device
ID” class).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** modular Keem Bay ECC actually binds at device discovery.
  Same class as device-ID additions.
- **Risk:** very low (one macro).
- **Ratio:** favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real modular autoload bug: OF match table present, aliases not
  published.
- Official stable rules: *“fix a real bug that bothers people **or just
  add a device ID**.”* This is publishing an existing OF ID for modules.
- User-prompt exception: new/missing device IDs and hardware enablement
  on an existing driver.
- +1 line, obviously correct, maintainer-applied, v1 unchanged.
- Same fix already used on sibling HCU/AES drivers.
- Driver has been in this lineage since v5.16; no missing prerequisites
  in this tree.

AGAINST:
- No user/syzbot report; author says source-level only.
- Niche SoC; no in-tree DTS node for this compatible.
- `MODULE_ALIAS_CRYPTO` can still load the module on algorithm request.
- Not a crash, leak, or security bug.

UNRESOLVED:
- Stable-list discussion (lore blocked).
- Whether out-of-tree Keem Bay DTs include `intel,keembay-ocs-ecc`.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard macro; applied by
   Herbert Xu.
2. Fixes a real bug that affects users? **PASS** — modular OF autoload
   does not work; device-ID equivalent.
3. Important issue? **PASS** under the device-ID / hardware-enablement
   exception (not a panic).
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — file and table exist; applies
   as a single insertion.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Device ID / module-alias publication for an existing driver.**

**Step 9.4: MAKE YOUR DECISION**
This is a one-line, obviously correct enablement fix: the driver already
matches `intel,keembay-ocs-ecc`, but modular builds never advertised
that ID to userspace. That is the same class of change stable already
takes for PCI/USB/OF IDs. Risk is negligible. This 7.3-rc4 tree contains
the driver and the historical bug; the patch is appropriate to carry on
this lineage’s stable trees.

### What the commit solves
Without `MODULE_DEVICE_TABLE(of, kmb_ocs_ecc_of_match)`, `modpost` does
not emit OF aliases, so a modular `keembay-ocs-ecc` will not autoload
when the DT device appears. Built-in still works. The fix only publishes
the existing match table.

### Risk vs benefit
Benefit is hardware actually probing on modular Keem Bay systems. Risk
is a compile-time alias with no runtime logic change.

### Concerns
Niche platform; no crash report. That does not disqualify a device-ID-
class one-liner. No functional dependencies.

Verification:
- [Phase 1] `git log -1 --format='%B' b73b71df4cb4c`: tags as listed; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] `git show b73b71df4cb4c`: +1 line `MODULE_DEVICE_TABLE(of,
  kmb_ocs_ecc_of_match)`
- [Phase 2] `include/linux/module.h` and `scripts/mod/file2alias.c`:
  alias generation confirmed
- [Phase 3] `git blame` on match table: introducer `c9f608c380090`; `git
  merge-base --is-ancestor c9f608c380090 v5.16` succeeded
- [Phase 3] Sibling fixes `86c85d6657e47` (HCU) and `0a94091e29f91`
  (AES) confirmed
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 lore URL; Herbert “Patch applied.
  Thanks.”; crypto list + original Intel authors
- [Phase 4] lore HTTP: 403/Anubis — UNVERIFIED via WebFetch/curl
- [Phase 5] Probe at `kmb_ocs_ecc_probe`; grep found no in-tree DTS
  using `intel,keembay-ocs-ecc`
- [Phase 6] `git describe HEAD` → v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` → 7.3.0-rc4; pre-fix parent lacks the macro; driver
  present
- [Phase 6] `git merge-base --is-ancestor b73b71df4cb4c HEAD` succeeded
- [Phase 7] Kconfig `CRYPTO_DEV_KEEMBAY_OCS_ECC` depends on
  `ARCH_KEEMBAY || COMPILE_TEST`
- [Phase 8] Failure mode: missing module autoload, not oops
- UNVERIFIED: stable@ mailing-list discussion; live hardware
  reproduction (author did not claim one)

**YES**

 drivers/crypto/intel/keembay/keembay-ocs-ecc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
index 59308926399d0..f31b5ae73f664 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
@@ -987,6 +987,7 @@ static const struct of_device_id kmb_ocs_ecc_of_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_ocs_ecc_of_match);
 
 /* The OCS driver is a platform device. */
 static struct platform_driver kmb_ocs_ecc_driver = {
-- 
2.53.0

