Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656D1C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 21:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 263312081B
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 21:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392805AbfBNVI4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 16:08:56 -0500
Received: from mail-it1-f173.google.com ([209.85.166.173]:40857 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390983AbfBNVI4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 16:08:56 -0500
Received: by mail-it1-f173.google.com with SMTP id i2so18021153ite.5
        for <linux-crypto@vger.kernel.org>; Thu, 14 Feb 2019 13:08:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=AuEDKfuBp1+raRwtt0FMOwcXttmIIcD2ACNX9+rQuYY=;
        b=QQVCjlW5/EngNDY6f08WjUz6BPR8FEvHNOXnsZgcleF13fYhbuRwidBxgGLaQf5R2M
         1tkJakGs9OAEmCfPRp9tWt7r96Jz7GGMVhoBrCUIj4S8Eq/HMYodtIw01lzfELdI+DjK
         S5yxdK4HZGhf5pXMuWG6qjciMZoSK+93jACzqqA262nCdFJCS2kP1cp/4D/mb7G9nnwA
         CRdFAy2L4RCy7mR0LoP0UsQJanF0qOFDSrNghNjs1ekmHqZy1gY/Nj0wvME4w/R84fs5
         /eTPquV0S1daUF3LZQ1Y7E+Dc4ohGFqyTRip/LLMcbSEuzUTYcK6iw4wfuvlB8n7DNYA
         LhdQ==
X-Gm-Message-State: AHQUAuZmHGBah3dundtsw2lVxfZwyQiimXQ48KppcFb+wH+feKGPhwNy
        fs7GOdaxZrESOH1HqwOdHXN1Xlh30W+l6aiG3we8tw==
X-Google-Smtp-Source: AHgI3IaRTWWDkqqwo6D4hQKiVc+eBmixfKSc7MVyb61UO1WjYm++VFM5xJa5telrWU1zWZn4x5H/D7XsYHGhl0Zr8HM=
X-Received: by 2002:a24:6985:: with SMTP id e127mr3306678itc.28.1550178535442;
 Thu, 14 Feb 2019 13:08:55 -0800 (PST)
MIME-Version: 1.0
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Thu, 14 Feb 2019 15:08:44 -0600
Message-ID: <CAOASepP1+ZzGfy62jO5S4ZtpYzPJKqVZntTPp8Xn-zK8Kd2k8A@mail.gmail.com>
Subject: SEV Command Privilege Separation
To:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I've been working on wrapping various SEV kernel APIs for userspace
consumption. There does not appear to be any privilege separation for
these commands: you can run them all or none of them. This is less
than ideal because it means that a compromise of the code which
launches VMs could make permanent changes to the SEV certificate
chain.

These commands are required to attest the VM environment:
  SEV_PDH_CERT_EXPORT
  SEV_PLATFORM_STATUS
  SEV_GET_ID

These commands manage the SEV certificate chain:
  SEV_PEK_CERT_IMPORT
  SEV_FACTORY_RESET
  SEV_PEK_GEN
  SEV_PEK_CSR
  SEV_PDH_GEN

I would expect the first group of commands to be able to be called by
whatever actor launches VMs. The latter group of commands should be
able to be called by whatever actor manages the SEV environment.

I don't have strong opinions on how this privilege separation should
happen. It might be sufficient to distinguish these based on the mode
of the open() call. This could then be managed with filesystem
permissions. But I'm open to other ideas.
