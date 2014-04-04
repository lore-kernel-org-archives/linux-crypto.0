From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [PATCH 3/9] crypto: qce: Add dma and sg helpers
Date: Fri, 04 Apr 2014 11:49:19 +0300
Message-ID: <533E720F.6050609@mm-sol.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-4-git-send-email-svarbanov@mm-sol.com> <20140403182520.GH28265@joshc.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
To: Josh Cartwright <joshc@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20140403182520.GH28265@joshc.qualcomm.com>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 04/03/2014 09:25 PM, Josh Cartwright wrote:
> Nitworthy comments :).
> 
> On Thu, Apr 03, 2014 at 07:18:00PM +0300, Stanimir Varbanov wrote:
> [..]
>> +++ b/drivers/crypto/qce/dma.c
> [..]
>> +int qce_dma_request(struct device *dev, struct qce_dma_data *dma)
>> +{
>> +	unsigned int memsize;
>> +	void *va;
>> +	int ret;
>> +
>> +	dma->txchan = dma_request_slave_channel_reason(dev, "tx");
>> +	if (IS_ERR(dma->txchan)) {
>> +		ret = PTR_ERR(dma->txchan);
>> +		return ret;
>> +	}
>> +
>> +	dma->rxchan = dma_request_slave_channel_reason(dev, "rx");
>> +	if (IS_ERR(dma->rxchan)) {
>> +		ret = PTR_ERR(dma->rxchan);
>> +		goto error_rx;
>> +	}
>> +
>> +	memsize = QCE_RESULT_BUF_SZ + QCE_IGNORE_BUF_SZ;
>> +	va = kzalloc(memsize, GFP_KERNEL);
>> +	if (!va) {
>> +		ret = -ENOMEM;
>> +		goto error_nomem;
>> +	}
>> +
>> +	dma->result_buf = va;
>> +	dma->ignore_buf = dma->result_buf + QCE_RESULT_BUF_SZ;
>> +
>> +	return 0;
>> +error_nomem:
>> +	if (!IS_ERR(dma->rxchan))
> 
> How could this condition ever be false?

Good catch. This is a leftover after error path restructuring. Will fix
it on next version.

-- 
regards,
Stan
