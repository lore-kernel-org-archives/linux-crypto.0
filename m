Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4144134FF5A
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 18:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776882054; cv=none; b=k601XbG5KShOf3vce1jnB1ltNV6s1d1h7/bLX+s8EyTf882LYoFhIKghSalmtWRYP6frFwLk2p50cRAFoSmtP2gY+7hE/tNNeBxOM6Y/xW1ljoEo/Zv11y6bxJ3Y7wfsiVfTUDR9ueCyCRyMdgehGiyZvoJw5SIXGytUwzPFX+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776882054; c=relaxed/simple;
	bh=FOfqXcIW8PzAAJseN6kMVkrxS6YbtRJvZudF491F3qk=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=MzecDkByOi4J1FmPFNMWVH6ZJGF1R47+eoh3X/aY87SxHDADrgRAi5tDUoGblIzxnJ0UHtuubQkXtfiSGay/ECs6IbBo3LmFTMQaI6M5AZ6E/bW6WwGsanQ7eDntgJIY1OLI3bI7ewxIa08ZJ6vWiQWTUy0Ab6KLKhPlvECy9vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y0sDBqcq; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0sDBqcq"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43eada6d900so5672932f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 11:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776882052; x=1777486852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FOfqXcIW8PzAAJseN6kMVkrxS6YbtRJvZudF491F3qk=;
        b=Y0sDBqcqucVgqAD/+5b3CqsV8JEJ6WfNyHT/YPNCjaVRZCnhpkTbm+WguUrIdE9NZj
         1Z0RJ8A7cvqdbEgvSODEsjcS55e2PNSvsOq4GVZo2oT6LTeYtw9mD7hp2bjyznxan/wW
         qhBUNfejby1k0yYp5e7pmcJKNO9Jz40IjfXbwlWpxxtGK896jh1VfAz4lQmUVANvjm7M
         fRAbnlX5QnwhSzHyzHR6dZ2w20qiOET85p1ZvcuLQhMhU5+hb3hjd4tm6gXVyg3TLb+V
         aTvLDWVi0pQLuB7B0P68RTN9ct0dyHnBaWDKsZlBYpVJevNiCoPv3iP1A2xeURI3brgv
         SZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776882052; x=1777486852;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOfqXcIW8PzAAJseN6kMVkrxS6YbtRJvZudF491F3qk=;
        b=oyqSKoT36ZbsicFmuiHpJMN9gRnCbPid7S3i9cnZ/kP5lxdxStwlC72B1WKdEVz53x
         CGUSo7MEJDV7gvFDaxnKycsdtavpgFzjDpZTYV1DLFZ0ueeCPEuGTvmeqpOQDzh0Iy+c
         3g9+oXEMIgE9IAEqcDG7Ms8wS0Vd99iXNzt5xKtpSEnlXhb39QK297pwqIvolPprkHnW
         KUTN0FwWAuSteP614vrQot1NMcAn6to1XC4CLuerMd4/ZNB6jkOzhdQsITOJ4Zu3CdtK
         Hzy/HIpGOWKNgMGWDyp9aoX2bG4S2kemeq+z3OVdq2uiMBnoe8deNTmJICX9FtSHpIZ0
         NOhg==
X-Forwarded-Encrypted: i=1; AFNElJ/Rf4U7uUaybinZwSDHLCEMuQ83xDGhfX3BchuvgszXdlR1yQdDE4nsb2LQiI+dyMRDUawbHgd4nIOUidA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+0LeJfViQ+gYlqetsD6q0FhaocUri8o7ooHCTFSU7Ypn/ESnZ
	AFIkjS39D30Bs0990atnKhWEdtmOIz6LjMFGuYhtX/HO5pzP2mR0VFgG
X-Gm-Gg: AeBDietoIquRuHi0vRtMR73AW5rSPv4ehf7UUUO2Ux6Lm8YpTLul3418fxCWrz/iO/+
	V393ed8Gg0QZEaNdcH8MwL24MMTnDVj5Cn8YPpRG2H6hp+kRCO07CLDAtNEq5+81DjIsEcAzZwe
	go2PU4ljQm6oU8b2JKVBgJ/T+Zjo7WTxOtGuLx2yPmj9Wa0J7bvolvbcSw2jRYkwIFUKpRHFZxo
	rmuSLdTEWubeWJxxRtn9Pba7Vh6cYdjEfeZNfN6zrFBYXIAzkaf9KOvuk5wo6zYkvTCGAopeNiM
	WT7umlyH5fb2KlaA8K4FxEOX6NUY6Xcfj1r6UZZWPRulDxn10HZFdMsZxqFbdU6OuU7Zi29Rl37
	tpuxwk3wouNK8gHAeNTKjsoC1yf+DkFyS5o/gRDZhYRHcEtuoM9qf009Kw2BMItt7XfBKYjnZNK
	V7S/bVu2rG0BrG/ExHX7QJ/Z3Tdm0d5WJbyn+k
X-Received: by 2002:a05:6000:1447:b0:43d:7b90:fa2a with SMTP id ffacd0b85a97d-43fe3db9c3bmr37137540f8f.3.1776882051593;
        Wed, 22 Apr 2026 11:20:51 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4d112sm51676217f8f.29.2026.04.22.11.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:20:51 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:20:51 +0100
From: Josh Law <joshlaw48@gmail.com>
To: ardb+git@google.com
CC: ardb@kernel.org, arnd@arndb.de, ebiggers@kernel.org, hch@lst.de,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-raid@vger.kernel.org, linux@armlinux.org.uk
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_7/8=5D_lib/raid6=3A_Include_asm/?=
 =?US-ASCII?Q?neon-intrinsics=2Eh_rather_than_arm=5Fneon=2Eh?=
In-Reply-To: <20260422171655.3437334-17-ardb+git@google.com>
Message-ID: <A11B0E21-5ABB-4609-829B-D4F0896331B6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

Hi ard.

Makes sense here

-#include <arm_neon.h>
+#include <asm/neon-intrinsics.h>

Reviewed-by: Josh Law <joshlaw48@gmail.com>

This series is a good (and deserved series)


That's me done! I've reviewed your lib patches for you, have a great day!
