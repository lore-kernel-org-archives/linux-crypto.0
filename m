From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v8 1/1] crypto: add virtio-crypto driver
Date: Tue, 10 Jan 2017 13:27:04 +0100
Message-ID: <e235caf4-f51c-dccf-4eb7-548d3fa71644@de.ibm.com>
References: <1481767396-187748-1-git-send-email-arei.gonglei@huawei.com>
	<1481767396-187748-2-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: xuquan8@huawei.com, weidong.huang@huawei.com, herbert@gondor.apana.org.au,
	hanweidong@huawei.com, claudio.fontana@huawei.com,
	mst@redhat.com, luonengjun@huawei.com, wanzongshun@huawei.com,
	stefanha@redhat.com, jianjay.zhou@huawei.com,
	longpeng2@huawei.com, davem@davemloft.net, wu.wubin@huawei.com,
	arei.gonglei@hotmail.com
To: Gonglei <arei.gonglei@huawei.com>, linux-kernel@vger.kernel.org,
	qemu-devel@nongnu.org, virtio-dev@lists.oasis-open.org,
	virtualization@lists.linux-foundation.org, linux-crypto@vger.kernel.org
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1481767396-187748-2-git-send-email-arei.gonglei@huawei.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

On 12/15/2016 03:03 AM, Gonglei wrote:
[...]
> +
> +static struct crypto_alg virtio_crypto_algs[] = { {
> +	.cra_name = "cbc(aes)",
> +	.cra_driver_name = "virtio_crypto_aes_cbc",
> +	.cra_priority = 501,


This is still higher than the hardware-accelerators (like intel aesni or the
s390 cpacf functions or the arm hw). aesni and s390/cpacf are supported by the
hardware virtualization and available to the guests. I do not see a way how virtio
crypto can be faster than that (in the end it might be cpacf/aesni + overhead)
instead it will very likely be slower.
So we should use a number that is higher than software implementations but
lower than the hw ones.

Just grepping around, the software ones seem be be around 100 and the hardware 
ones around 200-400. So why was 150 not enough?

Christian
