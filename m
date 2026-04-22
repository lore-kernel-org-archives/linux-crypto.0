Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A273E39A802
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 18:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881476; cv=none; b=gs6ZW8a06lFnESoe18+TU8X3MPsx5TMHo6Grdg/Cd3owWfu934mBkqCSNkCS0jFIfarJcwD86JCdxLLI3m+m+s2DlGw9xx9t1ooNnbobvs6RnCS7b/idzf/zwympkO46K9VfGCIcM8ZeG3bzeEI4jrRw/T22jQv2fSD51m0TWN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881476; c=relaxed/simple;
	bh=nXtwUn+NjPRObmT4cOtGmM7dgAdwJRC+fUheUU2sS5E=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=YAmDE3sEyuZeDV87XT5Istw0/Bn3LNDUfI/WslyKfNPjbjXBp+TTgGb4cggOrYU2kKv+QnxbUsFtu4PCqTiU4nS5Dr1BJi34C9vlNXkwvPd19asJsLjSpByjNZH/BjKs1sfm35C0y5DYPPvHOp0etOWJxboWHu8gV8x5dDZxEWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qs1LjsTQ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qs1LjsTQ"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d73352cf2so4734699f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 11:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776881473; x=1777486273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UgPO/NbskuOhdPOSGOgEbfwqbCTSS2Gc0tnUci+MT3Q=;
        b=qs1LjsTQAhEyN7SuqXnfFy0loULr4/nWx4+YLRPKhyzVYR6dRpFvtswIVoDB8IMrhJ
         5wybA1whF6hdmKQHtpLJg/0Viq9DzMb7HgN4Y3Plh3kyUIPDCwbJjtEhscZJkSF3iV2w
         U4HuYcgVuVc5WSwxFHhFXJBAmwPn3iJeygeVCW8i0bg9UTqtVZphjUzNTS3LmRNh/WZO
         CcvsVrRp5cLj+8Z2YMU2+CtiV6BF2zx17oJBXGyEnaN2x8LFPAfiRTcRtDtMHOv3TlBb
         YxvS14BbIXNy+jNG9m9p4Bq2F6+jlOLJByzW1uLhOXlhVfdgJGeyo7ITqADe9D/ocY0D
         8vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776881473; x=1777486273;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UgPO/NbskuOhdPOSGOgEbfwqbCTSS2Gc0tnUci+MT3Q=;
        b=dF3TjIP8z+GNSOF6108Vb1g6+VRRtn+qOn6e1/T9qz+53qKljx7YW7F+8VfT11E20v
         ztxybv9QhgGJefxWaoOgNUCWe6/u4t1OKzoOLSLDIxZo2jX6cPBFsfJ+9RUUBtBIsFRG
         LX1RUMDoSjbHGT+tsCBxEq/2mCHfynHIuvEOr+N2ZDA87evo92FqvbRB7/1Ey5P42mRf
         s6m3j5B1nVaflhJbhbjqTyUTrq0inW+HzCvwc7rLPvUITYjYpfxRzrvQZdsyd0grtDA8
         gl/GjCEaiv5jl7zefPz5j7cRlQta6+oX7+MvxymTxwoblzX37ibDtCdLPyiAa2ACQWgP
         f4cA==
X-Forwarded-Encrypted: i=1; AFNElJ8de1fP+srjLU95GyiTUrsMLLBFdiPbynMyzKMuBBhlatZ20hEMxdyI5NyJJNPKcCee/eO6VJyHSBkaBU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPD+K9+p0FGXHrY2ivo+PjttE8CE9lc9P74BxrB04SjSgYv+mD
	+wqvj5Y2ZibP/gHuekcc8yvQRIz55xZsb/t1Qd67MX2VThCsSg5aRQ66
X-Gm-Gg: AeBDietSwwzURnZoqvRz02OIad75bs1LicL0JrUk1weDatPTNYyuuguvVVP0b1MvUg+
	0RX+Dx4cJVDUR89fwWAq9N7JYib462qewb72DCJqCgVWjWaK5lAhqu1DoH2Ha8xkBGr1uVKcZne
	mPgiQ3YWBZ6M5HXysfnxXAwLqE1SrT087VJuwBwSm6ifbXRJs/PX6mJXZFhoJCQY+sx9/V6p32E
	/zxoDSynQgmfNLNlawrX5nSmy5KBZCePwGq7mXVGq4aY3jNwrKnOyANWUKlQlFePJoObFVaAaay
	C00mU5ISOdUbgITwIJHNQo1u6zXRhZG2ipQFPyya/SzHPy6VE+Y59W8nDERwV67+kUgLFTe1UsT
	VPQQjMY/1FKsGsBtPyc8TPI8thZU8IJ8kg450N23iOIy7rhi8TBoqeL8V4zIXf8NomTs/XFMltP
	I5ez9LmT/oX9zsj0uBM4SAAEAlSAOo4q4B0C9+
X-Received: by 2002:a05:6000:24ca:b0:43e:a70d:7632 with SMTP id ffacd0b85a97d-43fe3e0b463mr37323014f8f.25.1776881472867;
        Wed, 22 Apr 2026 11:11:12 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4ffa8sm48497290f8f.35.2026.04.22.11.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:11:12 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:11:12 +0100
From: Josh Law <joshlaw48@gmail.com>
To: ardb+git@google.com
CC: ardb@kernel.org, arnd@arndb.de, ebiggers@kernel.org, hch@lst.de,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-raid@vger.kernel.org, linux@armlinux.org.uk
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_3/8=5D_xor/arm64=3A_Use_shared_NEON?=
 =?US-ASCII?Q?_intrinsics_implementation_from_32-bit_ARM?=
In-Reply-To: <20260422171655.3437334-13-ardb+git@google.com>
Message-ID: <7DBC760F-0524-41D9-8A6E-6119F0E1AA9E@gmail.com>
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

>+#ifdef CONFIG_ARM64
>+extern typeof(__xor_neon_2) >__xor_eor3_2 >__alias(__xor_neon_2);
>+#endif

Creative. A  reduction of about 150 lines of duplicate code while
maintaining
the __alias for the 2 input case is great.


Reviewed-by: Josh Law <joshlaw48@gmail.com>

Thanks!
