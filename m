Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9860C3BD225
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 12:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786624829; cv=none; b=Bne1GunD65b2SanW+x7KxAHGN9GEJbBOGVRc8RZc3R15MQS0trX/MNz7iWILJXWWwLwonGTeH/gxiYH2/mARUG8nanGLWR35AtwZwi0+Wp3jpPSjSH++3Sk/dgZWYUrgh9JZv2kPlt8y6o1rhB7PE3IVL3kP8DvCBwFalgSSUOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786624829; c=relaxed/simple;
	bh=kZVXyLyM/GVc2wXcF2xaIfTYMUKFc8zlenZb+6U9AdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jc+v2bNZZnp7KZEpiY1ngLakeGgLfdc57Xn4H+tOXqyCsaSmOUpoonA4O8VhV+NSyxd06z5lJMtjCJ7qMlgsX2i1lBQOisShvqdfxY9fNs5d58yCCIcGBv8tnWys+aZN9k7xdIa8e+WF7NNcxnTUChW/umyijZopZ+xq8yxxtDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jetONqVl; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jetONqVl"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso1841724b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 05:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786624825; x=1787229625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VWg4UYHkA9s33zhrk75mu6M5WGetZ/Z5iOlL+3QXDpk=;
        b=jetONqVlCz20tnbHC4sZyvSD2omZhZF43anKQz0eiunP9GLAHvPO9YlJsWkbCDXXJ7
         8gFAnbxMrBQIhtq1d94hVP+tFF3d2/JC0YhOqXsdJEWyo7SagHETzcHC0H8xN2WxDijI
         cUCmBk0JdAqOLMkfAfZLo3vgPX+KV1N6mi08cRf+ktAJYbNtg3+oK0zL1hEGf53tZFHv
         Ek20aUIB99oRKFfIDHwQBxjRwmJSRN5jTtUu3W/i1GZE0xcBxALAisKJK/gha7Glgfcb
         dM2phfmHPoLFnqy+3jK6PRlheKASixnldI8O470/TLLupQzyyCTDFAVCz+5PpH9RjWnL
         oh8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786624825; x=1787229625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VWg4UYHkA9s33zhrk75mu6M5WGetZ/Z5iOlL+3QXDpk=;
        b=BsmPUO95KHvas3OMzS71csD2ZADAf6enQmnwFS1xyKjlQ9ziXn5gyDfWSrh1dx/mhf
         0sBxbVv1eCJTFRJfyL5DXDGEKpqb8uqQohitTtMhiBpZhHmf+eawhez9g2BYLH4c+2+Y
         103b49VHGC5FLvDr6qHGe6u0zqbRZOBcV+BtsVt7hmKm+nChepEQFV4q4RBuPK7Dott7
         i8KYqd7nZZxpb8DPSNaN9inxUYE4BpZRrpq2eEpxiB0nNdCz1L1/p38y5dfCMpPpEqlX
         Aqz6hMrJTMNRnNzNv8BE6QQsoWLTppzxtMUgcK5DJs9GCKuYeg/Kv5g4sChyzjheGzBe
         slzQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp0OvoQ1PaMwoNiqjdxy2QoVNd9mXlQwewr8p7NdVCgqPCdjY6ivW5vbSvB6GFLKjWnOAF9gBKOXSWdHiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2tPOqU77LLcPB7r2yGhpGY9iN7BMv3zHLYdNYUJ8jVimJyOPN
	CUJaXkMGp+Yqtjkw+gf8BzEWGJ4Zij+PpANpL99w2KZ62oxJ7SYzTz2y
X-Gm-Gg: AR+sD12luJV/NGcfnhThdKg6rE/Xf4Q6HMd0AusJS0H2EGsHH1KnXFxvl74aAOQSUk5
	pkVzqud2/5cC0vewq/Uhj5893GO3JF3B+r4yO3ksa2NjAWhY0VU9TTqTX8VxWAw/uv4syeCVeAI
	6AN3KkKo6aAlaZFGZrhJZ/zyaBjkh27HydD+zBFuH7U441PEl9f+mvCHUd+93OXX1xY8NTTPuyg
	hE7cwa/Wbszz4uKVxCg22HSLEEdgz5O3SfJemSff/IDjr1Q00SjU/B4hk99j3Sd/3XkIL87UiVj
	Zz/W4fNk9dH1DPcAdAVRXtSy0bUjYAYKyAl8eMAk9VdsTrOrCtXISPw3JaSSJXh9TrIW9ePyyki
	NBBZCu8fdGuzrSF0GDcyV9EEmLhBrsSLc8I2MHc1tUerQdvQliGWxTx3HpkeF/5ncMzClTg9Hs1
	Alb0XTJC0pYqYyD1jqEOj19cd4s3oWI0nI+a+bsr19/JtIhQzZ2Zl3Ae/9WbyeiFfSsMBJ+MVwf
	SABU94BEhQ=
X-Received: by 2002:a05:6a00:aa83:b0:845:363e:12d9 with SMTP id d2e1a72fcca58-84fc7492a10mr5851741b3a.3.1786624825151;
        Thu, 13 Aug 2026 05:40:25 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84fc5aaea05sm794718b3a.60.2026.08.13.05.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 05:40:24 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: keyrings@vger.kernel.org,
	David Howells <dhowells@redhat.com>
Cc: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Mat Martineau <martineau@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daehyeon Ko <4ncienth@gmail.com>
Subject: [PATCH] KEYS: asymmetric: reject non-positive restriction keys
Date: Thu, 13 Aug 2026 21:40:10 +0900
Message-ID: <20260813124010.2546648-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

asymmetric_lookup_restriction() resolves the serial in a
key_or_keyring restriction with key_lookup().  This can return a negative
or uninstantiated key as well as a positive one, and the restriction then
retains that key.

When the key has the asymmetric type, key_or_keyring_common() treats it as
a usable trust key and dereferences asymmetric_key_ids(trusted).  Negative
asymmetric keys have no payload, so linking an asymmetric key to the
restricted keyring causes a NULL pointer dereference.

A process can retain a negative asymmetric key after a request_key() upcall
fails and use its serial to restrict a keyring it owns.  Linking a valid
X.509 key to that keyring then triggers the fault without special
privileges.  On systems configured to panic on oops, this is a local denial
of service.

KASAN reports:

  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  RIP: 0010:key_or_keyring_common+0x688/0x880
  Call Trace:
   key_link+0x1e1/0x300
   keyctl_keyring_link+0x6e/0xc0
   __do_sys_keyctl+0x299/0x530

Reject keys that have not been positively instantiated before installing
the restriction.  The explicit NULL trust key used by
key_or_keyring:0:chain remains unaffected.

Fixes: 7e3c4d22083f ("KEYS: Restrict asymmetric key linkage using a specific keychain")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
 crypto/asymmetric_keys/asymmetric_type.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 16a7ae16593c9e..ce78dbc8b8c1cc 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -553,6 +553,11 @@ static struct key_restriction *asymmetric_lookup_restriction(
 				ret = ERR_CAST(key);
 				goto out;
 			}
+			if (!key_is_positive(key)) {
+				key_put(key);
+				ret = ERR_PTR(-ENOKEY);
+				goto out;
+			}
 		}
 
 		ret = asymmetric_restriction_alloc(link_fn, key);

base-commit: 3d6d817622b0a9721e3cc404df3469171582be13
-- 
2.54.0

