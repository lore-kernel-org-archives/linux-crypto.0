Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5561D5ADC
	for <linux-crypto@vger.kernel.org>; Sat, 17 May 2025 20:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747513624; cv=none; b=JbjLIeQR8RMmJwEt0NIpArSaHjHHJFlKpSwfBKYVX6blrzsxPTAs6BdEgvANYzh1skSNuAe6fwFgcMc5UZh0UITdTP5h8AL60bu+HYn4WRscu8/GgoS5RThKXAWurcd8n3p6vhQ23WJVy/wiM1iaP/uHh9phuXJDP2HJ3JhejzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747513624; c=relaxed/simple;
	bh=jQE21z2IC0DhYHB4xvmusQVU0dVi7D9N7FhnjH9Xrlc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dw8X5lpsyx0FexMb50VfQVbTeH0nND+ySB7CfUzcIsmqx94u5w8gLRQessrscMsW2QD4jDRT2qiDaLlYmXoTmJSs7kEDCgGqktan+VUsF+01pP6QgehOkkzTmMHRoa/HkC9tGP5L09uTpPKyWZcjj+4jpohZD1G/t5ELPHH70zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bgh1Kt48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bgh1Kt48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EFFC4CEE3;
	Sat, 17 May 2025 20:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747513623;
	bh=jQE21z2IC0DhYHB4xvmusQVU0dVi7D9N7FhnjH9Xrlc=;
	h=From:To:Cc:Subject:Date:From;
	b=bgh1Kt48GcmY6gElDgi3lPnDvjSrck5CSwehFtQRU4YDS5Zq9nwZ/BR6tzu5K55Mm
	 EpkDiQlOhZOtZbXUlejFVMpv+LCfs7QvEmnZ6SCya6kWT3Vm6frz/9Us11SamyEjyg
	 VM8qKvEA17AAjHqeUuMKk/T1KSDXDQCSoWlgb/DrZsf1BR0RpUmTuY5qTFkbAklRiH
	 bFS3Lt6dr4up06EuY6k8i5QV5i79nOg4+MEDFpRoMwySNEJSFEvR8Qoc50l+sfAIKm
	 fuSkJjHMMJz1A076w4ivu1QhDSh2AiXNizJIWwKodH1cDnp3mcwG+p7l+GRtXUD0We
	 M25copuV/tnFw==
From: Mario Limonciello <superm1@kernel.org>
To: mario.limonciello@amd.com,
	davem@davemloft.net,
	Herbert Xu <herbert@gondor.apana.org.au>,
	john.allen@amd.com,
	thomas.lendacky@amd.com
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH 0/2] Add some missing info registers
Date: Sat, 17 May 2025 15:26:28 -0500
Message-ID: <20250517202657.2044530-1-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

pspv5 and teev2 are missing the registers for version
information.

Mario Limonciello (2):
  crypto: ccp - Add missing bootloader info reg for pspv5
  crypto: ccp - Add missing tee info reg for teev2

 drivers/crypto/ccp/sp-pci.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.43.0

