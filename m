From: Stephan Mueller <smueller@chronox.de>
Subject: Re: kernel tainted while exporting shash context using af_alg interface
Date: Fri, 30 Oct 2015 12:10:51 +0100
Message-ID: <3576256.SqRabKS4lK@tauon.atsec.com>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com> <28376488.AMz6xlEXXD@tauon.atsec.com> <CAFXBA==pRTY57SkfPRnW_6MVRUJ0J8Uwi+Bigxtk21WNhvY3jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34480 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758776AbbJ3LK4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Oct 2015 07:10:56 -0400
In-Reply-To: <CAFXBA==pRTY57SkfPRnW_6MVRUJ0J8Uwi+Bigxtk21WNhvY3jA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 30. Oktober 2015, 14:02:27 schrieb Harsh Jain:

Hi Harsh,

>Hi Stephan,
>
>If we add sendmsg() in between 2 accept calls then the setkey problem
>will happen?
>
>handle->opfd = accept(handle->tfmfd, NULL, 0);
>sendmsg()
>handle->opfd = accept(handle->opfd, NULL, 0);
>sendmsg()
>handle->opfd = accept(handle->opfd, NULL, 0);

Without testing, I would very much expect that, because the setkey does not 
apply to the subordinate tfm.
>
>If yes, Then may be it is expected behavior and user is supposed to
>set the key explicitly with some other system call.Why I am saying
>this is. I remember somewhere in kernel code I read some comment
>related to setkey operations.

I would like to wait for Herbert to chime in here on how he thinks this would 
work.
>
>In that case my patch should work. 1 doubt I have related to patch is
>do I need to set "ctx->more" =1 after initialisation.
>
>Correct me If I am wrong.
>
>
>Thanks for your support.
>
>
>regards
>Harsh Jain
>
>On Wed, Oct 28, 2015 at 4:53 PM, Stephan Mueller <smueller@chronox.de> wrote:
>> Am Mittwoch, 28. Oktober 2015, 16:24:34 schrieb Harsh Jain:
>> 
>> Hi Harsh,
>> 
>>>Hi Stephan,
>>>
>>>I tried your patch on my machine. Kernel is not crashing. The openssl
>>>break with this. Can you share HMAC program which you are suspecting
>>>it will not work or do you already have some test written in
>>>libkcapi/test.sh which will fail.
>>>
>> See comments above test/kcapi-main.c:cavs_hash
>> 
>>  * HMAC command line invocation:
>>  * $ ./kcapi -x 3 -c "hmac(sha1)" -k
>>  6e77ebd479da794707bc6cde3694f552ea892dab
>> 
>> -p
>> 31b62a797adbff6b8a358d2b5206e01fee079de8cdfc4695138bba163b4efbf30127343e7fd
>> 4fbc696c3d38d8f27f57c024b5056f726ceeb4c31d98e57751ec8cbe8904ee0f9b031ae6a0c
>> 55da5e062475b3d7832191d4057643ef5fa446801d59a04693e573a8159cd2416b7bd39c7f0
>> fe63c599365e04d596c05736beaab58> 
>>  * 7f204ea665666f5bd2b370e546d1b408005e4d85
>> 
>> To do that, apply your patch and then
>> 
>> 1. open lib/kcapi-kernel-if.c and change line 567 from
>> 
>> handle->opfd = accept(handle->tfmfd, NULL, 0);
>> 
>> 
>> to
>> 
>> handle->opfd = accept(handle->tfmfd, NULL, 0);
>> handle->opfd = accept(handle->opfd, NULL, 0);
>> handle->opfd = accept(handle->opfd, NULL, 0);
>> handle->opfd = accept(handle->opfd, NULL, 0);
>> handle->opfd = accept(handle->opfd, NULL, 0);
>> 
>> You will see that the hash commands will pass, the HMAC fails
>> 
>> Without your patch, the kernel crashes (same as with your OpenSSL code).
>> 
>> The reason is that setkey is applied on the TFM that is not conveyed to the
>> subsequent TFMs generated with new accepts.
>> 
>>>Regards
>>>Harsh Jain
>>>
>>>On Wed, Oct 28, 2015 at 6:25 AM, Stephan Mueller <smueller@chronox.de> 
wrote:
>>>> Am Mittwoch, 28. Oktober 2015, 01:09:58 schrieb Stephan Mueller:
>>>> 
>>>> Hi Harsh,
>>>> 
>>>>> However, any error in user space should not crash the kernel. So, a fix
>>>>> should be done. But I think your code is not correct as it solidifies a
>>>>> broken user space code.
>>>> 
>>>> After thinking a bit again, I think your approach is correct after all. I
>>>> was able to reproduce the crash by simply adding more accept calls to my
>>>> test code. And I can confirm that your patch works, for hashes.
>>>> 
>>>> *BUT* it does NOT work for HMAC as the key is set on the TFM and the
>>>> subsequent accepts do not transport the key. Albeit your code prevents
>>>> the
>>>> kernel from crashing, the HMAC calculation will be done with an empty key
>>>> as
>>>> the setkey operation does not reach the TFM handle in the subordinate
>>>> accept() call.
>>>> 
>>>> So, I would think that the second accept is simply broken, for HMAC at
>>>> least.
>>>> 
>>>> Herbert, what is the purpose of that subordinate accept that is
>>>> implemented
>>>> with hash_accept? As this is broken for HMACs, should it be removed
>>>> entirely?
>>>> 
>>>> --
>>>> Ciao
>>>> Stephan
>>>
>>>--
>>>To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>>>the body of a message to majordomo@vger.kernel.org
>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> Ciao
>> Stephan


Ciao
Stephan
