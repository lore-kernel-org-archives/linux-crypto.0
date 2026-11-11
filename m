Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794412623;
	b=y08EuEp8PXWuVP80snHfG6gLh2bGgWqkhDy0ivwM+9All5lK7/14kn+NLVkCO+UPf3Zx
	 CIxpehrRZ1didxBM0Srgo9K2bUlE/wxfGi261tKkT12/n/Pg97+xdMjAMBbOj41S7f5Fo
	 ClUDG4uIRU/zAhqwLQJNgIE+5Ss2a5wTR+Bxc9mH2CCe2V8cP5B4/oHew2G4qr/kB8fDg
	 /UDW93rJd5AOCHH0t0qWA8DAOZQVhIJ6atpDu7vVx1oWt0HYi5etgZRGtxSBnmK0pZkG0
	 udDl2hbUXeknxRTQW7Xk1u+BYOHyfe0/Pp9fwyvTQQA+wSGsm+3rGMv4iWF5GLDX4zA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794412623;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+MJyH0brH7C7APh5BkHzbgRalv4TfEBTMAIY1XMNXoI=;
	b=UsO91A9B0ieo1gRh1vCvKDUUuK/KPojMaV8NWUSYhnIUxWzHb5Y/d9AefERfe4W7MfDl
	 4dwwybvnBokR8JojJMVXvvq+H80SvMrBQSUu6bfqpmHsLOycM0BAV3/8SbOcOv91Ft/c0
	 vD2o30huDDeBrIcZnfeX+DKEH5Z+oEOi9EJWcNRntu9Kswd+2YXBwOv6899zTtuGGIJ+p
	 lMIos1y0r1bze1O/6agdelYgZ0TBOalJ+o42XkM6v0sDn1TlOPKbnLxBGpzZw31cg2wEa
	 T905yjXiyc6s6ffErleF3W5PB1A+85sCW3lrJVDvtaOwBUEPnsCUNFWrcgUK0Uu5Szg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KnvqlPy4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FCE606A332;
	Wed, 11 Nov 2026 15:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KnvqlPy4
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794412623;
	b=RHEXsDIXla9Y6xyeskkIQO73vSf38IF1ZTEnw7ItmBuzpmYIupScE2UPRILTOkx4k+Y1
	 fUrO93UgwzJjYL/0sgyYeyfZriU3+a+ZLKr1XF3zV9R9467ZUfr6kORzpZSNsAhR2yD9Q
	 fzdm1I2ztOh6eQgDkliECkg7dzKUS2dk9Uo6nV+VvW97aQEB4biKzls/8DHDTIN+tA3jZ
	 UW2DMk13ygZ6TC723Mhjw8SH05qI/h8tVuOOaciEKRJQ07SVMW8Iw8tsbqEseBG5TnCHX
	 muBv/iBd131uxFLSFOvBZHwShf4U9ldKWaKpkFqvLCCCmfkRjmgCwQXWdkAnQX2KrtA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794412623;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+MJyH0brH7C7APh5BkHzbgRalv4TfEBTMAIY1XMNXoI=;
	b=Ub5nsbOl8zHsnBgTtkQPR1FQgsqLtVkETiMT0E6U1bwns60ANF0Em7bxzcD15xyABuA9
	 R4MygmrigDDQKw/tg4ilD7tB0I03YzxfGzkbeeBsjwpLUQgxoRlPZoLcRFPBI/OPzGZS9
	 znCeXHUAfPfkxAkpRnkxNDFg7pG0Cti4FO+vyrC/OM7CiuBA4bc3uLYYkPB8yPXsOgEIC
	 75JUIwVynGIQUNVHATgS5Lmsmxb8R1nj/2k0nLa4YVzwAbni+HSJCjd6BjXUst5P+Ntbm
	 IEH4JYUWlcE+Grj2cIG8R91/hWCe/KdsiyinyAct4bqZyu+l3zD3IIvmulSKIcdUKhg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0B9FF1F00A07;
	Wed, 11 Nov 2026 15:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794412623;
	bh=+MJyH0brH7C7APh5BkHzbgRalv4TfEBTMAIY1XMNXoI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KnvqlPy4GhVxmqHealfRrrdNHaU/iIHAF9DHdMzdIEmwkG1HaDS9e/JuSZg0iYc/c
	 +FkK7uri8SjwEzdGWiIJF9WqNdjfyqjqJRHUyzRZoLs4x9F2n4y4nX1vNAXeSPTscx
	 BTKup7Yr08yqkl3fuB6YGy/OyzfFw9b1jkXV0+9A0v7gzfVqaQfbkdtq00h3fd+n2U
	 s0phUN3lXPvRb6DK8xJ4GeHEygUUVGac9tjBEczUImRJ8AyEiWAk72YCezKB++Gtv6
	 L+4tF9qz7LHPiQfWeCHrYUcfvv9zhjar440iyzbF6JKbJhipysENp+bJs6hYqP1SQp
	 TDyEggyRgmSfg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8304449021;
	Wed, 11 Nov 2026 15:57:01 +0000 (UTC)
From: Florian Bauckholt via B4 Relay <devnull+florian.bauckholt.cispa.de@kernel.org>
Date: Wed, 11 Nov 2026 16:56:08 +0100
Subject: [PATCH 2/2] KEYS: asymmetric: Fix PKCS#1 decryption of an empty
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
Message-Id: <20261111-keyctl-pkey-fixes-v1-2-934ebaa267a7@cispa.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794412620; l=2104;
 i=florian.bauckholt@cispa.de; s=20261105; h=from:subject:message-id;
 bh=vJaOWDpg8Uw5hFBrBsFlJpRTmwjwBqTNl1b/UFAmAqc=;
 b=bmV0FPTA4jR7Gi819tFe//SQLjpWufci7CYlgGm2EU3o4uRcP9AjL3navg382pE0ks+xP2iDA
 yP/hD4rtfgRClKFsC0rdwYe4ediCJwQVDcuB5R5H/9UW8QLFn7QsMrc
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


