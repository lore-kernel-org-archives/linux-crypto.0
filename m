Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC1DC7619A
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjDLLzw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbjDLLzo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:55:44 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BD77EC4
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:55:43 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id y11-20020a17090a600b00b0024693e96b58so10168136pji.1
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681300543; x=1683892543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JdU41sKVVYSe/xl+xymK9a9yazNGz6ifbujCFlYI9rk=;
        b=R2nBc2dZiZqmMG0xzo/+KKsG+NVLWIvXsmQ0un4e6JxFReluxR+GgJSXiuvt45drMN
         0E8XNsfVcGdlhiBlE75hSiC4M/nko64EWFarYsM1KIkPdYxR4fACekefBlJW3AEmFhzU
         zVlo7K1l7eZM7VqTOhDFBrrCfQNOZ2yBSU0Wf6pYKxOUlg9fRA/cs6q6ExZ4+s3mKu7l
         yTX4BpvdZUIkH+arZuf9xkLt0+Osa8eIWXFWRP2yLi9l3Pigem7pTyNWGVWgLufFtwiI
         v+31Cf4trYh6dfaO2ZijgDJZxaNq9KXKEBqtjqzD2PmWJw60MeDA8Ffh88xgpXfQXivl
         ALKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681300543; x=1683892543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JdU41sKVVYSe/xl+xymK9a9yazNGz6ifbujCFlYI9rk=;
        b=cjFoSEF2B4bJM0K+XYL8a5FmKbmCj6XHk9VBNEAm+6HTtrLP1nTFtXUDYwJ8DBHv2H
         cCmQnuOgDc67JAcVTsYEOpHlqEmXgIxqiZ8+T2KfWpWwG4gTdHhkhAbKQib8eR1wiwML
         zGmuqUj98hcy2yc+zgwgXiBhuCJsm0W41GFhjkDul4FwUUfF70ukH5iEam+hAifpbNRz
         7xcAHKV+IRvk1J92g2mddaD25LHAvMVIl9U5TPkyeDHRsuyfCYBPxeGAYW51OHviPBLB
         DC9WhhVOOlzp8Y8YrtDAq5DjS3LMi07MNcYgsicXcLtNiDMsnmK/3n65cVdkYby/XdzZ
         1nCA==
X-Gm-Message-State: AAQBX9cEnnsTOMCrr2ElhFFsq2IpksVBufuA4Lcwk3dAlrBdYldsD6ZZ
        kgtzaEcIuq9AH+cWWoHzs6/vRg==
X-Google-Smtp-Source: AKy350ZX7QT7vb/UQxp6azYVplp03GhKCjpga4j8tEITnuOzlx0+PbCTd+G8HI7pjwkyzrEYrMLYGw==
X-Received: by 2002:a17:90a:2e03:b0:244:952c:9701 with SMTP id q3-20020a17090a2e0300b00244952c9701mr23042939pjd.7.1681300542744;
        Wed, 12 Apr 2023 04:55:42 -0700 (PDT)
Received: from localhost.localdomain ([124.123.191.81])
        by smtp.gmail.com with ESMTPSA id iq3-20020a17090afb4300b00233b196fe30sm1308948pjb.20.2023.04.12.04.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 04:55:42 -0700 (PDT)
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
To:     bhupesh.sharma@linaro.org
Cc:     agross@kernel.org, andersson@kernel.org, bhupesh.linux@gmail.com,
        devicetree@vger.kernel.org, djakov@kernel.org,
        konrad.dybcio@linaro.org, krzysztof.kozlowski@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, neil.armstrong@linaro.org,
        rfoss@kernel.org, robh+dt@kernel.org,
        vladimir.zapolskiy@linaro.org, lkft-triage@lists.linaro.org,
        anders.roxell@linaro.org,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH v6 00/11] arm64: qcom: Enable Crypto Engine for a few Qualcomm SoCs
Date:   Wed, 12 Apr 2023 17:25:32 +0530
Message-Id: <20230412115532.300516-1-naresh.kamboju@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
References: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


 > This patchset enables Crypto Engine support for Qualcomm SoCs like
 > SM6115, SM8150, SM8250, SM8350 and SM8450.
 > 
 > Note that:
 > - SM8250 crypto engine patch utilizes the work already done by myself and
 >   Vladimir.
 > - SM8350 crypto engine patch utilizes the work already done by Robert.
 > - SM8450 crypto engine patch utilizes the work already done by Neil.
 > 
 > Also this patchset is rebased on linux-next/master.

These patches tested on top of Linux next-20230406.


Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


--
Linaro LKFT
https://lkft.linaro.org


