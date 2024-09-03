Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52DE1EC018
	for <linux-crypto@vger.kernel.org>; Tue,  3 Sep 2024 21:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725398570; cv=none; b=O34+kgL+LRV7IlmKFZyQnduwJyQxx1Gk12tW3FeGMpm6EpaNnXtF4muVez+D5ujGgUUzbK8Wr1KSXQQ6Q6Ksdw4t/roj00yC/VK53SYAIs1XzKZIl8J9d7LiHO0hCeJp1cUjDFp33uvXqeZppDgbqM142zVD3U1NzgX0k0eXLc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725398570; c=relaxed/simple;
	bh=xLNiOMxaw2LZZ/ggNobSqCSlzqvrzF9ZY7MDKfT8EGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=O+ZOSyMai9mJhNEdBbzZlkwFolMUkp/8SaKihUWBQqxcfvlSXvKd/B+1b9kqtrYIgIlHj3ZEE2/maciccT9xjlUQ4SgsqolHdvEhikb4BGMrJJKCD120Wj8A1NDrknZKw3jR8VyP2SD6IPopJ1PJOkbKn1E1E0n8TpDA3JxYviE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MFUtwawY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MFUtwawY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725398567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P02lsMX4DngF767Z3UWIfE08mOI+plZIsLND6/2CQRk=;
	b=MFUtwawYHg4l1K0o32Zwdt6decdCAqsqB10sxS/121ZyH8T4oLSei8hC+Ot3fyjmi73EVZ
	hQ8b7YygSIwQhDKLevBE9st09kaUXyDc69Tz8EwrMOFHy2nR7NnYzbPfbHZ+SV8k9bxd9M
	fbzcXzVq7Bu0Yf1j8odNC2EcGMQyabg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-dHiL-5H_MUq2TsdMjtuKfQ-1; Tue, 03 Sep 2024 17:22:44 -0400
X-MC-Unique: dHiL-5H_MUq2TsdMjtuKfQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7a80872dab0so16275885a.1
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2024 14:22:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725398564; x=1726003364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P02lsMX4DngF767Z3UWIfE08mOI+plZIsLND6/2CQRk=;
        b=qjVYVSKwF8oyIG1lz/xi29XgOd1BBCjfVgvbyzibzsaWamkm2SrhDA4v/XvQbNMYts
         YqQGC0FUnvdUpCADYOQVsVk1sXMXDgCfDn2XSPwE/2kJZu3YchvQ1OOrQ9fbvseF8Ezs
         7mqcPbpTgtemRSM5TMJ+opJhF0gNfYpevdPkOb4/rCBM0tiyq3R/+6h1CHGFItgD25QQ
         QQp6f9m4kl/y5xJP/nylpprJHzKlaN1QYHEGSJiqT16hHWsYGmAoDT5HIkEYR37oNAnm
         CfRlsqNrpCZlLhqZsPyvaeMc1PPbM/Zxj5djGQg2oV+nxKQLNua+GHFzQ/bQxFq2wamV
         bUEw==
X-Forwarded-Encrypted: i=1; AJvYcCVWGWnId/d1Bw2JCVewYtwdUG9wpPed/8ZCOamI9KJ2Anzs0JBq4efMlwKvB+yjDegWoih1eWOvRmNDt/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBEdGkcK5XsFa9wY3iQ3OzLF7da4WqXjqfkKXEIuPYL+xTd3nz
	i6prey0l7PFeO4UrZjPUHhE32njXYr8pvnnhCjvbiofZWRxbCxoqV/ccqPk4o5IFqWLgPmJdTf3
	a+RuIiTjpFJWxgYwoao3EnspeR1KjFZqKDtcgAjVXGKbtDUCZxsFdkNRCgW9Kdw==
X-Received: by 2002:a05:620a:470f:b0:7a6:6d37:9f19 with SMTP id af79cd13be357-7a811f51a29mr2648121185a.15.1725398564277;
        Tue, 03 Sep 2024 14:22:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExSoBiJ4VDU7q6qrqmBNoLmWNnqwcKBZ7V+aCR+x+Y89wh/+jQl2xhNDuBYCHNMXig/9lHhA==
X-Received: by 2002:a05:620a:470f:b0:7a6:6d37:9f19 with SMTP id af79cd13be357-7a811f51a29mr2648118485a.15.1725398563905;
        Tue, 03 Sep 2024 14:22:43 -0700 (PDT)
Received: from x1.redhat.com (c-98-219-206-88.hsd1.pa.comcast.net. [98.219.206.88])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a806bfb8c9sm564737185a.25.2024.09.03.14.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 14:22:43 -0700 (PDT)
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
Subject: [PATCH v2 0/2] crypto: qcom-rng: fix support for ACPI-based systems
Date: Tue,  3 Sep 2024 17:22:18 -0400
Message-ID: <20240903212230.707376-1-bmasney@redhat.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

The qcom-rng driver supports both ACPI and device tree based systems.
ACPI support was broken when the hw_random interface support was added.
This small series gets that working again.

This fix was boot tested on a Qualcomm Amberwing server.

Changes since v1:
- Use qcom_prng_ee_match_data instead of qcom_prng_match_data for the
  true skip_init to match previous behavior (Ernesto)
- Reordered patches so fix is first (Dmitry)

Brian Masney (2):
  crypto: qcom-rng: fix support for ACPI-based systems
  crypto: qcom-rng: rename *_of_data to *_match_data

 drivers/crypto/qcom-rng.c | 50 +++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

-- 
2.46.0

