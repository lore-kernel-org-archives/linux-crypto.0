Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BE539A80E;
	Tue, 21 Apr 2026 21:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776805595; cv=none; b=T+L04TKgcIalcM+NLfhU8aA2XjdBhAm2+XWmmyGB8+UX/VouuJak4ppQ2ex+rDQD7lsHUn5SISLITE/MmKOXZmiIgYFtTQEv5M5ysz09Kq7pf7a0uiHGbQDNpybOl2FI84XcX57k9EZMyppvxsPJH3fT3L95TZWXA9KZFkdII1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776805595; c=relaxed/simple;
	bh=DC+j36Z9Nq1M5UtPHl1oeB+JG1/3v/YTNJSAk77kbrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbD7ijb63iaWW8MmFv1Ivt1ONH87etYUWgvyHCXzUqXJ8BgiKs/0tea+4mUm0bM6RQ+GYslC9cHendiqg6B+D9fr4Rm8lKhfTnwhjhLlBnw5xmirYsK6j1PokF0A3DTq+87R7DNtm/NKpdES0/WYCthUlFNhANheDgY/fbWqfJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uPr3jA5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uPr3jA5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6A9C2BCB0;
	Tue, 21 Apr 2026 21:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776805595;
	bh=DC+j36Z9Nq1M5UtPHl1oeB+JG1/3v/YTNJSAk77kbrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPr3jA5ReUgXjnrb2/6VG0RlmLBo1sgcijyuAwtYNIh8KAnwkWk1TFOqAEKGbTRTq
	 P9KEvEX50YNUaffBkdEpdfIbXjlhZG9eBUTGQ2dL+MjuQiVYC0G+2ANanArjeW6pIE
	 vjLwJVR70AwCBNsCIj8riJFsuSOWTiFiHYfT7SbApd/XBqLAjomrdOQ/d2QiOaTXcU
	 mvwPdDEphkfiWqwSJfJ6QXULXzvngUYGnbkIpSoFyTRli+Ibp7QX7vGv5dmmGeMuVB
	 7OXIYKVj46g8IZb+vB3SzTG6xoIrEumG8ltEen0PmOVDj9cfI8tBb7cfnSykAvWPZA
	 VnkobszuFK+Ag==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.18 4/8] kunit: configs: Enable all CRC tests in all_tests.config
Date: Tue, 21 Apr 2026 14:05:50 -0700
Message-ID: <20260421210554.36096-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421210554.36096-1-ebiggers@kernel.org>
References: <20260421210554.36096-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 44ff3791d6295f7b51dd2711aad6a03dd79aef22 upstream.

The new option CONFIG_CRC_ENABLE_ALL_FOR_KUNIT enables all the CRC code
that has KUnit tests, causing CONFIG_KUNIT_ALL_TESTS to enable all these
tests.  Add this option to all_tests.config so that kunit.py will run
them when passed the --alltests option.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20260314172224.15152-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
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
-- 
2.53.0

