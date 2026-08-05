Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56A526ED46
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 04:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785904149; cv=none; b=usArZUJ1FFGAuy7aVHHiRx7FQC3kqS/85139YFycQKQZmVHo8VGAUQ0LHWPWKACpPpUKbYFr8DE78hawWasCM2FICgHAbsr49ETXx14zcVGXqn8tlZ+IwXy2K00GCUXfwL1yxVS301m6pP+usDJWgUh18/J01yeNiLEw9s9Y9QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785904149; c=relaxed/simple;
	bh=cPu0LtyeHLgBfiU3Q+8yJ1HERAGXYe6VlsTiEwoQR8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qN3y6BavyuBYbhq/3ur0JxsFydBW1NWDYDSndk5gqWVEfu1BMaQR+zMusvAFVCK6qMqggwjvodJvION5ARIMDB+bieS9pERCPv71VfPSBBs02QMcMuZnaH0GGV1J6U+GkHHmCOhRI5gtrg5G1BCu5Qs+fid8MraQpj8cBUoW8v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=fb4Sj7IN; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="fb4Sj7IN"
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 144073FBCE
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 04:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1785904146;
	bh=cPu0LtyeHLgBfiU3Q+8yJ1HERAGXYe6VlsTiEwoQR8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=fb4Sj7INqsD/rzyaOgV6mN0CpCno3uVYWA3+9K9QE+NiZDx9vLZZS0USvdEc0pM1K
	 Re/T/8hTA/WYQMq/vTXpLmhDemhjN+gi8Ho8ho/t9rxKD3taFwomoIZZos4qzEMX7f
	 7WAWIausZtLYldRwuROji/Qpop9/5UCcUpD3ZwQLBCOlFUTHVN+7MncUw42U9b8x5+
	 BxYVZxcpkJWunG46utdcv6A/3BQLcQ6p+EslE4YuOGu6EL6H3x1RbLv16C0UD52pwa
	 gLYdzi3jwpHdnb5XFRTZITdlfftOjmsmAmkmBuAUxT/cGl2MRgCKCg5Lad8Qc0WfaC
	 opag8fRrp6W3iJiAd/SvA/GzBZ+l7xTnYeVfnmxn0lTdvKxbTn8NJjrnZpIPH0eHfM
	 rAu+p4s3qi7LXLDc4vE9ni0Lx203u9tXLsQljVuLCL4vM+9VRsGYx1y6gqdeb0zFmT
	 yCG3gUOjcseFIxBm95fmDKpTB1aDRmdA6q51cFrKDS/nzd6ZAYVI6CMo7lzhvP8/vO
	 B2CpxtqSkQfQWIlLXw9YdvG7t+AIHM9h8JOE+LI7AnhryLGgcfIDyl/Sv9tYP0MPIN
	 JvXhWqknbychU9f9Fq1IHO3NcCXcDd0bwMQzQKI8W38ItpcHtlm46O0aOc4Kk/YnCT
	 V08+quwX76BsLr8vTEYlvibY=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-ca6bd8a190cso732655a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 04 Aug 2026 21:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785904144; x=1786508944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cPu0LtyeHLgBfiU3Q+8yJ1HERAGXYe6VlsTiEwoQR8c=;
        b=BrQ17seAz6efpmBMBB9dO0A3ikYlUbGSCxzMrM/BkzA4gcMkKmIzOino7b59vN5l7l
         Yp3PFMOZ1SjTDLtwIseM8dYEB6nBArzudewh6MkYrPiBygWYaepuhVmOEv31VSQ26qUa
         NLGOaG/swt336DX1ysz996t0bXCX7AI183ZR+aoDshV7uzCE5qeRBXHuqgH0zOoFHuI0
         UeLdjyctWuIT7MVPxLMFXgTP+wI34TwOOBZrEUaGVFYVRJbRP7jaB+TqVbIKF+lAxCTq
         BuU3fjKnpjnrkzuKVDSCCsfV/ekuczNOpCaHn6TqfzbNDkyLuWSUOET7rQg9BqFWlKPO
         Imfg==
X-Forwarded-Encrypted: i=1; AHgh+RqTTO5llETQ1yu/N8gSFZ938PgRarWCqS66kS04Fdvklb3LoNf4bveIpPftIRbghrQwffDSFh7S/h0J6yI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHFsj8P0+jV2CUkXC35bXojANnAOBn70QuFQa7jVKo54CfqHQE
	+qsLpE07D7L4MeLgdK8f/e6901GSazy53B/qS97OKl/p0ww9IeUvRfVSq/ospt2jINH8LBFyUbH
	VCs+mXhpgOI0yDEMpM3Wo2tZWKmVr9JBTpbuHjTU/0CuDrzjqp3gkFS+fla8KiJbQA2OyvPc8Jr
	JjfEopXA==
X-Gm-Gg: AR+sD120L9iERT0WM9Wlx+zR0NHqucwG+DWdZb+5THlCwgEmxmJZFabZq9qQ+GgqLUR
	Tcj85wcpwnSLbX0NPa96ClA3lgVRYzzAEDbb8WiyQhxzbbjmFftQhkC2TPRHNK1dv8dMhQrcyWx
	MhvcIm0Gjk3Jrk8yrXVbPd7jD8Q9b+L7sHMeVVzzqQ1CZd20lZMdZ7CDbhsXzcRanlDXOw38kqs
	LIIL8jxZkOu8kTyHUIgTCnKLXLwkkhtjoobQdVfGjTlH/RprOSbGyUIfc2WISnJQmMVKzsWCaF+
	H2/x5+7Z8to5ThKb19ZJli+wsh1nwTpEzusacBhCR6CTNsIhCZ+TT8Gm/u9TquTw/2D2ud7KaX6
	/4/M+BmtjbEY=
X-Received: by 2002:a05:6a20:da12:b0:3c3:856e:dccd with SMTP id adf61e73a8af0-3cb85e53c7dmr4510086637.23.1785904144487;
        Tue, 04 Aug 2026 21:29:04 -0700 (PDT)
X-Received: by 2002:a05:6a20:da12:b0:3c3:856e:dccd with SMTP id adf61e73a8af0-3cb85e53c7dmr4510044637.23.1785904144145;
        Tue, 04 Aug 2026 21:29:04 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867a96e4sm10404295eec.26.2026.08.04.21.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 21:29:03 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au
Cc: Martin.Kepplinger-Novakovic@ginzinger.com,
	changwei.zou@canonical.com,
	davem@davemloft.net,
	ignat@linux.win,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	martink@posteo.de
Subject: Re: [PATCH v5] crypto: rsassa-pkcs1 - Avoid cacheline sharing with underlying driver
Date: Wed,  5 Aug 2026 14:28:56 +1000
Message-ID: <20260805042856.1576276-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <am2UMhd5CAhDiKBF@gondor.apana.org.au>
References: <am2UMhd5CAhDiKBF@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Herbert,

An orthogonal driver-level patch can be found at the following link.

https://lore.kernel.org/all/20260805041902.1575170-1-changwei.zou@canonical.com/T/#u

Thanks a lot.

Kind regards,
Changwei

