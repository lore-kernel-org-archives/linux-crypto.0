Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4747B3C2798
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 18:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881619; cv=none; b=TrzIjnIFoFAfxuk47Oa3nb1PskksOZa1ktX2ROifhCTa20RxmEee6slIqg9+m9mNQ6rvBEl7JvJaVONspjF0/CgOh6f8mHGVLfIWaHnE8LlfPZi5aps1J2APDlSYJm8Dyv/1ZedyzomWHkW3JTK4Ck6B59qjm3UfoGHGSGENK8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881619; c=relaxed/simple;
	bh=1G/9+VSes2KLldChLxUMctmdqTZCq5yUcorejOpjA4M=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=i118Mc3kbIKgkIjd4LSu0soFTewO2SnYOL3nM3jsXMoSlpnks5nmNuc+zb9Fs9eOsyCqDBIUK6wCsxFscK7kxNUwoPCPVSu+59Uw7nViaL8PKhsycbFfGnDkazKWuGgXJrDzH2/XWyvUoI+4Yt0yBX7fWJiN5sqyfGCAIVejz0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ktUaomzd; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ktUaomzd"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so50839275e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 11:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776881617; x=1777486417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uyz6tSF+oy1MloiWLm1wGiTPmiCDVtWICeLWrJM81rU=;
        b=ktUaomzdkHnA2fnsEnEGxS/H8qGbj19vBDgSIoPtHrLL3UKuRK2PrDZ0aiP+kc5Coc
         FyqKkZ6k70TfBUjuDii/ii4QwP9E7di39iJv0VZSTKtpeBKkxlJrFIXSFaj71C/dEUzA
         oLzU46UWqw9BmGindu+8QOGu8kV2rh+wyigI/JCvIv1SptRjwoQbfnuRDnDoqyGN0UUd
         WrkyavNmtufs1hV3zSeHe1JcgCS2aFFHECzUnM+aCypju2sxRz+igY1JQ5QTvYgHw+mY
         f9vpdIMONDxbCaCWUXAlnoAYEL23cBYHmYIOdUyzqevC4DrD5Vx49zLYR78aUveJeMcx
         4xLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776881617; x=1777486417;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uyz6tSF+oy1MloiWLm1wGiTPmiCDVtWICeLWrJM81rU=;
        b=Rjm4UoVU4ZW8LwUup8ro79c+FeO77yhcHb+YvUgXD9taoz0XJKS8G3mYEA6cXVThS1
         90MJ0iCaX04fMOdpfTQ8jPLKDMRqFjwOG9HObnF8Y+SldheEYVZ95RpeDYvJMLi3a9F8
         vTAPgrN6dMUbCkvwDXQden/lbP307ghIAjZ6JxRLRJHQBy6B8H4DP6auyRW4w0kCxYkg
         Twnt5pOd834BK2ybyTVaKsqmJIRxqUDqb9Eq8aO7okTy7RXdwdyShl3dvBgwWy6DOpVo
         Ubm0FFMn7fytM62yp3FTfTlpqqNsiSpZ3yje+Fi/8fFSHuQkNLm0JCduOaYB48j8/Jwc
         tNPA==
X-Forwarded-Encrypted: i=1; AFNElJ+M9A/OiJi0y9vVVi31O4fJEeL6OgiGlWhgUfMPbFF52d1F6Famk0ukMsD3eSSMnVnIgwpKrx9BCIP6xiI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxun4wWy6I8sxXlJ/9/uMO1wUuxg27T/XcoK0sLQ1A/WSzsvBBI
	dx3bVhgGyrhTpndTbtDrygEDbt3i/DeeFMsP44Lmu3TH/+4l8Qto0dp6
X-Gm-Gg: AeBDiesatMhCIXWW09LGabRVS8us+qZW83RyT3kMlSWAxh5HnqwjYLOQWVAcjrKXzJY
	t8Q2UbXC7IVbqc5vgXGqRR4xqoWLGFWYLMLKa7TIflITUt9dkFmZ5UQv2QgPDWG7M5B4Z3PPM34
	XSogBXpyu81NBX3/0ocEKqH0sWR+X+KQJAlilX/PTeqIQUGuZtM6TWZmzIl4/+13bqogzcWQLmF
	k8Mn4M+GQavzMOxrlBNF1SNRA2AJWoG3xP4/2kNkS/L0peZdL6qqFIdc/9QheNabaHCPdJDB82S
	buCvMI77WBVZnKX6JHMh1o9+KNy/4+OcGVqEN4DBQB7u+G6fx5nfF/A8S0/OS74824BCM2IsQR8
	JGwskBur1b0yjuBCMNrmatnCTwWEcI/o+/fQTa+5Ne+nmnac8PjBxEbSu9+snydrymB/NBLdevX
	s7/guuoe3Tw8l4hcSKq1cJpwpSfV+gbhJl4Vkw
X-Received: by 2002:a05:600c:8115:b0:488:8577:d9cc with SMTP id 5b1f17b1804b1-488fb77faacmr295680905e9.20.1776881616583;
        Wed, 22 Apr 2026 11:13:36 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb72d365sm232234915e9.1.2026.04.22.11.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:13:36 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:13:36 +0100
From: Josh Law <joshlaw48@gmail.com>
To: ardb+git@google.com
CC: ardb@kernel.org, arnd@arndb.de, ebiggers@kernel.org, hch@lst.de,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-raid@vger.kernel.org, linux@armlinux.org.uk
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_4/8=5D_lib/crc=3A_Turn_NEON_intrin?=
 =?US-ASCII?Q?sics_crc64_implementation_into_common_code?=
In-Reply-To: <20260422171655.3437334-14-ardb+git@google.com>
Message-ID: <E9489A63-1EFA-4AA0-BD66-6E4066F01C6B@gmail.com>
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


diff --git a/lib/crc/arm64/crc64-neon.h b/lib/crc/arm64/crc64-neon.h
new file mode 100644
index 000000000000..fcd5b1e6f812
--- /dev/null
+++ b/lib/crc/arm64/crc64-neon.h
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+static inline uint64x2_t pmull64(uint64x2_t a, uint64x2_t b)
+{
return vreinterpretq_u64_p128(vmull_p64(vgetq_lane_u64(a, 0),
vgetq_lane_u64(b, 0)));
+}
+static inline uint64x2_t pmull64_high(uint64x2_t a, uint64x2_t b)
+{
poly64x2_t l = vreinterpretq_p64_u64(a);
poly64x2_t m = vreinterpretq_p64_u64(b);
return vreinterpretq_u64_p128(vmull_high_p64(l, m));
+}

Makes sense.

Moving these polynomial multiplication wrappers into their own header is
good. 

Reviewed-by: Josh Law <joshlaw48@gmail.com>


Thanks!
