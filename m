Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935F63FB8B;
	Tue, 21 May 2024 20:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716322982; cv=none; b=r94WPhgosVIsowBwbe/dQzf7VYSvCgpaIpwwfVp212Vi433WHJhXN7Sa6uN0+Ss+Zayav/Ls6jZFpf9T8xeAUm2CgtzPBHjlRLcf10U0wpFFIHR4qfU5DnQaf19wMCR6ZLVrMyxtXvXeUuDtcbOOeHDT/fX41ZasD4Skvvd+U6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716322982; c=relaxed/simple;
	bh=Rygel7lRWEl019erYolLr+9sOFGxdECPHVMoJ63saII=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=A5U254ZiOMNSC7H+tOGqGn38z+tpxpno44DlD65hz2A3L34S0j0cwWM2sD67DVYtz6Ng+ZcTaRBeXSdL0UWDkYAk7HW5eT41AsSnebm6SaVoVTC0KD7Tda99FrU9YGEc59bOPFQpU5kwa1mosnD9uR+qmjhDFW76rjODe2sWZ84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rutwDc1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rutwDc1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6B3C2BD11;
	Tue, 21 May 2024 20:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716322982;
	bh=Rygel7lRWEl019erYolLr+9sOFGxdECPHVMoJ63saII=;
	h=From:Date:Subject:To:Cc:From;
	b=rutwDc1bDK07kt3hJHrIuDUuEQBLD+AqyYOJpXQRoajkZSY5x+zk35HlNw8LB9X5q
	 NllptBlAPdcyEWo67NuCbux9UtcPtjr15uP3vjyxXKxIWFD7agPtwOj8TGP9tbZ83z
	 kyu0IcN9Dkfs3JR3RlWyhRiiSNBQ4Rwuhd3Rd0Zsx971jZclFTE5Le5G4ZNe5qGghx
	 +s/xXTzQogpUee54SeiCjIz2bjzMgtBXypGjl6sD+PhAmYA10UsKX91GaC9Ur779yP
	 UY6Gwaxbob4gBa/4lWH98gD8kZ1+4zaOtkJf8Q52Ojole28vr/sD5B5EDje9XIZR72
	 95+b+1zeSNgqQ==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 21 May 2024 21:22:49 +0100
Subject: [PATCH] arm64/crypto: Raise priority of NEON crct10dif
 implementation
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240521-arm64-crct10dif-neon-prio-v1-1-e2975754b8f3@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJgCTWYC/x3MQQqAIBBA0avErBtQs6iuEi3EpppFGmNEIN09a
 fkW/2dIJEwJxiqD0M2JYyjQdQV+d2Ej5KUYjDJWtUajk6Oz6MVfWi28YqAY8BSO2A/WDU2ryGu
 C0p9CKz//e5rf9wMUHWYxawAAAA==
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-621fa
X-Developer-Signature: v=1; a=openpgp-sha256; l=1152; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Rygel7lRWEl019erYolLr+9sOFGxdECPHVMoJ63saII=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmTQKjC8Hyhfk9Z/Am/ERXw2VRa5M7c/f+qBckBcpx
 DRkrkHKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZk0CowAKCRAk1otyXVSH0FmcB/
 9Y+2EzwkuxrDQd7go9lzx6cNqRoPw8Q26bVcw+O2MECipm5HITkaTzvpoSSgpjEfQKS8iYfxigCVnO
 kYGCH52imMrpH18q7sR+8fgCS9Z/eIuBFNqorhslc+Pjb/6w4xHFGdg7CORU/jI+M/8vfu7XPmwC07
 lFk9Ss2RXGkXOeu6RyTOpKrm7zDVEMaGsbKZuROmGQ9rHJ26rF007LOEFLp6mX6V1fDco4U3T4PV2R
 eQAaRhgbsG6YHrUytJuARtPQFlcMYecoqN2ou08PXoPv3VxAHd13NVNE7lKXVKwaBiQw9nUjrKtZgW
 pb0NV1KNe/BjEPfQ91nRqqSwFNuwrd
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The NEON implementation of crctd10dif is registered with a priority of 100
which is identical to that used by the generic C implementation. Raise the
priority to 150, half way between the PMULL based implementation and the
NEON one, so that it will be preferred over the generic implementation.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/crypto/crct10dif-ce-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index 09eb1456aed4..59016518f44d 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -98,7 +98,7 @@ static struct shash_alg crc_t10dif_alg[] = {{
 
 	.base.cra_name		= "crct10dif",
 	.base.cra_driver_name	= "crct10dif-arm64-neon",
-	.base.cra_priority	= 100,
+	.base.cra_priority	= 150,
 	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 }, {

---
base-commit: a38297e3fb012ddfa7ce0321a7e5a8daeb1872b6
change-id: 20240521-arm64-crct10dif-neon-prio-894a9350ec1e

Best regards,
-- 
Mark Brown <broonie@kernel.org>

