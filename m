Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C897C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 15:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29EB320757
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 15:13:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZFvRTdGk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgFBPNm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 11:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBPNm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 11:13:42 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30F2C08C5C0;
        Tue,  2 Jun 2020 08:13:41 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id s1so13059920ljo.0;
        Tue, 02 Jun 2020 08:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=TpKFo6Tno/WdRNvEOQwM0VGAsoys2P8vC+dwPzRM56A=;
        b=ZFvRTdGkpbqCB2NNPWG8s+haqZKRhepCEpLVgucSMIMzy00f+qKBxWHoJ8zwgh1AXR
         fT5QKmsRoqMQgdyq20ckxEOEktHhjU4R/ld8R3C30Vo8PuP25300jlLcnJ9j4duL2Dfq
         UvAZ461kxuc9j09vzjx/cFFX2Mj+DZbvBU02en0PLCjPPzKhL+YZnd8nrNvKfifUgM68
         MgR60sC1FiZ9fh368g8piQfWkzZr8Qx1Y8VyXbvgjuO/gmPTzANZzd4bg/SXjG9cYJ6h
         0CBLn9EpT0yyiegsoCFMvGdMNz/huQiwgTlF+MaKac0jzjK+0pEgPL6/aNruCyEiYLVj
         CxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=TpKFo6Tno/WdRNvEOQwM0VGAsoys2P8vC+dwPzRM56A=;
        b=f1Muon8cTrP6cxeTfk9TbpkHoyuJ5eFnQlJlgsEzLz2ByFMSpAh2cfppsJpHIKrL20
         Ik2belyNeSdeupglbH+2D37KuTDLPob2oYqmPUcj2efY1/iaSPbh48nWKLzKBTNzN6TV
         SIBlfC2oUsMlVfzSQ/If06lHtDhxFMuD6Udlm+teYP2vDUTPgV6cU94FTCE1FYCY6Ric
         eHeGl3fjaMOp7PqfL7iCF1xbV6LBG7frIHQl7E0AZkdpOerN01iMLTig1RoYhelmSRXf
         Id36jKH33VcU6AJI+r19rn3ycPKdWoIRr7g1aSDyOlKKXgMEhhyt9oWFx6//vlKHWjgy
         2bEQ==
X-Gm-Message-State: AOAM531g/cvjT7a616wpg/7AsJtklXLCTz+2F72dDqjNlOSxoHm06Vhz
        q29IF4Jw040F9hDsSmY5+pnaerPjm5EcFC9bMzqPqZZd
X-Google-Smtp-Source: ABdhPJxFro7pTs+FgseKXXmKN73i/ajBYDPexPrEHo0C8QfHAD4i9rMKVRZms/dCQXvB0yS99EjpWq1CKjjJasJpxJ0=
X-Received: by 2002:a2e:998f:: with SMTP id w15mr6632062lji.463.1591110820115;
 Tue, 02 Jun 2020 08:13:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac2:4551:0:0:0:0:0 with HTTP; Tue, 2 Jun 2020 08:13:39 -0700 (PDT)
From:   Jari Ruusu <jari.ruusu@gmail.com>
Date:   Tue, 2 Jun 2020 18:13:39 +0300
Message-ID: <CACMCwJKcV41VNRqSKa0ZXzOKHis7sUjWiHnm2ttaYJzHdqR6cw@mail.gmail.com>
Subject: Announce loop-AES-v3.7q file/swap crypto package
To:     linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

loop-AES changes since previous release:
- Worked around kernel interface changes on 5.7 kernels

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7q.tar.bz2
    md5sum b9628468b35e92feee63eccfee8e4863

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7q.tar.bz2.sign

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
