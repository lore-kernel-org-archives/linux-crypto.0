Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB465C76186
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 21:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BD902253D
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 21:03:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kJ8lRTX8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389245AbfGWVDi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 17:03:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55810 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729084AbfGWVDi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 17:03:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MAiAHdI8iqd+O1xZOBVxWbAPjMbgMmfQoqtQMb7/9dY=; b=kJ8lRTX8AB9F+NMYgfnZETBZt
        +IMESiEAf2nmfF16xStjt7BfjJjungHR+CGu2CRXauwgHY1YwJx62B3pTjd+aBI7/7KsqWyeFV2Z+
        hTNct4d4QvyrO9XU/R/iNtmytjQaSgaT3uInXl1nLcBTF3/lheb+JLgzU5ePyKm1J4SkESXYAkROo
        33zzrI5H6VLQNmzdHCz0tIjYkMPbBsiOEde86mSCV9XIC0dJetkK4NgfXCQQJS8Lg37a2MkOBERi6
        xzJ18gGWKf2gy8MruIaf54lT5JNJMPkkdz5UKDYSEu5YKpHjMgm4lPTK1LP+WBzi7x0wiFMVx+jsT
        f3o3uomJw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hq1wf-0008BU-3W; Tue, 23 Jul 2019 21:03:37 +0000
Date:   Tue, 23 Jul 2019 14:03:37 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Atul Gupta <atul.gupta@chelsio.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: Introduce page_size()
Message-ID: <20190723210336.GP363@bombadil.infradead.org>
References: <20190721104612.19120-1-willy@infradead.org>
 <20190721104612.19120-2-willy@infradead.org>
 <20190723004307.GB10284@iweiny-DESK2.sc.intel.com>
 <20190723160248.GK363@bombadil.infradead.org>
 <20190723175838.GA29729@iweiny-DESK2.sc.intel.com>
 <20190723181413.GN363@bombadil.infradead.org>
 <20190723204416.GA27491@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723204416.GA27491@iweiny-DESK2.sc.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 23, 2019 at 01:44:16PM -0700, Ira Weiny wrote:
> > > Side note: why 2 checks for !page?
> > 
> > Because page is assigned to after the first check ...
> 
> Ah yea duh!  Sorry it is a bit hard to follow.

This is one of those users who really wants the VM to fall back
automatically to any page order block it has on hand.  We talked about
it a bit in the MM track this year; not sure whether you were in the
room for it.
