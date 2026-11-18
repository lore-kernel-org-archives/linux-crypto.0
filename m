Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795044007;
	b=VqVz1h6MvU9ii1OmA0s0NMbMDNRGX9cqgoVJDE5UztIulztMXt/aRZJwQrf/jhWJbd0j
	 TVoql8uzwf4kNf1P+FrTUAPu8u2YoOx0l2yd6WsAm/fE9F3ZLgbrC1JrTuNQczbK+aX/3
	 dFJhSgxAYHqdVmjMXVZuklOM0Ddz3d1xlI861NE8Sl3Iq3/EvdrqpTDmNXnImEVpvHDTA
	 NmJL2kHVJ6SUhu2SlvIvNhO0I0yuVN1qJ2f00L9xPvak34WiWOUuakMSG3lQvZ7ZnA1q+
	 hbblVWtYW0mvagsHIMOMJH2wklyJJnflC2jGdwCOq18Vv1H95ovcv+zt5t7qO9MB71A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044007;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=MG6hWnsdBkkXgnK7ZJ9S5t9lYIm03j9Z+rohLYfN/n4=;
	b=jg9xAl6iKhPu9BaJtHsQ5pfHeX0AZ67bhgxkQgL3Se0At19EB6ZrL2vUsjWUbsyvkmxT
	 K+ZERukGA2dB4AarQqghkmBRGfJRjvArQlf3aqrd0+YT3RiO6vgO01DhcchRWQm1wCIUW
	 qWMmzO/kTziDp0aqofyXFJooEux1uK66YfkUoDN7QLsMY5oC//e0YpJ+pkgpvhjziFX/a
	 2A5JWkvwOw2QoID37Qn5JOMoijj5D2IAJty8B/oBsETdcxIlergX0xGk1kI4cTxOjT+eO
	 Dca1qUbdahhA/8HaZL6wsO7YByEtQvJ7CScY0QEQXkh+w+orRNdK+KXBWNkU84dyNEQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dxH6T5Td;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826F460A260E;
	Wed, 18 Nov 2026 23:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dxH6T5Td
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795044007;
	b=sRu9AznW8nvIVu7Qgf+F7x3xN8DzIlfrxT1LH9AjzyYthHDghx/smJtr0OkY1cqOj2Br
	 B3v8/rRmolE2t/Ug/1LlZSryQwq/wZHmLFi7h/ssbrF1NsfKZLg3toQmsWPxn3gdkZaKB
	 6A/LSMw0rArOyru34ASCbnqLRGC81/vWVf5ZohH4xJOXqZBtTQ1T33KjAvzPLdsPIPz/3
	 yOMdvJ8ptThk22mEUzVMTDuKVQJKFB/M+hgpssoK2QGG2JY/B4FHVnphERgi3pBXV750S
	 2Qig33Je5vtLVrAoCD6B2FULgodwGXFJt3GWwo8QrQ23gTHH88aJm6EVLXeo/saReRA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795044007;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=MG6hWnsdBkkXgnK7ZJ9S5t9lYIm03j9Z+rohLYfN/n4=;
	b=IZbfcvZDrx55BkvxkV4pBNPPYx63wR6hZ5woda2xweI8rMP8qYO7qgNFmZZAGFlXKrFf
	 IDsOatoeVgNoKjy1+vwqI49DRLt7yAIUmkrBPWA0dxwZbtgj4l34hAeWWiRE+B76Ewzgl
	 vFssihhT6VIxeGYL9rKnPXOonCx67mfgDNWGfovYeecLNM70zmCZFrrQaMjJrVsZ/nvXd
	 jtfBcrb1xVqRj4Wz824mQIwbmhN7c4fxSb6TQtTzYgFwXXqSzkeMMY4uarI1uYXNzGNs0
	 gYwkJAlmebeUluQBHCfnJg7Ons1OPCrEHaqI0MA/NXHOL19HjkQHBb7lY+vUdTdjQbw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 780421F000C7;
	Wed, 18 Nov 2026 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044007;
	bh=MG6hWnsdBkkXgnK7ZJ9S5t9lYIm03j9Z+rohLYfN/n4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=dxH6T5TdgQHbXpxMBvr2TXBcxwbu9bdggBOnAoM7tcBcavXn3bCrC/9EAoUCEhd8L
	 bnREJHi2N2pUZYHPhOSKE5tZJAI0N8nbpamP8LAx0MSyBFjWWUSh8lLxhkdFrU9CV5
	 xtfOEnIBxnfgbWduP2apHkT3/GOK/URZ8gFbJHKtYHpwALeHfVeedvgMtnLM6ks+Zm
	 nZf53AVj14iKtEsUJrJ+FU4pk0LU+IhKk9M61BxKJi9iOljV7/Cb89yYfZ/nGM9mbl
	 RimOSei2tMIQ6y3YiNc6q20Tu8iHIzBkxy7AxiRdgr5jkAXjg6RNvhuV+yMmOxL1sp
	 QjR7f5FCcNxZA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 083B54B029;
	Wed, 18 Nov 2026 23:20:06 +0000 (UTC)
From: Florian Bauckholt via B4 Relay <devnull+florian.bauckholt.cispa.de@kernel.org>
Date: Thu, 19 Nov 2026 00:19:29 +0100
Subject: [PATCH v2 2/2] KEYS: asymmetric: Fix PKCS#1 decryption of an empty
 message
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
Message-Id: <20261119-keyctl-pkey-fixes-v2-2-9e2d1c7db7ec@cispa.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795044005; l=2154;
 i=florian.bauckholt@cispa.de; s=20261105; h=from:subject:message-id;
 bh=61cY2hx+6753NibYFuLl6rSMCEQVY9VLZLVipWWk1vM=;
 b=iX57flM5+ziDYBQrrp9KJ7kUDnjAqKWOgTIfvcM4S0fiRan6GPJMyfgKXEnDX3bFjNNWS3w4q
 GB7GkxeEikiD9yfpiYk3HDJJC6gB7oaIQwQerKvj+g48chhA1UksQao
X-Developer-Key: i=florian.bauckholt@cispa.de; a=ed25519;
 pk=n9klXQ+dI45FWy0qWLrGpQfXU5ylIA0SN+uWSmOx3ok=
X-Endpoint-Received: by B4 Relay for florian.bauckholt@cispa.de/20261105
 with auth_id=1420
X-Original-From: Florian Bauckholt <florian.bauckholt@cispa.de>
Reply-To: florian.bauckholt@cispa.de
Content-Transfer-Encoding: 7bit

From: Florian Bauckholt <florian.bauckholt@cispa.de>

KEYCTL_PKEY_DECRYPT with enc=pkcs1 on a valid ciphertext of an empty
message returns the key size instead of 0, and the output buffer is
filled with the ciphertext.

crypto_akcipher_sync_encrypt() returns 0 on success, so
software_key_eds_op() maps a result of 0 to crypto_akcipher_maxsize().
The mapping is applied to decryption as well, but
crypto_akcipher_sync_decrypt() returns the length of the plaintext,
which is 0 for an empty message. By then crypto_akcipher_sync_post()
has copied its scratch buffer to the output. pkcs1pad copied nothing
into that buffer, so it still holds the ciphertext.

Only the caller's own input is returned, so nothing is disclosed, and
messages that are not empty are decrypted correctly. An empty message
is valid, though: RFC 8017 section 7.2 only limits the message length
to k - 11 octets.

Apply the mapping to encryption only.

Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without scatterlists")
Cc: stable@vger.kernel.org # v6.5+
Link: https://lore.kernel.org/all/20260919221742.3709658-1-benquike@gmail.com/
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Florian Bauckholt <florian.bauckholt@cispa.de>
---
 crypto/asymmetric_keys/public_key.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 09a0b83d5d77..d71747d93b2c 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -341,6 +341,9 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 			break;
 		ret = crypto_akcipher_sync_encrypt(tfm, in, params->in_len,
 						   out, params->out_len);
+		/* Returns 0 on success and always fills the whole output. */
+		if (ret == 0)
+			ret = crypto_akcipher_maxsize(tfm);
 		break;
 	case kernel_pkey_decrypt:
 		if (issig)
@@ -358,9 +361,6 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 		BUG();
 	}
 
-	if (!issig && ret == 0)
-		ret = crypto_akcipher_maxsize(tfm);
-
 error_free_tfm:
 	if (issig)
 		crypto_free_sig(sig);

-- 
2.56.0


