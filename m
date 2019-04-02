Return-Path: <SRS0=5Ot1=SE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA665C4360F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Apr 2019 02:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC1ED2070D
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Apr 2019 02:51:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bTqR6OtN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfDBCvP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 22:51:15 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:56295 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfDBCvP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 22:51:15 -0400
Received: by mail-it1-f193.google.com with SMTP id z126so2637979itd.5;
        Mon, 01 Apr 2019 19:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qzcc4/2F2anEBs0yxcfDa0SSDpIJUqbgduaUlMcApaA=;
        b=bTqR6OtN2mOSNfb5+HBdYwCKeL0xq0V6F3o9nchI9U7ZxmMyh1pGmdGG7BkYPZCywH
         j5MWGwrSZ5RmieURRbKklpZAd42B7F8w8/nRoJxUIGsaNn5xEI84TBJgoPAfX4R1iYVx
         gCZFgqcPmdF4Ay05FmekZ5fyf08VBOSYIO90L3RgAw7+emCLLMDzXvUZWEAiUAbAuoFQ
         c16O5THjgmbBbx9drTgXsHABVEIPGkrPOroWCJ4Qq4sMhFE6rnm3wvFX0rBT7UVKzrRd
         LvNnV69rGFvRZvPnyfbbP9K+JS1kcvFsJi1pEwrj44f2TSbk9ALfFSa1LCy2X/hBGeZX
         B3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qzcc4/2F2anEBs0yxcfDa0SSDpIJUqbgduaUlMcApaA=;
        b=ZtVrtX1GrvCX+l634SjZgyg5oiBsFL/BoC/0fUUJxwHHL7gAIB91UB6XLB9XcTqDbu
         OqbXg0pgkVl7U4z/bw+ygKbTYFnCGlfxjVUBoFlUkgZuXAOpT9E1vp2yqM5m71sNzbbj
         GH+3BnqgY5N7BIaE5x/0Zt/ixewgKcadjtptzEHNbbCWjTdDqG1sHsIw76kY6riKj4Ux
         csNEljdp0Se1dSDdWP2/vtKTBT82utEYISjNqrUeafuFE8jTQtpMCAGUSDda5FfrI+LR
         wWQRdv9m1SgaEdI6bDGfs5l7wpVl25qEKqx4NkP8Hax4qmcV8KE+KcfA+9fXpBsC0cQJ
         m2Pg==
X-Gm-Message-State: APjAAAUkB1Mm+OTqPWfjv13mHuqCuFKKRDKtbJPXNeMjdRX73g+8OQxL
        m+jXd1JWdf1usl/up8C88Qel/JQka88=
X-Google-Smtp-Source: APXvYqyy4JxLbEVaNCVlbec2CoT/m2KHC4KW/XadAZ3gTDH2paZ8NcB4b9jmYwFVFGUm8Hi7bHXBjA==
X-Received: by 2002:a24:3ac8:: with SMTP id m191mr2218104itm.74.1554173473916;
        Mon, 01 Apr 2019 19:51:13 -0700 (PDT)
Received: from ubu (2600-6c48-437f-c81d-984d-b4e8-0abe-7e26.dhcp6.chtrptr.net. [2600:6c48:437f:c81d:984d:b4e8:abe:7e26])
        by smtp.gmail.com with ESMTPSA id o11sm6435986itb.33.2019.04.01.19.51.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Apr 2019 19:51:13 -0700 (PDT)
Date:   Mon, 1 Apr 2019 22:51:10 -0400
From:   Kimberly Brown <kimbrownkd@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] kobject: Add default group support to kobj_type and
 replace subsystem uses
Message-ID: <cover.1554151487.git.kimbrownkd@gmail.com>
References: <20190322201440.GA30814@ubu-Virtual-Machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322201440.GA30814@ubu-Virtual-Machine>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset adds support for default attribute groups to kobj_type.
Also, the uses of kobj_type's default_attrs field are replaced with
default_groups in the following subsystems:
 - samples
 - block
 - net
 - irq
 - padata
 - cpufreq
 - livepatch

The subsystem maintainers and lists will be copied on the subsystem
patches.

The uses of kobj_type's default_attrs field in the other subsystems will
be replaced in future patchsets.

Changes in v2:
 - Patch 1 is not changed.
 - Patches 2-8 are new.


Kimberly Brown (8):
  kobject: Add support for default attribute groups to kobj_type
  samples/kobject: Replace foo_ktype's default_attrs field with groups
  block: Replace all ktype default_attrs with groups
  net-sysfs: Replace ktype default_attrs field with groups
  irqdesc: Replace irq_kobj_type's default_attrs field with groups
  padata: Replace padata_attr_type default_attrs field with groups
  cpufreq: schedutil: Replace default_attrs field with groups
  livepatch: Replace klp_ktype_patch's default_attrs with groups

 block/blk-integrity.c            |  3 ++-
 block/blk-mq-sysfs.c             |  8 ++------
 block/blk-sysfs.c                |  3 ++-
 include/linux/kobject.h          |  3 ++-
 kernel/irq/irqdesc.c             |  3 ++-
 kernel/livepatch/core.c          |  3 ++-
 kernel/padata.c                  |  3 ++-
 kernel/sched/cpufreq_schedutil.c |  5 +++--
 lib/kobject.c                    | 14 ++++++++++++++
 net/core/net-sysfs.c             |  6 ++++--
 samples/kobject/kset-example.c   |  3 ++-
 11 files changed, 37 insertions(+), 17 deletions(-)

-- 
2.17.1

