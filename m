Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A0FC4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0749208B6
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgIYIte (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:49:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:53818 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgIYIte (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 04:49:34 -0400
IronPort-SDR: EJOCmMJ0p0qfhvTDoOJYkVS0aYspBkW0+F9Bh858hWkTfEWk/4n6A0+OGlHAeGZTT6+seZQdyu
 KrCGH0z3ItYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="161552511"
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="161552511"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 01:49:33 -0700
IronPort-SDR: Rc2/064Y9Fjl4jizWRZ+SdkfhtThtKjNQYZKV+mih+gN7pQ5L8jKPyRe7s1D+lFLnb4CyRlI7M
 Y9vePsuS8sVA==
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="487386607"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 01:49:31 -0700
Date:   Fri, 25 Sep 2020 09:49:24 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Liu Shixin <liushixin2@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        qat-linux <qat-linux@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: qat - convert to use DEFINE_SEQ_ATTRIBUTE
 macro
Message-ID: <20200925084924.GA30008@silpixa00400314>
References: <7a1e8142cb4944ee95cea13e7efad23d@irsmsx602.ger.corp.intel.com>
 <20200924050042.GA32206@silpixa00400314>
 <20200925081445.GA6496@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925081445.GA6496@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 25, 2020 at 06:14:45PM +1000, Herbert Xu wrote:
> On Thu, Sep 24, 2020 at 06:00:42AM +0100, Giovanni Cabiddu wrote:
> > On Wed, Sep 16, 2020 at 03:50:17AM +0100, Liu Shixin wrote:
> > > Use DEFINE_SEQ_ATTRIBUTE macro to simplify the code.
> > > 
> > > Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> > 
> > Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> 
> Hi Giovanni:
> 
> Your acks are not making it to patchwork, seemingly because your
> emails have a bogus References header with an Intel message ID
> instead of the original message ID of the email you're replying
> to.
> 
> I've added your acks manually for this patch but please fix your
> emails as I can't guarantee that I'll spot the problem every time.
> 
> Thanks,

Hi Herbert,

Thanks.

I just realized I replied to emails resent from qat-linux therefore the
bogus References header.
I'll make sure I'll be replying to the correct email next time.

Regards,

-- 
Giovanni
