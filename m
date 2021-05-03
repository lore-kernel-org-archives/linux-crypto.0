Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799C1C433ED
	for <linux-crypto@archiver.kernel.org>; Mon,  3 May 2021 07:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C65C6121E
	for <linux-crypto@archiver.kernel.org>; Mon,  3 May 2021 07:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhECH6A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 May 2021 03:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbhECH57 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 May 2021 03:57:59 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416CBC061761
        for <linux-crypto@vger.kernel.org>; Mon,  3 May 2021 00:57:06 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id z5so3079868qts.3
        for <linux-crypto@vger.kernel.org>; Mon, 03 May 2021 00:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=f/I8crA6XyQMlGZyflnFllaw+4mke1a81RQOyGK/4Q0=;
        b=pRa5Vdjw8OkcL5+KzBwx7yDLiyHNcNSZpWxfWVYiPRdsOIl/yT7tShaMCvI6Mblsai
         TBHqeEAPB+YbMJDbA2KxCvd+vJ3y8H1iM/pOAs7miw05Rs6svZ9+xSkYCVdiWyt5Rz5d
         cJ7dul62EcoxHVnsHtv9lpN4GA7bSkLhK7GM3+Cf5tiKUkN0M037T6zy9uewuOTsGshB
         C7eAdCsV58+ZoNW5W5p7YG7YVmsRfLVvOI5QzmOOD5Y/Q0jO18BRcIdkbj5veEJK/nTH
         +hGtoYCusdsNST01R3ztLDiu7zbrIcHg8PEYC5MalOmwdFkl5AGESn9h19akpOpI+tWe
         wabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=f/I8crA6XyQMlGZyflnFllaw+4mke1a81RQOyGK/4Q0=;
        b=XkcA1B5Esm83Lahg6l5UIAHcWazmfZMszS1PqcN2HRNZZd9ut1zWIK8flRPkNpLwzQ
         F9cYqUvEVZEoRMd4RSNde3i8xIhx3sPK2GbLmhTU3m630CbHmXh6VBlKbAY96ulagopn
         lMxJRRUQJ2KPGxOZzfG0C0x0VPpvZhyT20tOJxsDpcbaK7nojk8msjatwg5f/geKYjFi
         YbJYsbf0NaWJysevQvsaP+mwzNSEmNudXAd6yt+pZH5QDSbDbM3gPogwlLTUhIV50Jce
         sBxFZziA/waXFKdmiCOX83htUoo4g/w1AKYK41e6KFYmTqVWbXOPkqqH9xV0m7/jyi3w
         J+gQ==
X-Gm-Message-State: AOAM533S+8dt9zrdeV9Aq5xmxSxkSraK47por9D85fOQPeTzd9Z2s0ZZ
        vKW0N/FlD9TzCyWUENgACO4ukoWLBwyUiqzxSNOCO4RytLnj6Q==
X-Google-Smtp-Source: ABdhPJx+lMnwFE2Je5ybjtX2c2dwneu4eZqt6Okp1l26cWgQ0XdxYtJ9YBqYvuOR4ARtPs3fDwDXFGh5WGcaxfpaHwE=
X-Received: by 2002:a05:622a:1387:: with SMTP id o7mr9212517qtk.387.1620028625455;
 Mon, 03 May 2021 00:57:05 -0700 (PDT)
MIME-Version: 1.0
From:   Kestrel seventyfour <kestrelseventyfour@gmail.com>
Date:   Mon, 3 May 2021 09:56:40 +0200
Message-ID: <CAE9cyGSX4nwRrDbazih2FDp1_8e+wGTD17euyCJyitXWOignMw@mail.gmail.com>
Subject: cannot pass split cryptomgr tests for aes ctr
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I am trying to update the old ifxdeu driver to pass the crypto mgr tests.
However, I continously fail to pass the split tests and I wonder what to do.

For example, I successfully pass the test vector 0 here:
https://elixir.bootlin.com/linux/latest/source/crypto/testmgr.h#L16654
if there is no split.

But if the text "Single block msg" is split into two 8 byte blocks
(single even aligned splits), which end up as separate skcipher walks
in the driver, the second block is wrong and does not compare
correctly, to what is hardcoded in testmgr.h. Same if I try it with
online aes-ctr encoders in the web.
I have tried doing the xor manually with the aes encoded iv, but I get
the same result as the hardware and if I use the next last iv, I still
do not get the second 8 bytes that are hardcoded in cryptomgr.h.

Can someone shed a light on it?
Is it valid to compare a crypto result that was done on a single walk
with 16byte with two separate walks on the 8 byte splits (of the
original 16)? Is the cryptomgr test on the split tests expecting that
I concat the two walks into a single one?
If yes, how to do that on the uneven splits with separations like 15
16 5 byte sequences, etc., fill up the walk up to full block size and
spill over into the next walk?

Thanks in advance.
