Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0284823D7E6;
	Thu, 20 Nov 2025 01:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763601088; cv=none; b=XOZyjUjz1IqolaQgFIBCUqbTeTbXdhD77c70xXXUpgOVFvyF7Tgd1okityJbBoG8lobqVgH86DWdj7ADfcMENQg2GAhMiHk1egy3Mj+SdY4UBjmA/aWNglADUArN9zsw+zfyBVENCFUAv7nAAO1RlS8XYNueZkaN1Dolx6za+lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763601088; c=relaxed/simple;
	bh=d13wB1VhDml8gwAj8KipKlTFsJa7CZmwHFGQmm8a14E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p9JEiel+lXTcJEgo5No/E9451yTOx07suJIrQ+jZ3z/XguydYQWyAIZhI9213/WLMfL2FjBjfzMBzNZC/Na+6R0AybhOgwvVQLpSIPDflxEMhwoVgmHGKPK+QAxHRXTEpyEymAicUTUOaYcJzwop8LBoLN72BmN5JE/5FmwncdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=gkz0Dswi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gkz0Dswi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991D3C113D0;
	Thu, 20 Nov 2025 01:11:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gkz0Dswi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763601086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iINxSxAnLRAzyy3WNAy880b06nzJMlHl5NriNRsj0LE=;
	b=gkz0Dswibgj0+7X06yfTcFLScvzfyu+M595BPcGV8JBRbpzeful0dh2LlF9G9vv+ZwLmZT
	e3jkVMXoQA9cF3GQr0V9D1TEGIvJ6Bw+ApbxXqFGGcEfQgKCoxYlIrnFblLr5bDPBaiEfl
	LruphDK+H+ixYRrAsSTSqr12qblKpSo=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3114977c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 20 Nov 2025 01:11:26 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH libcrypto v2 2/3] compiler: introduce at_least parameter decoration pseudo keyword
Date: Thu, 20 Nov 2025 02:10:21 +0100
Message-ID: <20251120011022.1558674-2-Jason@zx2c4.com>
In-Reply-To: <20251120011022.1558674-1-Jason@zx2c4.com>
References: <20251120011022.1558674-1-Jason@zx2c4.com>
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

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/compiler.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 5b45ea7dff3e..cbd3b466fdb9 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -379,6 +379,17 @@ static inline void *offset_to_ptr(const int *off)
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
+#define at_least static
+
 #include <asm/rwonce.h>
 
 #endif /* __LINUX_COMPILER_H */
-- 
2.52.0

