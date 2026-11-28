Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795840856;
	b=EQ1sq7410w0nYv7YP4FuOTVVEZK27UaWLv1QUOU8bPkFXnN1wprLIRL810fzzvrMpMBA
	 Lzotkzh4Rs0/eAKngjPb3wtSMCESsi9TLCCj4+/goiAWmY4C1XzQICAkgh1mUXuY7hDvW
	 B5VEUIVix7MQtkK1nCWR1UmEuWzHdnwuXbNzMQfztd6lV++fExux/8S7cDz5OC3Mr48mw
	 d/H7P7xCP+RUjgHQGXk2DjT0yMpimxBEFNbfnzGC53kOwiykRy+TxIbkqI2teamkcZK+2
	 vgt4G4rxgtUK3C4DB6vlTKe/PJJubKfzJZApNRhwequDemqFg2DFhxK14ATmUqyKnRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795840856;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=G2gW943aPxIkGmC/mCym/SSE1QkZf84pbYDIvYJaQf4=;
	b=GZzp3H8tW9evl4vEU0eXxuA5j25cHx8vecFT9pDPia9wQxdCr4mI3MfMtdc3qc8gMzXf
	 6m9omEE1YhBGUrQH3+eDdz9HJXDSqxkP7rSlfL+fPZqN2yChOTwftDg5QLmZ8MQnLqn5R
	 JePi39BlidLy3jaOghWS8eyyL+22rOyIL7RLMBwvYHz5ASkp3HsI4Kz+cgA9jJFpkljzL
	 1yUmxHzKeV8jCIOgdYtU4uHlSaoMK0Sxs7wFE/L+IQ1fZmwV5ckbA0MVIC8kwxuqJaS6G
	 ySzLL/trMYQwERjxA/56ycoaCwh+l31RLaH5Nlo7E3IM3tp7bcEXgxUBTItlQKeh08Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d5hu86Kg;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFAD606A31E
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 04:40:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDFAD606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d5hu86Kg
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b439e37813so4567252a91.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 20:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795840855; x=1796445655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G2gW943aPxIkGmC/mCym/SSE1QkZf84pbYDIvYJaQf4=;
        b=d5hu86KgPNihIvXZrBnXdkf7jyn3/R3dmEdHid8/gqaqw0AzYDNzzOUXE10A0lapfc
         UNGxBUZmp1fSP/lb9geX/K0ehWnCCozjcc7frLFoC9drKhgVuD6kzfdpk3iLxzrK+iF9
         MrY73AetswUHnFHFQl5SixRfQ7Ca8kMrqMGx2LWnrWteulR0/0hMNKoGz+Lhmiiqbu0z
         LMUzTCw2VfoL+mJ89HH+qs4yOcJjfU3MDCLxgEomaP8yhKuhDXIrUHSgM+p7Mw2reFpr
         lU0fb5LVS78gGoxgTVgaPBdiwGubtS/LWurt3kWJzcIenCtU/MsMrXGwHF0AQQlsXDMl
         TlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795840855; x=1796445655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G2gW943aPxIkGmC/mCym/SSE1QkZf84pbYDIvYJaQf4=;
        b=nd2ew20qMWfEcMkZ3l9CgYdFO8XnlpII+eew7GM0soZa4vh+FX8zvy9bB2Ju87aD78
         O9TV4CA98qytTNb1dqQbDTXIUDzsRo0dcFpz8SZF18KcPl70xzKXWmu3MUMuZGPWynko
         od8+iRxG+MrEfu8JI8n22a5MGKtcnpXx0W/aqeUPHqpEkhLWA5PdT3M3JTFADk127fyE
         pbcbFZKfnhtq1rqtYp+wmNdQ4I1qjU9D14NeuL74Fm519qwaIy9oEJ1QYGZLLem4W2nS
         SnU5COKMqklq1G3hbP6QXYumiajkXQX0JZnNckOV0dWSrK98Qyq28fOgkaA0sCTudlLP
         YFEw==
X-Gm-Message-State: APuU4Z9vgbGe4NBaf0UQgc7i6ZcabZAfT6QAW57sUfsHO/G7LbnVD4gO
	dWNS7TP8lVpKy2Afk5P0PoWJByIS6q4WjvEdgdt/vZIuq0y7jZ1n2Xv5H3Q0Gw==
X-Gm-Gg: AZFdTZcLPUvISDWHwdf7tgKhKsUC8Bb3Svd7lKjIJySuWX87A4YD/dI6vhjOFp9uTsj
	Op18pIhyRZwB5n87FmTHm0YIlqWSOBk+dS3VhgAkmPuPAfnjgQCzn2NwpiUq8gPah7zWE4nfKBn
	xGyoEY1X5Kq0sRWszmmlpU11azk+UxNTkPAQMVmZuyEwODWowxEwTUo8MqGXNZrO4JrNvYm7vRN
	l6MYYnQgjkTTenEkCPpkEoHY9HO6sbTOyv8xjPVED8DK5i7uWUirl4NkZOpRdey6Yfgu3HQr9KT
	YomKW+DmZYK3pa6CsN+IeXSsxy82Kmo4EpmXxIIPBIP4IxwHymbf5lwTfnpGeWewC/6wlLi54Tk
	oj5UgnV/j+LNeaQ4pnkJ7rIPorX7Gv8fMP/TsifBl0MI53lQFq8KCtvjZHSoQJRIYDYQqvTgjhB
	jZM/yP5gIZMeK2hSZVBwO0g1iN1QcKlniD45xP0teScvFC36yFCStA6gEWX2fTms4jpHKzq3pYH
	gu0LfmFR2wHaUlYORQlGkw+5M81WzUsPqyHqDyRDluDIV+Pcswxl/wgfBDMePjcaLrflzxxTVDC
	zhYxmYMe6nKfD4dfPcbNQ5GMDls7LMbHOyRiQXHuUMlbYNkk5tN+mn+n4V5U2epmZ5nr/BKR8e7
	RREht4u0HOYmK6oMB/R7DQN/QsX7IJ/H1sms2n7aBDRHUIQVMctbWYrd/saj6iiyhmZMFjfP8Br
	MMnA==
X-Received: by 2002:a17:90b:4a88:b0:3b5:29e:11b0 with SMTP id 98e67ed59e1d1-3b5029e14a7mr9016636a91.17.1795840855310;
        Fri, 27 Nov 2026 20:40:55 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm42716729a91.1.2026.11.27.20.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 20:40:54 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Romain Perier <romain.perier@free-electrons.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/8] crypto: cesa - do not allow unbinding the device
Date: Fri, 27 Nov 2026 20:40:44 -0800
Message-ID: <20261128044050.722617-3-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261128044050.722617-1-rosenp@gmail.com>
References: <20261128044050.722617-1-rosenp@gmail.com>
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

The algorithms are static and a transform holds a reference on the
module, not on the device. Unbinding the device through sysfs therefore
leaves every transform allocated earlier in place: crypto_unregister_*()
only stops new lookups and warns about the algorithms still in use,
while the driver drops the device pointer and devm frees the DMA pools,
the SRAM mappings and the engines. The next request on such a transform
then dereferences freed memory, and the algorithms' reference counts
are left inconsistent for a later rebind.

With the bind attributes suppressed, mv_cesa_remove() only runs when
the module is unloaded, which the transforms' module references keep
from happening while any of them exists.

Fixes: f63601fd616a ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index ac4fe783735b..6dded0d44373 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -577,6 +577,7 @@ static struct platform_driver marvell_cesa = {
 	.driver		= {
 		.name	= "marvell-cesa",
 		.of_match_table = mv_cesa_of_match_table,
+		.suppress_bind_attrs = true,
 	},
 };
 module_platform_driver(marvell_cesa);
-- 
2.56.1

