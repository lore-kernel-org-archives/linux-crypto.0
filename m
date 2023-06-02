Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC0AC77B7A
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jun 2023 06:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjFBGFs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 02:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjFBGFr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 02:05:47 -0400
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B54019A;
        Thu,  1 Jun 2023 23:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; s=LIY0OQ3MUMW6182UNI14; d=nsr.re.kr; t=1685685818; c=relaxed/relaxed; h=content-type:date:from:message-id:mime-version:subject:to; bh=jvAAoIR7hWpzPGIvCqAL3GkKmLXxTRf22KLx1FttpVI=; b=biXsuUl1SHeh1YWBtqNITK0BNzQrygKmK5g7REAZ/eo/10bdmydFU2U8eX9tAHl30FYqSYNQkm6KIHIDkGKD80u8OlYjDxP1FNxzUZIUSsve9Kmz+zqojCm58dQhyvdfM8yjJOF0gZRIHtlkuW85riYkoqPYfvjT8+2dSm25Y8PM6oqsZsXkzU6szqhEiimP73EbPfJ97qn9XgHtXFbAP5NYUbqldzjaD34rzoSftTYJTFO1BHFqGVpkmhY450uncjLBUiq2WZP+h5xC68bMtDUbCijo0u9uPfB7xu4ZXF3GMv/wj88IE21lrjyz31eiQRYWvtkMlKVacFQnpv14aA==
Received: from 210.104.33.70 (nsr.re.kr)
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
        by mail.nsr.re.kr with SMTP; Fri, 02 Jun 2023 15:03:23 +0900
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 161;
          Fri, 2 Jun 2023 15:05:15 +0900 (KST)
From:   Dongsoo Lee <letrhee@nsr.re.kr>
To:     'Herbert Xu' <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, letrhee@gmail.com
References: <20230525121301.722682-1-letrhee@nsr.re.kr> <ZHh1H3yKPU68J7Uv@gondor.apana.org.au>
In-Reply-To: <ZHh1H3yKPU68J7Uv@gondor.apana.org.au>
Subject: RE: [PATCH v2 0/2] crypto: LEA block cipher implementation
Date:   Fri, 2 Jun 2023 15:05:16 +0900
Message-ID: <008d01d99518$33db63f0$9b922bd0$@nsr.re.kr>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQEgJe7QK/GSa6QvS9/PE8EqZ6STfbDp46/Q
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>>
>> We expect that the first application of the patch would be disk
encryption on the Gooroom platform ('Gooroom' is a Korean word, meaning
'cloud') [3]. Currently, the Gooroom platform uses AES-XTS for disk
encryption. The main reason for submitting this patch is to make disk
encryption with LEA (e.g. LEA-XTS) available on there.
>
>We don't add kernel algorithms without an in-kernel user.  Is there an
existing in-kernel user that can use this as is or are you going to add one?
>
>Thanks,

Our current goal is to encrypt with LEA in a data-at-rest environment.

One option we are considering is utilizing the `dm-crypt` module for disk
encryption. The `dm-crypt` module can use various ciphers provided by the
Linux Crypto API. By specifying the `lea-xts-plain` option in the
`cryptsetup` tool, it can immediately work without further modification.

Additionally, we are exploring the possibility of using `blk-crypto` for
encryption. Currently, the ciphers available for `blk-crypto` are
AES-256-XTS, AES-128-CBC-ESSIV, Adiantum, and SM4-XTS. We would like to add
LEA-256-XTS to these.

( https://github.com/torvalds/linux/blob/master/block/blk-crypto.c#L21 )

Instead of disk encryption, it is also possible to use `fscrypt` to encrypt
the file system for data-at-rest environments. `fscrypt` currently supports
AES-256-XTS, AES-256-CTS-CBC, AES-128-CBC-ESSIV, AES-128-CTS-CBC, SM4-XTS,
SM4-CTS-CBC, Adiantum, and AES-256-HCTR2.

( https://github.com/torvalds/linux/blob/master/fs/crypto/keysetup.c#L16 )

The above are what we will do with LEA.

Thank you.
