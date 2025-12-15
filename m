Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D2233CEA8
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 14:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765808267; cv=none; b=QBphcqaf0DcWVkg/h/A3U8WX6vEwKgxQuYuIMAnn7y3/4V17RRN+fsdf0JTTWi6Vk50Py+zAIcexFalX7PcRE3IWKl/pQPadYNwDj6ThuHYm0axXC85goDOU+26PkFoCxjhFqcm3G5Lzt5ymBgN+lBFMJrY70VNaO80ODBNupgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765808267; c=relaxed/simple;
	bh=SjEd6VJRjSq6j+23i9dm+VIV1mrWqjZFs7/yjFJu9o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ACoXnnSZYVk4wF9Mlxi0eczS5b4A68lKCZ06j+hDCthkl0KOB6744IPjqSPcVRMYRcY81hROholC07/N3mFQCkOFWelKuOBXSCy62lO06TrJBkw1vrVhF0mH7JnNkcEmaPOBBMlW+9nUdlCKWPZlS6nflCLKsbxqZONeOrb7bVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=h/JK6J4H; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="h/JK6J4H"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b73a9592fb8so756954966b.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 06:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765808261; x=1766413061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PbC785QpAYQenK85VtICOF43iYYBs1NW0kuyf7DWA0o=;
        b=h/JK6J4H49E4WhyzuQjHG7QTpJg5cYLaoN+kFvbnCh8FxdQE6KptszdJbtvpJ16gzl
         r4m6BAtiEUG2NtM0+9XviBkQyyElGX6zUC7cxOuUy/FZoVn2bl8Ccbn0lmJWRU7LIQBT
         uq564W752jZ4DoW+bRubLu3FMtZTuRVt/l4Tm2T+5aCKVG2PKt25auY/kaCKOAtYtV6M
         r+sdRUtiYFodPZmtfxZ9B6T1qUlV8Rcrv+QF+KqzMCGKnFkPMT2R2aGCzjtf7cnTyAbD
         VDAONVK9G8lixMYljHbeOwUxljR7i804l6cncvQi4mOhBho+3u0CRCjjbn3Z1ZwtPbum
         i3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765808261; x=1766413061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PbC785QpAYQenK85VtICOF43iYYBs1NW0kuyf7DWA0o=;
        b=v00KWUWtM+mXE5G4m+hEHQprxGa5+cGkRaDQC50Np4nyHNYaMPSg+jFPjdpxXFGgq5
         X/jPmfZDf85Nwaz8NsuaNegLbXd4NOGD7dBfuf+xASg7E3kwJqtV9q01emcsW4SdvbZc
         NdYggb1CazHCtYsvXqcWAPp3xO4yFCkijUNN510GCLVDJ6jh+QyirGHXePkEZW5wMVCt
         hV0VIXY7hxj2ChXc4iEemziV9Js3DHpVB1L5ae0T2/9uDGUGxJ0PnFQ3Rn7fNkh7Ypso
         05fYaLlZcV3j7cclfLDr3D89FVnmBH/B6/YTZLaN02zbsHGj9TmRknxEbPBOH60cIR2P
         hiDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZtMOBtUYBv0B8N83F8c5Lec/ZYJq7IdTvEd8kDVdK8GlQ0tyne8DpUcqF3KNLHXxvf9rxBEAq1pBAMyI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDaOzSaa1amutruiDsfs9FcHtTQhrRk9j8IxwnkVWYRLAoshYn
	JVdtL2O2zRdv9+cpsf3g4/a4goT9QaTMh8dmE68u3+i4a7C2NLB8BeS9Z5EAUW0g6SnAcMEizkG
	wzF1K
X-Gm-Gg: AY/fxX6KtzVOSkqAFIJ+5ClG6jxsmK1G9Si8T1vQU8PUBnE6wB9Mrmg6bqoiUHDEcdR
	kYIrB42/igLlhB8kNfJj/nRNRjw+dRc7YzBgAvWs7KBssJIHGgAE8OkjgGpCCMylpCfAgCf7Dso
	JF4zOmf8vcp9HbiSAfvZA/DplmL6EbDrXMLXRY1KLL3XMR+M4WU5Wn2kxlP1WPKFS/I5w4VPlpK
	Td96Xa4rMgCPT41j3Mpi42kZS9LcmIUV+M4zIvgL9g79b5Gc/N4+3w/FnZywDuvV5S9Ec33qbAF
	9EPNIvzWSyIiOS0rdfNhqAZHwr+X/0E/J3MDBTokinWeNOOUZVDiSMLYB0hWlYR98zfFbZhbuDs
	d6f7Pj5jcTyTf9oNbaXBGZrVOPs9huIYaPsrmaoYtklIEA3DWFR2zNB2C2oBLe/4PFhAJTLYdmc
	RWJtxEyR//bw/LcPTx56/ufw9fhpU9GH2tdom13DECjzEoap7tt2JYpbSa7w==
X-Google-Smtp-Source: AGHT+IEZpKvQ+hycfkLhAZU1bkIfs9hjT/nN1SWB48QII7f5RuGpBZd/Ndg22CntlimXslvQkoET6A==
X-Received: by 2002:a17:907:94c6:b0:b7c:cc8d:14f4 with SMTP id a640c23a62f3a-b7d0213705cmr1612870366b.4.1765808261098;
        Mon, 15 Dec 2025 06:17:41 -0800 (PST)
Received: from localhost (ip-046-005-122-062.um12.pools.vodafone-ip.de. [46.5.122.62])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64982040e2bsm13503641a12.6.2025.12.15.06.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 06:17:40 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Jens Wiklander <jens.wiklander@linaro.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: op-tee@lists.trustedfirmware.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: [PATCH v2 04/17] hwrng: optee - Make use of module_tee_client_driver()
Date: Mon, 15 Dec 2025 15:16:34 +0100
Message-ID:  <d0074b2e05cfb78ce5e95c875731e784bef52411.1765791463.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1765791463.git.u.kleine-koenig@baylibre.com>
References: <cover.1765791463.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1318; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=SjEd6VJRjSq6j+23i9dm+VIV1mrWqjZFs7/yjFJu9o0=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpQBhVdjM0yUwXxXFzx4aHBLn/Ds+MiNtpCXJ3V 953KZqt7++JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaUAYVQAKCRCPgPtYfRL+ Ts3hB/4rg9tut6lPOPfor6BYQUFfnX83d3OmNYlQfMOEoVlpBiI3dveN+tab1HfLbXvsdJxEYii PuEfVOeX7Lop+gOlexjK7TxmbSY/TFYicwC5P7r7a/LZ7avaYB1HjDktvTueCGtgHLmAXZsmleq ZW/qLiQmVbdCKMqrMp8aUxUI8wslhF5UCZYemgcXHho/CnsHqq90HdqXrY6Hwc4iStBkFZ34HDP MGqmlzs+XukATpnr7RjvVk8a0Nh+eXyUaEyglo/2O/9f6AU+PqUcKc3n7+2qU+LSDUz3egKtOYi xn1KyXoW6Dsw9bXNU8YUAOMXWO7Jj0msC1/mXh+DkgM3UJZg
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Reduce boilerplate by using the newly introduced module_tee_client_driver().
That takes care of assigning the driver's bus, so the explicit assigning
in this driver can be dropped.

Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/char/hw_random/optee-rng.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
index 96b5d546d136..6ee748c0cf57 100644
--- a/drivers/char/hw_random/optee-rng.c
+++ b/drivers/char/hw_random/optee-rng.c
@@ -281,24 +281,12 @@ static struct tee_client_driver optee_rng_driver = {
 	.id_table	= optee_rng_id_table,
 	.driver		= {
 		.name		= DRIVER_NAME,
-		.bus		= &tee_bus_type,
 		.probe		= optee_rng_probe,
 		.remove		= optee_rng_remove,
 	},
 };
 
-static int __init optee_rng_mod_init(void)
-{
-	return driver_register(&optee_rng_driver.driver);
-}
-
-static void __exit optee_rng_mod_exit(void)
-{
-	driver_unregister(&optee_rng_driver.driver);
-}
-
-module_init(optee_rng_mod_init);
-module_exit(optee_rng_mod_exit);
+module_tee_client_driver(optee_rng_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Sumit Garg <sumit.garg@linaro.org>");
-- 
2.47.3

