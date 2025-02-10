Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8180C204845
	for <linux-crypto@vger.kernel.org>; Mon, 10 Feb 2025 17:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739207890; cv=none; b=b6EoJ22KI9ghGO0Q5srAkhwYSx/CxnAFv/YLuOYS1O7JStqvGnfqJDY0CE0puIAzm9UdAQLashM8DVchgDfBVZhwWVOoVNEcjDcc9HXTdnOzPHh47c3iRnjcsh/JKrRakNaz92RbR2xdV6z9NADv80oHB5YI+BK1bOTQoxb/kGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739207890; c=relaxed/simple;
	bh=V1oTeNAZzqUC0sfug3CF4OzT9P0BAyeF+Kx1b8/iPzg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=X/9Bdg62gk9nOaotn5MRsvrLdkHYv50TTY9AZnEb34/W5ZNwNI0eUKN/vn5feQNtZZxhADIkgFtVehSuml4eE9ruKwjtVQZ6QnTZhXv+ui7UgZbgsZekcnSyEPQkOapEnNOeg3oO8vhAohIXEeN1G5JoiPHeJvcNapOs5/tkJXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGz07F7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGz07F7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F99C4CEE5
	for <linux-crypto@vger.kernel.org>; Mon, 10 Feb 2025 17:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739207890;
	bh=V1oTeNAZzqUC0sfug3CF4OzT9P0BAyeF+Kx1b8/iPzg=;
	h=From:To:Subject:Date:From;
	b=BGz07F7O3pB7AwGy/vrJIOnz0p/iHq0ZWRjSk355WoRc2CM6FTHDYEpykzAXZ/s9H
	 Wy9N9kwvCtfridt9Nn7TzB4/AB/+lXrTnCyOD8l8tHoQFQjonDSM51mUMFg+o52uX1
	 2ua5S/MH7mGRe+UE8b+P7GuVCZnGgv5dLpEXhWb/UTekSlWfex4t2wtoc/bY/RK7U4
	 dGnNliaKsvap6MLz+5ykfHHoVf8RIRFdozQ1F7mz+BXJPs7ZSP50leCaagvcvYCsQ6
	 q9L5NC04HW6lfcU5EXMEWtudhRG3sAYwfuY1eY+K9OOKJKpwjbtE1VmkLceK05OPsq
	 AkSVCtDZ0++vw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: x86/aes-xts - change license to Apache-2.0 OR BSD-2-Clause
Date: Mon, 10 Feb 2025 09:17:40 -0800
Message-ID: <20250210171740.65546-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

As with the other AES modes I've implemented, I've received interest in
my AES-XTS assembly code being reused in other projects.  Therefore,
change the license to Apache-2.0 OR BSD-2-Clause like what I used for
AES-GCM.  Apache-2.0 is the license of OpenSSL and BoringSSL.

Note that it is difficult to *directly* share code between the kernel,
OpenSSL, and BoringSSL for various reasons such as perlasm vs. plain
asm, Windows ABI support, different divisions of responsibility between
C and asm in each project, etc.  So whether that will happen instead of
just doing ports is still TBD.  But this dual license should at least
make it possible to port changes between the projects.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes-xts-avx-x86_64.S | 55 ++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index 8a3e23fbcf858..93ba0ddbe0092 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/arch/x86/crypto/aes-xts-avx-x86_64.S
@@ -1,13 +1,52 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * AES-XTS for modern x86_64 CPUs
- *
- * Copyright 2024 Google LLC
- *
- * Author: Eric Biggers <ebiggers@google.com>
- */
+/* SPDX-License-Identifier: Apache-2.0 OR BSD-2-Clause */
+//
+// AES-XTS for modern x86_64 CPUs
+//
+// Copyright 2024 Google LLC
+//
+// Author: Eric Biggers <ebiggers@google.com>
+//
+//------------------------------------------------------------------------------
+//
+// This file is dual-licensed, meaning that you can use it under your choice of
+// either of the following two licenses:
+//
+// Licensed under the Apache License 2.0 (the "License").  You may obtain a copy
+// of the License at
+//
+//	http://www.apache.org/licenses/LICENSE-2.0
+//
+// Unless required by applicable law or agreed to in writing, software
+// distributed under the License is distributed on an "AS IS" BASIS,
+// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+// See the License for the specific language governing permissions and
+// limitations under the License.
+//
+// or
+//
+// Redistribution and use in source and binary forms, with or without
+// modification, are permitted provided that the following conditions are met:
+//
+// 1. Redistributions of source code must retain the above copyright notice,
+//    this list of conditions and the following disclaimer.
+//
+// 2. Redistributions in binary form must reproduce the above copyright
+//    notice, this list of conditions and the following disclaimer in the
+//    documentation and/or other materials provided with the distribution.
+//
+// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+// POSSIBILITY OF SUCH DAMAGE.
 
 /*
  * This file implements AES-XTS for modern x86_64 CPUs.  To handle the
  * complexities of coding for x86 SIMD, e.g. where every vector length needs
  * different code, it uses a macro to generate several implementations that

base-commit: b16510a530d1e6ab9683f04f8fb34f2e0f538275
-- 
2.48.1

