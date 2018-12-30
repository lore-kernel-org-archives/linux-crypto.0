Return-Path: <SRS0=5fel=PH=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35066 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbeL3O7v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Dec 2018 09:59:51 -0500
Subject: Re: [PATCH v1 2/2] hwrng: add OP-TEE based rng driver
To: Jens Wiklander <jens.wiklander@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
 <1545908831-25910-3-git-send-email-sumit.garg@linaro.org>
 <CAKv+Gu9ShfrBhfCuRK_L_ZtZ3KnN7Jb-4hcX9nSO7AYbT8V8LQ@mail.gmail.com>
 <CAFA6WYN5+NWKpPhnGHRnh_ZOF9A8K=MvbbSQ9uvc2Tv1expXcA@mail.gmail.com>
 <CAKv+Gu-Go=GwsO=_WvmTr-OZb4WMGGQrMb2joxX1Kzfhza3JiA@mail.gmail.com>
 <CAFA6WYPm3_SZ59vOxceZkn0uzcJw3ECQZs5R_Ypz0ejpzTgAbQ@mail.gmail.com>
 <20181228144610.GA21561@jax.urgonet>
From: =?UTF-8?B?VmVzYSBKw6TDpHNrZWzDpGluZW4=?= <dachaac@gmail.com>
Message-ID: <79744651-991d-ff44-2238-96721ff9bc18@gmail.com>
Date: Sun, 30 Dec 2018 16:59:46 +0200
MIME-Version: 1.0
In-Reply-To: <20181228144610.GA21561@jax.urgonet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All,

On 28/12/2018 16.46, Jens Wiklander wrote:
> Hi Sumit,
> 
> On Fri, Dec 28, 2018 at 06:33:22PM +0530, Sumit Garg wrote:
>> On Fri, 28 Dec 2018 at 16:08, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> Jens,
>>
>> Is there any particular reason to wait indefinitely in
>> "optee_supp_thrd_req" if there is no supplicant running? I think we
>> should probably return as follows from "optee_supp_thrd_req" API in
>> case no supplicant is available:
>>
>> --- a/drivers/tee/optee/supp.c
>> +++ b/drivers/tee/optee/supp.c
>> @@ -88,10 +88,15 @@ u32 optee_supp_thrd_req(struct tee_context *ctx,
>> u32 func, size_t num_params,
>>   {
>>          struct optee *optee = tee_get_drvdata(ctx->teedev);
>>          struct optee_supp *supp = &optee->supp;
>> -       struct optee_supp_req *req = kzalloc(sizeof(*req), GFP_KERNEL);
>> +       struct optee_supp_req *req;
>>          bool interruptable;
>>          u32 ret;
>>
>> +       /* Return in case there is no supplicant available */
>> +       if (!supp->ctx)
>> +               return TEEC_ERROR_COMMUNICATION;
>> +
>> +       req = kzalloc(sizeof(*req), GFP_KERNEL);
>>          if (!req)
>>                  return TEEC_ERROR_OUT_OF_MEMORY;
> 
>  From a user space point of view it has been more useful to just wait
> until the supplicant starts to serve requests than polling the interface
> until the call succeeds. For this new use case it makes more sense to be
> able to return an error instead.
> 
> The proposed change is a user space API change, so we will need to do a
> bit more than that.

There are parts of kernel that need randomness before user space is ready.

Can't we move necessary logic for this to in kernel now that there is 
kernel service requiring TEE services?

I suppose there are even more services that would be better to be only 
optee<->kernel interface and not exposed as such to user space. One 
example of such would be mass storage encryption key or hardware rooted 
encryption for Linux keyring. Eg. replacement for TPM chip when TEE 
environment is available.

Thanks,
Vesa Jääskeläinen
