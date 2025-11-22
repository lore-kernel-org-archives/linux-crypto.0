Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0103E4C97;
	Sat, 22 Nov 2025 02:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763780176; cv=none; b=eJaQ5FekRIuw5cnbEAs8D6U5yBn91LObwCUGHkcQaTMwA47yZxERju6o5yOcTqEcWP/m0kxZt2hFFQ2Pz++llk4fQ8tZ3o+wWH7iKx6uD5NO3xKGhWlW2QHijrnlkwxURUaf3FsZDGENVRWQgiY5mVqLYPW8YApNnwGhYNi/HCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763780176; c=relaxed/simple;
	bh=GQfeNiyDqiv737IJDXT0mJB2WUgo3S+u2htVmKhLyWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FrlA1oUBeiUPllnUwUSe26VOhhIqCMLSNLlDfdxZZYKfq2XNL2QJTJAk/sAk3EalvN61laBc6kVngilOgjhLbTthlhHaMQs26VJFbLNGJqKSNTbgVJkEIf5UJbL7ztOdWucO9EIYOflolWpfnfxWnKAWUZ92WE4AWtxzlyskiT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=dvObuMCw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="dvObuMCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D244EC4CEF1;
	Sat, 22 Nov 2025 02:56:14 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="dvObuMCw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763780173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0FGZzzn1dkq2UmC+UfXSnPkyPYpT8Gs0eA1nO1PzORA=;
	b=dvObuMCwktzJS1Df42kV+AUtWm04DoWiRuHTbuFi0H/5tpBS7EmfpjdBrvOY2ZqANVtRvo
	PpYSfXzhfvGksyPFKP0Ff+d+FG2xKehe2lKcR+Fpzn2dEeKPp31dwJz8P6Ik31k8VIzuJR
	Jd/vDR1JDymn9qMNG3kvG3sBC4DU80I=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 60911ce2 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 22 Nov 2025 02:56:12 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH libcrypto v3 2/3] compiler: introduce at_least parameter decoration pseudo keyword
Date: Sat, 22 Nov 2025 03:55:11 +0100
Message-ID: <20251122025510.1625066-4-Jason@zx2c4.com>
In-Reply-To: <20251122025510.1625066-2-Jason@zx2c4.com>
References: <20251122025510.1625066-2-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Clang and recent gcc support warning if they are able to prove that the
user is passing to a function an array that is too short in size. For
example:

    void blah(unsigned char herp[at_least 7]);
    static void schma(void)
    {
        unsigned char good[] = { 1, 2, 3, 4, 5, 6, 7 };
        unsigned char bad[] = { 1, 2, 3, 4, 5, 6 };
        blah(good);
        blah(bad);
    }

The notation here, `static 7`, which this commit makes explicit by
allowing us to write it as `at_least 7`, means that it's incorrect to
pass anything less than 7 elements. This is section 6.7.5.3 of C99:

    If the keyword static also appears within the [ and ] of the array
    type derivation, then for each call to the function, the value of
    the corresponding actual argument shall provide access to the first
    element of an array with at least as many elements as specified by
    the size expression.

Here is the output from gcc 15:

    zx2c4@thinkpad /tmp $ gcc -c a.c
    a.c: In function ‘schma’:
    a.c:9:9: warning: ‘blah’ accessing 7 bytes in a region of size 6 [-Wstringop-overflow=]
        9 |         blah(bad);
          |         ^~~~~~~~~
    a.c:9:9: note: referencing argument 1 of type ‘unsigned char[7]’
    a.c:2:6: note: in a call to function ‘blah’
        2 | void blah(unsigned char herp[at_least 7]);
          |      ^~~~

And from clang 21:

    zx2c4@thinkpad /tmp $ clang -c a.c
    a.c:9:2: warning: array argument is too small; contains 6 elements, callee requires at least 7
          [-Warray-bounds]
        9 |         blah(bad);
          |         ^    ~~~
    a.c:2:25: note: callee declares array parameter as static here
        2 | void blah(unsigned char herp[at_least 7]);
          |                         ^   ~~~~~~~~~~
    1 warning generated.

So these are covered by, variously, -Wstringop-overflow and
-Warray-bounds.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v2->v3:
- Added Ard's ack.
- Conditionalize macro on __CHECKER__.

 include/linux/compiler.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 5b45ea7dff3e..a9356b158d33 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -379,6 +379,21 @@ static inline void *offset_to_ptr(const int *off)
  */
 #define prevent_tail_call_optimization()	mb()
 
+/*
+ * This designates the minimum number of elements a passed array parameter must
+ * have. For example:
+ *
+ *     void some_function(u8 param[at_least 7]);
+ * 
+ * If a caller passes an array with fewer than 7 elements, the compiler will
+ * emit a warning.
+ */
+#ifndef __CHECKER__
+#define at_least static
+#else
+#define at_least
+#endif
+
 #include <asm/rwonce.h>
 
 #endif /* __LINUX_COMPILER_H */
-- 
2.52.0

