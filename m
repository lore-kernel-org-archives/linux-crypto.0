Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795044007;
	b=1hd6mgPjEylO5zP4fl8JnA2P5XLmerD7HASjaKsFg+9a7Fmkw0wjuk7Y3lv7XPIIuSEt
	 PQQmTouZWPsk3N8xWwQSNLMeooCD1G+kvYnIA3HTqc+aHPeIYR+Y7leOJfxiNmk7Hi/MK
	 Vjadbsq2x+wOlkWcuoyB4hWB9UwLzAWXh3ni6GJtKmrMPYfeWX/lC80n0pWPooLp7i1AN
	 9UJlgZIN0YBCDDzSisV6/uX/W/fC5QFJOB5ZqvDmqrh57QrkEwx8oJEY822IoxHtrYRvQ
	 d2QrUG03W+QRijRUmYjcM8qBoIsWzu2QIPtt8MAMRRwpdm0Jib6P11ozmW+ObB3Kj2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044007;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=cAtWuKOf90j0KKs/0tgiXt2VtNITorRh1Hu2bGq4a6k=;
	b=ycv354MWo+QVew8ETUHh/jyOHRW6rBqA/O5zm+dWk4wueYoaUHiaqm+4lrOsP28DTH7K
	 xJxAdIyFDgDkCRK8wcUVbYxOUHFhWrJaJfiIjZSEv+yAylm5gEZ2Qxvl26TX3RiYbnQx6
	 d+C2lFKjBSuMHza8E3mBBrZHAM2Yc3afwdzqrndVfnWlqOJxTgIxipaywvLhBHwZk/gCw
	 BLDK7iqyCURxZQFKbSb18Uwl2IkWmH5Jv2GpB5AMKuDLMQsgndqvkX55/ArSEeo8L2fl+
	 PA4cWNyOI5NAKuAjo+ecx7MfT0tOmbZIVPY33sLA75H3F8hgVj9bTLGFcvl0V9FbnnQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LbwqWBzJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8D360A2616;
	Wed, 18 Nov 2026 23:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LbwqWBzJ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795044007;
	b=2PyEJyZIeXzIiZBbbHW6xHelEJoLIzfMDzGzNY7Ul5X4BqcehL8aCz/NVPfe/HKHNiHh
	 vB+lfu8+528QB46LBC1GyoaqWf9t5TNbxlE0Ha93KeIjlvHiHMEiS7P5biQ0/PpPczF2U
	 aZ9SkVOnJ9qYv9h8pzqjwRZ276iBlh4k+hJKqz4DR/H+iMf9gL2eUwQlIVYFofLzsdhFc
	 zaZszOxlia++JNny9ZtBCFQmNkiLvzrJbPv6ES25eT0NXMLGsOHIvM+IJa3elijdz5MLF
	 VHSBfLs5wT5ALoO/hH04Qh4q6X2l6VkAtMwRcYmcvjbLOjuY88HxLGp84YeTHwghRug==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795044007;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=cAtWuKOf90j0KKs/0tgiXt2VtNITorRh1Hu2bGq4a6k=;
	b=BDFAuJGbooSsgBnODD+ZdOhuwSKuaH4f5VwFWfjSjf3b/1fBHmxW6NtNo3CxrdOq4rSa
	 n24bdWBepJILsOQs6f1TsZGmIwU5PYf27zyfESq7h3fBnXh+9RhSRk536ixmPwVJ1Fii9
	 9kylO4mjjiqMOzNgkTif01/Yjo8pew2a/iQH4o3w7ZI9Yuupz1X17Y5bH8eNpLcuPQxLJ
	 FWTQd0LQ9kfimhjaaEnL4ZHgrpEeN1Hl1tehdLCqCKbPcLon+JchlF0NIWpPNUjykxfOG
	 yQ5UvBl7KU1dtHZV0xWXdOslhRp20yWj5qQWa1bFhmDIZe1TZUKPPvCvIKVxVBbtxPg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 653DB1F000C6;
	Wed, 18 Nov 2026 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044007;
	bh=cAtWuKOf90j0KKs/0tgiXt2VtNITorRh1Hu2bGq4a6k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=LbwqWBzJaejVhgWfNJNaU050RlLmerBYzdY4ARo3Q4CnUIUJQGjdUQ8VyitOTHekT
	 kspXkNu1UjMB4izEDwDNlviJzHo329tsSCxaahfvYhkWPJfKbyG+ODwHyP72yqQSNW
	 yrJUjPDifAGF4eAViSnWXBWifHwmEjmbmKj8MJPy+cArFAqgFPOk9ea3ZXwbeV1I2e
	 8+wBHBEFdLYunQLgclBxTBVADiRnecllwXjR/xzLN6xh1CDj9RhChn7fuBU0PypjOH
	 5F4sqKv+W/nfwoe1U4pG5uxVT9eVgAIcwM9g7o9NvOfhL+hIBhAuJ4d0TNdBY0sp/L
	 0e9eZXjEMVTtw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E593B4B027;
	Wed, 18 Nov 2026 23:20:05 +0000 (UTC)
From: Florian Bauckholt via B4 Relay <devnull+florian.bauckholt.cispa.de@kernel.org>
Date: Thu, 19 Nov 2026 00:19:28 +0100
Subject: [PATCH v2 1/2] KEYS: fix signature length passed to
 KEYCTL_PKEY_VERIFY
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de>
References: <20261119-keyctl-pkey-fixes-v2-0-9e2d1c7db7ec@cispa.de>
In-Reply-To: <20261119-keyctl-pkey-fixes-v2-0-9e2d1c7db7ec@cispa.de>
To: David Howells <dhowells@redhat.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, Lukas Wunner <lukas@wunner.de>, 
 Ignat Korchagin <ignat@linux.win>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>, 
 Stefan Berger <stefanb@linux.ibm.com>, 
 Rodolfo Giometti <giometti@enneenne.com>, keyrings@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Florian Bauckholt <florian.bauckholt@cispa.de>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795044005; l=2019;
 i=florian.bauckholt@cispa.de; s=20261105; h=from:subject:message-id;
 bh=N7REUG2kPhLJRwBc7RQwMvseCRnp8G0f0SHndQLFK84=;
 b=wSsNJ4/DKFfO0vdFGpQJfzVa8dJ017dKUNWPMWaEWXXHpVYVoAkcNfEMHgfl83BghL0USVvEF
 FXj7nNAKOtpBz1L9okSFKAosb93728onlmmj0rk1rixMNgzkKntZHh8
X-Developer-Key: i=florian.bauckholt@cispa.de; a=ed25519;
 pk=n9klXQ+dI45FWy0qWLrGpQfXU5ylIA0SN+uWSmOx3ok=
X-Endpoint-Received: by B4 Relay for florian.bauckholt@cispa.de/20261105
 with auth_id=1420
X-Original-From: Florian Bauckholt <florian.bauckholt@cispa.de>
Reply-To: florian.bauckholt@cispa.de
Content-Transfer-Encoding: 7bit

From: Florian Bauckholt <florian.bauckholt@cispa.de>

Commit cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
made keyctl_pkey_params_get_2() set params->out_len to the maximum
output size of the operation instead of the size provided by the caller.
It does so for KEYCTL_PKEY_VERIFY as well, but verify has no output
buffer: out_len shares a union with in2_len, the length of the
signature.

As a result keyctl_pkey_verify() ignores the signature length passed by
the caller and always reads max_sig_size bytes from the signature
pointer. A shorter signature is extended with whatever follows it in
the caller's memory, or the call fails with -EFAULT if that memory is
not readable.

The x962 ECDSA template currently ignores data following a DER-encoded
signature, which hides the problem there. A truncated RSA signature,
however, is accepted if the bytes following it happen to match the ones
that were cut off, as reported by Rodolfo Giometti [1].

Use the length provided by the caller, which has already been checked
against max_sig_size.

Fixes: cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260919221742.3709658-1-benquike@gmail.com/
Link: https://lore.kernel.org/all/0e20f799-e389-40d2-aaee-2f174748faae@enneenne.com/ [1]
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Florian Bauckholt <florian.bauckholt@cispa.de>
---
 security/keys/keyctl_pkey.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
index e7121523b9c9..722521a014ab 100644
--- a/security/keys/keyctl_pkey.c
+++ b/security/keys/keyctl_pkey.c
@@ -175,7 +175,7 @@ static int keyctl_pkey_params_get_2(const struct keyctl_pkey_params __user *_par
 			goto out_up_key_sem;
 		}
 
-		params->out_len = info.max_sig_size;
+		params->in2_len = uparams.in2_len;
 		break;
 	default:
 		ret = -EOPNOTSUPP;

-- 
2.56.0


