From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH v2 5/7] crypto: aead: Add aead_request_cast() api
Date: Wed, 8 Jul 2015 12:13:25 +0530
Message-ID: <559CC68D.9080800@ti.com>
References: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com> <1436283109-13318-6-git-send-email-lokeshvutla@ti.com> <20150708035652.GC12627@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>,
	<linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:57823 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577AbbGHGq1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 02:46:27 -0400
In-Reply-To: <20150708035652.GC12627@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 08 July 2015 09:26 AM, Herbert Xu wrote:
> On Tue, Jul 07, 2015 at 09:01:47PM +0530, Lokesh Vutla wrote:
>> Add aead_request_cast() api to get pointer to aead_request
>> from cryto_async_request.
>>
>> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
>> ---
>>  include/crypto/internal/aead.h | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
>> index 4b25471..0423fa5 100644
>> --- a/include/crypto/internal/aead.h
>> +++ b/include/crypto/internal/aead.h
>> @@ -157,6 +157,12 @@ static inline unsigned int crypto_aead_maxauthsize(struct crypto_aead *aead)
>>  	return crypto_aead_alg_maxauthsize(crypto_aead_alg(aead));
>>  }
>>  
>> +static inline struct aead_request *aead_request_cast(
>> +					struct crypto_async_request *req)
>> +{
>> +	return container_of(req, struct aead_request, base);
>> +}
> 
> Please drop this and use the aead_queue interface I just posted.
Okay will update in next version

Thanks and regards,
Lokesh
> 
> Thanks,
> 
