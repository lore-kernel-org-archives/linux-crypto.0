Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD551BBBEA;
	Mon, 10 Feb 2025 09:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739179470; cv=none; b=orB8Fnrur7VV2nsS4jYqJd7Ka1AgIkjy6uFEcEN/YVM8N1bk4OVbQyxVESvi/VdJvBlqhOj7bddq+rR29rdnfCgrp7bH2W0sUBINF22Yme2Tk2gdlBCJM4ND3L1GVJMGH0w28qITjD1A7PiboecXCldhLohfRN762sx0yEQ37n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739179470; c=relaxed/simple;
	bh=DSLcEZITRPL62T9rigCQskjKO0Hvwus0+e1uc/TnvEg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=con00DUrnhxZFBjNi+LVJyJ0WXblqaV2yV7tP2Uj1yVjXnySOnWU+RMEeGg493G4EkqR7f+7m04DptuL9DjqcdqIarnDD3r5mBbHJxjl9zoDyDn677exa5ruCRdFZD8VPHrols6Mh+uKMsxfXa40i4xvez7CZHMRgoUsAjbzF+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=ut+ANQFZ; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="ut+ANQFZ"
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id CB08B10000C;
	Mon, 10 Feb 2025 12:14:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru CB08B10000C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1739178896;
	bh=DSLcEZITRPL62T9rigCQskjKO0Hvwus0+e1uc/TnvEg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=ut+ANQFZiByN3Lz+Olhyd4425H90AilO40Ck3WYciKkESk6DoMbCeTRjrFnKQ1QJD
	 f1yzw6qb65rP44IF+ltAiS460YWv8r6jgfwgKZ0ODUq/xPwOemUpWZHOdIrjPYvqQx
	 Qii4zaTC/12leKEAsVVe/vhqeDJeaitjQRu+prfxkDCvnLc6lx8rJteTPKKnqqr45z
	 bfAlJzla9QmZI5za1mR5a5IrmhX+a+UErDgJSMbS30mb25aqv0Y2Y7DIDzCHgQysub
	 0jf343yxfh71zA2SZJdb0AoLa8at7ImyGnfW54q0ir8AzWfMNDzrCn8+Df9cg3Mu5Q
	 31Zxvjrm5cCXg==
Received: from smtp.sberdevices.ru (p-exch-cas-a-m1.sberdevices.ru [172.24.201.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Mon, 10 Feb 2025 12:14:56 +0300 (MSK)
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
Subject: [PATCH v11 00/22] Support more Amlogic SoC families in crypto driver
Date: Mon, 10 Feb 2025 12:13:13 +0300
Message-ID: <20250210091313.15190-1-avromanov@salutedevices.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <Z2aokzSrAHpJE_PG@gondor.apana.org.au>
References: <Z2aokzSrAHpJE_PG@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-a-m2.sberdevices.ru (172.24.196.120) To
 p-exch-cas-a-m1.sberdevices.ru (172.24.201.216)
X-KSMG-Rule-ID: 1
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 190896 [Feb 10 2025]
X-KSMG-AntiSpam-Version: 6.1.1.7
X-KSMG-AntiSpam-Envelope-From: avromanov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 50 0.3.50 df4aeb250ed63fd3baa80a493fa6caee5dd9e10f, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;127.0.0.199:7.1.2;smtp.sberdevices.ru:7.1.1,5.0.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2025/02/10 05:33:00 #27152708
X-KSMG-AntiVirus-Status: Clean, skipped

Hello guys!
Gently reminder.
