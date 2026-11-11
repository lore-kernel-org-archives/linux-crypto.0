Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794412623;
	b=1zzGAYYMKR+O3sSWvMZjCtgAw5+wNQ77e9jV2+SRHejxAIr4PaZ4Dg49C6Cu/4PO1rXm
	 2TGLyA23VwQlT+37WKQt54vlXCbhbvFumi/0189JHjeC6DUg7lttN4+LqUqMSpjJuEN5B
	 PIwz/PhGcwSSIfCa6JklFdmKq/67BAjPa/ef7w7rME4fj2/TRf9ISFO215OXUX/1wosIs
	 oEy23rkMyWsB3uKKOEiGTTjqoJaj7w5MvaNtK3sr99J1aufYEE1MG64OdW1NI+Bqy6fkg
	 rCvV6wa3DniSwdpuyaOn2FvzEMXlhnuXiqXUsjnWK4l6Cd0UCUMABCU7bKCLNo7Untg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794412623;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=hB3qr0XijsciFSTqEKSx+8DjTeDGtKWKa/wAKflq8fY=;
	b=k/w1ueTCOEsuIglipdkP45rsVoRGfzShEX7PCQHSf4BeH033YG/DCCvaGYOn75rEQLRW
	 QaFwAjMlQV62ag8GnqfQMfjYDFCO4SIPG0xcaDgt8U9DU7OdEMrzixNXNxZWTGA9uLy/Y
	 t5Y89Oeow6hhZwbo8rhlykn6fDU7R/fnjgglVoT4SUNmmouDyrj46CelcPMuYMxMqtxAq
	 Vo+tWhJtKjY3yfxtKICiljYIQvmho8dpcTC/UZKJGgPS+nPQ0mVbqAUZ/3HoHsI6N8SCI
	 Jrz1bvjoig1mQM3EkQf+wLNrdnxKcl2AG8XNCNhhqyhl+ewQTP4AIjMOye/uUcPkLqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mkz4FcqF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECADE606A32D;
	Wed, 11 Nov 2026 15:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mkz4FcqF
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794412622;
	b=fUqQUrQA7hB3EdmLYXkbEUjqHSMIvCaV3nHgzgjuhFJWjUAomgHQgifzLchrZaYaU3wJ
	 BqN6KQ7uIKv5bI9RGo2ywbMJG5H+WDaNSaOCosMaNWLI3UBrb2EKCwJRTjOYnYKKw9PC8
	 o5NoCeO5hjDfyw8oaE9PpE9A2SUigDX5dIWe46z1v7yXh8eCglqgDHp3vMpE3jKchwkkm
	 2Re0nqdu3OYj7a3jQ/4Y7ag2a+7PoifKZppEB92Wd5nP26xdO372EXp4c+D+bg2gg7y2c
	 aMAhzk7IcoVYxE37lQz9rmZPui+aeXjCn08Pvc5162kr+Jo04iRUwuAni20KGadjazQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794412622;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=hB3qr0XijsciFSTqEKSx+8DjTeDGtKWKa/wAKflq8fY=;
	b=FQsfeBuVSmZEPuEhU9i8eglrvKEfq+HKQXPCJqfyTaVlmcSmBBEg3Po0mIip0K5XJD47
	 PPL2LbKIz55IX1OWcax6DllxL7wgm/joOSEzX7F+/LZUJ6Z6f4vMrGqb6GVjHNSYuXzYx
	 Dc6rwXyAVeHi237GP2+tcxJQ11Yf7h2MT05SHZDv8gTCNNvENVkF72fvQFZW9OOnhRvoo
	 8Xws4QYtrDxAFnBeEHKCjPqmwp3G/MjdhAuDYGHfsQVqFd+zFJWZJt4DN6vQYaLcmJjqh
	 Ct71dH0/iYbFT6OQ3peM0orNScjn8KUclXCsvdQTHq++o1VpspfF5DZNFYbK9d3XpLA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DBC211F00A05;
	Wed, 11 Nov 2026 15:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794412622;
	bh=hB3qr0XijsciFSTqEKSx+8DjTeDGtKWKa/wAKflq8fY=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=mkz4FcqFfpaNw9TRp2Sal4Nhd6pwXiiuNOHTyhIVf8qIc8lHZSjZoEQHbsS6Oy0SL
	 7krBZQI+qkM0GiBlbuG1ff2NWyvFYD7B2hL1eSSVAC50zESQTJcNsLIWNNFw3l7KT9
	 Y2Dkcu8Cp18ky8LQqAbN31JAjr30XaXpNI4C3aHLK/7rhWfFPvrvUt40PtnacZALff
	 o+OxKa/IHkL6Bcbtq7kP+dLIqjFszZnAnQR5XtHMeLYyAIIEja6EfVxdL6pk2zvUd5
	 RLu+hbALuOjIYBghRKeBbqsOSAOa3JAHWCZeBx0X0SyTcB1UBPEBAb5pV5AQgAb7tT
	 b25difc71pTiw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 32F8548F87;
	Wed, 11 Nov 2026 15:57:01 +0000 (UTC)
From: Florian Bauckholt via B4 Relay <devnull+florian.bauckholt.cispa.de@kernel.org>
Subject: [PATCH 0/2] KEYS: two fixes for the asymmetric keyctl operations
Date: Wed, 11 Nov 2026 16:56:06 +0100
Message-Id: <20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de>
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
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDINDNTq1MLsnRLQDSummZFanFukZmxqYWiRbmBuZJZkpAfQVFqWAJoLb
 oWAi/uDQpKzW5BGSQUm0tAM4iKAB1AAAA
X-Change-ID: 20261111-keyctl-pkey-fixes-26358a8707b6
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794412620; l=1414;
 i=florian.bauckholt@cispa.de; s=20261105; h=from:subject:message-id;
 bh=GOMrVRBSeE8hLfYs6YtkMRfH5HXSdleUYoeN7mchAzM=;
 b=ttCpoRZ+CbmvpkYf413TemwqzcVJRwcmDQFBw0RzMU4Y567p7HmCNsBTbuz39K5A+kzj5pEPC
 UY6g6KZOvd/CwiN08BuJKpNjqRuza+FpOi7QwafT0wnivIQ2G0SvzMu
X-Developer-Key: i=florian.bauckholt@cispa.de; a=ed25519;
 pk=n9klXQ+dI45FWy0qWLrGpQfXU5ylIA0SN+uWSmOx3ok=
X-Endpoint-Received: by B4 Relay for florian.bauckholt@cispa.de/20261105
 with auth_id=1420
X-Original-From: Florian Bauckholt <florian.bauckholt@cispa.de>
Reply-To: florian.bauckholt@cispa.de

Hi,

two small fixes for KEYCTL_PKEY_VERIFY and KEYCTL_PKEY_DECRYPT that I
ran into while doing differential testing of crypto implementations
with the kernel hooked up via UML:

Patch 1 fixes a regression from commit cb481e59ea6c ("KEYS: fix overflow
in keyctl_pkey_params_get_2()"), which was tagged for stable:
KEYCTL_PKEY_VERIFY ignores the signature length passed by the caller.
It also is a prerequisite for making the x962 ECDSA template reject
signatures that are not DER-encoded, which I'm posting separately to
linux-crypto.

Patch 2 fixes PKCS#1 decryption of an empty message returning the
ciphertext.

Both changes were part of a patch posted by Hui Peng in September that
did not get a reply [1]. That patch also changed the out_len checks in
keyctl_pkey_params_get_2(), which is not included here.

Thanks!

[1] https://lore.kernel.org/all/20260919221742.3709658-1-benquike@gmail.com/

---
Florian Bauckholt (2):
      KEYS: fix signature length passed to KEYCTL_PKEY_VERIFY
      KEYS: asymmetric: Fix PKCS#1 decryption of an empty message

 crypto/asymmetric_keys/public_key.c | 6 +++---
 security/keys/keyctl_pkey.c         | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261111-keyctl-pkey-fixes-26358a8707b6

Best regards,
--  
Florian Bauckholt <florian.bauckholt@cispa.de>


