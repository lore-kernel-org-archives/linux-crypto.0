Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C662A23AD;
	Mon, 16 Jun 2025 02:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750042299; cv=none; b=EFZSLqBd4JwWRFuu8l9nZf6j3OOYGyT/QICB4bt3Qyb8CqhP6Yh5Dds142QLS7ua/5dDfmeMg3ZNSzk6NtNAegM9Li8aLxRm47NJSZksmT0XIeay6G4z7Rd5xlg97XumAof+BJ84mBp9OvKHuQXtayYKnVgPLWHPEy32rmTC8+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750042299; c=relaxed/simple;
	bh=t0PstE8Y3LGllZTQ5OPBIV0oLS9BFz+KoRlQLDjH+gQ=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=SqVSeB63ZFx9hN+cJ+Japw+aq/S97c2W3cJsXGQ1TxNtjvfLlBSI/YtqUIQT/ngcCv7Se9ZjE5BFMMweAzNT3i8sjVLBD/edDKC6/uOIRlMPUov2cWBA4FiUXKSuReMrz0B08ELb7ixtg3af7Xrcl9T38te2aE5bM1Kmk1ftvmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4bLDww2wBvz1d1h9;
	Mon, 16 Jun 2025 10:49:20 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id DC557180450;
	Mon, 16 Jun 2025 10:51:28 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Jun 2025 10:51:27 +0800
Subject: Re: [PATCH] virtio-crypto: Remove unused virtcrypto functions
To: <linux@treblig.org>
CC: <arei.gonglei@huawei.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<xuanzhuo@linux.alibaba.com>, <eperezma@redhat.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<virtualization@lists.linux.dev>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20250614000505.596563-1-linux@treblig.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <16a17372-891b-28f6-b3bd-aa92b0557b90@huawei.com>
Date: Mon, 16 Jun 2025 10:51:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250614000505.596563-1-linux@treblig.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk200017.china.huawei.com (7.202.194.83)

On 2025/6/14 8:05, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> virtcrypto_devmgr_get_first() and virtcrypto_dev_in_use() were added in
> 2016 by
> commit dbaf0624ffa5 ("crypto: add virtio-crypto driver")
> 
> but have remained unused.
> 
> Remove them.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/crypto/virtio/virtio_crypto_common.h |  2 --
>  drivers/crypto/virtio/virtio_crypto_mgr.c    | 36 --------------------
>  2 files changed, 38 deletions(-)

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
