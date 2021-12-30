Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359CAC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Dec 2021 08:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbhL3I3J (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Dec 2021 03:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhL3I3J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Dec 2021 03:29:09 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088E9C061574
        for <linux-crypto@vger.kernel.org>; Thu, 30 Dec 2021 00:29:09 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id e5so49020998wrc.5
        for <linux-crypto@vger.kernel.org>; Thu, 30 Dec 2021 00:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=U/48TNfZ5u7u3obYpRqZY+OGr9VJLLf/2/GpB8YfDNc=;
        b=SHJsffFlnnBgOR07CvIBfPQ1ztcWVKHP1aFDXbtsc9sc2JBM69W8tlcWSw3J6kXI/r
         3/xOHXUQotNWGp0vZuM7x1sW9dxtWBD0jog0Gr+Ws+yRI6f/JUSW6cG2RC6Qhfr7ORIB
         5ceEyjNQtPSkoOocXVdCwKW8+SJDB4pSAx6mnjDs3b7XRko1oe8Zj53DbuMGOIxwzfdW
         LGfbn77SsvhkEWQ/14+uSFPudQRQptUmh9OV4h34saW8Ixu6nDgSqDt7Pr/AwsdTh5pJ
         sw8xAwjt1mwntEjv6cb77EiRBj0SDH8fEU1z2PxTXaxaiCdOg1X7s2Hqe64BTtG343rI
         3tPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=U/48TNfZ5u7u3obYpRqZY+OGr9VJLLf/2/GpB8YfDNc=;
        b=FpDXiyT3JenRcysJrwPo+ytaodNl1PjpE3RudQB1k46bI1XY6kJwBA4vjB0HOS4vpz
         V1lN4TRiuBV7faG6+lUEG9/KAptMbM86W01HfVYXD4X1DFY97p7JW/MWuXo9WqVLoSLq
         3oaDp81AZUJuYQ16KODPJhUFEMZx6uhhk6hcQHJ35FXA0MQsztw4JUTkRAgA77dKhk0q
         MeooseqqcQqIewcewkugzvpYTNzQacpIUYx+9eJMODcL7Grw8KzUM6X/RF4vy41JI5is
         YH+M5nnpN8GFKbxtvNgK6gKwIuit07/LgC3x4Y6NIu7gNJypJcby6lMH+ydObXZZ5i0S
         ymEQ==
X-Gm-Message-State: AOAM530NVPKU3YpHyqx2jqjxRw2pE2IluEY3ZLKe8E2asrmv+HwRwohB
        oXAsGZ1xjfYU7ZCdBgdZymRYzDPV0DNFaHEwPiMMPZJZ
X-Google-Smtp-Source: ABdhPJzJWD/tVvM7GAFr2enWzwKxOBF+YcmFJvdIxLTsCcA3t/MYY+exJT0cbLq5N0y1vLs9cbhUtwR+azS1xPZd940=
X-Received: by 2002:a05:6000:1b03:: with SMTP id f3mr24649642wrz.58.1640852947450;
 Thu, 30 Dec 2021 00:29:07 -0800 (PST)
MIME-Version: 1.0
References: <SY4PR01MB62510D797406741564AD5213EE429@SY4PR01MB6251.ausprd01.prod.outlook.com>
In-Reply-To: <SY4PR01MB62510D797406741564AD5213EE429@SY4PR01MB6251.ausprd01.prod.outlook.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 30 Dec 2021 16:28:54 +0800
Message-ID: <CACXcFmnkoLS+Gr4OH_yquvxDBbb=kDNBH0A40qhitvPsAEyujA@mail.gmail.com>
Subject: Fwd: [Cryptography] This is it, we're all going to die
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a well-known expert posting  on a crypto list.

---------- Forwarded message ---------
From: Peter Gutmann <pgut001@cs.auckland.ac.nz>
Date: Thu, Dec 30, 2021 at 4:00 PM
Subject: [Cryptography] This is it, we're all going to die
To: cryptography@metzdowd.com <cryptography@metzdowd.com>

While searching for something vaguely related, Google turned up this:

  https://www.spinics.net/lists/stable-commits/msg184308.html
  Patch "X.509: Fix crash caused by NULL pointer" has been added to
the 5.10-stable tree

The Linux kernel has X.509 processing inside it.

We're all going to die.

Peter.

_______________________________________________
The cryptography mailing list
cryptography@metzdowd.com
https://www.metzdowd.com/mailman/listinfo/cryptography
