Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD11C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 21:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DFF02084C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 21:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbfJKVFV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 17:05:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59076 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfJKVFV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 17:05:21 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D8AB2C01FBD9
        for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2019 21:05:20 +0000 (UTC)
Received: by mail-io1-f72.google.com with SMTP id w8so16298002iol.20
        for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2019 14:05:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=T6nN5QVk09gIDvkOFTEMQ2zlhiOadfEsIkZwkKFcinc=;
        b=hwCViBRrkG3VeoMVPeWyO+mLASxCIKevDpcIzYF8/i24crxCK5lj5mfsaBHDVCVMFh
         WocJCLl32DgEXx/wmuUcMs4o0hleqO9ftiCZvaQ2uTX460/UIy4OrophaVRLKT9rz5UJ
         gPY4wflSth/eR+kU8I8Q8cURwFwXfcoNw6ZTxUH7IR4tsh0J5+2voWkD3NJb7bIKrjPm
         1KyZgu5yixBNeDBfMuPYgNZ/aNzqN76QokbLQiERuQf4WwJZtB+b0pjZvJja4LqTLnwW
         MfvMQ5U6VuqGAm9BOeLNyzHNslqcRI9nsVfg/8ytFTnJY/sj54y+qkD/SsUvaqw1Uid1
         HU0Q==
X-Gm-Message-State: APjAAAW67z+hvzu86oZaiBpeMo6b67BBrn6Rz9DotiUKxOrh4Q1Iyq4t
        HEhqhatOVStucgOIMoPgvgmwsn0TjsbpnrmottFE898F/eMMs4d1kFIdDFQedU1zf93K/tcc1rz
        ieltRgx35q5nXRAmytjD57YHu
X-Received: by 2002:a02:cb52:: with SMTP id k18mr19911868jap.97.1570827920182;
        Fri, 11 Oct 2019 14:05:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxEVW3IbyR5eo7Y7vjH1MySickb9sECy4da7QTB9xvqhAM+inaAIj9NElVpvE+wQ+LlOfYACg==
X-Received: by 2002:a02:cb52:: with SMTP id k18mr19911826jap.97.1570827919801;
        Fri, 11 Oct 2019 14:05:19 -0700 (PDT)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id a25sm5765883iod.62.2019.10.11.14.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 14:05:19 -0700 (PDT)
Date:   Fri, 11 Oct 2019 14:05:17 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sumit Garg <sumit.garg@linaro.org>, dhowells@redhat.com,
        peterhuewe@gmx.de, keyrings@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, jgg@ziepe.ca, arnd@arndb.de,
        gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        linux-kernel@vger.kernel.org, daniel.thompson@linaro.org
Subject: Re: [Patch v7 0/4] Create and consolidate trusted keys subsystem
Message-ID: <20191011210517.qxjemugqczsvscu6@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sumit Garg <sumit.garg@linaro.org>, dhowells@redhat.com,
        peterhuewe@gmx.de, keyrings@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, jgg@ziepe.ca, arnd@arndb.de,
        gregkh@linuxfoundation.org, jejb@linux.ibm.com, zohar@linux.ibm.com,
        jmorris@namei.org, serge@hallyn.com, linux-kernel@vger.kernel.org,
        daniel.thompson@linaro.org
References: <1570425935-7435-1-git-send-email-sumit.garg@linaro.org>
 <20191011123757.GD3129@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191011123757.GD3129@linux.intel.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri Oct 11 19, Jarkko Sakkinen wrote:
>On Mon, Oct 07, 2019 at 10:55:31AM +0530, Sumit Garg wrote:
>> This patch-set does restructuring of trusted keys code to create and
>> consolidate trusted keys subsystem.
>>
>> Also, patch #2 replaces tpm1_buf code used in security/keys/trusted.c and
>> crypto/asymmertic_keys/asym_tpm.c files to use the common tpm_buf code.
>>
>> Changes in v7:
>> 1. Rebased to top of tpmdd/master
>> 2. Patch #4: update tpm2 trusted keys code to use tpm_send() instead of
>>    tpm_transmit_cmd() which is an internal function.
>>
>> Changes in v6:
>> 1. Switch TPM asymmetric code also to use common tpm_buf code. These
>>    changes required patches #1 and #2 update, so I have dropped review
>>    tags from those patches.
>> 2. Incorporated miscellaneous comments from Jarkko.
>>
>> Changes in v5:
>> 1. Drop 5/5 patch as its more relavant along with TEE patch-set.
>> 2. Add Reviewed-by tag for patch #2.
>> 3. Fix build failure when "CONFIG_HEADER_TEST" and
>>    "CONFIG_KERNEL_HEADER_TEST" config options are enabled.
>> 4. Misc changes to rename files.
>>
>> Changes in v4:
>> 1. Separate patch for export of tpm_buf code to include/linux/tpm.h
>> 2. Change TPM1.x trusted keys code to use common tpm_buf
>> 3. Keep module name as trusted.ko only
>>
>> Changes in v3:
>>
>> Move TPM2 trusted keys code to trusted keys subsystem.
>>
>> Changes in v2:
>>
>> Split trusted keys abstraction patch for ease of review.
>>
>> Sumit Garg (4):
>>   tpm: Move tpm_buf code to include/linux/
>>   KEYS: Use common tpm_buf for trusted and asymmetric keys
>>   KEYS: trusted: Create trusted keys subsystem
>>   KEYS: trusted: Move TPM2 trusted keys code
>>
>>  crypto/asymmetric_keys/asym_tpm.c                  | 101 +++----
>>  drivers/char/tpm/tpm-interface.c                   |  56 ----
>>  drivers/char/tpm/tpm.h                             | 226 ---------------
>>  drivers/char/tpm/tpm2-cmd.c                        | 307 --------------------
>>  include/Kbuild                                     |   1 -
>>  include/keys/{trusted.h => trusted_tpm.h}          |  49 +---
>>  include/linux/tpm.h                                | 251 ++++++++++++++--
>>  security/keys/Makefile                             |   2 +-
>>  security/keys/trusted-keys/Makefile                |   8 +
>>  .../{trusted.c => trusted-keys/trusted_tpm1.c}     |  96 +++----
>>  security/keys/trusted-keys/trusted_tpm2.c          | 314 +++++++++++++++++++++
>>  11 files changed, 652 insertions(+), 759 deletions(-)
>>  rename include/keys/{trusted.h => trusted_tpm.h} (77%)
>>  create mode 100644 security/keys/trusted-keys/Makefile
>>  rename security/keys/{trusted.c => trusted-keys/trusted_tpm1.c} (94%)
>>  create mode 100644 security/keys/trusted-keys/trusted_tpm2.c
>>
>> --
>> 2.7.4
>>
>
>I fixed a merge conflict caused by James' commit. Already pushed.
>Compiling test kernel ATM i.e. tested-by's will follow later.
>
>/Jarkko

Are you missing patch 4 on master?
