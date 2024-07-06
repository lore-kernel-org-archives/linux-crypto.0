Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DA5132109;
	Sat,  6 Jul 2024 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720276939; cv=none; b=i3xW8FubZun9i2eQgyEUJbd6LFAo/UqAE+cHL/0rIIcT9QnotKuaGJeBuSRg5cDjrw55DnfYbKhFd7VJy7om2e7fP5SRaVzR+AaOCBVqwe+JKrWmqjU2fLyHase2ZeScsGq50+gVtHw6Nz6AETBgQBItE/U3lII2pMRntk5RoO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720276939; c=relaxed/simple;
	bh=kmaLasBc28PecSN5WaVJ/A5fIQaXdnrZjil/fqE4rA0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MhzAUumw2K2rG5+sg6LHeNCb7FaJBknM5HfAskODdJj7GM9p3k5BSDmuBjs6f28ycposT9dk/gOidtsr/02Zz/7bhtBwyCncpIoBm1vaeWdq9UWn8nHzAA3/anI3EWvJDYGb60mV1xT563PJg39s2ZROCsC2L1QgFyo3jWPOId0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVDy32S3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVDy32S3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D5DC2BD10;
	Sat,  6 Jul 2024 14:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720276939;
	bh=kmaLasBc28PecSN5WaVJ/A5fIQaXdnrZjil/fqE4rA0=;
	h=From:To:Cc:Subject:Date:From;
	b=EVDy32S3vTBtxBzdJU1z+QSG3MJdyXZ/crOKEqBtNmRq0I2ih5eUroyvp61nWl4fp
	 mxVsmcuxZpykXWHXDNVhFzOpKYSr9PRQ60iAf7up+3da7MZMMYUVM1A3+xQXFgwdMX
	 Flu4mlWZ23iJAqBKQYStS4ixsVazAqh8bwK9E3v/jalCzDkd/4jkawObZwaSHnMsdw
	 JsTLl8xqik9TEanwqBkWNhV5qqAu2lZgUwyhT32V6rwh91EEPmA6XcygwMH9n/B6P9
	 jV7KzuPrADsmWtypWiv6lr6fJnbI/yhKcoHY0P9VX5nHAmCvxSTmEZooWfPDtuVtcs
	 C++kuOgGkfPHA==
From: Masahiro Yamada <masahiroy@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH] hwrng: core - remove (un)register_miscdev()
Date: Sat,  6 Jul 2024 23:41:24 +0900
Message-ID: <20240706144205.2301865-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These functions are redundant after commit 0daa7a0afd0f ("hwrng: Avoid
manual device_create_file() calls").

Let's call misc_(de)register() directly.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 drivers/char/hw_random/core.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 4084df65c9fa..29a663db6909 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -470,16 +470,6 @@ static struct attribute *rng_dev_attrs[] = {
 
 ATTRIBUTE_GROUPS(rng_dev);
 
-static void __exit unregister_miscdev(void)
-{
-	misc_deregister(&rng_miscdev);
-}
-
-static int __init register_miscdev(void)
-{
-	return misc_register(&rng_miscdev);
-}
-
 static int hwrng_fillfn(void *unused)
 {
 	size_t entropy, entropy_credit = 0; /* in 1/1024 of a bit */
@@ -668,7 +658,7 @@ static int __init hwrng_modinit(void)
 		return -ENOMEM;
 	}
 
-	ret = register_miscdev();
+	ret = misc_register(&rng_miscdev);
 	if (ret) {
 		kfree(rng_fillbuf);
 		kfree(rng_buffer);
@@ -685,7 +675,7 @@ static void __exit hwrng_modexit(void)
 	kfree(rng_fillbuf);
 	mutex_unlock(&rng_mutex);
 
-	unregister_miscdev();
+	misc_deregister(&rng_miscdev);
 }
 
 fs_initcall(hwrng_modinit); /* depends on misc_register() */
-- 
2.43.0

