From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: kernel tainted while exporting shash context using af_alg interface
Date: Wed, 28 Oct 2015 16:24:34 +0530
Message-ID: <CAFXBA=mM=6TRbGV1VfE7fHnvYecit+rZgExduCex+wzKmd231Q@mail.gmail.com>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com>
	<CAFXBA==5iFOGWrZ+JtM4Yr1XnBL2NFRs=EMoeS4F2mF-R89iqQ@mail.gmail.com>
	<2100556.thFK4ZhSZX@myon.chronox.de>
	<42534143.fhk1W1Xe60@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:32782 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbbJ1Kyg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Oct 2015 06:54:36 -0400
Received: by lffv3 with SMTP id v3so1746009lff.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2015 03:54:35 -0700 (PDT)
In-Reply-To: <42534143.fhk1W1Xe60@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

I tried your patch on my machine. Kernel is not crashing. The openssl
break with this. Can you share HMAC program which you are suspecting
it will not work or do you already have some test written in
libkcapi/test.sh which will fail.


Regards
Harsh Jain

On Wed, Oct 28, 2015 at 6:25 AM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Mittwoch, 28. Oktober 2015, 01:09:58 schrieb Stephan Mueller:
>
> Hi Harsh,
>
>>
>>
>> However, any error in user space should not crash the kernel. So, a fix
>> should be done. But I think your code is not correct as it solidifies a
>> broken user space code.
>
> After thinking a bit again, I think your approach is correct after all. I was
> able to reproduce the crash by simply adding more accept calls to my test
> code. And I can confirm that your patch works, for hashes.
>
> *BUT* it does NOT work for HMAC as the key is set on the TFM and the
> subsequent accepts do not transport the key. Albeit your code prevents the
> kernel from crashing, the HMAC calculation will be done with an empty key as
> the setkey operation does not reach the TFM handle in the subordinate accept()
> call.
>
> So, I would think that the second accept is simply broken, for HMAC at least.
>
> Herbert, what is the purpose of that subordinate accept that is implemented
> with hash_accept? As this is broken for HMACs, should it be removed entirely?
>
> --
> Ciao
> Stephan
