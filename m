Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE957D47;
	Wed, 22 Nov 2023 04:11:43 -0800 (PST)
Received: from kwepemm000009.china.huawei.com (unknown [172.30.72.56])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Sb0Pn06zbz1P8Zm;
	Wed, 22 Nov 2023 20:08:12 +0800 (CST)
Received: from [10.67.120.153] (10.67.120.153) by
 kwepemm000009.china.huawei.com (7.193.23.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 22 Nov 2023 20:11:41 +0800
Subject: Re: [PATCH] crypto: hisilicon - Add check for pci_find_ext_capability
To: Herbert Xu <herbert@gondor.apana.org.au>
References: <20231109021308.1859881-1-nichen@iscas.ac.cn>
 <6eeced40-7951-ca0d-1bcd-62e1d329ca96@huawei.com>
 <ZVdCLjo7GOQN54sx@gondor.apana.org.au>
CC: Chen Ni <nichen@iscas.ac.cn>, <wangzhou1@hisilicon.com>,
	<davem@davemloft.net>, <xuzaibo@huawei.com>, <tanshukun1@huawei.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: Weili Qian <qianweili@huawei.com>
Message-ID: <450d30a4-5b01-6e20-3fd7-bee0cead419f@huawei.com>
Date: Wed, 22 Nov 2023 20:11:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZVdCLjo7GOQN54sx@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm000009.china.huawei.com (7.193.23.227)
X-CFilter-Loop: Reflected



On 2023/11/17 18:36, Herbert Xu wrote:
> On Fri, Nov 17, 2023 at 10:07:00AM +0800, Weili Qian wrote:
>>
>> Thanks for your patch. The function qm_set_vf_mse() is called only after SRIOV
>> is enabled, so function pci_find_ext_capability() does not return 0. This check
>> makes no sense.
> 
> Perhaps we could add a comment instead?
> 
> Thanks,
> 

Okay, I will add a comment for this.

Thanks,
Weili
