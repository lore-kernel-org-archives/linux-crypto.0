Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0508836CE1C;
	Tue, 18 Nov 2025 17:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485388; cv=none; b=EmV8BDWVYclQeajjnYH7M4Pst9QwrmMLx6YimJsQlKvCY8KdbP+8exVv8bExpvxDHUJGDcLk13hS6X7yJKv2e0N3PV/O4uydNdLfR4WVGAswKAKFZ9Fd3fNLoiqqdIoUF3hX7QkHon+IuQb7ElUzNutLdtwAmY1rN3MzrHdNYhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485388; c=relaxed/simple;
	bh=FuYoqguP7bcYpyCkSan1ZcwKcNavEG6ckSTFvvv/mhM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eq+xWCDq+QRZSe9JdbNiWxAgYOeSuxAkUu8iFNYFtI4/cSu9PqtYug9WPq+SOXJFXrHDG1MeDJlA/ihjsxkD3uva3jVD5NmtFVUClKA9ahb3ZMoLWhdjA/1sQAiWVaRUc19O3PK33jlAwLJQvFRt+sQxgqRV0/VY57pohwihcVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=BzxA53fk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BzxA53fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34986C116D0;
	Tue, 18 Nov 2025 17:03:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BzxA53fk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763485384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9+57XdN/Gbe2F3qKJBw0ih4kdK6TNvPjlqGo0bVtGjs=;
	b=BzxA53fkwoTRFr+Uw5eOPaBfzaiJhoxFzS/tPh5owdd45rQQtwJKU29KlXis7l1h9KExng
	L4MHe6YTZRYBqq3zMk2Xfhs6KXQYjgz9B2qzhglgvNYM5V17PUlGKtnG2L+Jz8fMNiPfWB
	m79RKzSp6JiORKRc2YfZN0ptAjNkA4o=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 405181d5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 18 Nov 2025 17:03:03 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH libcrypto 1/2] array_size: introduce min_array_size() function decoration
Date: Tue, 18 Nov 2025 18:02:39 +0100
Message-ID: <20251118170240.689299-1-Jason@zx2c4.com>
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

    void blah(unsigned char herp[static 7]);
    static void schma(void)
    {
        unsigned char good[] = { 1, 2, 3, 4, 5, 6, 7 };
        unsigned char bad[] = { 1, 2, 3, 4, 5, 6 };
        blah(good);
        blah(bad);
    }

The notation here, `static 7`, means that it's incorrect to pass
anything less than 7 elements. This is section 6.7.5.3 of C99:

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
        2 | void blah(unsigned char herp[static 7]);
          |      ^~~~

And from clang 21:

    zx2c4@thinkpad /tmp $ clang -c a.c
    a.c:9:2: warning: array argument is too small; contains 6 elements, callee requires at least 7
          [-Warray-bounds]
        9 |         blah(bad);
          |         ^    ~~~
    a.c:2:25: note: callee declares array parameter as static here
        2 | void blah(unsigned char herp[static 7]);
          |                         ^   ~~~~~~~~~~
    1 warning generated.

So these are covered by, variously, -Wstringop-overflow and
-Warray-bounds.

Introduce min_array_size(), so that the above code becomes slightly less
ugly:

    void blah(unsigned char herp[min_array_size(7)]);

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/array_size.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/array_size.h b/include/linux/array_size.h
index 06d7d83196ca..8671aee11479 100644
--- a/include/linux/array_size.h
+++ b/include/linux/array_size.h
@@ -10,4 +10,11 @@
  */
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
+/**
+ * min_array_size - parameter decoration to hint to the compiler that the
+ *                  passed array should have at least @n elements
+ * @n: minimum number of elements, after which the compiler may warn
+ */
+#define min_array_size(n) static n
+
 #endif  /* _LINUX_ARRAY_SIZE_H */
-- 
2.51.2

