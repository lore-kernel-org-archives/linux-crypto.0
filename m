Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A254217C67
	for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2024 01:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724894495; cv=none; b=iFzQeM0xvZVJ/AKDxxEwH0N9qXVtnOSO0olpzSnLz6YN+lp0+3jTmUhDd9WxhHIpJNAZa5WhO2jeT5k/V1p5YVnEi6v6K7V4mxd+sQXvmzQAmZOBjRkx/FZ87Z76+Y/dwlCNpKpdpRwXgZnKPMZh73h3//pDnRn5zkTUBfYCqZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724894495; c=relaxed/simple;
	bh=skcMYmkBzaPdB5Cqc+jAvVZYCWgXNtH/S9Wna3ROl98=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=HoWf2psxlR4/fdko+oTX9FqramfPJ8ynaHAUnW0TaElfwl5clV1QLcqxOoQboNyMwOFjLq2qAt8BqSdCnHbF/Kh7GO8Y6cDi81tdt9XE+lXV1qiMC87LHdJp1BwJAgThYno+WqwzJLNKB21Omd5r7eZ8eIj3Csabv0I6IklaEAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DTAhS1+y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DTAhS1+y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724894491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xA96S5hJVD7jAK1AQwcph0AMSK8pgIwZSqUYdNlyckI=;
	b=DTAhS1+yQCmFuJcYt3K+gP3mYBInAhaVE922Tar2KPByPfg3ctr+UWwwMxFTxrHJYA/WOQ
	NfRdnbgdUZvMDaeQ78GRJyfP2IxS3MJtaoc7DG/FdJzY8tVmfzlVIi11rsJu9Qhk+r97r7
	S/EX+jfcsuxohKx0B46QL7JJo6Ktoeo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-2dLY1PCrOUabagjqc4NeGw-1; Wed, 28 Aug 2024 21:21:28 -0400
X-MC-Unique: 2dLY1PCrOUabagjqc4NeGw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6bd94069ceeso22588636d6.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Aug 2024 18:21:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724894487; x=1725499287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xA96S5hJVD7jAK1AQwcph0AMSK8pgIwZSqUYdNlyckI=;
        b=vMP0qnHiYvtC8Q3Wzw5hcB78xZ8WWc6NU+ngZAwwv/X2yh0XsdQy5MYoewPzdzKVjG
         8s1cDqvYoJvWky/PgIvlIVvNxLpV43yjJ1vksZJbheHWXNs/pW06708mi6llBDWRGMoX
         sdFEQGMNVHm76+v8nU4a+IW2GbevML8d3xCUFvFVlwscQScfeLjke0PjcsPxfEvuRAj+
         9qxtTYCz1EJpdVAWSTnJpMvl3nQA1nbk4YD/zv5WnExr8rAs70JvJEyEKNyq/12OeIWt
         RqJ/TtG37durttuLOPzyn0W5Nu8Vdd1pD4W0m3TvMMVbY+eMOHabx2ffvItL5TvTgxlA
         gXhg==
X-Forwarded-Encrypted: i=1; AJvYcCUAsE+TR6RBb8hIdcW0MLYY7k3eIkNS72tpzy4qbfif2LJAbm9b0UFliAwkNdLgMgMX99hIExY4Mg75Mkk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgImODxniTFKZGNLTIWdD6YmDKLgWxVvrt+kl1PnCgXSlaW4ZQ
	H925m5dp7zK5ZN6DhSoyNrqRl08q/nuAJlo5ieDBEObaK3+qEPcOR9K/H0QcQobG2em4S5Xnv72
	QqXX3OHzXCpQVfJCYU6a+FlfjM4WJJYlF3QjBmTAu1lDEyiK8afQqCyAMn19fJg==
X-Received: by 2002:a05:6214:2387:b0:6b7:923c:e0b7 with SMTP id 6a1803df08f44-6c33f3a4170mr20180386d6.21.1724894487588;
        Wed, 28 Aug 2024 18:21:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3ImsCNh+Reo0irARwQCo+4xKteQ5h6er6E2txS3nQ6+qHXf5Bul+76XAT8VTntFotrWpmRg==
X-Received: by 2002:a05:6214:2387:b0:6b7:923c:e0b7 with SMTP id 6a1803df08f44-6c33f3a4170mr20180076d6.21.1724894487205;
        Wed, 28 Aug 2024 18:21:27 -0700 (PDT)
Received: from x1.redhat.com (c-98-219-206-88.hsd1.pa.comcast.net. [98.219.206.88])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c340c96825sm1013236d6.75.2024.08.28.18.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 18:21:26 -0700 (PDT)
From: Brian Masney <bmasney@redhat.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	quic_omprsing@quicinc.com,
	neil.armstrong@linaro.org,
	quic_bjorande@quicinc.com,
	linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] crypto: qcom-rng: fix support for ACPI-based systems
Date: Wed, 28 Aug 2024 21:20:03 -0400
Message-ID: <20240829012005.382715-1-bmasney@redhat.com>
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

Brian Masney (2):
  crypto: qcom-rng: rename *_of_data to *_match_data
  crypto: qcom-rng: fix support for ACPI-based systems

 drivers/crypto/qcom-rng.c | 50 +++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

-- 
2.46.0

