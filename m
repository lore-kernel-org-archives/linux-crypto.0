Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22724CA9EBC
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 09:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F225E21929
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 09:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393434AbfJYJum (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 05:50:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:40297 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390193AbfJYJum (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 05:50:42 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 02:50:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="202566063"
Received: from irvmail001.ir.intel.com ([163.33.26.43])
  by orsmga006.jf.intel.com with ESMTP; 25 Oct 2019 02:50:39 -0700
Received: from sivswdev08.ir.intel.com (sivswdev08.ir.intel.com [10.237.217.47])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id x9P9ocwp003574;
        Fri, 25 Oct 2019 10:50:38 +0100
Received: from sivswdev08.ir.intel.com (localhost [127.0.0.1])
        by sivswdev08.ir.intel.com with ESMTP id x9P9ocxT020005;
        Fri, 25 Oct 2019 10:50:38 +0100
Received: (from gcabiddu@localhost)
        by sivswdev08.ir.intel.com with LOCAL id x9P9obDT019995;
        Fri, 25 Oct 2019 10:50:37 +0100
Date:   Fri, 25 Oct 2019 10:50:37 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Yunfeng Ye <yeyunfeng@huawei.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        qat-linux <qat-linux@intel.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "linfeilong@huawei.com" <linfeilong@huawei.com>
Subject: Re: [PATCH] crypto: qat - remove redundant condition
 accel_dev->is_vf
Message-ID: <20191025095037.GA19336@sivswdev08.ir.intel.com>
References: <78b1532c-f8bf-48e4-d0a7-30ea0137d408@huawei.com>
 <CAKv+Gu_MVe8mEeC-fVVbbLfUv-rEEk5_eoxfHjTCMgAFmSHrJw@mail.gmail.com>
 <77832b26242f4987877d6122ba14a0d0@irsmsx101.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77832b26242f4987877d6122ba14a0d0@irsmsx101.ger.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 25, 2019 at 10:45:31AM +0100, Yunfeng Ye wrote:
> On 2019/10/25 17:33, Ard Biesheuvel wrote:
> > On Fri, 25 Oct 2019 at 09:24, Yunfeng Ye <yeyunfeng@huawei.com> wrote:
> >>
> >> Warning is found by the code analysis tool:
> >>   "Redundant condition: accel_dev->is_vf"
> >>
> >> So remove the redundant condition accel_dev->is_vf.
> >>
> >> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
> >> ---
> >>  drivers/crypto/qat/qat_common/adf_dev_mgr.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
> >> index 2d06409bd3c4..b54b8850fe20 100644
> >> --- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
> >> +++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
> >> @@ -196,7 +196,7 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
> >>         atomic_set(&accel_dev->ref_count, 0);
> >>
> >>         /* PF on host or VF on guest */
> >> -       if (!accel_dev->is_vf || (accel_dev->is_vf && !pf)) {
> >> +       if (!accel_dev->is_vf || !pf) {
> > 
> > I disagree with this change. There is no bug here, and the way the
> > condition is formulated self-documents the code, i.e.,
> > 
> > IF NOT is_vf
> > OR (is_vf BUT NOT pf)
> > 
> > Using an automated tool to reduce every boolean expression to its
> > minimal representation doesn't seem that useful to me, since the
> > compiler is perfectly capable of doing that when generating the object
> > code.
> > 
> ok, thanks, this modify just fix warning, and make code simple.
This change simplifies the code but it makes it less readable.
I'd prefer to leave it as it was.

Regards,

-- 
Giovanni
