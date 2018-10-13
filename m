From: Harsh Jain <harsh@chelsio.com>
Subject: Re: [PATCH 1/1] crypto:chelsio: Update ntx queue received from cxgb4
Date: Sat, 13 Oct 2018 12:53:36 +0530
Message-ID: <4f628759-bd3a-d7d3-6be2-e3dba759fdf3@chelsio.com>
References: <cover.1539343454.git.harsh@chelsio.com>
 <64a8109a1c4ce9bf53797dc3dfb8deb64ceef4e2.1539343454.git.harsh@chelsio.com>
 <7e220dd5-fb54-84b4-20c9-a318d18d747b@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        herbert@gondor.apana.org.au, atul.gupta@chelsio.com,
        indranil@chelsio.com, swise@opengridcomputing.com,
        varun@chelsio.com, ganeshgr@chelsio.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <7e220dd5-fb54-84b4-20c9-a318d18d747b@gmx.de>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 13-10-2018 05:46, Lino Sanfilippo wrote:
> Hi,
>
>> +	if (uld_type == CXGB4_ULD_CRYPTO) {
>> +		i = min_t(int, adap->vres.ncrypto_fc,
>> +			  num_online_cpus());
>> +		txq_info->ntxq = rounddown(i, adap->params.nports);
>> +		if (txq_info->ntxq <= 0) {
>> +			dev_warn(adap->pdev_dev, "Crypto Tx Queues can't be zero\n");
>> +			return -EINVAL;
>> +		}
> Shouldn't we free txq_info in the error case?
Yes, Will fix this in V2. Thanks.
>
> Regards,
> Lino
