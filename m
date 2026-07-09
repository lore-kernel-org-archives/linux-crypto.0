Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0671536CE03;
	Thu,  9 Jul 2026 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783607968; cv=none; b=ujSgvRX8E83xEq6TLn1gfhHcg6ABtJNnUlw2zCW6xVjgV3YsObU2Nr9+GSauXxUFAbJmVh656yQcGXaireoDlALqTRer9Lw/YOSsvCXis58a1KL4k35/ETAmxjH4TLuJ0855Z03SlKrFjjnN3jbr5TdWnN3Qz2/ixTMzaJcEQ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783607968; c=relaxed/simple;
	bh=49zOOt5+xEk9/lTP2PmM+mws9UQunmmAuhg/nSTLDRA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mSb0bgI30WhMX14rJvKPGDo9Bj4LneZu9ZsSrycCpX4JBy+PeLo363RsFqSBxlsChh8lQJk8W7XNaRBMjfwJh4xhdXqBafVa5hnBilUKjaCW/aF87JbCJqEoltFaBFTcfkl7eTruQ52HKD1uOkrBP79ww1Kje7CkKDJBUXtWXc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=dRhx9Vg5; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=k4Cl4FVG; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="dRhx9Vg5";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="k4Cl4FVG"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4gwyK91bs2zKvv5;
	Thu, 09 Jul 2026 16:39:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1783607965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gccvbgfpf+svZIfM1dyBRepcYv+RTgI55mHg15KJzOY=;
	b=dRhx9Vg5XMMaNFWJxU6loVPHKXRgx76ulJ4aNmbnw/TFAikPLPvCsKnmoGb6MqsU7MqsRB
	EKvwM7G1PVrbog4awVRT/tb1FXgKSA2EdChJ+wJQzS7y+6kKnTdfTumtkn7vzF3/cLs8v4
	LvhSZwanT2f8ljrcABuR1xbbHykqtM1+dd/hVEoIhpku3DRaLZyYcyPlibysj/mzV9lNil
	3Ay4JvV//zsm8vor4ZDf4l/ZI93upTMcENCK4HvfyZz3Q8gJGABThATGu63UmBlEXRvbGN
	jt71CVnXcSg5viLL4U9HeqW4O9FIPrQU8qd0u+kEW665MDM9JsusGuOg84fd+w==
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1783607963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gccvbgfpf+svZIfM1dyBRepcYv+RTgI55mHg15KJzOY=;
	b=k4Cl4FVGxyhYi+jtAQI3/DLHP5ZVnJxXj9xuIuKtJ1u7CygKjlNHFgcW0iWb/KVhByrXc6
	PEOQNGDeRz115of/FfJQ3wYLZPIFqd5NNKMn8VV32ppf0kQu+drsWqQrVXbYECDYZABeeY
	tP51M59xIT1EzZwYRHxla9UE0oTGqEvEFYbc/pfT7me23CSrzKPxoPjsB9fFG2Vgdk+lQp
	UsaGNE4mjkH455f0C8c3ruC2Py8Prb7gq+578ZFxVdBFyohUXHm3lFdubJnG/5dyG5brZB
	wWLDJlIhGG8vzKaiPYnbg4Kp9GMux+9GaEA+rMqNIMmUT7E9+WrYmdQhtk9XjA==
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Stephan Mueller <smueller@chronox.de>
Cc: Manuel Ebner <manuelebner@mailbox.org>,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: fix bracket
Date: Thu,  9 Jul 2026 16:38:37 +0200
Message-ID: <20260709143837.405758-2-manuelebner@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 78dd1a326d509db60c4
X-MBO-RS-META: 3e9gqk1jxiax9ytow16ok41tk5jgr96c

Remove needless ')' from code block.

Fixes: 3b72c814a8e8 ("crypto: doc - convert crypto API documentation to Sphinx")
Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
---
 Documentation/crypto/architecture.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/crypto/architecture.rst b/Documentation/crypto/architecture.rst
index 249b54d0849f..ec2e99d99aff 100644
--- a/Documentation/crypto/architecture.rst
+++ b/Documentation/crypto/architecture.rst
@@ -95,7 +95,7 @@ additional templates may enclose other templates, such as
 
 ::
 
-        template1(template2(single block cipher)))
+        template1(template2(single block cipher))
 
 
 The kernel crypto API may provide multiple implementations of a template
-- 
2.54.0

