Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE4A212B0F;
	Wed, 22 Jan 2025 12:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737549724; cv=none; b=Pqy9vdzVOiEd2BggZzkf0iPBDN70JqEn7uZbNG+84viDVsIazsRTQtais4KJ2FYOjC4Zq1q5RhJcrYNYlu6ugRpKdHCD8eEhQrhdVycOaluLkPDBOOE+ar+be1ve0XHhLENIv7xfDUf30pajPUonHHWhsjLWg2A0Zq4o3q1ba64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737549724; c=relaxed/simple;
	bh=g3yZ+nt990iVpKGd+guiyGorA0WqjyYUcxb0w0TSLT8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=quWicbOy+gFkcyzc5Fx5CwHkvCtlLd6jTq5lhRGMGR26PLOJyFS8O7lNSmBndgC08ZwoFEAUVlmTW05ERCMtiaLnexvsa+GukHGYeAJSOx2xCVfsFa5Ci+PwMa+9LLU9xEzHU6sUTtzM0aggaXr9hQOB9/vu4v9dhJR5YzeZANg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=avQeXlvD; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="avQeXlvD"
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id C866810000F;
	Wed, 22 Jan 2025 15:41:45 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru C866810000F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1737549705;
	bh=YTtwLlBe37BdCgnBuy1MLWGgT5Jb4n0isj9w5Ot2fmw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=avQeXlvD0X76BKyLAQbtpU0G3qYpQ3zlmE3dI99AX943Xfct8cW7NJvm9cGfOjrdc
	 s/HQN1xG/Jb5rcHHGMz4UkoXcyVbj85l5FNQbJsB58oJO5ecLOmARNbj+Pd7+EEuAT
	 BHivPC0jbb25+xuKVki+2UaTOsinFp2B61IyZ/9Ps0RnzoHHl57QMEYDBdt91KRr1h
	 JCfW7rMzEghqyABkc5rrb1LZyVUVTzh23wYkqvfvDgwpuI2pFmkef+WZ2OsfBYLFDB
	 2q31eADmH1Jm1F2H/EzfcHW2Dp7Tt89tmuzSiglcufKcm5P8HfbRWXDcI45npON9xz
	 SxjmCWLErLEJQ==
Received: from smtp.sberdevices.ru (p-exch-cas-a-m1.sberdevices.ru [172.24.201.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Wed, 22 Jan 2025 15:41:45 +0300 (MSK)
From: Alexey Romanov <avromanov@salutedevices.com>
To: <herbert@gondor.apana.org.au>
CC: <avromanov@salutedevices.com>, <clabbe@baylibre.com>,
	<conor+dt@kernel.org>, <davem@davemloft.net>, <devicetree@vger.kernel.org>,
	<jbrunet@baylibre.com>, <kernel@salutedevices.com>, <khilman@baylibre.com>,
	<krzk+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<linux-amlogic@lists.infradead.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<martin.blumenstingl@googlemail.com>, <neil.armstrong@linaro.org>,
	<robh+dt@kernel.org>, <vadim.fedorenko@linux.dev>
Subject: Re: [PATCH v11 11/22] crypto: amlogic - Introduce hasher
Date: Wed, 22 Jan 2025 15:41:29 +0300
Message-ID: <Z2aokzSrAHpJE_PG@gondor.apana.org.au> (raw)
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241213140755.1298323-12-avromanov@salutedevices.com>
References: <Z2aokzSrAHpJE_PG@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-a-m1.sberdevices.ru (172.24.196.116) To
 p-exch-cas-a-m1.sberdevices.ru (172.24.201.216)
X-KSMG-Rule-ID: 1
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 190505 [Jan 22 2025]
X-KSMG-AntiSpam-Version: 6.1.1.7
X-KSMG-AntiSpam-Envelope-From: avromanov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 50 0.3.50 df4aeb250ed63fd3baa80a493fa6caee5dd9e10f, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;elixir.bootlin.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;smtp.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2025/01/22 11:41:00
X-KSMG-LinksScanning: Clean, bases: 2025/01/22 11:41:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2025/01/22 10:19:00 #27099507
X-KSMG-AntiVirus-Status: Clean, skipped
Message-ID: <20250122124129.veSIqf71IiP-ugcj8Hpsh27omoIg4PgagbIR2qECS3c@z>

> You cannot sleep in the digest function.

Why? I couldn't find this explanation anywhere.
In addition, I found an example of one of the digest functions that is sleeping [1].

Links:

  - [1] https://elixir.bootlin.com/linux/v6.12.6/source/drivers/crypto/mxs-dcp.c#L804
