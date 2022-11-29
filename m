Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8DBC4167B
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Nov 2022 08:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiK2IZw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Nov 2022 03:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiK2IZu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2022 03:25:50 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECCA56557
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 00:25:49 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id z18so18706685edb.9
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 00:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rZUenHtKPq2dIPRKUI4YkE7MjW2g3QtOJmpKI+2Qn3o=;
        b=gGK456z2WRLaCXHOwMFdHGvfFgJhaWZsmslL7bufWhOQ0Q3qvX2aDgMOi2ja03RCnm
         NdGvjr2n7dxWMSrxhGxBdIDl2jZOfrD+2k5vRWjBh5RgWepcfx9WRx+rVxCdxMmtSCqd
         RP5hOThgGUF9OdBm1kFhEu9uyjFMq+6Q85Jk+ZycXXoZpEz8zRoxJtLtFqJ8+ncqgmhm
         4wc2jc5c5JUviaUDl6qOKs8yb5XJn9HImWIJkxqXQPGYXgq9hGuxNfpbERnf/C8bffkT
         ML/3rEOdCUgRGrRo5SkoyK/r5egDu0LQAvOSnhyiAZR2pCv3GOE3KrvNcIuwQQNDcWF6
         6mOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZUenHtKPq2dIPRKUI4YkE7MjW2g3QtOJmpKI+2Qn3o=;
        b=RxvjtAIWtQuA2M6I2K7PtEuY6LWOknAcP0SdHt1/9GN5qnLtNYXlbIHOZc3PMAA5jO
         icnsco/wHCbxwQ01mY2Jm98LaA0zK8CyTY3RI4qm7fB4tFHOY2nTk7lSrIBbK4MnZBt5
         zLNSLSU1v98I916Ko2/FAA4LuZ5tU9N3bAcyrgRb/Qv54sx4Tjgv3HKxHdN570BJF9Jl
         valdtE+PmZEXN6iedcLFqVPuXY1kP2gKp5pB84eSmAwNL8uaW8e0Ne5F2swwIuLv2m+q
         IKSR64O1u1r8zWhV4aqc7dOoRXOC54vo0cNvQSHa6dRxzWiqyk1nqt2HN99vlI2y7IIu
         MlPw==
X-Gm-Message-State: ANoB5pmbwRUTGMLC1YJzP1l7XP0Uq18ZzqEYRwLf69ekj84BWiDLroQ3
        YKzL3AQZd5GUYZc0M4tbBKCxxw==
X-Google-Smtp-Source: AA0mqf7oggbm0ZvKv+OkUU5+fbdLpbPP1G+n+KZSETJmKURydZSHzYM/yx9a/+JnxN4LXSIHKdvoZQ==
X-Received: by 2002:a05:6402:2421:b0:461:524f:a8f4 with SMTP id t33-20020a056402242100b00461524fa8f4mr50312403eda.260.1669710347875;
        Tue, 29 Nov 2022 00:25:47 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id u23-20020a056402065700b0046778ce5fdfsm5962890edx.10.2022.11.29.00.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 00:25:47 -0800 (PST)
Date:   Tue, 29 Nov 2022 09:25:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        linux-crypto@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>
Subject: Re: [PATCH net-next v5 2/4] net: devlink: remove
 devlink_info_driver_name_put()
Message-ID: <Y4XCCl6F+N2w+ngn@nanopsycho>
References: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
 <20221129000550.3833570-3-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129000550.3833570-3-mailhol.vincent@wanadoo.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tue, Nov 29, 2022 at 01:05:48AM CET, mailhol.vincent@wanadoo.fr wrote:
>Now that the core sets the driver name attribute, drivers are not
>supposed to call devlink_info_driver_name_put() anymore. Remove it.
>
>Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

I agree with Jacob that this could be easily squashed to the previous
patch. One way or another:

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
