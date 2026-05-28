Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042B73AA517;
	Thu, 28 May 2026 09:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959378; cv=none; b=dX4slaqRX8BJbtS4LZFcshb9xPz/yeVPSCxfKwU5f7CFhxarmEIlwYsWq1ayZXmuc4u73uqOWtvGD82YTEBTfBobi1gdScsIM7JHTznIxud2XVyei+8J7HTec893FyeOtoSvV4qYh3GJ5H0pDmyF8FEUdDcLiGYQVfTQ1sWxx6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959378; c=relaxed/simple;
	bh=S/1dG4bsyIIViXbgS02bbpnmmLKSvCc4zmx0WqU1GLc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fRrArGV0TkWXtE0jIOM0Cud/yCXfoAfOtLdpTARwbfTeGq6+wBBTfezyo6+sqNLf5zE1C2bnfN/0z5tm9VGZ9fjFDmR40Oy671ZvwGmTgrRu/IZ3ENeN+1T7EX+ULLaWT5ZwzTA9947sbESk+y65Tk2fubHCKQ8OXQCNSe0VcK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=wHP6nJ6s; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="wHP6nJ6s"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id C4E00C62447;
	Thu, 28 May 2026 09:09:33 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 9E60C60495;
	Thu, 28 May 2026 09:09:33 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 52A8F10888C72;
	Thu, 28 May 2026 11:09:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959373; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=4FzTPaj1dYIgTp2U5poQ40jpJf1rVzQEeowpKSrLRks=;
	b=wHP6nJ6sbX55TI3aModQF1/yQkAXbbQrZKXkRxTfqvqUBxNytkw/fiWn/pRKlz9UFBQ692
	deoZtW473/kWvIqow/P4Q/REZrJ0+BmV5Piam7zRydUfhWiQvcq8UXFc2Y53/0MHKOLyXR
	TN4OJ++zPVolzgZJ00bV4hd6jg0UyHlJ7K287FQAGwSp+28Myi9HTJAA4H+bn8QT2+jSV3
	hmQzyNX6nVM3EH0ttqWF6TVB0Eu+uGOJ2qFQwYJkAQR7ADIg86MWjYo1sfL2K1DQYIWMj0
	bcCNlwqcmmcMheaJgi6kL/OOujgvTqM0FJLQvGDev4rjfanLLYx3zSoHDZ2zPg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:24 +0200
Subject: [PATCH 11/29] crypto: talitos - Remove unused priority field in
 struct talitos_alg_template
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-11-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=674;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=S/1dG4bsyIIViXbgS02bbpnmmLKSvCc4zmx0WqU1GLc=;
 b=U3htglhSDRqXJriWcshXuXst8t5py5IyGK1ky7Mdk8rpLhLISiBfmjpJUrd7pjvPairr4kHPd
 oDUD4JyfMT+DXC7246v8d4Ck5+vBpYqFpnuRN/IUifTLtDcJw+7PleG
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

After algorithm properties are now set at definition time, the priority
field in struct talitos_alg_template is no longer used. Remove it.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index 438be8c8f08d..6cf3628c52c2 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -203,7 +203,6 @@ struct talitos_ctx {
 
 struct talitos_alg_template {
 	u32 type;
-	u32 priority;
 	union {
 		struct skcipher_alg skcipher;
 		struct ahash_alg hash;

-- 
2.54.0

