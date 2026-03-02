Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229C53E7172;
	Mon,  2 Mar 2026 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772463757; cv=none; b=D0HP2YEBylOwrYvvgE6tMHIWQzjACIffKRT+p0c0ucgfh1OtgxAAZnBTQKzPzJRm7qJmd2tWX91Ca9RBXgmJiOG/W55zRm5+85pDqMJbnCZgVX+GvtZAZ9Irbcs8E1Z8Pk8H+7ogPKAZGUJBf7mmQVh4ao7sR17DItbOfZ05+4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772463757; c=relaxed/simple;
	bh=HHeDj+KF6QektlNz6hjab7qUia77cZtM3PHhvm2nGh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AY58CW/BkB+gJllhfSCewR7spCB9P+YJviSWGEp+iWWsmrL9wMR8Jcfs/R3cy8Ebdt3ckjKYkV/XbAXyCoOdz+PWyteL2CY/RmDUtt6fNLgEwXksLYm711Y1sn2LVQ3a3pRk2m4EWLRtxXhag9Qo68Iiy6DXUB48FAabrg9rC58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5zKctiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5zKctiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC0CC2BC86;
	Mon,  2 Mar 2026 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772463757;
	bh=HHeDj+KF6QektlNz6hjab7qUia77cZtM3PHhvm2nGh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5zKctizyquGR2/kQT5MhN3zUeb/NlPhYLZL6VutT8AlfnDzYbesbxD1bx63SAoBL
	 405eEI+JhMcLohzn5U5g83AceCZXCWeXyZdMZHJ8vflvEfYmHO2A2GSheSZDXmwYN0
	 YQDxKz4xoIFvozzAzX0+8N3IfqU0lRGX3EwBYRgyNc1GYuTTn1Isx5HTcAhOoLLJn4
	 0gPVOneGAzf+TVAhov5fSYrliTSwTN2fdYPoz64MpnLQ87i1OM/SYDLo7rQ58BRFjX
	 syZac1kCySxP8Gbk0KOD6lnc1Zhjsx+4XD+LEcuYJA0f9UaLByl1cNUJSRy47y/yJ6
	 wJHhaf2YZp+8w==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] include/psp-sev.h: fix structure member in comment
Date: Mon,  2 Mar 2026 08:02:24 -0700
Message-ID: <20260302150224.786118-2-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302150224.786118-1-tycho@kernel.org>
References: <20260302150224.786118-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

The member is 'data', not 'opaque'.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 include/uapi/linux/psp-sev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 2b5b042eb73b..52dae70b058b 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -277,7 +277,7 @@ struct sev_user_data_snp_wrapped_vlek_hashstick {
  * struct sev_issue_cmd - SEV ioctl parameters
  *
  * @cmd: SEV commands to execute
- * @opaque: pointer to the command structure
+ * @data: pointer to the command structure
  * @error: SEV FW return code on failure
  */
 struct sev_issue_cmd {
-- 
2.53.0

