Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACD1C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jun 2022 12:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345129AbiF1MPq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jun 2022 08:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbiF1MPp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jun 2022 08:15:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C8AF23BCA
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jun 2022 05:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656418540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ddZauxgs0hwCqpk1Kk2l3rlfcajsKYSuQmpLDJpa4rk=;
        b=dvWI+JpX0ZCbeHWMGiuzgsKabxlmw69FO67vIHgY0yVX3PqYuX77N8EwwnVHSPPlmqcMCI
        mFrpMrWXFJDiuv2tzQtEfj3ZVMjpopiv3X7HVYj+A4gNr+fDNt7nODw9SyZE47IjehyHq6
        P/A+5urjz/aCcUFgwCGGMN51x8CFiMM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-8HanAEZrNMaO98ntCCnypg-1; Tue, 28 Jun 2022 08:15:39 -0400
X-MC-Unique: 8HanAEZrNMaO98ntCCnypg-1
Received: by mail-ed1-f70.google.com with SMTP id h16-20020a05640250d000b00435bab1a7b4so9475334edb.10
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jun 2022 05:15:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ddZauxgs0hwCqpk1Kk2l3rlfcajsKYSuQmpLDJpa4rk=;
        b=bvlD6QVm7SRJqcw1VBZ2YHgxCuWiptIqrAwnkdR+YUKxrF+lBXxWuzkqeIQCOC9iil
         GLyid+nZeZWg/r1+uyAQjLXA6fdaAtoLBP7kBP2yUSamtbdOvCdqs8KU5WvlMlJVpVNf
         k6OFxE+7YId5YlB7FWN7IdHs0WHEcFPzlJuVXc6kegIniAkGrHri007qYktnPKgeK2V3
         8kDb4CkWv19kCR+bVcoIJcYNN71+2Yz4pJp4oB61QpXFaXSFKGR5kGNHgUBs8RZSrB7T
         W/YUea3+U5TEzizpX2qXpzeJltCYbaq18x7lc3KZXL8P6rUT2Jems8pC7BLpOdnB/hFi
         v6ng==
X-Gm-Message-State: AJIora+OHkifcK5rjuu3/CmuHh1nxu3mEBgmp5Vp1iLvam8ES4ioCpww
        vLRzTY7YpAEqTeg7NGw5XCzpvHTfvLfLI7yc7DQvodJ6Pd+inQ1C8IJH357Q2eBpANEI23r0beM
        QlEI8jOWjJV8aa/a+nNUtJkIJZ+o/YKaDWqAtXUdv
X-Received: by 2002:a17:907:60cb:b0:726:a69a:c7a with SMTP id hv11-20020a17090760cb00b00726a69a0c7amr9963933ejc.156.1656418537765;
        Tue, 28 Jun 2022 05:15:37 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tkWXdyDIvhoEkZtCUzHu6imZZvI7uBV5/+O06+Z3rfPkdQ8FtSA8cpnX0seEQjQ/NsMbJYglcUJykmVxkDfFk=
X-Received: by 2002:a17:907:60cb:b0:726:a69a:c7a with SMTP id
 hv11-20020a17090760cb00b00726a69a0c7amr9963920ejc.156.1656418537572; Tue, 28
 Jun 2022 05:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220627083652.880303-1-giovanni.cabiddu@intel.com>
In-Reply-To: <20220627083652.880303-1-giovanni.cabiddu@intel.com>
From:   Vlad Dronov <vdronov@redhat.com>
Date:   Tue, 28 Jun 2022 14:15:26 +0200
Message-ID: <CAMusb+SU1AtWf+RQH6r9kxDwKfR0qTrGaB1BfSk0s7gTKjbp_Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] crypto: qat - enable configuration for 4xxx
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Mon, Jun 27, 2022 at 10:37 AM Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> qat_4xxx devices can be configured to allow either crypto or compression
> operations. By default, devices are configured statically according
> to following rule:
> - odd numbered devices assigned to compression services
> - even numbered devices assigned to crypto services
>
> This set exposes two attributes in sysfs that allow to report and change
> the state and the configuration of a QAT 4xxx device.
> The first, /sys/bus/pci/devices/<BDF>/qat/state, allows to bring a
> device down in order to change the configuration, and bring it up again.
> The second, /sys/bus/pci/devices/<BDF>/qat/cfg_services, allows to
> inspect the current configuration of a device (i.e. crypto or
> compression) and change it.
>
>     # cat /sys/bus/pci/devices/<BDF>/qat/state
>     up
>     # cat /sys/bus/pci/devices/<BDF>/qat/cfg_services
>     sym;asym
>     # echo down > /sys/bus/pci/devices/<BDF>/qat/state
>     # echo dc > /sys/bus/pci/devices/<BDF>/qat/cfg_services
>     # echo up > /sys/bus/pci/devices/<BDF>/qat/state
>     # cat /sys/bus/pci/devices/<BDF>/qat/state
>     dc
>
> Changes from v1:
>  - Updated target kernel version in documentation (from 5.19 to 5.20).
>  - Fixed commit message in patch #1 and updated documentation in patch
>    #4 after review from Vladis Dronov.
>
> Giovanni Cabiddu (4):
>   crypto: qat - expose device state through sysfs for 4xxx
>   crypto: qat - change behaviour of adf_cfg_add_key_value_param()
>   crypto: qat - relocate and rename adf_sriov_prepare_restart()
>   crypto: qat - expose device config through sysfs for 4xxx

The patchset looks good to me. Please feel free to use:

Reviewed-by: Vladis Dronov <vdronov@redhat.com>

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

