Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD91F274651;
	Tue,  5 Aug 2025 13:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399440; cv=none; b=dv5pwDDUaGd3LCDQcwRBAbc6lTKx8XVq9rGOGS9Ebx0NxO9JuMJjsUm4u/VS5e/yDhvAMqY0lMS8j3tLCdKyHnm4MjSgzhoIXM7nr7cr9d1e3filusVZPh7Slc+8qgA5AKaPWxKIedN+89Kbl6p4JhE026tEfJT7lYx1jPoCCgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399440; c=relaxed/simple;
	bh=1LBmXEsIk7i9eIwYyb7QaDcW9pHu4+ceXg9aRHN09jo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j8mkrMufSB+lBfDEzwJoM6afTvJAuBBFIXsILNAy4FW//C6Jp+5V2N8XYbWwDeQ2rPDoe1LNATNHvwOzCMFWx7Yh1D/x0KSD+vABDzwvQrj63gFCWAAXBsnaCsZ8rmckF6+jqfRj+fWkVTrG/aBpF7oZMlHg0r+kvp4qu739e8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7LGdBaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7LGdBaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E77C4CEF0;
	Tue,  5 Aug 2025 13:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399440;
	bh=1LBmXEsIk7i9eIwYyb7QaDcW9pHu4+ceXg9aRHN09jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7LGdBaOvL0ycDUg+3IlqV2BbwBYo7NINcocrmgbIHPZ+wCr+A7GgWl7BcDWoWrbk
	 OPHKAPtETB+yod/au8inzw84m910dFKIrFD15dSU/70h8b/KorORjNEcEz2c/e1Q0I
	 tJ7DVJ8wE1oaevylN4l+eNI3lTT8OV4uWIvKk3Br7inFM5SltpoWFXWT4PrbqFviQV
	 1pKIsCeNn8xCV7gdJmkoXX8tj0+/n3JtZUtFjHFOXy9XA4JnEXjnl0D9wvGl2ZE8U4
	 psH+6X+KgH9Ojm94/HcR3Vzy9XdA6JDo8u1D4FUJcfj9tmXLWXphwX0F0eYdqeUzyJ
	 YdlwHnizKx3Xw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Ernberg <john.ernberg@actia.se>,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16] crypto: caam - Support iMX8QXP and variants thereof
Date: Tue,  5 Aug 2025 09:08:59 -0400
Message-Id: <20250805130945.471732-24-sashal@kernel.org>
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

From: John Ernberg <john.ernberg@actia.se>

[ Upstream commit ac8aff0035fa58e53b39bd565ad6422a90ccdc87 ]

The iMX8QXP (and variants such as the QX, DX, DXP) all identify as iMX8QXP.

They have the exact same restrictions as the supported iMX8QM introduced
at commit 61bb8db6f682 ("crypto: caam - Add support for i.MX8QM")

Loosen the check a little bit with a wildcard to also match the iMX8QXP
and its variants.

Signed-off-by: John Ernberg <john.ernberg@actia.se>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Great! The code uses `glob_match()` for pattern matching, which means
wildcards like `*` are supported. Now I have all the information needed
to analyze this commit.

## Analysis Summary:

**Backport Status: YES**

## Extensive Explanation:

This commit should be backported to stable kernel trees for the
following reasons:

### 1. **Bug Fix Nature**
This is clearly a bug fix, not a new feature. The iMX8QXP and its
variants (QX, DX, DXP) are existing hardware that should have been
supported but weren't due to an overly restrictive string matching
pattern. The commit message explicitly states these variants "all
identify as iMX8QXP" but were not being recognized by the CAAM driver.

### 2. **Small and Contained Change**
The change is minimal - only a single line modification from:
```c
{ .soc_id = "i.MX8QM", .data = &caam_imx8ulp_data },
```
to:
```c
{ .soc_id = "i.MX8Q*", .data = &caam_imx8ulp_data },
```

This is a low-risk change that only affects the pattern matching for SoC
identification.

### 3. **Hardware Enablement Fix**
Looking at the firmware driver code
(`/home/sasha/linux/drivers/firmware/imx/imx-scu-soc.c`), we can see
that iMX8QXP is identified with ID 0x2 and returns the string
"i.MX8QXP". Without this fix, CAAM crypto hardware acceleration is
completely non-functional on these SoCs because the driver fails to
match the SoC ID.

### 4. **Same Configuration as iMX8QM**
The commit correctly reuses `caam_imx8ulp_data` which is an empty
structure, meaning these SoCs have special handling where:
- CAAM clocks are managed automatically by hardware (not by Linux)
- Linux doesn't have access to the CAAM controller's register page
This is the same configuration used for iMX8QM (added in commit
61bb8db6f682), confirming that iMX8QXP variants have identical
requirements.

### 5. **No Architectural Changes**
The change doesn't introduce any new functionality, APIs, or
architectural modifications. It simply extends existing pattern matching
to include variants that should have been supported from the beginning.

### 6. **User Impact**
Without this fix, users of iMX8QXP, iMX8QX, iMX8DX, and iMX8DXP SoCs
cannot use hardware crypto acceleration through CAAM, which is a
significant functionality loss for these platforms. The crypto subsystem
would fall back to software implementations, resulting in degraded
performance for cryptographic operations.

### 7. **Wildcard Pattern is Safe**
The use of "i.MX8Q*" wildcard is appropriate here because:
- It matches both iMX8QM (existing) and iMX8QXP variants (new)
- The glob_match() function in the kernel properly handles this pattern
- Both SoC families have identical CAAM requirements (no clock control,
  no register page access)

This is a textbook example of a stable-appropriate fix: it corrects a
clear oversight that prevents hardware from working properly, with
minimal code change and risk.

 drivers/crypto/caam/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 38ff931059b4..9cd5e3d54d9d 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -573,7 +573,7 @@ static const struct soc_device_attribute caam_imx_soc_table[] = {
 	{ .soc_id = "i.MX7*",  .data = &caam_imx7_data },
 	{ .soc_id = "i.MX8M*", .data = &caam_imx7_data },
 	{ .soc_id = "i.MX8ULP", .data = &caam_imx8ulp_data },
-	{ .soc_id = "i.MX8QM", .data = &caam_imx8ulp_data },
+	{ .soc_id = "i.MX8Q*", .data = &caam_imx8ulp_data },
 	{ .soc_id = "VF*",     .data = &caam_vf610_data },
 	{ .family = "Freescale i.MX" },
 	{ /* sentinel */ }
-- 
2.39.5

