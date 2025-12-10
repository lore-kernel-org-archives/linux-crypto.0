Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECAA2FFFAC
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 08:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765355519; cv=none; b=ZMNL+0Wi7W7dpr5gFZUZ+V4RRzBIROvhk8iSTAfLKKZ+YFd2lnMUYgnEvdi7M54IRZ8xV7SxKHCeKc0niOhpqNoxGoXWPRqtJFmxTu4ndII7DyxrEAmUrDl76EG5K2+NonO7NpxSOe8ehMIG9XY8ovbpyL+NbtVCb6e25NU+Wv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765355519; c=relaxed/simple;
	bh=FFNspWcgr6JBh3jF6KiuWIJwLT9QVchWO/Z3r4hqr+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h1CiRMRYAYMhObZeKf78uq/5XVSV+egpFC1wUWiscA4u1LEAOWidWzaLZZBlgdrp8XlPQINasRdCKQecsGxvLZPVoOjkroRDFl1cp6LPJJbr1b79y9/InpDXBiW+RhZttJ61NGavmHHYGsPU9fuAJLapcWQDGCp1mOWKHA0BboY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=cF0BEjQb; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="cF0BEjQb"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b7277324054so980797366b.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 00:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765355513; x=1765960313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSMdgZiYQlpcrCoz/a1I+Tk8d9M7yHxRNKGn/fSx/9c=;
        b=cF0BEjQb+pTEHhzIg1eJMLMIX8DydObzAgCGq3MbMZONR3gBxvoTVTn18tW/DtS+BF
         YJ6SQThIszXytIBMVK0xujqHuocRfFhNrvlRDYJ3kC8MGLNiuoJcpdms29NkFgK42wfy
         EXdBwa8XRxpdmSkzApbEZHa+Dnumu5vnxFDxkCx3P2hxaU1dgtgUOxNuxb14HoP8VizS
         TyvA6l24P4XBbHeNwdBnYvZjOBGzCb+vD5izgNO8JrFY0Ez7q6YpEcLzHrCKPlMHsWcw
         z2koF1GtH3nj9p2fxVwViw0C2MmHAC6ZnuB+UOPQDbE89avAbYCLBkKd1sIOqSgFtRYf
         cVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765355513; x=1765960313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lSMdgZiYQlpcrCoz/a1I+Tk8d9M7yHxRNKGn/fSx/9c=;
        b=Zah+gGIQxgWl0HaQKODOXLYSB7nmpaWLgFph8kS4qNBE//LZWmJWAoeSUIA24Vt/Pk
         jQnf1uFYIvwgw1TUs7arrRS9FPERemXsO/Z1/1CwHWEV4InVRyuTJenqcmrTs4p+rObX
         GwIqrn1EKT1CHVljH2apSoYYULTBy6xsjxWPmyDn3zYA9RWk+WSJtf+z76x9IaTNYf93
         YIr+mnxTP061We/an7VIReCxvn9wB0sQqT7dAqQsf5EAaGr6oEDeC3SKfwKX0/HXPrHq
         jq9KrvGE0UJajVZjx5Iuwza/WbjGTlQMJoa7W5+4LHlIkFHcixYoMqkGoOYpVGrUcCb2
         PmcA==
X-Gm-Message-State: AOJu0YyPhfahCtrCfQrafJaxNmCbhhwX0U7B/MHirOQYN1q/mptmnmSj
	hylcIEx2B84yIANKQqaYsbGMtsf1IR/mnRD4qWBmv2b8StBkSJ78ffK8IiFkU2kl4cE=
X-Gm-Gg: AY/fxX4vie/p1mSZkN9Eu3XTN0SzN1vP2Ol1un9HLPaKV5muPpM4HM3TNBG+9Vw7Rw0
	FK8/odkTGQ3D+eFbpJ8H2T2YTp/GEWTSJIOpIkgpwvj4ZoXQRBeCHVTXK6JRZYGAqbazidxIxKl
	XsUqPAauDyXMz12XjrphxYv5Zd8O+ULwGFPyqoCI3yhlFaSE31ftqYESL7ZvuwS9EqqJZpzYpB8
	cpeY/cFaFDvi9Z8E3tR5LwaK5tMwL4bkDQXP6rL0MPVhY2O6lxoCwzaN/SgQxGMPBpGMtCzenrP
	/1c0TTNAqFscxDwRa8bEnIvq/ldYL+YEwpqhHjOQNEVzUu10s9gGZoWIv9XbTSC+vE++1p+qz43
	1YIwiAFc+m6Wnd15KMk2coUgSKdu1yWgHSaAdQmd12+wkztN5sBvjx7cgGqICkK7W0CR+U7TiQG
	PDWqaPNylGHpG9hayx
X-Google-Smtp-Source: AGHT+IFYDRtX5PoiZPxafkMiANC8Xf6Bj78BEbFQEysHNafXsqKHXNdBL6htv855tq3hOMwvxyT2DQ==
X-Received: by 2002:a17:906:dc89:b0:b7a:1b3:5e52 with SMTP id a640c23a62f3a-b7ce8245e92mr181408966b.17.1765355513484;
        Wed, 10 Dec 2025 00:31:53 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b79f4975c56sm1602897366b.33.2025.12.10.00.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 00:31:53 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sowjanya Komatineni <skomatineni@nvidia.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linux-staging@lists.linux.dev
Subject: [PATCH 2/2] host1x: Convert to bus methods
Date: Wed, 10 Dec 2025 09:31:38 +0100
Message-ID:  <dd55d034c68953268ea416aa5c13e41b158fcbb4.1765355236.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1765355236.git.u.kleine-koenig@baylibre.com>
References: <cover.1765355236.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3411; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=FFNspWcgr6JBh3jF6KiuWIJwLT9QVchWO/Z3r4hqr+s=; b=owGbwMvMwMXY3/A7olbonx/jabUkhkxL/XeniljWpVlqZprUz387O3yFDZsen0Dv82P2G2Sm3 TlnKlbUyWjMwsDIxSArpshi37gm06pKLrJz7b/LMINYmUCmMHBxCsBEVC3Y/zu/fWz+PrXm6LS0 dE5ho5k693/XWU84d3BxsdDGBK8J1dxsNlGXf78pl87kPVPNdPVFGHN/poPqz/XF2R+y4+P+1Pm uF4y9sNcp+StnnJ+woIjkh4kejO9X8ru5rza4Jv51C38E74xrNc+9+s/5tdZ2eKV8MPe/cbB8iu cJA8ud7316C22vnJ8Va705o+iMduCiwGk7jKrzVOL++s14Lv+wt93cRPTHzfK2Ob1enG0Va8y73 AR/zb+W8Z1zSvTLS2YKRjzB/H1W97rMXDljNyk1tquedzktlBzCnO2smc3YUKHdeTDPcUruiQf6 sUVfGVMl1taKv/g0yShu35X6slxd4de/9vOe3K3QXAYA
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The callbacks .probe(), .remove() and .shutdown() for device_drivers
should go away. So migrate to bus methods. There are two differences
that need addressing:

 - The bus remove callback returns void while the driver remove callback
   returns int (the actual value is ignored by the core).
 - The bus shutdown callback is also called for unbound devices, so an
   additional check for dev->driver != NULL is needed.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/gpu/host1x/bus.c | 67 ++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index fd89512d4488..c0d7a9b5f07a 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -346,6 +346,36 @@ static int host1x_device_uevent(const struct device *dev,
 	return 0;
 }
 
+static int host1x_device_probe(struct device *dev)
+{
+	struct host1x_driver *driver = to_host1x_driver(dev->driver);
+	struct host1x_device *device = to_host1x_device(dev);
+
+	if (driver->probe)
+		return driver->probe(device);
+
+	return 0;
+}
+
+static void host1x_device_remove(struct device *dev)
+{
+	struct host1x_driver *driver = to_host1x_driver(dev->driver);
+	struct host1x_device *device = to_host1x_device(dev);
+
+	if (driver->remove)
+		driver->remove(device);
+}
+
+static void host1x_device_shutdown(struct device *dev)
+{
+	struct host1x_driver *driver = to_host1x_driver(dev->driver);
+	struct host1x_device *device = to_host1x_device(dev);
+
+	if (dev->driver && driver->shutdown)
+		driver->shutdown(device);
+}
+
+
 static const struct dev_pm_ops host1x_device_pm_ops = {
 	.suspend = pm_generic_suspend,
 	.resume = pm_generic_resume,
@@ -359,6 +389,9 @@ const struct bus_type host1x_bus_type = {
 	.name = "host1x",
 	.match = host1x_device_match,
 	.uevent = host1x_device_uevent,
+	.probe = host1x_device_probe,
+	.remove = host1x_device_remove,
+	.shutdown = host1x_device_shutdown,
 	.pm = &host1x_device_pm_ops,
 };
 
@@ -611,37 +644,6 @@ int host1x_unregister(struct host1x *host1x)
 	return 0;
 }
 
-static int host1x_device_probe(struct device *dev)
-{
-	struct host1x_driver *driver = to_host1x_driver(dev->driver);
-	struct host1x_device *device = to_host1x_device(dev);
-
-	if (driver->probe)
-		return driver->probe(device);
-
-	return 0;
-}
-
-static int host1x_device_remove(struct device *dev)
-{
-	struct host1x_driver *driver = to_host1x_driver(dev->driver);
-	struct host1x_device *device = to_host1x_device(dev);
-
-	if (driver->remove)
-		driver->remove(device);
-
-	return 0;
-}
-
-static void host1x_device_shutdown(struct device *dev)
-{
-	struct host1x_driver *driver = to_host1x_driver(dev->driver);
-	struct host1x_device *device = to_host1x_device(dev);
-
-	if (driver->shutdown)
-		driver->shutdown(device);
-}
-
 /**
  * host1x_driver_register_full() - register a host1x driver
  * @driver: host1x driver
@@ -672,9 +674,6 @@ int host1x_driver_register_full(struct host1x_driver *driver,
 
 	driver->driver.bus = &host1x_bus_type;
 	driver->driver.owner = owner;
-	driver->driver.probe = host1x_device_probe;
-	driver->driver.remove = host1x_device_remove;
-	driver->driver.shutdown = host1x_device_shutdown;
 
 	return driver_register(&driver->driver);
 }
-- 
2.47.3

