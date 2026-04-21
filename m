Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8C539A80E;
	Tue, 21 Apr 2026 21:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776805595; cv=none; b=c0cWpv48EuGD9SIDk/+VP9bzMTMAwvXzmzth02JV9p0/bUOGrEk1SGfYC1YCJf29y44jbkFlKgpvFG1CpOmQv8j6tU8UFANEh3OYHhdm2X1PySlJ3J/2PR6q0MUoPjMTkB7Wl7uwGYD9uaZiyHOOV+ZHQmK9700apyg7KyjXWWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776805595; c=relaxed/simple;
	bh=89HlTdVmwqhIWOEWRxLYQTfdZYwTZpcS32dM+ACP5d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxTrM+8o0S5EVWsq51qXpTessEdHHxpxEvBpaF7qo8zGumCWzFDtnhe5MLtdn4WUv9BTBUCt/7cUBwPkbQpazsbg/hS6CXGogFB3ecFmOhQWIPXBad2yjg7inmfE30qOCDgdiG/aSuqOIo05nK/YXMWEKrdRN3m1nnrugk+PRmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qTl8sRa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qTl8sRa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1E8C2BCB8;
	Tue, 21 Apr 2026 21:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776805595;
	bh=89HlTdVmwqhIWOEWRxLYQTfdZYwTZpcS32dM+ACP5d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTl8sRa0msjOCNb1tonVMirQXijDqt5Jid/BenlsAnKK/dif4r7BCPV6wAbNwSMpc
	 uoUQuUx9mySao0MBY4+06nxQIIMzRAhmUkKWtdUYQ2P75TLML9i7bhHXtwv+13Hw5C
	 h/ycuJJMg6rmr3y4drCR69swL/ntcCqtfB1WKPKJgYiAspb37HNq7+r2gakf2KzR9E
	 ax9OmD9D4KkkTt6kf7iqv90dB8P07WGlYE2Ijp4iotJWiMoAFWYv90n5Amu9izkdBj
	 9n/doIJBdhm4jjwWbK1cf6cHG3m1YwSaJNf3XKS9OikwNMujfwin7sOavkERYQk9RD
	 VB/m/WA08ypsA==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 3/8] lib/crc: tests: Add a .kunitconfig file
Date: Tue, 21 Apr 2026 14:05:49 -0700
Message-ID: <20260421210554.36096-4-ebiggers@kernel.org>
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

commit c13cee2fc7f137dd25ed50c63eddcc578624f204 upstream.

Add a .kunitconfig file to the lib/crc/ directory so that the CRC
library tests can be run more easily using kunit.py.  Example with UML:

    tools/testing/kunit/kunit.py run --kunitconfig=lib/crc

Example with QEMU:

    tools/testing/kunit/kunit.py run --kunitconfig=lib/crc --arch=arm64 --make_options LLVM=1

Link: https://lore.kernel.org/r/20260306033557.250499-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crc/.kunitconfig | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 lib/crc/.kunitconfig

diff --git a/lib/crc/.kunitconfig b/lib/crc/.kunitconfig
new file mode 100644
index 0000000000000..0a3671ba573f0
--- /dev/null
+++ b/lib/crc/.kunitconfig
@@ -0,0 +1,3 @@
+CONFIG_KUNIT=y
+CONFIG_CRC_ENABLE_ALL_FOR_KUNIT=y
+CONFIG_CRC_KUNIT_TEST=y
-- 
2.53.0

