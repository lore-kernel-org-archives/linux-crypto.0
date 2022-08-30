Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C39ECAAA1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Aug 2022 17:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiH3Ros (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Aug 2022 13:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbiH3RoX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Aug 2022 13:44:23 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCE2F58F
        for <linux-crypto@vger.kernel.org>; Tue, 30 Aug 2022 10:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661881289; x=1693417289;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=69qLIlnVoByyX03jIi4uHWe7L9o2Ja+LIZ86JkNpGL8=;
  b=SAQ7/m9gmdz6Ub6AuenRaznWzr6WoXuB36OVPaTXDnDFH1fgzajR30Ik
   mcyAevd40b5Zkqk5bdK8/cqc0M6JjRlyvU3DjRThcT5bUgtN2iYwqHRB8
   xMOksclL6a7yIXvEzkI7sMFU45sMfOgC2LrwgPeVZ4E+ZO5LgAAQx4nQb
   PtNOsUHc0DAgJLQuR/KztqVg/HX9k9unoyK+S2Se/HNT0+fjYcNxJ197q
   /98qssPbcJqoaJXFNHSyGS+yEeS0m+B5m1cqhMkdR4vxDPyECNCkrgHi+
   qHoJZIIhqrCjOWAHZWs7Z+QVMEpLYzubhec+bFPDgoYzguHnGpe8jDvjX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="282226899"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="282226899"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 10:40:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="611802157"
Received: from schen9-mobl.amr.corp.intel.com ([10.209.71.199])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 10:40:48 -0700
Message-ID: <75a6faa29066960a74e7b2c60a7ae6acfd1893ab.camel@linux.intel.com>
Subject: Re: [PATCH] crypto: x86/sha512 - load based on CPU features
From:   Tim Chen <tim.c.chen@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Kani, Toshi" <toshi.kani@hpe.com>,
        "Wright, Randy (HPE Servers Linux)" <rwright@hpe.com>
Date:   Tue, 30 Aug 2022 10:40:40 -0700
In-Reply-To: <Ywg1fKiTGyNk78tB@gondor.apana.org.au>
References: <20220813230431.2666-1-elliott@hpe.com>
         <Yv9ubekvQiL3UGwd@gondor.apana.org.au>
         <MW5PR84MB18425E5211BD4EAF09D0CE3EAB6C9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
         <MW5PR84MB18426EBBA3303770A8BC0BDFAB759@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
         <Ywg1fKiTGyNk78tB@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2022-08-26 at 10:52 +0800, Herbert Xu wrote:
> On Fri, Aug 26, 2022 at 02:40:58AM +0000, Elliott, Robert (Servers) wrote:
> > Suggestion: please revert the sha512-x86 patch for a while.
> 
> This problem would have existed anyway if the module was built
> into the kernel.
> 
> > Do these functions need to break up their processing into smaller chunks
> > (e.g., a few Megabytes), calling kernel_fpu_end() periodically to 
> > allow the scheduler to take over the CPUs if needed? If so, what
> > chunk size would be appropriate?
> 
> Yes these should be limited to 4K each.  It appears that all the
> sha* helpers in arch/x86/crypto have the same problem.
> 

I think limiting chunk to 4K is reasonable to prevent the CPU from being hogged by
the crypto code for too long.

Tim

