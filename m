From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 3/7] crypto: testmgr: fix warning
Date: Mon, 19 Oct 2009 09:58:22 -0400
Message-ID: <4ADC707E.2040802@redhat.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com> <1255906474-25091-4-git-send-email-felipe.contreras@gmail.com> <alpine.LSU.2.00.0910191551030.8582@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	linux-crypto@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150AbZJSN7m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2009 09:59:42 -0400
In-Reply-To: <alpine.LSU.2.00.0910191551030.8582@wotan.suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/19/09 9:52 AM, Jiri Kosina wrote:
> On Mon, 19 Oct 2009, Felipe Contreras wrote:
>
>> crypto/testmgr.c: In function ?test_cprng?:
>> crypto/testmgr.c:1204: warning: ?err? may be used uninitialized in this function
>>
>> Signed-off-by: Felipe Contreras<felipe.contreras@gmail.com>
>> ---
>>   crypto/testmgr.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>> index 6d5b746..1f2357b 100644
>> --- a/crypto/testmgr.c
>> +++ b/crypto/testmgr.c
>> @@ -1201,7 +1201,7 @@ static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
>>   		      unsigned int tcount)
>>   {
>>   	const char *algo = crypto_tfm_alg_driver_name(crypto_rng_tfm(tfm));
>> -	int err, i, j, seedsize;
>> +	int err = 0, i, j, seedsize;
>>   	u8 *seed;
>>   	char result[32];
>
> As it is not obvious to me immediately why/whether tcount couldn't be zero
> (which would cause uninitialized use of 'err'), I am not merging this
> through trivial tree. Herbert?

I believe I'm the guilty party who wrote the code in question. 
Initializing err to 0 isn't correct. tcount should always be at least 1, 
if its 0, test_cprng has been called with invalid parameters. I believe 
err would best be initialized to -EINVAL, lest the caller think they 
were successful.

-- 
Jarod Wilson
jarod@redhat.com
