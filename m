Return-Path: <SRS0=cgyY=YY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003F5CA9ECB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 21:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE2262086D
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 21:45:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T2CkxNkY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfJaVpH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Oct 2019 17:45:07 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:37023 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbfJaVpH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Oct 2019 17:45:07 -0400
Received: by mail-qt1-f173.google.com with SMTP id g50so10581645qtb.4
        for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2019 14:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=content-transfer-encoding:from:mime-version:date:subject:message-id
         :to;
        bh=r030ck3KhUPSr6Tc9VX/TPH3wHXcPR+6aaIR9/HlVvo=;
        b=T2CkxNkYiAagRZhJ+2qyzWi0K+3zUr9uzrjZ8y7hT44Dra4rUbXhr3i1mCibfTwLLM
         7q5c6Qt5DnvCz24saLKwzuv+xqOlKMnOWt4RMO9kTsbG+dwYmu8ENH8AYWgURQNc++55
         hcI+o+fWRNRqUW5XxdsrwEADZUuPyeO6/jiHDczfbfhHz/aqMPnCRRDfowcCC+H/DiiF
         aREypxpXQ96A6xsfpCYYdGbVCcdkAeWnkzk4xUHuiSQt18DB/YhnX8KDoSksF7Xjq17L
         LKJIpTdSSkmdv8krxzNIjUkCxw+OspLhO101Gg+eday8oo9P/cyv+AEaUyAZvNACfSDH
         HGOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version:date
         :subject:message-id:to;
        bh=r030ck3KhUPSr6Tc9VX/TPH3wHXcPR+6aaIR9/HlVvo=;
        b=RK3O4iqIEoVkJRP7RI4TZB0tzBUkmZxrQrviYOOSlTJ4Tptq5Ilk8/zHHOJehl1hzu
         cE1tU0KRHv3GKB5r87wFAQAts4F1U7KYbP+VVXLSQ5jvwAO/NnF1B0eQlg/kgeFVvsHo
         t4AhnmPB9ZuNidl/p729LOE770K9stFxuF/YQI14N4LEXF2N1igh48CjR6zQT01ALjcL
         iIMNOB+G/jocF455DCLoaCY1vIPqpoQOpgXdnntAscmxClAudbaztxhHixWO1AnA8gor
         u3d4FqwffBkQVCfiftGkIv2EhxuAo+cv6Ft34/Q+miTfpHCiDcAWuXSjt2uSgi7dYBlx
         JlDg==
X-Gm-Message-State: APjAAAV/zCVCCmBDcsBmkpXyxmx/GS5bfQ4dbECBsz3kiGUUjIGDuzfi
        wv4yKr4jVOB0VcdDTMNY0EU3eN32
X-Google-Smtp-Source: APXvYqzD4wBkKSqswHaFGDXRRzPDJFcHBV2Nq+yI/JDYcQ2UJd227z3nUKI5ddlmzHfdMYU7bJDeIg==
X-Received: by 2002:ac8:545:: with SMTP id c5mr1929870qth.375.1572558306236;
        Thu, 31 Oct 2019 14:45:06 -0700 (PDT)
Received: from [192.168.1.165] (pool-74-96-161-17.washdc.fios.verizon.net. [74.96.161.17])
        by smtp.gmail.com with ESMTPSA id q17sm3888669qtq.58.2019.10.31.14.45.05
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 14:45:05 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Connell Paxton <connell.paxton.crypto@gmail.com>
Mime-Version: 1.0 (1.0)
Date:   Thu, 31 Oct 2019 17:45:04 -0400
Subject: Any assignments?
Message-Id: <2CE17BA9-B2DC-449C-A703-779A391AF063@gmail.com>
To:     linux-crypto@vger.kernel.org
X-Mailer: iPhone Mail (17A878)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I am a recent graduate looking to contribute, I would like to know what I co=
uld do to best help. (I have implemented  cryptographic algorithms before in=
 both c and assembly(x64, 6502, Arm and PowerPC))

Thanks
-Connell=
