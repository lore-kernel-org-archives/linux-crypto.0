Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B43C54EBE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Jan 2023 23:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbjALX7t (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Jan 2023 18:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238033AbjALX7n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2023 18:59:43 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6C95D8AA
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2023 15:59:39 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id w3so21816973ply.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2023 15:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YOxGu9TF0QtV9czLWlRoi8MtO/LfBf5pI1clFeTOj3o=;
        b=sWx4RBoGeV3nGFYmL0SgAWnfFH7s/pPAka7EdFUbaGzvI+oz9UpEJ/MkQDEtTuwnN9
         ED2OZlG8Oc1Y/tAlmxByk1osBkmYbNDZFMdEVgbMyQt++/iBLJ77u1urNxwq5OA8Qe2C
         ZaPFXwFSFeUAQdG0JVNbeWX1KowNmelNcdauSM80Wz6HXNDh+eHXCIADwF/s4SBEtZsg
         NB8JEcUHOPgT6O1QpfqYNDcgT2v43qEUqY5N7+Ik5R11fF8nqgZdH87rpoLAmOLaJgVJ
         Nd/bapu4YRQuYRTFv9grs7qrkxl9l4oxvL0f+tLxHwetZL0cliCw/l+jxF5dUthWAxKr
         Sc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YOxGu9TF0QtV9czLWlRoi8MtO/LfBf5pI1clFeTOj3o=;
        b=kzWwq47iSKCD3ij+/uFWveT2mDWUT93V4eu1GUf83ZO9m9T2z/1xyDOCUS5rWNUab7
         fPKB0KbbwP9UTd5jBsl4mIPZDl3QZE5IAoAhVifS/qm4jCr0d9Mk8XKmodMrA9L5ZiBu
         ghnQfBLnq3E+e5A6ytBYsVw5VxyNHiyRercc+p1LUFAWgUEtJTfI00vXI87Bm5Uc1sRM
         6anZYxILtOAAJxYFsKXbHXbEHNcV0KW6MFw0s8G+StFEjII9JH2mIOmHQys69M0B7tBd
         HcvHF0nXwQVXlyzRrLvJVU0ZtQzT3SeuyeNjHPld9UL3IZ9CQtKmEnbaPp+Z1dluAVRW
         EmTg==
X-Gm-Message-State: AFqh2kq2tCall1VBbpDSfcr78r1lCDcpQwOWEhfhNMEyka4KRTiCcGQE
        SK8g8vBrAdbg1juRWSwvujOlFGRDxW45O23s
X-Google-Smtp-Source: AMrXdXtscQ7xEgomCamqZcZazKq6mWA71lXLjuymhU8awjVGmi4jnbBHrzR/XzGQnLoGXa4o7sltYw==
X-Received: by 2002:a05:6a20:4284:b0:9d:b8e6:d8e5 with SMTP id o4-20020a056a20428400b0009db8e6d8e5mr1410949pzj.2.1673567978825;
        Thu, 12 Jan 2023 15:59:38 -0800 (PST)
Received: from [2620:15c:29:203:1f3b:d48c:199c:9f57] ([2620:15c:29:203:1f3b:d48c:199c:9f57])
        by smtp.gmail.com with ESMTPSA id d4-20020a17090a8d8400b001fd6066284dsm11340564pjo.6.2023.01.12.15.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 15:59:38 -0800 (PST)
Date:   Thu, 12 Jan 2023 15:59:37 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Jarkko Sakkinen <jarkko@profian.com>
cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] crypto: ccp: Sanitize sev_platform_init() error
 messages
In-Reply-To: <20230110191201.29666-1-jarkko@profian.com>
Message-ID: <1a78beb1-bd63-ca70-6b05-bff45de842e5@google.com>
References: <20230110191201.29666-1-jarkko@profian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 10 Jan 2023, Jarkko Sakkinen wrote:

> The following functions end up calling sev_platform_init() or
> __sev_platform_init_locked():
> 
> * sev_guest_init()
> * sev_ioctl_do_pek_csr
> * sev_ioctl_do_pdh_export()
> * sev_ioctl_do_pek_import()
> * sev_ioctl_do_pek_pdh_gen()
> * sev_pci_init()
> 
> However, only sev_pci_init() prints out the failed command error code, and
> even there, the error message does not specify which SEV command failed.
> 
> Address this by printing out the SEV command errors inside
> __sev_platform_init_locked(), and differentiate between DF_FLUSH, INIT and
> INIT_EX commands.  As a side-effect, @error can be removed from the
> parameter list.
> 
> This extra information is particularly useful if firmware loading and/or
> initialization is going to be made more robust, e.g. by allowing firmware
> loading to be postponed.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>

Acked-by: David Rientjes <rientjes@google.com>
