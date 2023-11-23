Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69BA1BE;
	Thu, 23 Nov 2023 03:06:55 -0800 (PST)
Received: from dggpemd200003.china.huawei.com (unknown [172.30.72.57])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4SbZv41Zh9zMnNK;
	Thu, 23 Nov 2023 19:02:08 +0800 (CST)
Received: from [10.67.120.171] (10.67.120.171) by
 dggpemd200003.china.huawei.com (7.185.36.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.28; Thu, 23 Nov 2023 19:06:52 +0800
Message-ID: <234619d9-c1ae-4663-9c4a-de6f18dcedba@huawei.com>
Date: Thu, 23 Nov 2023 19:06:52 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: hisilicon/zip - add zip comp high perf
 configuration
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <shenyang39@huawei.com>
References: <20231121134024.114476-1-huangchenghai2@huawei.com>
 <ZV3QSHgP6DgE6NkX@gondor.apana.org.au>
From: huangchenghai <huangchenghai2@huawei.com>
In-Reply-To: <ZV3QSHgP6DgE6NkX@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemd200003.china.huawei.com (7.185.36.122)
X-CFilter-Loop: Reflected


On Wed, Nov 22, 2023 at 05:56PM, Herbert Xu wrote:

> On Tue, Nov 21, 2023 at 09:40:24PM +0800, Chenghai Huang wrote:
>> To meet specific application scenarios, the function of switching between
>> the high performance mode and the high compression mode is added.
>>
>> Use the perf_mode=0/1 configuration to set the compression high-perf mode,
>> 0(default, high compression mode), 1(high performance mode).
>>
>> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> Is it still compatible with the software algorithm implementation
> when in high performance mode, in both directions?
>
> Cheers,

The high performance mode only improves the performance of the compression
direction, and it is compatible with the software algorithm implementation in
both directions.

The v2 patch will be sent for adding comments "These two modes only apply to
the compression direction." to the code and "crypto" prefix to the subject.

Thanks,
Chenghai

