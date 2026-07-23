Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDF227707
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 00:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784765091; cv=none; b=siB0pYCcYrrQRRYNnVuXP9JLB7xOJ2SCT5E68pO6z7BOP5NDq0YGYDNPI8qV0iA1en6HCcOUKCR6ZfUNo03EazhYoWsMchwdXYc7ILp8JLXjJlBYWlQr+3VyUACW/wkgf2LhBi3cyfuuaqQaQCkatfRBwiiNUOqND5sbvOPphuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784765091; c=relaxed/simple;
	bh=ZP//XMZ7JCb/uHzLK9Z1FXYMo5tDITZi8CuuW9mXdh4=;
	h=Message-ID:From:To:Subject:Date:MIME-Version:Content-Type; b=Nb2yB55BxPpP2o3FwehbLG/KRKvmN3XTyJu1yY6FCwdQSowuO/9To8iHU7QIFtb3gRLWApQrIrEts40URKzVu217jEPvL9n+PvAnD6xePdlQFeX0v9GEBag0zpjRaVzRtjA3dcbVMn93J10+GeVwERw2xodSHnP8ZpMDhqKgCfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gosalescloserapp.com; spf=pass smtp.mailfrom=gosalescloserapp.com; dkim=pass (2048-bit key) header.d=gosalescloserapp.com header.i=@gosalescloserapp.com header.b=xJ96yWmQ; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gosalescloserapp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gosalescloserapp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gosalescloserapp.com header.i=@gosalescloserapp.com header.b="xJ96yWmQ"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c2808dbc3so271801cf.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 17:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gosalescloserapp.com; s=google; t=1784765089; x=1785369889; darn=vger.kernel.org;
        h=content-type:mime-version:date:content-transfer-encoding:subject:to
         :from:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZP//XMZ7JCb/uHzLK9Z1FXYMo5tDITZi8CuuW9mXdh4=;
        b=xJ96yWmQTIyODC3GikebkmdrlRZwbQ9jTepje8/HLfUX4AjkWOzYp72yMydc7XeU9q
         3vw0Gq6RrLwyo9HPgn4rg9MHRjTJTJZmWsJb/hO/AOQZeRri+Nn0cvXNahWjHPe/Rms+
         W15h79fuIMipDD1grmemgbrRO8zQu7gOIwdQUUyCOkwctAsa2Iy8OZsC5+xJy3N7CQ6U
         sF8+6QutHWZBz5QOi4hHm/xUmjiii+8tuV2v9ywJ5sDq4dAFcpXPdV+4AjP7UDsrPhZF
         hdUW7KJBxSPGjbvXnBrZsp3+ugqTkOwQAt65mva0AsQzOvTeCydwQ8ifqtEyJDUzw4hl
         PmNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784765089; x=1785369889;
        h=content-type:mime-version:date:content-transfer-encoding:subject:to
         :from:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZP//XMZ7JCb/uHzLK9Z1FXYMo5tDITZi8CuuW9mXdh4=;
        b=C7mHGeaJHQQp4LAS9lBK9MkQjeXsC1+lJXlgdHOxzYjzN62fz6sPIP2rRZcsrg30ka
         XjFTzbmjx2qdRp8zcqOh6r3iiZyN42RiQD/31M0PIq93PTvQ3nH98IEHELrd3fTHLVY3
         uESiH808U9edvZjdhmcnyM2E4hsthMbiIq7s27VUTz1y0rgGikVYkB7kndzoa+Fvwdyl
         lCuZ60XNP8n7a8Z3UChtdUNnRu+DwnziMiZxJcZ8X6WT+kkLbIpg9a+bPObQnr8GmAdm
         qH32r7jkldyuN8FsJTQ4NgStSIUkHObD1BN/NWwFFkbEebxeZt/RCBCOzop1F7LJ0Kcf
         go6g==
X-Gm-Message-State: AOJu0YyjmnpIAxiWfnB0Zg3WrAS6Yvb+Ru+6S1satxEimZSBLdA54Afi
	qVXtqiUP5Uj7KZIh8kCPas91IP9gAl5LOMGAReTtLZRayJ28hH+G4tV9mwwvfXIm1+m2xIpctge
	93bQ9Xg==
X-Gm-Gg: AR+sD130OgC1MRtV1Z5ngGFr3WQLWoYPDxxU1SuQG6eFNSy+qjtn3O6wOLd1n0jrBS5
	YUtv0TK9bTXJeGaClNyH29rO3kTFSYEa+8djz/zmgRBZTj9j6HlLugItCEdx9c/qUvsu2gFjqcQ
	WJty7rE6BbciHboQzAgd+jclaGcWx5sW+STS5G9DuGkMCdN2WYZzozuPT5zV3zVanBaJ7XRaSOl
	E1L/HGM3jtn1ZHWvf24z6eqAZWdTOAgOrX+tl1dUjfg9sUZ5YktIL5ZBhlAHI8Jq+4088u4rNmY
	f56pqLBkphGmsCxQzaDau+8vBD6UYRsZFIHpWJlz28ufrSAJdnEt6EHPqshYojeLyHzEc94nsbd
	jcRSYkLRojm7BBTBBx7Ljr+LgTcXZfnbYDRs+dd8r82QtnwdkYoRzKdOMwho97KeD1JrsA8mtYw
	5c3jGOpvoqMzBBgL8ZwhJHJd4YkcUSUHkZm/bfjCVzycehgsHj7PuSn6SJZQalBpSW3OG/vrpAu
	mrDJx17lKBcr5hpwysQ3BSfzolX1pge2WdCCr/j
X-Received: by 2002:ac8:7dc4:0:b0:51c:7b12:5fec with SMTP id d75a77b69052e-5283e036049mr7356251cf.88.1784765089152;
        Wed, 22 Jul 2026 17:04:49 -0700 (PDT)
Received: from 019f8c49-5228-7909-b3ee-a449a6f1c14b.local (ec2-54-173-11-139.compute-1.amazonaws.com. [54.173.11.139])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d2e77004sm24788381cf.14.2026.07.22.17.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 17:04:48 -0700 (PDT)
Message-ID: <019f8c49-5228-7909-b3ee-a449a6f1c14b@gosalescloserapp.com>
X-Mail-Abuse-Inquiries:
 https://app.instantly.ai/privacy/report-abuse/019f8c49-5228-7909-b3ee-a449a6f1c14b
From: Emily Cooper <emilycooper@gosalescloserapp.com>
To: linux-crypto@vger.kernel.org
Subject: Yale Blockchain Initiative sales
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:04:47 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8

Hi,

I noticed how the volatility of Bitcoin=E2=80=99s price can make it =
tough to stay on top of client communications and leads in the crypto space=
.

An AI-driven platform can help manage calls and meetings smoothly =
without stretching your current resources.

One of our users in fintech =
found it easier to keep prospects engaged and schedule appointments even =
during market swings.

Would you be open to exploring how this kind of =
support could fit into your workflow?=C2=A0


Best
-Emily

P.S: let me know if irrelevant.
