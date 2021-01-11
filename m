Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93ABCC433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 11:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BE1D2242A
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 11:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbhAKLEi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 06:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727747AbhAKLEi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 06:04:38 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23214C061794;
        Mon, 11 Jan 2021 03:03:58 -0800 (PST)
Received: from zn.tnic (p200300ec2f088f0076781dde3322831e.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:8f00:7678:1dde:3322:831e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9F9771EC0304;
        Mon, 11 Jan 2021 12:03:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610363036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=UakkcWenq1z7BJChiF5DJB9KugQPmWGiKzxCrVkRxtM=;
        b=d8CAAgxEWT3neFXZIU/nOYd80kmOKIeE1hd8hoRXg7PtaNUoePEahwDHE/xuYHwDyAYisf
        SJtieBaOHOTS9tpJGtcn16FFyv7LFcKSKhzkdZWs/h0nKkW+jJ2rUy8SdenxnVJ5Db0bF4
        RtuqRjfIIIP3xh9p2La10ak/MTTZBOY=
Date:   Mon, 11 Jan 2021 12:03:51 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, tony.luck@intel.com, dave.hansen@intel.com,
        seanjc@google.com, fenghua.yu@intel.com, thomas.lendacky@amd.com,
        kyung.min.park@intel.com, kim.phillips@amd.com,
        mgross@linux.intel.com, peterz@infradead.org,
        krish.sadhukhan@oracle.com, liam.merwick@oracle.com,
        mlevitsk@redhat.com, reinette.chatre@intel.com, babu.moger@amd.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        TimGuo-oc@zhaoxin.com, CooperYan@zhaoxin.com,
        QiyuanWang@zhaoxin.com, HerryYang@zhaoxin.com,
        CobeChen@zhaoxin.com, SilviaZhao@zhaoxin.com
Subject: Re: [PATCH v1 1/3] x86/cpufeatures: Add low performance CRC32C
 instruction CPU feature
Message-ID: <20210111110351.GC25645@zn.tnic>
References: <1610000348-17316-1-git-send-email-TonyWWang-oc@zhaoxin.com>
 <1610000348-17316-2-git-send-email-TonyWWang-oc@zhaoxin.com>
 <20210107063750.GA14697@zn.tnic>
 <871e93d3-701e-86cd-6454-19fbb083d0c5@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <871e93d3-701e-86cd-6454-19fbb083d0c5@zhaoxin.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 11, 2021 at 06:51:59PM +0800, Tony W Wang-oc wrote:
> This issue will be enhanced by hardware and patch submit will be pending.

I have no clue what that has to do with your current patch... you might
need to explain more verbosely.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
