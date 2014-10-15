From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH v2 0/2] crypto: qat - Fix for invalid dma mapping and
 numa
Date: Wed, 15 Oct 2014 07:25:45 -0400
Message-ID: <543E59B9.6060804@redhat.com>
References: <20141014012251.742.5500.stgit@tstruk-mobl1> <543E4DFF.9000101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, naleksan@redhat.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Nikolay Aleksandrov <nikolay@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbaJOLZw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Oct 2014 07:25:52 -0400
In-Reply-To: <543E4DFF.9000101@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/15/2014 06:35 AM, Nikolay Aleksandrov wrote:
> On 14/10/14 03:24, Tadeusz Struk wrote:
>> Hi,
>> These two patches fix invalid (zero length) dma mapping and
>> enforce numa configuration for maximum performance.
>>
>> Change log:
>> v2 - Removed numa node calculation based bus number and use predefined
>> functions instead.
>>
>> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
>> ---
>>
>> Tadeusz Struk (2):
>>        crypto: qat - Prevent dma mapping zero length assoc data
>>        crypto: qat - Enforce valid numa configuration
>>
>>
>>   drivers/crypto/qat/qat_common/adf_accel_devices.h |    3 +-
>>   drivers/crypto/qat/qat_common/adf_transport.c     |   12 +++++---
>>   drivers/crypto/qat/qat_common/qat_algs.c          |    7 +++--
>>   drivers/crypto/qat/qat_common/qat_crypto.c        |    8 +++--
>>   drivers/crypto/qat/qat_dh895xcc/adf_admin.c       |    2 +
>>   drivers/crypto/qat/qat_dh895xcc/adf_drv.c         |   32 ++++++++-------------
>>   drivers/crypto/qat/qat_dh895xcc/adf_isr.c         |    2 +
>>   7 files changed, 32 insertions(+), 34 deletions(-)
>>
> 
> I just gave a quick run of these patches and they seem to fix the NUMA issue and
> the 0 length warnings.
> 
> Tested-by: Nikolay Aleksandrov <nikolay@redhat.com>

Thanks Nik :)

Reviewed-by: Prarit Bhargava <prarit@redhat.com>

P.
