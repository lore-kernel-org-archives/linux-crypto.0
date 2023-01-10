Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB60C54EBC
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 16:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238735AbjAJQtf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 11:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238561AbjAJQt2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 11:49:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96494216
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 08:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673369320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lJePnZsKXnubDcGA3DYzaayBveLdWQPssGSlTfWc4l8=;
        b=TVodgAXQv+xTQHZdt2rKYeMfVOTOBMl1yTTiaHRGOz6fGYmsBvN0F8bCjlzvrEB4USFwEU
        iCWjVXInJFw+mSOzqBOoaa3uF64nNHPwXuqma9NQHeEXIKXrAEwaUSN2sF5P0RfhGyeX+m
        a0U5pCHXOPwICIhj2DrwEtF3ttPy1hk=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-66-qf-GHNnBO7OWRxoPdjUyMA-1; Tue, 10 Jan 2023 11:48:39 -0500
X-MC-Unique: qf-GHNnBO7OWRxoPdjUyMA-1
Received: by mail-pj1-f70.google.com with SMTP id t12-20020a17090a3e4c00b00225cb4e761cso5100423pjm.3
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 08:48:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lJePnZsKXnubDcGA3DYzaayBveLdWQPssGSlTfWc4l8=;
        b=Wawydch+o3fFiBSAIXmxNr0YAhdtpvPae02j7kyzGUhjm9QUREeztbCUzVJlMET3aw
         vZtOpUm7J3jhWWq6cmZ1aF8qmQOfeGi79MVKZU4Sp644i4zVxEfFN4cZ4bMje1KJJGm+
         BsnM0eWyncabCv4NuwYEFKaHRfSAzxmxtv/LeCsQMOjT+9RcLhfsBUyQnORJW5xs9Pel
         4Wd+bfZirpW6sFIcjQPplQuwDQ68M3wgV4u70OfyDcqlYJGajBpYKRiYdvaWboWpaV0j
         Iqmk+62oixie63mjma0O9awyYwxQo8yzHlqKkNHGb0I8ltQoO7Db52yG+52u7i8Ttdj0
         mmOQ==
X-Gm-Message-State: AFqh2krKY1H3aLwU4bk/ydIdQ7XZrmCdGDWxYDvJziA0IIRoSgFSI9J7
        oAKG/hXaiTMTD0mBHBoHlp2dkI230KJV3NpjvZvrg7EUG1KBQCI7llIKeDRgjE4727541mKzeZQ
        1UxUMuhVJBfxK1OQJOwt1z/WR
X-Received: by 2002:a17:902:8c90:b0:192:a470:2c0b with SMTP id t16-20020a1709028c9000b00192a4702c0bmr36292902plo.49.1673369318518;
        Tue, 10 Jan 2023 08:48:38 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuNUHJUABqba3WYraNADndH3NP90X++/rRyazKN7bjjjbrXyT/4JMDE35Fof+hR07vv+79c1g==
X-Received: by 2002:a17:902:8c90:b0:192:a470:2c0b with SMTP id t16-20020a1709028c9000b00192a4702c0bmr36292883plo.49.1673369318177;
        Tue, 10 Jan 2023 08:48:38 -0800 (PST)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id l7-20020a655607000000b00477bdc1d5d5sm7061400pgs.6.2023.01.10.08.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 08:48:37 -0800 (PST)
Subject: Re: [PATCH] crypto: initialize error
To:     Peter Gonda <pgonda@google.com>
Cc:     brijesh.singh@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        nathan@kernel.org, ndesaulniers@google.com, rientjes@google.com,
        marcorr@google.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20230110161831.2625821-1-trix@redhat.com>
 <CAMkAt6oqBH35=moST5nO_BXwc8k0M4h_8TvT9H6outR9vOw5qg@mail.gmail.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <ecd0c7f2-f82c-845f-b1fe-a7d3bf495bb1@redhat.com>
Date:   Tue, 10 Jan 2023 08:48:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAMkAt6oqBH35=moST5nO_BXwc8k0M4h_8TvT9H6outR9vOw5qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 1/10/23 8:27 AM, Peter Gonda wrote:
> On Tue, Jan 10, 2023 at 9:18 AM Tom Rix <trix@redhat.com> wrote:
>> clang static analysis reports this problem
>> drivers/crypto/ccp/sev-dev.c:1347:3: warning: 3rd function call
>>    argument is an uninitialized value [core.CallAndMessage]
>>      dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
>>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> __sev_platform_init_locked() can return without setting the
>> error parameter, causing the dev_err() to report a gargage
> garbage
ok
>
>> value.
>>
>> Fixes: 3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support")
> Should this be: 'Fixes: 200664d5237f ("crypto: ccp: Add Secure
> Encrypted Virtualization (SEV) command support")'
>
> Since in that patch an uninitialized error can be printed?

It was a bit of a toss up on who is at fault. This is fine, i'll change 
this as well.

Thanks

Tom


> +void psp_pci_init(void)
> +{
> +       struct sev_user_data_status *status;
> +       struct sp_device *sp;
> +       int error, rc;
> +
> +       sp = sp_get_psp_master_device();
> +       if (!sp)
> +               return;
> +
> +       psp_master = sp->psp_data;
> +
> +       /* Initialize the platform */
> +       rc = sev_platform_init(&error);
> +       if (rc) {
> +               dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
> +               goto err;
> +       }
>
>
> ...
>
> +static int __sev_platform_init_locked(int *error)
> +{
> +       struct psp_device *psp = psp_master;
> +       int rc = 0;
> +
> +       if (!psp)
> +               return -ENODEV;
> +
> +       if (psp->sev_state == SEV_STATE_INIT)
> +               return 0;
>
>
> So if !psp an uninitialized error is printed?
>
>> Signed-off-by: Tom Rix <trix@redhat.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 56998bc579d6..643cccc06a0b 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1307,7 +1307,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>>   void sev_pci_init(void)
>>   {
>>          struct sev_device *sev = psp_master->sev_data;
>> -       int error, rc;
>> +       int error = 0, rc;
>>
>>          if (!sev)
>>                  return;
>> --
>> 2.27.0
>>

