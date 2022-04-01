Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99FEC433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Apr 2022 08:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbiDAIcP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Apr 2022 04:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243812AbiDAIcL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Apr 2022 04:32:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380A85132C;
        Fri,  1 Apr 2022 01:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648801822; x=1680337822;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4Ib0Vzjakf6ZPrJYum7yQ1QLUYoaZZXBlO6Yvscvauk=;
  b=HGiLv+vrvJmOoJ1TDgdJaVHAqv2z59fD0Tc4aVSeN434rNVkrvYa+lsI
   SsX8uCABSdS1rHtbgIxPn2+aDeY9HGzEPdEdDwgSomyHY3S5XaMt8ZGY3
   U5PRJ6mh+JHPes20tVnXsu0v2QN5JfXM8vVtO4ISM1XlJZ0be5mAhQfkW
   RYs6kjR5SZBCPKF65fmL0QRn1wy4kOJPv9E9gJKT3xhhzoYmrw/zSzAhU
   Qe6RoQ/4O/2EuOMbJv84NO8jYyUTYqN/HDyLnue8UXujp12T9soAxQirb
   EFCoKJQhhIoZ5T3yuiqF4knO6EeGc5I3Wn44oLFENnXjEuZCng8zlTur3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="258910150"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="258910150"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 01:30:21 -0700
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="522693080"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 01:30:19 -0700
Date:   Fri, 1 Apr 2022 09:30:13 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - test in-place en/decryption with two
 sglists
Message-ID: <Yka4Ff5eZuTP+NLy@silpixa00400314>
References: <20220326071159.56056-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220326071159.56056-1-ebiggers@kernel.org>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 26, 2022 at 12:11:59AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> As was established in the thread
> https://lore.kernel.org/linux-crypto/20220223080400.139367-1-gilad@benyossef.com/T/#u,
> many crypto API users doing in-place en/decryption don't use the same
> scatterlist pointers for the source and destination, but rather use
> separate scatterlists that point to the same memory.  This case isn't
> tested by the self-tests, resulting in bugs.
> 
> This is the natural usage of the crypto API in some cases, so requiring
> API users to avoid this usage is not reasonable.
> 
> Therefore, update the self-tests to start testing this case.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
FWIW, I tried this with QAT and I don't see any issue.

Regards,

-- 
Giovanni
