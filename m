Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBFB3BE165
	for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2026 05:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789624619; cv=none; b=IWKWrvjDz8kWCizMutQ1F4H8+IK9dlhnK0csckUug69cums00Hge4DBwjRHibiLz6yM1Fe7+B8OIZLcD2YbGSEcWRLPcKoeZ9zRtOVdicP7RbsbaYAcc4pxCInIzdxxJBFImkw+HIsFsYIGMzkH22ylPcs5w834u+u6gYHOW5HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789624619; c=relaxed/simple;
	bh=axjKGAd5Z/3bPAjXWt5In13wd/F8lTzuocyx1Fp1oag=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Nr8uur3BDwr5cJQsDytdB0CNBZfLJwSqWwNmOO560z8pm9ILw4X4GJolBT/luBEQULdMpJts9vkgGNx6gXC9vzavI4VyvkUidxuRfcbX7Wqyf687S5UrBHtoSIIfwvsFIrBzInIYsZusmJ+SK32T+3lAzUtWWrr+vNHkfrk7GN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Is5sYCTW; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Is5sYCTW"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d391aso3170545e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 22:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789624616; x=1790229416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TXa2jqQKkTliyGqricPHkYJ8GTisx6eCrgeiQ3lmh5M=;
        b=Is5sYCTWeKu+bYQiM7B63cAOJ4NXKZMHIlOUp3yaK8FDUJ1KZcoqjSR1X/xWKwnM1f
         jVroKGDczKboO785tS2sjWOQFbNE27Vamk1fuf3HV83H7xU1UTPEJnWuiEwcSi2gI+hO
         IBfCWz7SPEcShWvkoND1vmR4cBDHVVNQhDz1JDn6eBTMKsPOhe0bFyYCKgMjMspmipwB
         Fa+fMNzl6fijGcFfsRQ/XBNuLIYcggAY7cSPhNoXTRrMoKywa6hAUstG8EDxh2QhjM8r
         Jv2F8MldT4XWRNOTczerGxCD4Pl8fKHSk+kB5zf0IqPMm41uHVc/NfkH/0RR2n98lSQv
         kRYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789624616; x=1790229416;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TXa2jqQKkTliyGqricPHkYJ8GTisx6eCrgeiQ3lmh5M=;
        b=ynB8Yw3pKiuYAY2ofyF2VkOnXwssjhsyym/vK09QZp8t5CI9xXjbNXlHRZT3KXrSJ7
         Lr2B8BpuJxKgvSl7jzk0MG/oE+zWiwv/19NKZcF0UY5/jkPdbCLTALRXQ3okYZPniI1q
         kKv9hXGmzHP/4o0/5vqM1CX1kPEAaGpC98go54VBc+YZhYxjBXgpEAt2svtM6lLPYlaf
         bqvRlE0FspwB1qEdrTq3329+Y5786y2HAlUTrAYdO6qgGUfodrDQtXxYDHWMpHgbKuwy
         geXfYvOcyZiD8guXutrZuGWDJlg7bNLLXj0VQtDNRui98BmsjTLtvts0SxLs8djQPPr4
         9FaA==
X-Forwarded-Encrypted: i=1; AKwUvBwxqPkwskWQxultMxEoC55doJyUBTAq95zWWd6q7m62ZL0J0r2GjjQaqxtZmr8RP/l/0C/aK130aY2tUZ0=@vger.kernel.org
X-Gm-Message-State: AFuF++kYJ2jlGVHt6aPJoBP809+BfCjt83fM72nBqn/Ojp2uy+QiRPwd
	8cETMMNUOOMuorYp4HXcRXWKlndHsSRLTLaN89MphfatmIEFHkspPTUO
X-Gm-Gg: AYBFou1XMBgE9UUl3QxGYHFRbMIb+c2lmPR/kVkC7Vcm3stIHFcJZf8zTRY2JuCUOFt
	LQlaGQ/XTu2aVwGyDJpNDETAZgreeRUI3zwM2i0TdPbceAamGRZ2QNFrep/X1rzmvITRPfg8Dki
	NOlMV/VrdmId57luPpbKDT4JEw4CMiRmd86qbABa4RBR3SCHxzmkdvZJutCGrFHiQUrBtYm0fe9
	N2T68OxpjJTIoisih1By9iiERDD6Q6+u+YWq3VcaBvii2nXRudNgwOWra0FdoxQorng7F/6soIS
	uwWYsvIPu6k4PpX9EWmanhZJhiNFbTCHIBgMXq2pPIEHguwZCNRSNf2omtMa7XX5ebG1pfJNJEz
	TYj5/cG8qCOnpOT9RwepNwtJl+MMVopiVn34NeBj1KW2DydeKQCATRQbhmXGAOUi9rABxppmcWR
	reGrPUaiUpalbCIx5yzhEd6G06QpP9yeNMxpoEdZkVxiu85GO48hsrSIdp3XFcZv5WNBzKJq8Sw
	s6AjW/2xTXxLzzIzTugKPjAOx2F33JPdXUtL+MmmxsrKQBOpPqnzaHsdimPM4x4DIko27+Dwnv9
	sYpki9718yR6Jv+8NfOeALD56YdZ9MazxBdzGWurHS84K5IUo3MN3ZWsyTlgRoeG7B/3XEMGS9o
	I8miEcGIGAMTcshzJiDIcenb3DQ==
X-Received: by 2002:a05:600c:c8f:b0:49c:fc6c:be15 with SMTP id 5b1f17b1804b1-49eb733c62dmr64900215e9.27.1789624616385;
        Wed, 16 Sep 2026 22:56:56 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-9dc6-c001-54ee-4741-4927-0a28.310.pool.telefonica.de. [2a02:3100:9dc6:c001:54ee:4741:4927:a28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e847eab65sm76230685e9.2.2026.09.16.22.56.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 16 Sep 2026 22:56:55 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Haren Myneni <haren@us.ibm.com>,
	Dan Streetman <ddstreet@ieee.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.com>,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] lib/842: depend on the decompressor for KUnit tests
Date: Thu, 17 Sep 2026 07:56:45 +0200
Message-Id: <20260917055645.26780-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

842_DECOMPRESS_KUNIT_TEST selects the decompressor even when no other
option needs it, including through KUNIT_ALL_TESTS.

Depend on 842_DECOMPRESS as required by
Documentation/dev-tools/kunit/style.rst. This also prevents the test from
promoting a modular decompressor to built-in.

Fixes: cca072cb1423 ("lib/842: add KUnit tests for the decompressor")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/r/CAMuHMdVcZ5cV4-HrjLYfFKh6UshiVxq5eXCNyp0Z1k_SMAvF5g@mail.gmail.com/
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Follow-up to the accepted commit, based on cryptodev-2.6/master.

Testing: Checked Kconfig dependency resolution for eight x86_64
configurations before and after the change, including KUNIT_ALL_TESTS
and modular/built-in combinations.

 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 48201092b3df..49f74005394b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2228,7 +2228,7 @@ if RUNTIME_TESTING_MENU
 config 842_DECOMPRESS_KUNIT_TEST
 	tristate "KUnit tests for the 842 decompressor" if !KUNIT_ALL_TESTS
 	depends on KUNIT
-	select 842_DECOMPRESS
+	depends on 842_DECOMPRESS
 	default KUNIT_ALL_TESTS
 	help
 	  Enable stream-validation and boundary tests for the software 842

base-commit: 9e06d371730b841ad8fe79ebfccf0def9470201f
-- 
2.39.5 (Apple Git-154)
