Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795753137;
	b=vw/RJmeGP27bytF+FRIINLGC+hxdYvgQkdQbtoe67HaOzkfai8zzcczAM3DKg0kbp3pC
	 E4sJux9ZsyQrgIFmFPvpUFk4XpqGwA+k3eoXuyutqQVsT52Qi9ovjiQMYreeQhXTV5SXG
	 8AI4+kn5Wy/Kgfg+J84SuEeWx1CXk6A5UeNBXDVj/Y4K3Q0rRipVzzoNf8rIYl4CNxWrM
	 caN28LVVqEszQtJ/2DVxVb25S2WrJJRxuEkDC5PkhGeonlyJLQRlJ+b6Lm/JwWZiVhPcf
	 tvNnUEaM7iDKMaRZSobQv3VgaPZMF2JieoYruCHkv2W5wkWVTnF0gdJHD9PPrOsTUzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795753137;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=93YINut3KE5OztbS+NDPfxjifdfR77qYaLTwskp1sjA=;
	b=zRDsu8sQQ2heRXYNJdPyy5nQ2owrysd1fF1dQMjjJWiwMN3/t2oJ7VTdz5ceQjh5Uv/z
	 GDI4GNhQpLgHvonw2E8PZyKfRNSqsx83If/Rfe6mXlQTblwRo1/xXoppOnOZ274XX86Uv
	 R4a7XgtbxauyQA1usH/HQ3LwSlQDSW6mpvv+O7dbo6cD5pWLWMWsojja7yBBPY1CAuO6W
	 8Lv/KBoE6DKRHLFOlT6ZrFiuSXjZx4P031gPi1gWDAtCHkXUkW/2XUXfJF3bjffjQBPPu
	 KEJrogRkEWXYGjOHaj7JVGIWQ2yaxAaszf9+G1ThHHt7wlUDculggzXsfirbNmLf5Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KZIamYWu;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13475606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:18:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13475606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KZIamYWu
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cde5a7d7849so3333955a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 20:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795753136; x=1796357936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=93YINut3KE5OztbS+NDPfxjifdfR77qYaLTwskp1sjA=;
        b=KZIamYWudgLOaRsKoqqyDFI8ih6B/PwA45hiEyepNUmZ0Y8HlIe/rhfBjb7D8KUbWY
         fFuYxERH3zxGt0ZoDOi8NUzEmzLsMcttanbdG4P8Z+WnPQtgBF3fDbzbDg50Upl4XYTq
         y64ktzqAl3fqKpTZja93M2PobdoXDX0XgOkH/7grUKWf/sJFaMEG7N1BT16XNRPDnbAz
         6vdzGTiEN7su9ZgThwVOS2RGckGREbia60tiduJxWnSoiF/Igf1ObK83gO2OhEJReSCW
         C07J45Xm8yu7LaGBsGwumChXHegUmLsXEBbDd+ec2++CL/rIVgqPWYVZHhZ86u84SdGY
         2S2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795753136; x=1796357936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=93YINut3KE5OztbS+NDPfxjifdfR77qYaLTwskp1sjA=;
        b=WC1QcfpPYQekuYsVvZFMuINgrwTghvZd6UitDvAzvpOgqPb8P+9kjBuAI1q9r1I8X7
         EFUqrcmUw2Az67zL9jghlDs4ciHzcoFqjSCnqZXuGDAd2dCw0qpDXTJPCI4s2P1JA7Rl
         B/kGYYQ4VpfjObx39zfA9y7xDZA55+psZdGxiPu2Bryb0ZfQ1dctgkfHlK/MPMRJIUPp
         Kl0/exBZG3VRT9MuSsulXlVXWiL9tL4b3LsGwg2oSXg5PYtz9eCRjO8GfJQnbLRY5nR6
         NYxpuZaKIS4Jpf5ZXA3Ghq1mawZ7qIuPR20Y+Gv0PXjhU2OYbeyoRykR0tKFwmWzVDpj
         AzyQ==
X-Gm-Message-State: APuU4Z/mx5v8rGCf5xc96TshQRkMLWeq9jW4nT+YIpJXdZJDGWh7XhyZ
	1pC3AH+AsVbdvMVY3RYLpWrqgGdyVqS1qqpgEb4PNvtFJfNh5GQ2JDWU
X-Gm-Gg: AZFdTZcQlNd8zELr3SvnxNYfqmjHnBwwG6FzFto6q+pxKpmvOO931ddqmuBkbX83Bw3
	P7NZGyQJ7OtbtcrkfIS+YxAZK7ZbYKijs4ptZHsg9wWaPjqYt+tagK0Q+XM/Xn4aNhshAEgdbrU
	z4RyPJMkxqV9TLVdQyXwtXt2HZsjBTcUVgZ3pdeIHLXLbrnYCZ2PBetzSbCQifqub70xEKys8LX
	R4S5MCeq+wWk0SNs43HaGGJcJWNgSlEjP8zkV6KRzELUaTnJ8K4eu1YI8DUvnVdX8/AB+7CIa4P
	le4SqRkAWWfjgGN6Mb1rNjS3tSP2f5AoeMpOt7UBZJzF1lKIlj/4UqsJ9nW98dyuZImkf2ciryf
	0ilh7v5myoYQ6+q46C2Eypz41ieRJKYobRTkFD9fMWhFgU047D2juQkL0hvNsjxB+rf5WNj8046
	df37f49ftlWNFcWTSLQMnks6dYRfRkdc+gVkcjGZcB5XNctbFB+2P3BsZw+S6X5zIn9vXuFLhRm
	kqsa0GA+ZrhyggMpRalwrov78kboMhQ+lEJ8KpXNWH8q2uecUZbGjKOPXIOZYnaTQs3MG5hZEtG
	t0NfMvEEwVH6gjR95dSq0W/tJzZmnE9aZW2CLL6AwanXJVofyw==
X-Received: by 2002:a17:90a:e705:b0:3ab:1b1c:8a70 with SMTP id 98e67ed59e1d1-3b41c938d83mr20435234a91.38.1795753136343;
        Thu, 26 Nov 2026 20:18:56 -0800 (PST)
Received: from fedora.tailc1fb0a.ts.net ([172.219.65.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad46ef5sm36000501a91.8.2026.11.26.20.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:18:56 -0800 (PST)
From: Artem Novak <artem122novak@gmail.com>
To: ebiggers@kernel.org,
	Jason@zx2c4.com,
	ardb@kernel.org,
	stian@itx.no
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Artem Novak <artem122novak@gmail.com>
Subject: [PATCH] crypto: sparc: remove trailing whitespace from AES assembly
Date: Thu, 26 Nov 2026 22:18:53 -0600
Message-ID: <20261127041853.127855-1-artem122novak@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the trailing tab after the key expansion label in
aes_asm.S.

Signed-off-by: Artem Novak <artem122novak@gmail.com>
---
 lib/crypto/sparc/aes_asm.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/sparc/aes_asm.S b/lib/crypto/sparc/aes_asm.S
index fd90b129972f..0ddf181f342e 100644
--- a/lib/crypto/sparc/aes_asm.S
+++ b/lib/crypto/sparc/aes_asm.S
@@ -293,7 +293,7 @@ ENTRY(aes_sparc64_key_expand)
 	ba,pt	%xcc, 80f
 	 std	%f58, [%o1 + 0xc8]
 
-1:	
+1:
 	/* 192-bit key expansion */
 	ld	[%o0 + 0x10], %f4
 	ld	[%o0 + 0x14], %f5
-- 
2.56.1

