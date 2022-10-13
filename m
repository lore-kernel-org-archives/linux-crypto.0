Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3A9C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Oct 2022 18:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJMSze (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Oct 2022 14:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiJMSzL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2022 14:55:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3913342AE8
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 11:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665687069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8pkajZPOZxDkGw1RxC1xTCn1Bly76di5EaF0TtIpiUE=;
        b=FT/U4atbl2SjlTNnzGd66W/q+Lri2Kv+zprL4BB0cOVC+BcROzCSVjjSc5LK0WeB/CHDpE
        6cOVo89l8V7Fisvy9KJ06GvTVbGd42emfUlmrpkQHv6EgO91juqXPGCGqbdJjS8tI9kl2I
        mPYNYq9Q+62mCItEqbL4VZDdeJVzCVU=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-350-PS79rkjDPQ6JG5fxCyt4Og-1; Thu, 13 Oct 2022 14:40:50 -0400
X-MC-Unique: PS79rkjDPQ6JG5fxCyt4Og-1
Received: by mail-ot1-f71.google.com with SMTP id q6-20020a9d6306000000b0065757df1611so357488otk.19
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 11:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8pkajZPOZxDkGw1RxC1xTCn1Bly76di5EaF0TtIpiUE=;
        b=Usq4XwUTecft+Tn8VxPj+AuxpbUafA/LiZCcwzAowvGBDkTYyRtbfFmUJN4tgDtGcl
         e8y16is+eVTulF5euFzX5vuGnzQ1uaD1SJBDGdDZ0UeXLnlm3UXshQUdIB+OzCZXwxrN
         654caBdInI74eHY0KA4U2BmP/1uk1f7x5emvlWA02h+xTrcCd4pjYaCyAb+jTvXOjIzM
         zks/sUoZuxFvS3L79guPHKBcq9Zbg0Zb+j+q61Z0KzhuwwMTU54cV35ptDxaOfy6Yla/
         rUm41Xq7uTBEflSuCRHicPPavSnMPE75z1jbuZ1pEg+g0VF/RH0sEdgx5dU1+h/B/PeD
         uenw==
X-Gm-Message-State: ACrzQf1orb1jOEy7yhn0d9J5X4XSE+cdRUYtCjRWUUl4dY45jdISEjtZ
        nTJmmB78rg1OLJFTq74YfvOd6LgdpaeXp+0q+at0b6EUQ/pjLGJXN3RlDHpxiJJ3FboySUKCemE
        zDHTLR4eO+jJjXGRtJeV+i99V
X-Received: by 2002:a05:6830:2647:b0:659:edd8:3fcd with SMTP id f7-20020a056830264700b00659edd83fcdmr681881otu.344.1665686449486;
        Thu, 13 Oct 2022 11:40:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5zsqe12qXgtGqOG3X4aAkxg5HN1AkA2/2fmrv6WsfdypDLxNxz0oYk6/aTlQR85OUwZLjPpA==
X-Received: by 2002:a05:6830:2647:b0:659:edd8:3fcd with SMTP id f7-20020a056830264700b00659edd83fcdmr681866otu.344.1665686449258;
        Thu, 13 Oct 2022 11:40:49 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:a801:9473:d360:c737:7c9c:d52b])
        by smtp.gmail.com with ESMTPSA id v13-20020a05683024ad00b006618ad77a63sm244521ots.74.2022.10.13.11.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 11:40:48 -0700 (PDT)
From:   Leonardo Bras <leobras@redhat.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leonardo Bras <leobras@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 0/4] CPU isolation improvements
Date:   Thu, 13 Oct 2022 15:40:25 -0300
Message-Id: <20221013184028.129486-1-leobras@redhat.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Patch 1 removes some noise from isolation.c

Patch 2 adds some information about the housekeeping flags and a short
description on what to expect from the HK functions. I would really like 
some feedback on this one, since I got all that from the flags usage, and 
maybe I am misreading stuff.

In patch 3, I am suggesting making isolcpus have both the _DOMAIN flag and 
the _WQ flag, so the _DOMAIN flag is not responsible for isolating cpus on 
workqueue operations anymore. This will avoid AND'ing both those bitmaps 
every time we need to check for Workqueue isolation, simplifying code and 
avoiding cpumask allocation in most cases. 

Maybe I am missing something in this move, so please provide feedback.

In patch 4 I use the results from patch 3 and I disallow pcrypt to schedule 
work in cpus that are not enabled for workqueue housekeeping, meaning there 
will be less work done in those isolated cpus.

Best regards,
Leo

Leonardo Bras (4):
  sched/isolation: Fix style issues reported by checkpatch
  sched/isolation: Improve documentation
  sched/isolation: Add HK_TYPE_WQ to isolcpus=domain
  crypto/pcrypt: Do not use isolated CPUs for callback

 crypto/pcrypt.c                 |  9 +++++---
 drivers/pci/pci-driver.c        | 13 +----------
 include/linux/sched/isolation.h | 38 ++++++++++++++++++++-------------
 kernel/sched/isolation.c        |  4 ++--
 kernel/workqueue.c              |  1 -
 net/core/net-sysfs.c            |  1 -
 6 files changed, 32 insertions(+), 34 deletions(-)

-- 
2.38.0

