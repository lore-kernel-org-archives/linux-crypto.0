Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794412622;
	b=qSe2PightJVzHfpJJETwv1tmaBCqfgygAguZMn4q5SqzEe44GMIGA2odITEfhC2naMMA
	 fN6z3gA2jHYoKZgb6a4nP0srv6SroSJps1mExf+X3w1NkLSL8yR0U/PIgV97s9P0f5K8H
	 KM+hbtadI0WTfDb8esJziqme5RGfP/km2FvOIERKkxsd77G5uvppXmjZoqqDxJJnY+NAW
	 FQun0bdB+VtziL5PwKcHSq8QrAdBcnSbOpBjkttuBpLDVtz1HvcXtfmRsVM+OXeIraPt1
	 +8RsyJlZLCKV+w+5IiIfXhCRz/35cOEwQEM0UAEdhV3KAsuQ1sUJn1Wu3F7I5UBySfg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794412622;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=l72ke06IumL1lybCFh4S+DGD+QQ04pS0z3OJQjSqU0s=;
	b=Q6iheXzmuvonIlLUAtFgJAUjUUYZ0STU495g5AHfm12S2pXO51SNuoDVLnPpLnzNoQFY
	 2HSWWYNpcoyeXNHmuvr4VQglwSkkCLYT23OrppmiGX3QP98BT5ldIKjrNXr47AQ3DBjsA
	 TaCY6TsYimN8UIdnbKRRY7nnzv6aYj4rGpBjAarIj6kwDHU476BSkaabegOhXJy2P9WSd
	 Nt95mtAqOTNHHHt3GhgSv5KZsx6qW5gypXj7hV9C0G5EMOY67gomeJN/m8ZF8rNbL1jQh
	 XK9Xzaqag+/lbfrnGrlBJITVuzGOzMsN5pVTsbGUW5ZRzavUPjrA+Bs3LZQ6xstSWPw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fx490pRN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD08606A326;
	Wed, 11 Nov 2026 15:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fx490pRN
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794412622;
	b=HyTgi8C1tj9zw90bHWH6lQQ17i3PB40vzWjZ8oo2DYPPq4kRaExqyhsdbdwzjsuGRlR2
	 PYu3x2bmo8bQw54TXgrfkWzyquVYjbNrwoT/Hnj0JnkWt0toBi/Umn/aIINty9bGnEyiz
	 j//JOF/EHEHd/N1gvSQ8e4NOzxKowN/p9ROdC3DcB0w8D4yL3K1LVLLWo0cVHa+COTkWE
	 +7TZa7K/UyVSxORE0/klmYtgdg24PQ/ZVrC4lUpy5PBKjElN28XvZItWzUMk1/YSG9gYa
	 0g6ujjyPzeM7bqQTYjE3NNxmEakXYKM8huJkaB/8LIqqDN8ditLWxY4pK2ld+sQsClA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794412622;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=l72ke06IumL1lybCFh4S+DGD+QQ04pS0z3OJQjSqU0s=;
	b=T4pbzYDHIWu3vV/Efpo353wMQaWNCsO/CrwajLdJyA8m2MK64/esvQyvxDxrIYoqzHFt
	 +8NJSX+HoFv6mUAnDtkg5XnIafNfbt0p/oqf6FvgJOSoQ5LxcAt+TOTkpZ6NkcpSOkjaF
	 BSjctDVyryHhMJKu5o2UjRRfoNkhGxJsmvMxHoAioD52IaRUewV8AiFt8AYDKOZaTkdpM
	 6WAqofk+jzJIdmFGgMAhH6Z7GX40w+FfkotYW94C7MjMw2rjeWK4puw7ZifZrF8olsA57
	 rn/7KtQYbtXLwpXPB/lCkDQwXCTUxo1aow74JNnwmQ/L3yLfzI9RhiANKm836vZtzNg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DC37C1F00A06;
	Wed, 11 Nov 2026 15:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794412622;
	bh=l72ke06IumL1lybCFh4S+DGD+QQ04pS0z3OJQjSqU0s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fx490pRNPZRZZ4d6yAJUFP0j1MRP2quRjzL4v57NzFhKFoLuHVKW/Br/uEzYSjPYm
	 oPSNqxJ0BEBrsx7T+5YBQvDuiokZdNJddjNyggONOK4VVmi2We2UK3Bga6+VVvRM0V
	 VWWdexO5Mj/ZkO8vQZ5wHsBBkZ9nA+UtbrymQbDUQam1ZdZZfeAMKN797dd4uHWv6y
	 wlsyGbxi6MA074AyxvaglooprPphc73SqJuTd+eGDrlk1kZStkzG1ESdZGFxX3nbCG
	 /8UuRbZEZt2HuymtoXf6oqL3aup3QYTx68UVr/E7bM2Z/8wtmbY1Rd8bBitumKEarB
	 GFidRTNQu2THw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5E97449011;
	Wed, 11 Nov 2026 15:57:01 +0000 (UTC)
From: Florian Bauckholt via B4 Relay <devnull+florian.bauckholt.cispa.de@kernel.org>
Date: Wed, 11 Nov 2026 16:56:07 +0100
Subject: [PATCH 1/2] KEYS: fix signature length passed to
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
Message-Id: <20261111-keyctl-pkey-fixes-v1-1-934ebaa267a7@cispa.de>
References: <20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de>
In-Reply-To: <20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de>
To: David Howells <dhowells@redhat.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, Lukas Wunner <lukas@wunner.de>, 
 Ignat Korchagin <ignat@linux.win>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>, 
 keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Florian Bauckholt <florian.bauckholt@cispa.de>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794412620; l=1884;
 i=florian.bauckholt@cispa.de; s=20261105; h=from:subject:message-id;
 bh=LVmuxaZSH2taEYfRhlXMhvvv8Nox03oxmZ6NpX/Ry9M=;
 b=qYKEFVkNM/BmDKGEExfP2pA+Ye2Q6kqKInfaNFuLLB8Vn82lJSXEmc/WIbxgoUJIyTVq9z/df
 O7aBXzk7K35BtmDlJN0trkPlZkr7hXktWxP/vJYeyK0/hBt8Jz5YQF0
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
the caller. It copies max_sig_size bytes from the signature pointer and
passes max_sig_size as the signature size to the verification.

This makes no difference for signatures that are always max_sig_size
bytes long, such as RSA. A shorter signature, e.g. a DER-encoded ECDSA
signature, is followed by whatever is behind it in the caller's memory,
or the call fails with -EFAULT if that memory is not readable. The
x962 ECDSA template currently ignores data following the signature,
which hides the problem.

Use the length provided by the caller, which has already been checked
against max_sig_size.

Fixes: cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260919221742.3709658-1-benquike@gmail.com/
Signed-off-by: Florian Bauckholt <florian.bauckholt@cispa.de>
---
 security/keys/keyctl_pkey.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
index 15b6bf6399b5..794fa3d01911 100644
--- a/security/keys/keyctl_pkey.c
+++ b/security/keys/keyctl_pkey.c
@@ -160,7 +160,7 @@ static int keyctl_pkey_params_get_2(const struct keyctl_pkey_params __user *_par
 		    uparams.in2_len > info.max_sig_size)
 			return -EINVAL;
 
-		params->out_len = info.max_sig_size;
+		params->in2_len = uparams.in2_len;
 		break;
 	default:
 		return -EOPNOTSUPP;

-- 
2.56.0


