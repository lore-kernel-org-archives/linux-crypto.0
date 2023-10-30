Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CB3C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Oct 2023 09:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbjJ3JD6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Oct 2023 05:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbjJ3JDu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2023 05:03:50 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EE411D
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 02:03:43 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2c503da4fd6so61400381fa.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 02:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698656621; x=1699261421; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ry5cBR1G8n3E9F85z2DDrKDVnd4RRN37X7+T4meK1xA=;
        b=ENhynPEjakSj/dDzthqkrphwjqLpj4202bwwnOdPb9CsCLgcQcJfSHeQa4f6b71t44
         rgO5X4LaVdWNHgVQMbm4wuaRI81hPlMl193sj+TdYmiLdMO7uvqDPvQKUKiSykYMDwi+
         9LvvZz4NY//gb72HtGvaAlqMeGobWHoYKpSFgrPPNPFPW9LMmSJHhrsKg7BlFNnLb7bj
         Y6v6NhhFXoCm7A+c1HnuTjEPgC8afa226A2BRh7qFyd+R1GIKaVhh0auc590F37TBasb
         3LnviI98seuYG+FDwESzDnVcJ8Zq2L3EyIyaY7nVHWnfhr7Z1onj1NWauYWdF3vdXxp6
         3bjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698656621; x=1699261421;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ry5cBR1G8n3E9F85z2DDrKDVnd4RRN37X7+T4meK1xA=;
        b=IOiz255KxBw7ob+MAGDN8mMG+9Xui/5fSlp979mI1OoSwMzGaBLK2HXLXq1WcKrvMH
         h169alqrT/YC1WCo4BJcLHPJul1BZFKbZWbacA1kUwSLTvrAvYv/sNpYALqipt4S4nuV
         QaVOdyNSkryOc7D6M3QpsRTcNcOs5L+RfDK26lDGPeGjF63206e33eht8Qjisna/LA0l
         d4THYh9Zt9bsQ5Ponm7e2RfiyUIGO7OvjfD9NPbX2qAKucoZllvGxHm1VKyfnOHAxFTU
         BfVo/k8CccR12rgqQsMvqhkzSOTpmeSmZrBpx1w42Nbkf8MfJPO06demmI/UXwfwfWwF
         RbHw==
X-Gm-Message-State: AOJu0YykRmDlxRb+iZugpL054xrKIs6kUhcPcFIt0haJ+256tWVYyzW1
        P1Z8Vn5wO9V19zxPnGgXG31Q4zoijAxFLme6YHM=
X-Google-Smtp-Source: AGHT+IFiyciaYBzcYjGouPyLn0OlG1awct9t4m5YLV3IAGUW0NUgM3CbaRP4AgXWMrEWmpWmed9jCA==
X-Received: by 2002:a05:651c:c9b:b0:2c0:7d6:570a with SMTP id bz27-20020a05651c0c9b00b002c007d6570amr7640073ljb.33.1698656621305;
        Mon, 30 Oct 2023 02:03:41 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id n13-20020a05600c500d00b0040772934b12sm12051022wmr.7.2023.10.30.02.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 02:03:41 -0700 (PDT)
Date:   Mon, 30 Oct 2023 12:03:38 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     tianjia.zhang@linux.alibaba.com
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] lib/mpi: Extend the MPI library
Message-ID: <da288365-f972-479d-91bf-ceef411abdb9@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Tianjia Zhang,

The patch a8ea8bdd9df9: "lib/mpi: Extend the MPI library" from Sep
21, 2020 (linux-next), leads to the following Smatch static checker
warning:

	lib/crypto/mpi/mpi-div.c:46 mpi_fdiv_q()
	error: potential null dereference 'tmp'.  (mpi_alloc returns null)

lib/crypto/mpi/mpi-div.c
    43 void mpi_fdiv_q(MPI quot, MPI dividend, MPI divisor)
    44 {
    45         MPI tmp = mpi_alloc(mpi_get_nlimbs(quot));
                   ^^^^^^^^^^^^^^^
Check for failure?

--> 46         mpi_fdiv_qr(quot, tmp, dividend, divisor);
    47         mpi_free(tmp);
    48 }

regards,
dan carpenter
