From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v2 0/2] crypto: qat - Fix for invalid dma mapping and
 numa
Date: Mon, 17 Nov 2014 07:43:08 -0800
Message-ID: <546A178C.6070908@intel.com>
References: <20141014012251.742.5500.stgit@tstruk-mobl1> <543E4DFF.9000101@redhat.com> <543E59B9.6060804@redhat.com> <20141024144521.GA20889@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Prarit Bhargava <prarit@redhat.com>,
	Nikolay Aleksandrov <nikolay@redhat.com>,
	bruce.w.allan@intel.com, qat-linux@intel.com, naleksan@redhat.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8280 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbaKQPpv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Nov 2014 10:45:51 -0500
In-Reply-To: <20141024144521.GA20889@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/24/2014 07:45 AM, Herbert Xu wrote:
> On Wed, Oct 15, 2014 at 07:25:45AM -0400, Prarit Bhargava wrote:
>>
>>
>> On 10/15/2014 06:35 AM, Nikolay Aleksandrov wrote:
>>> On 14/10/14 03:24, Tadeusz Struk wrote:
>>>> Hi,
>>>> These two patches fix invalid (zero length) dma mapping and
>>>> enforce numa configuration for maximum performance.
>>>>
>>>> Change log:
>>>> v2 - Removed numa node calculation based bus number and use predefined
>>>> functions instead.
>>>>
>>>> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
>>>> ---
>>>>
>>>> Tadeusz Struk (2):
>>>>        crypto: qat - Prevent dma mapping zero length assoc data
>>>>        crypto: qat - Enforce valid numa configuration
>>>>
>>>>
>>>>   drivers/crypto/qat/qat_common/adf_accel_devices.h |    3 +-
>>>>   drivers/crypto/qat/qat_common/adf_transport.c     |   12 +++++---
>>>>   drivers/crypto/qat/qat_common/qat_algs.c          |    7 +++--
>>>>   drivers/crypto/qat/qat_common/qat_crypto.c        |    8 +++--
>>>>   drivers/crypto/qat/qat_dh895xcc/adf_admin.c       |    2 +
>>>>   drivers/crypto/qat/qat_dh895xcc/adf_drv.c         |   32 ++++++++-------------
>>>>   drivers/crypto/qat/qat_dh895xcc/adf_isr.c         |    2 +
>>>>   7 files changed, 32 insertions(+), 34 deletions(-)
>>>>
>>>
>>> I just gave a quick run of these patches and they seem to fix the NUMA issue and
>>> the 0 length warnings.
>>>
>>> Tested-by: Nikolay Aleksandrov <nikolay@redhat.com>
>>
>> Thanks Nik :)
>>
>> Reviewed-by: Prarit Bhargava <prarit@redhat.com>
> 
> Patch applied to crypto and I will push this to stable.

Hi Greg,
Any idea why this didn't make it to 3.17.3?
Thanks,
Tadeusz
