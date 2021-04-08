Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48DDCC433ED
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 09:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 041A461130
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 09:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhDHJcY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Apr 2021 05:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhDHJcX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Apr 2021 05:32:23 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED75C061760
        for <linux-crypto@vger.kernel.org>; Thu,  8 Apr 2021 02:32:11 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id z1so1931835ybf.6
        for <linux-crypto@vger.kernel.org>; Thu, 08 Apr 2021 02:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=fnMlI4cCi5i1NUufdtdv3pSuJm+l7oWlNXT7wYqme/w=;
        b=bHgeyreC34y/fcAqWRBoIwsfvdZkzYyZmrqHyhWcPg7AMKYpwTPLq28D/dFAhF5Yl+
         XgR6err4AXKzcy6stJsw43sjDFB560/4rfw+ll+kNJfshWjncVPXRMr4FebB7kBt29W+
         0B9zB/cGDhfNM6X1J3Y6HEBk7KtW+/so6iQ8LBdf4j+giIhpckip8lcUuAPnVZYGBAm9
         6w16j7CoA03fE9IVY0q3/Fc4SH0a8mIycVu8LVQmjenHD23gr5SoWcfnmfOODFkh0tzO
         kxeCVjEG9wdyWPa9u8CKnezQQ1OgKBN2D44b9ShOZIaHjX6cau5gGi02TY+rH75+UpCK
         Y70Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=fnMlI4cCi5i1NUufdtdv3pSuJm+l7oWlNXT7wYqme/w=;
        b=QCM1nexxjc3rU9ZQDY1phDWmkEPiBkGZHMRFutoHXVcuYvF66PT8gdA/7/JZiEZTuz
         CVPt8nZbX3aBovYnltXOKywRMMQ+3l/83cTyZK2IzXBwKtlH1wC4Wd7ElWtscSgD0fRG
         ulZz8vyfU8zYpR1d+UApv7F4St4HCO8B7rBrhQ4YhZV2bbVPRtCFcucz3CnP3QRR3Eo4
         TtakjQz3w9tFYYotpI0+BbGCDg2oD/EcfLql3Mg8txafBYl3NItB48loaDf2WpT7WFR+
         LGH6mxBzgqvHdHfU+okhh/9fSZzfT6TxUsmDGVgj3WGNtzp1JLDj7miDQmyPmlvHZAf5
         V6yg==
X-Gm-Message-State: AOAM532baojcaRWZDMdxsjcuWqd00v2kherDB86t8bxie8rbkpkp7RF2
        FhpymccjpYxqCwUAXUp2HKayJDrrPGC2xDXXfmI=
X-Google-Smtp-Source: ABdhPJyQ4YkNxT7dTfE5jXwHMohMXu/712oSG60h7tDyNnw8AHnXvu0iGYiOvjRIQ5tE2DIYBmwBcCj+7r9BoGe3uzM=
X-Received: by 2002:a25:b906:: with SMTP id x6mr9689759ybj.504.1617874330845;
 Thu, 08 Apr 2021 02:32:10 -0700 (PDT)
MIME-Version: 1.0
From:   Tony He <huangya90@gmail.com>
Date:   Thu, 8 Apr 2021 17:31:59 +0800
Message-ID: <CAAUX2SU=_h32YHa9=U1fjq6LWXFi_9yaa_-pRWwNY=jgO+0kxQ@mail.gmail.com>
Subject: =?UTF-8?Q?Is_it_possible_to_add_block_ciphers_for_MIPS_OCTEON?=
        =?UTF-8?Q?=EF=BC=9F?=
To:     aaro.koskinen@iki.fi
Cc:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[Resend this email because the previous one contains a HTML subpart.
Very sorry!]

Hi Aaro,

Sorry to bother you. I saw you have added some message digest modules
to support OCTEON hardware accelerator. May I know if we can support
block ciphers
such as AES/DES ? We can get ASM primitives from
https://svn.dd-wrt.com//browser/src/linux/universal/linux-3.10/arch/mips/include/asm/octeon/cvmx-asm.h?rev=24520
Thanks.

// AES



#define CVMX_MT_AES_ENC_CBC0(val) asm volatile ("dmtc2 %[rt],0x0108" :
: [rt] "d" (val))

#define CVMX_MT_AES_ENC_CBC1(val) asm volatile ("dmtc2 %[rt],0x3109" :
: [rt] "d" (val))

#define CVMX_MT_AES_ENC0(val) asm volatile ("dmtc2 %[rt],0x010a" : :
[rt] "d" (val))

#define CVMX_MT_AES_ENC1(val) asm volatile ("dmtc2 %[rt],0x310b" : :
[rt] "d" (val))

#define CVMX_MT_AES_DEC_CBC0(val) asm volatile ("dmtc2 %[rt],0x010c" :
: [rt] "d" (val))

#define CVMX_MT_AES_DEC_CBC1(val) asm volatile ("dmtc2 %[rt],0x310d" :
: [rt] "d" (val))

#define CVMX_MT_AES_DEC0(val) asm volatile ("dmtc2 %[rt],0x010e" : :
[rt] "d" (val))

#define CVMX_MT_AES_DEC1(val) asm volatile ("dmtc2 %[rt],0x310f" : :
[rt] "d" (val))

// pos can be 0-3

#define CVMX_MT_AES_KEY(val,pos) asm volatile ("dmtc2 %[rt],0x0104+"
CVMX_TMP_STR(pos) : : [rt] "d" (val))

// pos can be 0-1

#define CVMX_MT_AES_IV(val,pos) asm volatile ("dmtc2 %[rt],0x0102+"
CVMX_TMP_STR(pos) : : [rt] "d" (val))

#define CVMX_MT_AES_KEYLENGTH(val) asm volatile ("dmtc2 %[rt],0x0110"
: : [rt] "d" (val)) // write the keylen

// pos can be 0-1

#define CVMX_MT_AES_RESULT(val,pos) asm volatile ("dmtc2
%[rt],0x0100+" CVMX_TMP_STR(pos) : : [rt] "d" (val))



// pos can be 0-1

#define CVMX_MF_AES_RESULT(val,pos) asm volatile ("dmfc2
%[rt],0x0100+" CVMX_TMP_STR(pos) : [rt] "=d" (val) : )

// pos can be 0-1

#define CVMX_MF_AES_IV(val,pos) asm volatile ("dmfc2 %[rt],0x0102+"
CVMX_TMP_STR(pos) : [rt] "=d" (val) : )

// pos can be 0-3

#define CVMX_MF_AES_KEY(val,pos) asm volatile ("dmfc2 %[rt],0x0104+"
CVMX_TMP_STR(pos) : [rt] "=d" (val) : )

#define CVMX_MF_AES_KEYLENGTH(val) asm volatile ("dmfc2 %[rt],0x0110"
: [rt] "=d" (val) : ) // read the keylen

#define CVMX_MF_AES_DAT0(val) asm volatile ("dmfc2 %[rt],0x0111" :
[rt] "=d" (val) : ) // first piece of input data

// 3DES



// pos can be 0-2

#define CVMX_MT_3DES_KEY(val,pos) asm volatile ("dmtc2 %[rt],0x0080+"
CVMX_TMP_STR(pos) : : [rt] "d" (val))

#define CVMX_MT_3DES_IV(val) asm volatile ("dmtc2 %[rt],0x0084" : :
[rt] "d" (val))

#define CVMX_MT_3DES_ENC_CBC(val) asm volatile ("dmtc2 %[rt],0x4088" :
: [rt] "d" (val))

#define CVMX_MT_3DES_ENC(val) asm volatile ("dmtc2 %[rt],0x408a" : :
[rt] "d" (val))

#define CVMX_MT_3DES_DEC_CBC(val) asm volatile ("dmtc2 %[rt],0x408c" :
: [rt] "d" (val))

#define CVMX_MT_3DES_DEC(val) asm volatile ("dmtc2 %[rt],0x408e" : :
[rt] "d" (val))

#define CVMX_MT_3DES_RESULT(val) asm volatile ("dmtc2 %[rt],0x0098" :
: [rt] "d" (val))



// pos can be 0-2

#define CVMX_MF_3DES_KEY(val,pos) asm volatile ("dmfc2 %[rt],0x0080+"
CVMX_TMP_STR(pos) : [rt] "=d" (val) : )

#define CVMX_MF_3DES_IV(val) asm volatile ("dmfc2 %[rt],0x0084" : [rt]
"=d" (val) : )

#define CVMX_MF_3DES_RESULT(val) asm volatile ("dmfc2 %[rt],0x0088" :
[rt] "=d" (val) : )


Tony
