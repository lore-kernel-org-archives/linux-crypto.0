Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C05346768
	for <linux-crypto@vger.kernel.org>; Sun,  8 Feb 2026 10:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770546974; cv=none; b=oiVCgmYwY04jixFmlG4P77CeBtOgb9qm8O+yTpz3LoFARSDmJYk+FuklhdWOsmvAj1In22cQvpaqi4SyaOy3mg3dtwOxg+ZxdDAzADpOn9DrIhBseqqA5ITL4Yfh0aCmOl/qcsPIxtZ90/bBxogiJAd4pHtl/VUTMHbWpnC86s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770546974; c=relaxed/simple;
	bh=IcTYawaFBeJfuFKLXC7lkwm/OW5Bd/DOnZ/nJnlXj3o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V3VJxmHlwFhrGKGILbSZ9r9v0b0lpVFSxsTlpFUfZevw6MpSY9m3MChEIKQgYPasZFVC15jWhj5BlqtxiLLBmEu1Iwm0C1tuSzDRUofXpqnERzIg/lxySfT+Fg71eTTIcTPO0HtpwqAEHwX/e8trtCPEjRlpwmJjK5I408sTMPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=1o9htlAO; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="1o9htlAO"
Received: (wp-smtpd smtp.wp.pl 37523 invoked from network); 8 Feb 2026 11:36:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1770546965; bh=bQIBPlygIKoml7L+Ihnk+5AR68cs+54R2080CFZM2AA=;
          h=From:To:Cc:Subject;
          b=1o9htlAOFFnnCOxVNM/5hhodEfb/krkw0WxgjEY9dFbeLoU64dv5DOsN6PffjhHT6
           2KPB4gQrsi5XTCWtE1swDnJn0tMNygf2mAsWbhnrdL9DzU6A4NlN+s/cH1z9FN/Ahe
           Jo2MOHFTrTSwy05g1b0JbMkqgMEt7COMVdoDfuv01LwXTM/chZVw3RMF7ry61Ziogq
           XkWVsnqKOwmnkngFUahoAPZ/x4n3NQTz4CuVhCG2ydKg8mQJiP6VasNnz3q7grETT3
           Kzsdy26DmUYlXE0whP/lVOJ48DBi2CnTRzkN1U3XI3CtMisbI9JM84+hO0KheFY/bA
           v5i7s70I3fsDA==
Received: from 83.5.238.100.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.5.238.100])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 8 Feb 2026 11:36:05 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: ansuelsmth@gmail.com,
	atenart@kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vschagen@icloud.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: inside-secure/eip93 - fix register definition
Date: Sun,  8 Feb 2026 11:35:53 +0100
Message-ID: <20260208103602.8168-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: da3e187710d6e777b859ab11e9c9b3a3
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000008 [Qevk]                               

Checked the register definitions with the documentation[1]. Turns out
that the PKTE_INBUF_CNT register has a bad offset. It's used in Direct
Host Mode (DHM). The driver uses Autonomous Ring Mode (ARM), so it
causes no harm.

1. ADSP-SC58x/ADSP-2158x SHARC+ Processor Hardware Reference
Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/crypto/inside-secure/eip93/eip93-regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-regs.h b/drivers/crypto/inside-secure/eip93/eip93-regs.h
index 0490b8d15131..116b3fbb6ad7 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-regs.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-regs.h
@@ -109,7 +109,7 @@
 #define EIP93_REG_PE_BUF_THRESH			0x10c
 #define   EIP93_PE_OUTBUF_THRESH		GENMASK(23, 16)
 #define   EIP93_PE_INBUF_THRESH			GENMASK(7, 0)
-#define EIP93_REG_PE_INBUF_COUNT		0x100
+#define EIP93_REG_PE_INBUF_COUNT		0x110
 #define EIP93_REG_PE_OUTBUF_COUNT		0x114
 #define EIP93_REG_PE_BUF_RW_PNTR		0x118 /* BUF_PNTR */
 
-- 
2.47.3

