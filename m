Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795044007;
	b=zCh2Ozuv5i3I49eiTiWMl/q/6nGYPIYCoYuqIPINZc2Yst1tj9tOuHp/hxlUnZpiMC7o
	 Pm+ejvKx9pLl2T6N2V72X/n3+NSU3gqeV1HB0en+jKFFiM6HnM6rIVk/uxyddYCil+Gji
	 U0FhGyTJ+C3K7Hzeut/tKuF3EKkQHELojFxBGLQcuRh5K9RkNXIwmXAnJ5V6mwGM2oJST
	 HsVYAWYY2oK8fZA+28X+TaJsx1DO3OUmJb0qWineT476ZiuScwqAhLb+T0ZlVizneckrx
	 mrcnuoRr8Yw24pj4GXrk1xHL6KLZKBGd1kPbYbA6LVBg2pFEsec0ilQlOG38vwV/f0w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044007;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=KuzSUeKTvu0n86QvwvTTzILivYz+E3C9v4A9dUNMtTA=;
	b=Z8tRFQ/MI6oUocpLWn41mqGuH8oTPZqieV6VKfmW2VN6d+1WZseYqdCTGBU0sNAbmpJp
	 bSTjyUaT2JO5eTSfCzB55zBMnokATRmKL48vCuXwax3Fm0lmeM5thKo8zJmZnUS+fa4IA
	 ZhdjW6iYtKPtSUsfPOIoLVb2hYAFmdeqAOkxp86dKmmYFrzWdZOfL/j8mX73FpGdFkpUK
	 G6430lpQvWQdelDJM5cOHdJkFexNnKgp0w8m5hjrceUBAiCOAL/VzrHYm0W8Br4X/e418
	 zr9JhUVvViAWAc3dIfhTxAWAcMzTPoQehVacfeh1Ahrv5sKNmE6pdeJUJmV645KbM7Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="iT/OSNJL";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270FE606A338;
	Wed, 18 Nov 2026 23:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iT/OSNJL
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795044006;
	b=UUU4ESAt/SHVKBB5X8EWvlsf5HDtrrWK2WEZmZZpfDhyVJg70zX7VgtH2bR1vO/NX/4K
	 z1Sg/RdVO9ZGoEFAJ2Foz9orb2R3Qe6sCQ/JJGG0Ffetk6n95FoU9ROsJsQy7yX9lFPYC
	 S1T7X5IHonzJe0i0jHhVjLbbo1OuzJrhPoWhY+bLXctgF39eyhjqcQzHCGjdNQU00kGLz
	 /xeYH9UqIF8aiFNkrMKN+WF/AnyN8vrjpTB963dSRkdE5DjvwPGapIWbZZANl58eWDH2n
	 TxkpebKaK2WKAXguVdGShpgWrq+0jNO1NfaSCrSJpLfghTvwZETXrSx/9zT+gMAf4QQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795044006;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=KuzSUeKTvu0n86QvwvTTzILivYz+E3C9v4A9dUNMtTA=;
	b=jo+0Vczz8YZOxGgT6qzKTVnJ+GjYlnT0q6mdTFtFwmHOA1v6v40xkSTnYjSCPeKzQMCQ
	 AZOrx/7FILJoW+zMT7KnwCd2w/J/MxwKnAMrUY+tnFroAbTWcUmiR3KwaZuzW/LOtNI7H
	 R/rbT+vdsYXzJRPZV8bBzuQp65L8cZfgG7aE+/xdRrR+roKDkNyGike2mzp43qrSsAuxb
	 ka730ACazRh4BakMVKoUkMp1Ps+9nCj92nBbd18aUb+Ic1nPYR8KwOUs3eTX8DmocB8h8
	 bYL5LGfdvntVa+zeymMH/qkUjsa3vUX5v4KXF0zl7BmLOJMjYAQTqsmRXea1GGl69+Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 579071F000C4;
	Wed, 18 Nov 2026 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044006;
	bh=KuzSUeKTvu0n86QvwvTTzILivYz+E3C9v4A9dUNMtTA=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=iT/OSNJLfvzQYzlpS9/SsgFtHeTOu+r5hw27SVJFmRlE3ojGKlzlMvwY2giRErmZd
	 qFd6Ny++FdgcFiAVvmzhwe2S0Q1RTT9t0hO0eP9+qWjb8eKt6Thwfn+zKJICk9HMRd
	 atKYDDnaKN3kOhI5URJTIuBtgp9JxilpgiWyD2FmHPFR1xr1IYdBscDeW+CmKQRZSc
	 jTVLqpl2fj2sTyWJ/FTPM2CFC4uWwr3v8UL2lk2o6qyFROUvUvYLCUg9WFPftMk1Fo
	 015AZBykGI85CGk5KlhJ4p0jGeWk7SzalwH/ERhDbbQIv73F8q8/wGUbqukZk/co1y
	 OmQuNnasyrRUw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CB3C44B01B;
	Wed, 18 Nov 2026 23:20:05 +0000 (UTC)
From: Florian Bauckholt via B4 Relay <devnull+florian.bauckholt.cispa.de@kernel.org>
Subject: [PATCH v2 0/2] KEYS: two fixes for the asymmetric keyctl
 operations
Date: Thu, 19 Nov 2026 00:19:27 +0100
Message-Id: <20261119-keyctl-pkey-fixes-v2-0-9e2d1c7db7ec@cispa.de>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NTQ6CMBCFr0Jm7ZhStEVX3sOwKGWUUQOkg0RCu
 Lst7n2byZd5PwsIBSaBc7ZAoImF+y6C3mXgW9fdCbmJDFppk0fhk2Y/vnCIF2/8IUFtimPpSqt
 sbSDmhkDbI8au1Y/lXT/Ij6koOVqWsQ/zNjrlyfevf8pR4ak4UO2cNtbZi2cZ3L4hqNZ1/QJbd
 XROwwAAAA==
X-Change-ID: 20261111-keyctl-pkey-fixes-26358a8707b6
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795044005; l=1979;
 i=florian.bauckholt@cispa.de; s=20261105; h=from:subject:message-id;
 bh=FDAmoObBsHQBGQ+MetdjiLo0kYxapT4Ogq4Y3JdbTA8=;
 b=Wk1rAO/meq+r3f/pjo64iqVGKoS19pmqMHM9xPsXpyGDnVlWCtUdfEuvhLovt1cvaysJFtuQL
 tCvradrixlqCEdT2Je4d9Jncgq1EAGoPrSv0Mn4NmON56/1No+Asitb
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
signatures that are not DER-encoded, which I posted separately to
linux-crypto [2].

Patch 2 fixes PKCS#1 decryption of an empty message returning the
ciphertext.

Both changes were part of a patch posted by Hui Peng in September that
did not get a reply [1]. That patch also changed the out_len checks in
keyctl_pkey_params_get_2(), which is not included here.

Thanks!

[1] https://lore.kernel.org/all/20260919221742.3709658-1-benquike@gmail.com/
[2] https://lore.kernel.org/all/20261112-ecdsa-x962-der-v1-1-36b24c5f5e11@cispa.de/

---
Changes in v2:
- Rebased onto jarkko/linux-tpmdd.git for-next-keys (141b164bbe18).
  Patch 1 no longer applied after commit bab48a104447 ("KEYS: Protect
  pkey method checks against type removal"). The code change itself is
  the same.
- Patch 1: the commit message now mentions that a truncated RSA
  signature can be accepted (Rodolfo Giometti).
- Patch 2: unchanged.
- Link to v1: https://patch.msgid.link/20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de

---
Florian Bauckholt (2):
      KEYS: fix signature length passed to KEYCTL_PKEY_VERIFY
      KEYS: asymmetric: Fix PKCS#1 decryption of an empty message

 crypto/asymmetric_keys/public_key.c | 6 +++---
 security/keys/keyctl_pkey.c         | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
---
base-commit: 141b164bbe186423e295b139e40e8e2d11cf1341
change-id: 20261111-keyctl-pkey-fixes-26358a8707b6

Best regards,
--  
Florian Bauckholt <florian.bauckholt@cispa.de>


