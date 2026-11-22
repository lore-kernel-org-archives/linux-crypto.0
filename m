Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795360375;
	b=YWN5ljdlsNkCLbmVQ/DRTSNb1HA7/j1aLxrrFHkCxKcwFwNdsJTL5Uf0YTf9rZKVRayQ
	 imCRtv7nMb5vBUIc+X6ahrN7O3kGeuOVU/p6bWi958l0Fldk1aYA5Oaw3cy/rsHydGlVm
	 DKDPZAgRc1jMmW26uy1blEHyU8jEleOOEPqRkxsiCHjyGLuFHMXOoqd7OJy7lGz3mwd0L
	 3uncCHZonLzc6hglR6mH6UXkbvBUzHxgRiU9Rmdl/2QIVY6vm/W/wNMisPbz0NfZwYd16
	 bDgcdo7RNI2Oyn0yhvPT4eb4evMpnsISEkxJ74mRoI0FK5Z8rJg5D++/WDmi5xhmf6w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795360375;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Content-Type:
	 Content-Transfer-Encoding;
	bh=4Gup+vM7qnK85QKR1mb397R23AX4QXpqYh5VwnUG1Mg=;
	b=4Mtx1riN5JPx51qY+C07GEYWdyKxBP/0zOxN7SsnDTcm0V4tRUu3+I8y9gIp1605wo1X
	 oN2Ncctj6755e4nUGtx6IJj3LYa9GPGNoRnZ2zbbMy9/KJrifJTa+PzwzjNBTmWRU1TfX
	 fu4Bhm4Qr1wITDIUwaY9PWdXRPyunuUgBI9sXqip+OGtYgeUNFdo1n2TLt06zGqt6fSRN
	 rjJCmZVMjhx8ohu2Y5kxScKLZC2YyLCRcvCja62Ba2GFDgQB58zfm5scu16Z2tmeL5Rlq
	 yy2JLVYd4qx+CpuekR5qbzZnczh23yK3qfgZXZcLXXVlGbvCsVbpjsUYO9RvBtu5bGw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lczMsqmu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.50
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0FA606A338
	for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 15:12:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C0FA606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lczMsqmu
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7d2db1b9bf2so809387137.2
        for <linux-crypto@vger.kernel.org>; Sun, 22 Nov 2026 07:12:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795360374; cv=none;
        d=google.com; s=arc-20260327;
        b=kEvcIXLIbdwiTbRfIHMAXcTK21JYTD2DPMc7WSD4p4O7mXNLUcBX9Z9jwFShe5meB6
         p6i1lO0ZByK7Vl74ikveoQucvB8LG/vmZdIOwEKRglUbMUllbExNYd1uc56K04az4+5P
         nuRYf9cHKDJHLMcj6i0P5ptdOT//pCLXPK+bKkr1P7Qx6ieZewXAzjj1Dngm5svaLhfe
         L5Rnq7beMjMe0sHm3uONwBppFk0swCg/SgU0CcyA8JkHtoQ5bDJ+Yaez27FUpYz2ZvCN
         s63v0xriungCAtpKM5qcboZ2Hzo7Ia80QyF2ENw6RwkrFA7ShcnpjdITDus9Is25EpUa
         bFUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=4Gup+vM7qnK85QKR1mb397R23AX4QXpqYh5VwnUG1Mg=;
        fh=uKl1CTlin8qnxt56ErGp3UOINPCBskOXHDuKvJLDQbo=;
        b=nI6ltaYT5jWgQJl4TXpluUOREbkq7ZfaSjUSuK5Ew7WfRecUTcSiZwS+vtHdh5gfqG
         zrdl+8or7v5OypRZP0Ed9n9qKOqMDMrTNp2P+hWyte8sA+yO+LwY/R22u0FNnlpwo/uz
         BieTbTVTGMhSwn7Nj9p+BwEBBrSAcqzrkkJ1w+BqIQ4KvtRxfEOhZX164saWwJ6AZ7w9
         FiQrdu9B+jOGHPzmzwyTRiD/lt6TuErwDYWeU31a5J7RkahLM5DQ73LrLzGIQRKjfTqK
         LM440QEAIESLxAL70e97hFiNve6/Aq0pXr+KTjB8PwiM26yGISQpxgEeEgTlay8oY57o
         dc+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795360374; x=1795965174; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Gup+vM7qnK85QKR1mb397R23AX4QXpqYh5VwnUG1Mg=;
        b=lczMsqmuc23ycleMX5bR0bq5IEvIZSq/UcgAHdI/bgKU0bE6bb0FvplG6uV12UGi3x
         j2eWdOQM1XvypI2YJAHV7ckjrdn9aMumhd7IgEoM7V5Q82gThqn+J4I4pAt+5XZAuzI1
         s3HN8axMkCo1wfx9bueTImCtfmrsOyDZqeXdwlQUE7laANl7zeQKsis3z/r7qJGjXbYV
         d1VX8nnk4QfemIuryJrtUQ3xL2DC6PnNkvBJuUAxu3AlCbC+NCqCxmY7dgFADROA9bsY
         hu/C0YDFH5U1q27jDzZPBCc1Ol3yLpTjWWDiXdD7AiF3poy95PR/tBkDfY71JjpVabOb
         2B5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795360374; x=1795965174;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4Gup+vM7qnK85QKR1mb397R23AX4QXpqYh5VwnUG1Mg=;
        b=kQxQtGge1A1l6bx1xa1RgJ0E7L8lQc4Dt73w15v5d2dCvVzTWvcPRefY/IN97UI5PN
         p0+TlLNncPUUIP0l/a4L69c4swnTKpxNjzDWcJhWxcL5RvLhh9ZZ2F1Jdhq6cbRTfJKM
         qBnww+JTB3hF5/aYXyMfN46fLs4g+x+uezDNlMdToi0g1jElURtQXb1LO0542fyfPhSh
         eRZQ35G1++H5nZNxWIdTLutv1jsZccdnonzRfTY7o0Q+gl5tanU0kbLZU/qDLKLPiQPa
         GrHffCbbJVqb1Wjqgh57gW1RRJXMFGNDAf6s362S0ltE1eElm5tv+y0IU/Ez7N6JIxEz
         i8QQ==
X-Gm-Message-State: APuU4Z/e83iwWAcQHbSbgerqHcsxVdEnISLz8Glzrv6K2qKKWBrEj/aO
	4oRiGRfPxf0bhqaE4IJIv6vfkeZ7K2sjOGERX6n4cMeq0lUcDiX8b5heOAjAu0ZP60RvXTNAJeh
	YJt8lInMM0mrCJ6wNkruNrS/8IS7srMJc8SIEpWX9tQ==
X-Gm-Gg: AZFdTZe21Mbl3whfP3VH3B+zgUxB8xhtKHqHDDanbh+nzF7X7i3xYaCNDpzOOQsVThG
	qC4mP8h9trk+mohuoc4F/xtYan3otxRrhXoLozcPeyUV4qOtlInTLjT6W/fz5UJKdGmVu8DwgXj
	qEvj/gbKTebh/56I6oBRdFCxIGQID+uq7E4B432cMcIr3OGmLYHQx1M6mOXsNziI8JN3H+juy7z
	qroK7ulZF1h3xPADoIMRFH3j+7BQSDq2QemS/Ldi/5IHxpEU58QMbrVVef5GVE08EI/BkX12iOW
	g9OLelgXcLFoDcEBpUpwcm0CGx5nPDzo0rWtr1q5HR8mkYP2C9HoCZIM0ZcVYoUa1R872i00UvI
	BqC9nRJD4qR3vfut+GE+mKIYEZSOFzfMHoUtUsKx0wDgTyjI/Gk+hEpK6WYptDPwczM75GB/UUs
	BL3XkUylBaPfeMFAb9h3rBt74TqeiGzElEeaxkBg5UBWPsx4GA+BF93z6z9OowB5ZuvRsuE5IFJ
	dH97IgfuGAn6DTP0GWDwMPEp8uPUla/gLHh1aSOq1qbzwm1+k1EL9UTnTxUvPH7KcBh
X-Received: by 2002:a05:6102:3f13:b0:7c8:18a2:f769 with SMTP id
 ada2fe7eead31-7d71e3723aamr3738481137.0.1795360374213; Sun, 22 Nov 2026
 07:12:54 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Francisco B <chicao.estudos.12@gmail.com>
Date: Sun, 22 Nov 2026 12:12:42 -0300
X-Gm-Features: Aa3M54qo4xOSozdqWjP5jcMyiHQxecrUYXGRwhP1GnqXtxVk6Ik6gDmi8TrJhpU
Message-ID: <CA+KC=zdmpFtVjKT3arzv-+1qduFAxdW5wEuaEKNzX6BBsBUQ+g@mail.gmail.com>
Subject: Request for 100% Post-Quantum Cryptography Adoption Across the Linux Kernel
To: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Linux Kernel Crypto and Hardening Developers,

I formally request that the Linux kernel transition 100% of its
cryptographic protection mechanisms to Post-Quantum Cryptography
(PQC). Since we cannot predict when quantum computers capable of
breaking current asymmetric cryptography will exist, proactive
migration is essential against "Harvest Now, Decrypt Later" and future
forgery risks.

Standardized PQC techniques already run efficiently on everyday
consumer hardware=E2=80=94for example, hybrid key exchange like X25519MLKEM=
768
(X25519 + ML-KEM-768), alongside ML-DSA, SLH-DSA, and/or AES-256,
etc., across kernel subsystems, module signing, WireGuard/IPsec, and
dm-crypt/LUKS.

Complete PQC coverage across the kernel will safeguard users ahead of
future quantum threats. Thank you for your time and dedication.

Sincerely,
Francisco Barros de Aguiar Pereira
