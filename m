Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54F5D2FF
	for <linux-crypto@vger.kernel.org>; Fri,  6 Sep 2024 00:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725582341; cv=none; b=l18VOEqj74Vms7kGUIRZocsgzppAEuHpLAuVCYHAQG0/Z355aBKJqx5Yaqdj65yLl8yadKhV7s4PzuIyEzAk83igw7dtB13QyLGC9cYJbA2WkMPRzcas8Q2cnQgZn6XyZGGU+0NZKT8tYb2e9qHcoyvkMBlwJGDgmFsv1TaDPdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725582341; c=relaxed/simple;
	bh=DnoU5m6tPFhGKffI5RUSLnEi3V+rpQJ/v5KK4fQJEoo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-type; b=Ws8F+1f7EWR47diQxavcr3r+au0SWjtRUn32X10iplX+7Hi3McKgG0SKtn6Rids6jEDfbdfp0YfW/LTT2Wu8nE8UDwaId+MI3zyvHlUvSBZKTEx5GTJnixfFhWjPfSUfSrcvIAMNAamVKVeV1Dgz7g0NqiKAhvpy3edmD9wXTDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GomBWiB0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GomBWiB0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725582338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=prgA+zV+zc0VBOH/hj65VBSwzfC4zfATQNsgodIZJoM=;
	b=GomBWiB0E24mI7xPpOoyjqbFAMeOTF5x88DZe4/dOCHsxed8Q+yVmXXy6cxYXWsdfMeDzG
	s3mhc7Fp2/WNKp6gwDIbKoZRSLpJov3138DxFg/iyJmD1x5WACrDlM4MZUx7PJuYCArzJz
	naLN3Hp5e1Twzyb0PekqMjjK/pqICMY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-3dt0uoXgP5qsgyxOeug2Wg-1; Thu, 05 Sep 2024 20:25:35 -0400
X-MC-Unique: 3dt0uoXgP5qsgyxOeug2Wg-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7a968ad3765so248916785a.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 17:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725582335; x=1726187135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=prgA+zV+zc0VBOH/hj65VBSwzfC4zfATQNsgodIZJoM=;
        b=IKTD+sAsCAYErqg9DdNAynXTV1giAi2wVFcf3aOVkIScoqSgd8QOfG4+zzX6zMmEuV
         /RlFS7UX6ArNIqVEV1rpBz5muIQVJpRV94feQ4oNzu97NzVAWE1w9BweLcct98hH27DR
         IcjJyFFqW+Eyl7hUnbnhzYOMWM5hnoS6lqAv4OEq85FyJGDZ3tq+gA7DrcGAUn0Qsrcb
         EFObc3PKqe2t7QEOJwoeQWzYu/Cq4qFVsbs5atyOOzBYC0Zcv/rW/ISGD4r7pkKf3q+R
         03jLpXdT5EA1+y9iQOywDzv8jsKgriuzXxNzeeme0OSCpk7m/jRpiiPwA1DSPTv6M+vz
         IVEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWE++iTiRm53IpljNs67fgy7Lq727qch0Rk6+fP1WzFs+NIX38BdwxIwP1Tz4mIVScitczNzY6T7saueA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBd5bIIadfcXbUkeH4/OXrBN3brMbaR3qz55Kc9LPE6Vc4m9hY
	xZavVOgQ661qjakFLDdkeU2r2VAQFHGv9MMsbF/UafE8mxANOR8zloqr4bU0uXRLK4nJJyLiknW
	9L6Aqizk3GjzizhNiOrfYwvYacKXmFXM1h9AMwe40vAwNOhYRxFbOdhFWAvZFmw==
X-Received: by 2002:a05:620a:2955:b0:795:2307:97ef with SMTP id af79cd13be357-7a997328596mr99140185a.6.1725582334960;
        Thu, 05 Sep 2024 17:25:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXjTU1DKgO9eg7wmv7EJbP7h41p0rEDFhDntd0hLbHaHx9IJKQbqSrMBmwKPodVNONK7KN0w==
X-Received: by 2002:a05:620a:2955:b0:795:2307:97ef with SMTP id af79cd13be357-7a997328596mr99138585a.6.1725582334689;
        Thu, 05 Sep 2024 17:25:34 -0700 (PDT)
Received: from x1.redhat.com (c-98-219-206-88.hsd1.pa.comcast.net. [98.219.206.88])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a98f026309sm120779185a.128.2024.09.05.17.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 17:25:34 -0700 (PDT)
From: Brian Masney <bmasney@redhat.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	quic_omprsing@quicinc.com,
	neil.armstrong@linaro.org,
	quic_bjorande@quicinc.com,
	linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ernesto.mnd.fernandez@gmail.com,
	quic_jhugo@quicinc.com
Subject: [PATCH v3 0/2] crypto: qcom-rng: fix support for ACPI-based systems
Date: Thu,  5 Sep 2024 20:25:19 -0400
Message-ID: <20240906002521.1163311-1-bmasney@redhat.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit

The qcom-rng driver supports both ACPI and device tree based systems.
ACPI support was broken when the hw_random interface support was added.
This small series gets that working again.

This fix was boot tested on a Qualcomm Amberwing server (ACPI based) and
on a Qualcomm SA8775p Automotive Development Board (DT based). I also
verified that qcom-rng shows up in /proc/crypto on both systems.

Changes since v2:
- Simplify ACPI fix based on what's done with other drivers (Brian)

Changes since v1:
- Use qcom_prng_ee_match_data instead of qcom_prng_match_data for the
  true skip_init to match previous behavior (Ernesto)
- Reordered patches so fix is first (Dmitry)

Brian Masney (2):
  crypto: qcom-rng: fix support for ACPI-based systems
  crypto: qcom-rng: rename *_of_data to *_match_data

 drivers/crypto/qcom-rng.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

-- 
2.46.0

