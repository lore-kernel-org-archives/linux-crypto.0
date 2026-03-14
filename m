Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430BB225416;
	Sat, 14 Mar 2026 17:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773508990; cv=none; b=PjC+N6ThqRJxqIfKbJg1/gA0vZ2g2xA2GKbFXYKtspeSeEsNQUKOsr//ftk7SlQ9w8B6TCky6aSYyOBY5MP2b5XrcCCPSOuY/vjYGs2mG362qNi+KMtE/oxbMs7amoeXWXpuuZ6d8gBSuFGnDvmx5eEjG0Ds5hdhRRrJ3W2T2Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773508990; c=relaxed/simple;
	bh=4cOsk2lY3LTa99G3MdQoK8BC43EoIInJQtYTcXWnq14=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u9xVX3APZ/J0XMutxu/WbqMK+DLGQNZ6xcgebpEzRdN2Jx3THG/GpOHTw5LDSbzgN6YiVAhHZMtVuyivMXCJ4jitYoElVCfP0FHdwerkVJ8XySHcVaOIVZ5tzU2yijJ6YwGOVP+xcIpD5ynEEO3qLKbI9LWcIib8uYOmy7sAjVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h1hWt8o2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h1hWt8o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C13FC116C6;
	Sat, 14 Mar 2026 17:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773508989;
	bh=4cOsk2lY3LTa99G3MdQoK8BC43EoIInJQtYTcXWnq14=;
	h=From:To:Cc:Subject:Date:From;
	b=h1hWt8o25JhTlc9+iQlsh4UHlNfkHPNACt8lVPimCq+SxVVQieQ82KUyd1o3Z0OkZ
	 UPrKKJ+uqM/dwCZuYKkHBioH8wTEW6OKFRs+VzoM3xMvKvCrjFjkaLtGE/BkjHrSNt
	 6u9vrwyGPIEyzMIZJVHNKOWv27GpMaedY1oJL7yepGYDj/CFkAceiCilOnng6Oh8y1
	 U7Tp338idhWi4gi1ESgnDAQzXTahh+pxOjJZXRZCv49jMp2hf9PoubieApBPRwA61E
	 cJXlXuz9hbNF9Gci05Gmch2ZrLBnUlK0Nivf5Vs44VDMtNFmZI7wz7Bzqgs7vlV9e4
	 72ArQjSpTKz/Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] kunit: configs: Enable all CRC tests in all_tests.config
Date: Sat, 14 Mar 2026 10:22:24 -0700
Message-ID: <20260314172224.15152-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new option CONFIG_CRC_ENABLE_ALL_FOR_KUNIT enables all the CRC code
that has KUnit tests, causing CONFIG_KUNIT_ALL_TESTS to enable all these
tests.  Add this option to all_tests.config so that kunit.py will run
them when passed the --alltests option.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting crc-next
(https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next)
which has the commit adding CONFIG_CRC_ENABLE_ALL_FOR_KUNIT.

Note that patch also mirrors
https://lore.kernel.org/linux-crypto/20260314035927.51351-3-ebiggers@kernel.org/
which does the same for the crypto library tests.

 tools/testing/kunit/configs/all_tests.config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/kunit/configs/all_tests.config b/tools/testing/kunit/configs/all_tests.config
index 422e186cf3cf1..c1d3659a41cf0 100644
--- a/tools/testing/kunit/configs/all_tests.config
+++ b/tools/testing/kunit/configs/all_tests.config
@@ -44,10 +44,12 @@ CONFIG_REGMAP_BUILD=y
 
 CONFIG_AUDIT=y
 
 CONFIG_PRIME_NUMBERS=y
 
+CONFIG_CRC_ENABLE_ALL_FOR_KUNIT=y
+
 CONFIG_SECURITY=y
 CONFIG_SECURITY_APPARMOR=y
 CONFIG_SECURITY_LANDLOCK=y
 
 CONFIG_SOUND=y

base-commit: c13cee2fc7f137dd25ed50c63eddcc578624f204
-- 
2.53.0

