Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D6B15530C;
	Sun, 23 Nov 2025 05:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763876963; cv=none; b=p+jhmLcx6kMYXa34RCz6eMRk39MsJU+rhKxywhKexAbIfMUCa8GqIyRorBTWVpJwvhyR42LuyPaUzEjX4gxI78yyM0J+vMZfSHlvygEu2H44kLrZzIzX1o9umOvu7QvXKTxsUj8FtlMRU2U3BT8pATgyNyEWG3xrD1izUxYGvmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763876963; c=relaxed/simple;
	bh=fClPLgaPQFbCAjnybbu56E9nzodus5H6s3YsUYe7zvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cbSdHl3xfylwObQ8KczbJrkqnZpt3fZu52d0yfQMQjlBcjOT/MIIXlDUbO6EicyeqogCCH0jt3xwRUEeT7MjlO+rtKKC/RhnCgAsj2xKdkXVmOazh8fEtiTbYHR3q6WsC7Wu7QXqcfbYSUmoPv6vMbEu5YCezOMH5EUIwgMMKQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=T90MP66o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="T90MP66o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB28C116B1;
	Sun, 23 Nov 2025 05:49:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="T90MP66o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763876960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=18qXA2tU37k5YWiheu9rbDUZYN5uyH72PwmZEunmaBc=;
	b=T90MP66oeYVLiH06ykZTpEOvuNxq8q7mkJtgxZn0ttTz2uvg7aoy0VfR1z4BawZaoc/H0R
	IOPKzFzp5Px0oTiEjWhEZxi0c+2L23cF3vWwJd1YYHKv9T1HjB8puFPNLDkMgnpPACSEzx
	cGGC6Zrg9fvU5KNkwNvHGyWbsDJBK3o=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e985aa43 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 23 Nov 2025 05:49:20 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH libcrypto v4 2/3] compiler: introduce at_least parameter decoration pseudo keyword
Date: Sun, 23 Nov 2025 06:48:19 +0100
Message-ID: <20251123054819.2371989-3-Jason@zx2c4.com>
In-Reply-To: <20251123054819.2371989-1-Jason@zx2c4.com>
References: <20251123054819.2371989-1-Jason@zx2c4.com>
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
Changes v3->v4:
- Move to compiler_types.h

 include/linux/compiler_types.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 59288a2c1ad2..51f0dccdb54d 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -394,6 +394,21 @@ struct ftrace_likely_data {
 #define __counted_by_be(member)	__counted_by(member)
 #endif
 
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
 /* Do not trap wrapping arithmetic within an annotated function. */
 #ifdef CONFIG_UBSAN_INTEGER_WRAP
 # define __signed_wrap __attribute__((no_sanitize("signed-integer-overflow")))
-- 
2.52.0

