Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A33C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  9 May 2022 14:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237855AbiEIO6X (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 May 2022 10:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237764AbiEIO6V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 May 2022 10:58:21 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506272C4780;
        Mon,  9 May 2022 07:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652108067; x=1683644067;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cXGN16AjvvHzj8vLffhSi+a0BXyUYujkz+6rZNcFLzw=;
  b=cKjdBrj1LnCB72cz/gA1Zv8cU465yTTPCfyOJ/oXcmG9j3Cr0UApZyP+
   RKAGUS/O+z3PIe9W743X5LQ/cAmM/U5IsN2Wyb7FboAbekE8bfdtZEJ/Q
   S+EN6fuv5wHQVm++RNt/8cTdzaUYexpTi7cgFmhAY46HzfArOuLuft3V0
   TNHE2MyF6HgE4oaHESWiSfqoxKyJeisbC+0QpWRLRexCfgko55Jnlb1wN
   WIBaeAHTe4wRCuqZFFQ8B23WyaJDBKqxlxY60RQhjaeqgAcR5qOf2bTwj
   uAQEva7Kxo7I0HINitFRHcrqqRlDT2Xp4aQSAM/vwLz/eJGF8eSlqV4x1
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="256607819"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="256607819"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 07:54:26 -0700
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="696599856"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 07:54:24 -0700
Date:   Mon, 9 May 2022 15:54:21 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Greg KH <greg@kroah.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, stable@vger.kernel.org,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH] crypto: qat - set to zero DH parameters before free
Message-ID: <YnkrHdxLeS2PXpaj@silpixa00400314>
References: <20220509131927.55387-1-giovanni.cabiddu@intel.com>
 <Ynkgs262rVNat0fp@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynkgs262rVNat0fp@kroah.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 09, 2022 at 04:09:55PM +0200, Greg KH wrote:
> On Mon, May 09, 2022 at 02:19:27PM +0100, Giovanni Cabiddu wrote:
> > Set to zero the context buffers containing the DH key before they are
> > freed.
> > This is a defense in depth measure that avoids keys to be recovered from
> > memory in case the system is compromised between the free of the buffer
> > and when that area of memory (containing keys) gets overwritten.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: c9839143ebbf ("crypto: qat - Add DH support")
> > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > Reviewed-by: Adam Guerin <adam.guerin@intel.com>
> > Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> > ---
> >  drivers/crypto/qat/qat_common/qat_asym_algs.c | 3 +++
> >  1 file changed, 3 insertions(+)
> 
> Why isn't this part of the other series for this "driver"?
Just for consistency.
I preferred to decouple this from the set `crypto: qat - re-enable algorithms`
since differently from the other patches in that set, this is not fixing
a functional issue in the driver but it is adding a protection measure.

Regards,

-- 
Giovanni
