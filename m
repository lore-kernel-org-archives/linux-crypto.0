Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7339FC678D5
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Mar 2023 15:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjCHPLf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Mar 2023 10:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbjCHPLV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Mar 2023 10:11:21 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F9FC488E
        for <linux-crypto@vger.kernel.org>; Wed,  8 Mar 2023 07:11:03 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id l7-20020a05600c4f0700b003e79fa98ce1so1358837wmq.2
        for <linux-crypto@vger.kernel.org>; Wed, 08 Mar 2023 07:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678288262;
        h=content-transfer-encoding:subject:to:from:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CpL8pfFHgYoyZ2Mo0Ft2NbfXGys8eh5PDeoz/LLjCnE=;
        b=JhYAaqTyvQHQi0wMsHLyeiep4ZqV3bb6xfSqTOFAqA0u/TXXVOGBoNfBH3j/Sd9S69
         dAwMF4AeKVnVV4MdAGSTcvaij+1wHCH/K8sVmUslIapuy3ZmuJyz45YtuzphTcZzKF6m
         FhRVHqaDjcd3aseiqZ3gHFuz/edoOugnETRLOMoGNInMzN1f4Vw5kmKiP1EPe+tW3233
         Pyo5Y7qFmJUjvXcVdXw0mjq8JTbx4LceNYDLfzov4TahLsKpTRUEOO1k0cWrcbg4UPXy
         nvaW8xR/XCNaZXHmDbCrKH+oPZVwO3gd0c9uhKo71U7MeMVwjzNMb/L5ec2HYJS697cs
         fEdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678288262;
        h=content-transfer-encoding:subject:to:from:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CpL8pfFHgYoyZ2Mo0Ft2NbfXGys8eh5PDeoz/LLjCnE=;
        b=lZyrPJM3I/tfrsD14v/zNMrKKG8iEzHvNZvgBFAbUSWnOUAxwxSRT9eJ/QSS2AC4Ip
         OGghSwCExnvBNcOuNal0eG/w86Km538neiQT7l9h+Ppp796ip+9AHC6j+0mLSJ9cwTRv
         6700Ev9TsmT1KUSE2nehbbV+lrcrdJI9eV22JVtCjVwjZ8ihIbpkmz9S63jW6ZGNLYCf
         mZDd2WdT/X7PpctbjhmHKYPDa3q3ynbXEhWZpLC2gZe72hl9Py42CNTs8qwbShf7SJA/
         ATqMDYmQ7o20B3alDOaunasFLDgNNDVmelyKgmF8tTZmVueOfzbBEm47zJIESR54JVax
         rvqw==
X-Gm-Message-State: AO0yUKXBbKViDc3whdeRX3Z9MJHXEjkvgutvME6ejLE1417B/D6UjHcq
        QnqJT7oPYAwkvgP0N1MN13OqyDJGxqg=
X-Google-Smtp-Source: AK7set+1Ca713dJFk1tk/Udz1OLiuqlZ4udeBG+P4V+SYewGpZL/okTJwnc4mPeIqS2mz8fscTraeg==
X-Received: by 2002:a05:600c:4590:b0:3e2:2467:d3f5 with SMTP id r16-20020a05600c459000b003e22467d3f5mr15802713wmo.25.1678288262042;
        Wed, 08 Mar 2023 07:11:02 -0800 (PST)
Received: from DESKTOP-8VK398V ([125.62.90.127])
        by smtp.gmail.com with ESMTPSA id w7-20020a05600c474700b003e204fdb160sm21413872wmo.3.2023.03.08.07.11.01
        for <linux-crypto@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 08 Mar 2023 07:11:01 -0800 (PST)
Message-ID: <6408a585.050a0220.d61ce.2dcd@mx.google.com>
Date:   Wed, 08 Mar 2023 07:11:01 -0800 (PST)
X-Google-Original-Date: 8 Mar 2023 20:11:01 +0500
MIME-Version: 1.0
From:   terenceblake6795@gmail.com
To:     linux-crypto@vger.kernel.org
Subject: Bid Estimate
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,=0D=0A=0D=0AWe provide accurate material take-offs and cost=
 estimates at low cost and with fast turnaround. Our team of prof=
essionals has been providing these services to General Contractor=
s, Subs (Painting, Electrical, Plumbing, Roofing, Drywall, Tile a=
nd Framing etc.). We offer both Residential and Commercial Estima=
tes and we cover every trade that you wish to bid, whether you wo=
rk with CSI Divisions or your unique classification. We use the l=
atest estimating software backed up by professionals with over a =
decade of experience.=0D=0A=0D=0AWe are giving almost 25% Discoun=
t on the first estimate.=0D=0A=0D=0APlease send us the plans or l=
inks to any FTP site so that we can review the plans and submit y=
ou a very economical quote.=0D=0A=0D=0ABest Regards.=0D=0ATerence=
 Blake=0D=0AMarketing Manager=0D=0ACrown Estimation, LLC=0D=0A

