Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BF0C64EC7
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Feb 2023 09:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjBNJFe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Feb 2023 04:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjBNJFQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2023 04:05:16 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CE0241D9
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2023 01:04:35 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jg8so38376500ejc.6
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2023 01:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B1Z3q3DmS5pOVEGCvUAhyPF2bKswWr3oxM1fP44E01g=;
        b=COuUcT2AZRNsgh9PCtbDoV0xwtkZWgtPrWi0j45nCIH+dV8sucbSd3+SYnyQv4y9o3
         ZPe0l/BpBLeKgxQy0xp5VWH853xLbsTOEv81tJbrO84pCQmlx7v+BS0zdsYRHqxJ40p3
         Kn5cCw8AFYmOw4bbCEQkoGam0kTsWm3qNgrNUanOF2uhZh8kTeND61lGxf6LKSpsXc2t
         HsgjbLGYP2p5n2Rfms1o7UmPcg3FWOTRzvThW3dFRzqN+rhylkaXtiQCsfhzieKSmCxa
         zQIV2f3AFobTga5xgdf/wvs1v3Ps1qEoWML/t8QGmVcGiTK/bNuzbjIdE4RjJYYwfBga
         TPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B1Z3q3DmS5pOVEGCvUAhyPF2bKswWr3oxM1fP44E01g=;
        b=4p/qJX4pmM9l9u0CgnsWrqdvWXaqdhp8Ra4yFhL1E6uyRzQ+yL/DCIdWGlYjjPDbLn
         +RRT1OEY6pcvJBMuvgOKGcE29zXbg4YyT/KG0LHk9PnHkI6AN7OpHfqpyp4m1nehNfQ2
         +Cxz2jVuFKpQlGJlcQ1kCvYBiq0rBSo5T4Ybgr3XnhYpPfWxNYzqz4uHD63T8c3WpSqx
         uA8xoxolBcO6bMbiYgyzGOchs0Jj74NkjHvCSezV01dyV9ZCKPYhWLZNGo+0X1WL6klQ
         4Y0OXI9p4e6RIOiIcsCk52KpAFsjOghykflR80SAGC2PRtrpPBm5m2QL1RShAIYMjexV
         //6A==
X-Gm-Message-State: AO0yUKXaZxxZaMcREFr84ur+DJEbq1J/R1I3Ncyyn+rfhc8uUff+5ntE
        Socp/bd7DLrUhja86kVi8oKG5wYS6e5sFmis6bv+vQ==
X-Google-Smtp-Source: AK7set+hnsT1pAPi2MI7vrdiN/w8ZaWDcCTCHsqz2LQt0+BtAA2hKUW/X8H+N/bzrjH9fJpgD+558039XefVrYatVD0=
X-Received: by 2002:a17:906:1696:b0:8b1:2fff:8689 with SMTP id
 s22-20020a170906169600b008b12fff8689mr630834ejd.6.1676365470122; Tue, 14 Feb
 2023 01:04:30 -0800 (PST)
MIME-Version: 1.0
References: <20230209223811.4993-1-mario.limonciello@amd.com> <20230209223811.4993-4-mario.limonciello@amd.com>
In-Reply-To: <20230209223811.4993-4-mario.limonciello@amd.com>
From:   =?UTF-8?B?SmFuIETEhWJyb8Wb?= <jsd@semihalf.com>
Date:   Tue, 14 Feb 2023 10:04:18 +0100
Message-ID: <CAOtMz3PuzpcrqQb-L9kzY1be4xwhp72fqNqSWnRvAE0Nd4d3qQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] crypto: ccp: Move some PSP mailbox bit definitions
 into common header
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Grzegorz Bernacki <gjb@semihalf.com>,
        Thomas Rijo-john <Rijo-john.Thomas@amd.com>,
        Lendacky Thomas <Thomas.Lendacky@amd.com>,
        herbert@gondor.apana.org.au, John Allen <john.allen@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(...)
> @@ -99,7 +93,7 @@ static int psp_check_mbox_recovery(struct psp_mbox __iomem *mbox)
>
>         tmp = readl(&mbox->cmd_fields);
>
> -       return FIELD_GET(PSP_MBOX_FIELDS_RECOVERY, tmp);
> +       return FIELD_GET(PSP_CMDRESP_RECOVERY, tmp);
>  }
>
>  static int psp_wait_cmd(struct psp_mbox __iomem *mbox)
> @@ -107,7 +101,7 @@ static int psp_wait_cmd(struct psp_mbox __iomem *mbox)
>         u32 tmp, expected;
>
>         /* Expect mbox_cmd to be cleared and ready bit to be set by PSP */
> -       expected = FIELD_PREP(PSP_MBOX_FIELDS_READY, 1);
> +       expected = FIELD_PREP(PSP_CMDRESP_RESP, 1);

What's the meaning of "PSP_CMDRESP_RESP"? I see that this new macro
name is currently used by other drivers, but in my opinion "READY" is
more descriptive. (It is also aligned to the comment above this line.)
