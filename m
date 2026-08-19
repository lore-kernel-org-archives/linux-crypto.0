Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864BBA95E;
	Wed, 19 Aug 2026 03:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787111755; cv=none; b=mNoZx6BqYRAYhFhdXChQiuQDA5Ps5jvqEHXti8pEzqNXgIdXkv/P4gTcHES9D+I3iVG8CGvLzelyE0O1J5BbPe/cKgiERK+FHMBfS3iQvpgLlFsKeZm6mV+xxgUtqO0FXkc8BJv+hZUcCsK92zYXUpcjxZ9rXQuwYPr6F5+P7nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787111755; c=relaxed/simple;
	bh=h6Aiiqc6pPTqagFnG9lC2PlRHY4rxsyDkgN/02O3V5I=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=Fot8nVvate3hJzYvGSrKJzwtyQYvhm9xT8mDs44kqulsMEKSzjii9AB+o+KYhFM2quFwMcTIE/yqANenfXlhW8GNnmvOVGH1KkJXjp1RQIZT4EHBk866Z++H4QqdznBW5O78b5o9sH0aEp43R7KNTdqn7aPQ8ERfYEKVEWhRm5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=lIptmsTi; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="lIptmsTi"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7QTGTr741l6XRWzBqb9sbKXm950kSl13DKxY8KjnctU=;
	b=lIptmsTiAeWTStmNuwWerMhS/P465QRltX9aCA5VyKE7l0fZ5+WiHOZjLGiJOYZe8PaldThDx
	/uFbmQfCfDJAz6GconBqPBVo4BHYIjrqFw56vBLjKtFkr+aVnEMzESrYfwPRT6dhZY9jaLX/D8n
	Z9EQyEraOh85kI0CoCmS9ls=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hPss819kSz1K96b;
	Wed, 19 Aug 2026 11:45:00 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 7049140572;
	Wed, 19 Aug 2026 11:55:41 +0800 (CST)
Received: from kwepemq100003.china.huawei.com (7.202.195.72) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 19 Aug 2026 11:55:41 +0800
Received: from [10.67.113.213] (10.67.113.213) by
 kwepemq100003.china.huawei.com (7.202.195.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 19 Aug 2026 11:55:40 +0800
Message-ID: <6A85293C.2010008@hisilicon.com>
Date: Wed, 19 Aug 2026 11:55:40 +0800
From: Wei Xu <xuwei5@hisilicon.com>
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Chenghai Huang <huangchenghai2@huawei.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<xuwei5@huawei.com>, <prime.zeng@hisilicon.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, "Rob
 Herring" <robh+dt@kernel.org>
Subject: Re: [PATCH] crypto: hisilicon/sec - remove SEC crypto block cipher
 accelerator
References: <20260818083132.1860726-1-huangchenghai2@huawei.com>
In-Reply-To: <20260818083132.1860726-1-huangchenghai2@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq100003.china.huawei.com (7.202.195.72)

Hi Chenghai, 

On 2026/8/18 16:31, Chenghai Huang wrote:
> The Hisilicon SEC crypto cipher accelerator has been superseded
> by the newer SEC2 driver (drivers/crypto/hisilicon/sec2/). SEC2
> provides wider algorithm coverage and is the maintained path forward,
> and users have migrated to it.
> 
> The legacy SEC driver has had no active users for some time, and its
> primary maintainer, Jonathan Cameron, has moved on from Huawei and
> is no longer in a position to maintain it. With thanks to Jonathan
> for his contributions to this driver over the years, and with no one
> left to keep it up to date, remove it from the tree.
> 
> This drops the legacy SEC driver together with all of its residual
> configuration, devicetree binding and board description references:
> 
>   - drivers/crypto/hisilicon/sec/
>   - CONFIG_CRYPTO_DEV_HISI_SEC Kconfig option
>   - sec/ entry from drivers/crypto/hisilicon/Makefile
>   - Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
>   - hisilicon,hip07-sec device nodes and their supporting mbigen_alg /
>     smmu_alg infrastructure from arch/arm64/boot/dts/hisilicon/hip07.dtsi
> 
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  .../bindings/crypto/hisilicon,hip06-sec.yaml  |  134 --
>  arch/arm64/boot/dts/hisilicon/hip07.dtsi      |  280 ----

Since no active users, it is fine to me to drop the dts part as well.

Acked-by: Wei Xu <xuwei5@hisilicon.com>

Best Regards,
Wei
