Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7A0C4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 16:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8ADC2133F
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 16:16:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PFZR2AQw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388001AbfJNQQy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 12:16:54 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:43351 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387548AbfJNQQy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 12:16:54 -0400
Received: by mail-wr1-f51.google.com with SMTP id j18so20413794wrq.10
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 09:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mfy391OkCgKorVuTp3Zz3reemWsXeISYwrwbDVYSKs8=;
        b=PFZR2AQw08fG2ZO9qVCmLyhPvpMjU7vcjM9dMRrGo2K2oOR+wrFlib4j9Wt2CL2zGr
         vgGzoCLZ2U5Vjsg9RBwWP79XWzFIfiNNN6Ww+JhsUTS9Mef2Crrz2BlyF8meqqVP9Tej
         wMRGNUzyXqbGGsPVynt2CSp6y2STkr8sO0XMhbBeRCcZ3k5COnuJa3/UbbahTpoZS0QF
         So45R+4QxaHCHKnm28fy6c8638+rzzFDvXcLNWeO4CFKWE1S8wvyCxu16RvQE2oc0x+X
         MBdyGZ7NU4KHnTKCw2WIs5tn436e+j4ZTRCUMjs0nfFPC1mzJqHDcE/26b8XV3yDUfjp
         SsGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mfy391OkCgKorVuTp3Zz3reemWsXeISYwrwbDVYSKs8=;
        b=Ujn0slVZcDLMjMqa5aCUVZWb1ZWswZ5bMkoFdDnYFApcVn9fP5LMkBC1IjgrtblTwq
         1aRpkBvjJhNPydoLuhZUU2J5Z4yPTr5J7Mhet088RfJw7CCoDjf/Qa6GthzYXvIn1cBz
         k8NPJeQPO2m4Jt+k7B4Ed75nzA2H7/YfnP+CHk5mXnjTXpXXWzqofl7jutNee59pvXet
         7dy1F3ODWDLc/twYtyA+QzlfrWnpsjIeIE+E3z9h0eJw5VxXg2Xa82uG7xndMkUR8xZT
         fBCWlYKrzlSTDpvZ2hOKQ+K0yHjcsVBd38BhLFvTmtsLLZeXpJO1+UTOzXqE0QUzg8Kg
         744A==
X-Gm-Message-State: APjAAAWnQhDo/ASPzZqxAohNYfAHaUKdqf1XYRub8kjfyPpozL3EkKd2
        MyQGzNnG/9g3HnIG5wpv4bYR3L7XFSU5Ug==
X-Google-Smtp-Source: APXvYqzLJMb7WcIOx12Voq3tcZhfIqXUZM5i+qmP+9nd4M87CKsR+XCYCdDw/2xc49+x+GdEFSJS3A==
X-Received: by 2002:a5d:43c2:: with SMTP id v2mr21145585wrr.153.1571069810513;
        Mon, 14 Oct 2019 09:16:50 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-23-27.w90-88.abo.wanadoo.fr. [90.88.143.27])
        by smtp.gmail.com with ESMTPSA id a14sm17308655wmm.44.2019.10.14.09.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 09:16:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v2 0/2] crypto: aegis128 SIMD improvements
Date:   Mon, 14 Oct 2019 18:16:43 +0200
Message-Id: <20191014161645.1961-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Refactor the aegis128 code to get rid of indirect calls, and implement
SIMD versions of the init() and final() hooks. This results in a ~2x
speedup on ARM Cortex-A57 for ~1500 byte inputs.

Changes since v1:
- fix missing Sbox loads for plain SIMD on GCC
- fix endianness issue in final_simd() routine

Cc: Ondrej Mosnacek <omosnace@redhat.com>

Ard Biesheuvel (2):
  crypto: aegis128 - avoid function pointers for parameterization
  crypto: aegis128 - duplicate init() and final() hooks in SIMD code

 crypto/aegis128-core.c       | 125 ++++++++++----------
 crypto/aegis128-neon-inner.c |  50 ++++++++
 crypto/aegis128-neon.c       |  21 ++++
 3 files changed, 134 insertions(+), 62 deletions(-)

-- 
2.20.1

