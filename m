Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5B5274651;
	Tue,  5 Aug 2025 13:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399442; cv=none; b=T510GORqXWDd34krazf4844ThuGz9FnegH2rQF0yeRooDo7HQEMnw8dzRjgw9EUuF9aAMDRq/P0/3ST+R5Q/j6nojRmIhQRctTElH219+KTaxZEXEyj2oX07QaLLSxr+npNdAV1g93CGqsF6w1od4rhvyq445plOppgRuaKySy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399442; c=relaxed/simple;
	bh=rw1CbOROrUo0a/gRwjMVLMl3CRMzauKxKnYJSoi6CsA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KyBRNxnPKkAcKhzpYoqZCGUWTfsm0mFXPRc1tyWzTq0ce0nQVI+eyjulLXYR7+M5ktBlrB4Ombt8w7QVAtNat4JCYFYNTxb4jDTwRyfEFTstGGbQqlswBqmK35DUqgjX2LwxjTH3bGx3TVO8xSmUABeVO/AamLwhQSm2OL9EFc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H4iwD3TG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4iwD3TG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2E6C4CEF0;
	Tue,  5 Aug 2025 13:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399442;
	bh=rw1CbOROrUo0a/gRwjMVLMl3CRMzauKxKnYJSoi6CsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4iwD3TGQ8Vl/aFBh6icG50OrR7ku8VscVB37Uab09pECoI9jMHxSd4G8nMp/Ytet
	 ciXxoxLAT0TyiPtHNaa4s+/YQPFyrD9NhFQ0n8H+XWm2lp97JICUttnRqn1n6RS7aS
	 1ucyAYF8YZjCtdTqj6CEI5IW5+UDf6XF45AVLegEGkQOQe45FsEPYDGGSlmXmGoN/7
	 mRVJkpg32udVDySjXNSivnvFKNHOJFjpMZ4O0FrURL4BSGouk2MsTgIjzFYQhp7b85
	 Lj5HZCRUVh3tkugNayo5crtLgDiQc6LJ7lxca4iHQLxqp07nBkLw3SiCBIWHEQG/Z1
	 SArRROkMkUtLQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	john.allen@amd.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.12] crypto: ccp - Add missing bootloader info reg for pspv6
Date: Tue,  5 Aug 2025 09:09:00 -0400
Message-Id: <20250805130945.471732-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit aaeff14688d0254b39731d9bb303c79bfd610f7d ]

The bootloader info reg for pspv6 is the same as pspv4 and pspv5.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I understand the full picture. The pspv6 structure was added
initially without the cmdresp registers and bootloader_info_reg. The
cmdresp registers were added later in commit 949a0c8dd3c2, but the
bootloader_info_reg was still missing. This current commit adds the
missing bootloader_info_reg.

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix**: This is a clear bug fix that adds a missing register
   definition (`bootloader_info_reg = 0x109ec`) for the pspv6 hardware
   variant. Without this register, the bootloader version sysfs
   attribute would not work correctly for PSPv6 devices (PCI IDs 0x156E
   and 0x17D8).

2. **Minimal and Contained Change**: The fix is a single-line addition
   that adds the missing register offset. It's extremely low risk with
   no architectural changes or new features - just adding a missing
   hardware register definition that already exists in pspv2, pspv3,
   pspv4, and pspv5.

3. **Functionality Regression**: The missing register causes a
   functionality regression where users cannot query the bootloader
   version through the `/sys` interface on PSPv6 hardware. The code at
   line 78-80 in sp-pci.c checks for `psp->vdata->bootloader_info_reg`
   and reads from it to expose the bootloader version. Without this
   register defined, the sysfs attribute would not be visible or would
   return invalid data.

4. **Consistency with Previous Fixes**: A nearly identical fix was
   already made for pspv5 in commit 52e8ae868a82 ("crypto: ccp - Add
   missing bootloader info reg for pspv5"), demonstrating this is a
   known pattern of missing register definitions that need correction.

5. **Hardware Support Completeness**: PSPv6 support was added in kernel
   5.20 (commit bb4185e595e4), and the cmdresp registers were added
   later (commit 949a0c8dd3c2). This commit completes the hardware
   support by adding the final missing register, ensuring PSPv6 devices
   have feature parity with earlier PSP versions.

6. **No Side Effects**: The change only affects PSPv6 devices and has no
   impact on other PSP versions or any other kernel subsystems. It
   simply enables existing functionality to work correctly on newer
   hardware.

The commit follows stable kernel rules perfectly - it's a targeted bug
fix with minimal risk that restores expected functionality on specific
hardware without introducing new features or making architectural
changes.

 drivers/crypto/ccp/sp-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index e1be2072d680..e7bb803912a6 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -453,6 +453,7 @@ static const struct psp_vdata pspv6 = {
 	.cmdresp_reg		= 0x10944,	/* C2PMSG_17 */
 	.cmdbuff_addr_lo_reg	= 0x10948,	/* C2PMSG_18 */
 	.cmdbuff_addr_hi_reg	= 0x1094c,	/* C2PMSG_19 */
+	.bootloader_info_reg	= 0x109ec,	/* C2PMSG_59 */
 	.feature_reg            = 0x109fc,	/* C2PMSG_63 */
 	.inten_reg              = 0x10510,	/* P2CMSG_INTEN */
 	.intsts_reg             = 0x10514,	/* P2CMSG_INTSTS */
-- 
2.39.5

