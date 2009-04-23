From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 1/3] crypto: properly handle null input and assoc data
 aead test vectors
Date: Thu, 23 Apr 2009 13:30:16 -0400
Message-ID: <49F0A5A8.50308@redhat.com>
References: <200904091434.59639.jarod@redhat.com> <200904150835.38818.jarod@redhat.com> <200904150935.15947.jarod@redhat.com> <200904150936.10800.jarod@redhat.com> <20090420062301.GA1083@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757919AbZDWRbO@vger.kernel.org>
In-Reply-To: <20090420062301.GA1083@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 04/20/2009 02:23 AM, Herbert Xu wrote:
> On Wed, Apr 15, 2009 at 09:36:10AM -0400, Jarod Wilson wrote:
>> Currenty, if either input or associated data are null in an aead
>> test vector, we'll have random contents of the input and assoc
>> arrays. Similar to the iv, play it safe and zero out the contents.
>>
>> Signed-off-by: Jarod Wilson<jarod@redhat.com>
>
> This patch doesn't make sense unless you were getting a crash
> without it.
>
>> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>> index bfee6e9..a8bdcb3 100644
>> --- a/crypto/testmgr.c
>> +++ b/crypto/testmgr.c
>> @@ -314,8 +314,18 @@ static int test_aead(struct crypto_aead *tfm, int enc,
>>   			input = xbuf[0];
>>   			assoc = axbuf[0];
>>
>> -			memcpy(input, template[i].input, template[i].ilen);
>> -			memcpy(assoc, template[i].assoc, template[i].alen);
>> +			if (template[i].input)
>> +				memcpy(input, template[i].input,
>> +				       template[i].ilen);
>> +			else
>> +				memset(input, 0, MAX_IVLEN);
>
> If template[i].input was really NULL then the memcpy should crash.

I needed to do this for some extended testing elsewhere in 
similar-looking code, where input could indeed be NULL and I did 
encounter crashes, but its not reproduceable within tcrypt/testmgr 
itself, so indeed, not necessary here.

-- 
Jarod Wilson
jarod@redhat.com
