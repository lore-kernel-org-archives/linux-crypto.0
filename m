Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D152C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jun 2022 14:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiFBOH2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jun 2022 10:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbiFBOH0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jun 2022 10:07:26 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE001243B95
        for <linux-crypto@vger.kernel.org>; Thu,  2 Jun 2022 07:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654178845; x=1685714845;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iA2f07DofbgpqKMJ7Nxh4vWQj+UA7dMN4Mk+2eFhsks=;
  b=lK28P+bOt1WYK/Jy9EO3xM/nk7Eqm/X7szPYFszVZWsg2gjdbfQm5CkJ
   WfQ0jdxKIG24EN6db2wdPBfZahPdfrGzglqZsYIYGjIYeHnXQ5nLgi/9I
   qCdeICbPIJQrNpIyJk5cek4TjlRdzSeGXf0KObIkugJsZppL5o8IAC6A+
   v3/XIOrwyoX7+ro8CFfen12MiLxqQa95WDlEuuAt+yjn8ST5ilYnzKXuA
   s0KDFpQUO9/X9AJ6UT3wu52mixdhdJ2EoacSX0xDAALOSo53ynhTn3gZF
   Qs9FqqebQaZWSGpfrq00SzHj90BTl7q+gMIifIZaFmoibKq96YE/Wl7vK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="256436187"
X-IronPort-AV: E=Sophos;i="5.91,271,1647327600"; 
   d="scan'208";a="256436187"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 07:07:25 -0700
X-IronPort-AV: E=Sophos;i="5.91,271,1647327600"; 
   d="scan'208";a="707579346"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 07:07:23 -0700
Date:   Thu, 2 Jun 2022 15:07:17 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Vlad Dronov <vdronov@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/4] crypto: qat - enable configuration for 4xxx
Message-ID: <YpjEFQxtpfWQH9QH@silpixa00400314>
References: <20220517141002.32385-1-giovanni.cabiddu@intel.com>
 <CAMusb+TA6wRHtkz=wXohH9-184fK_v=X3v=eYxr7BSWuVimOmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMusb+TA6wRHtkz=wXohH9-184fK_v=X3v=eYxr7BSWuVimOmQ@mail.gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 02, 2022 at 03:21:57PM +0200, Vlad Dronov wrote:
> Hi, Giovanni, all,
> 
> I've read through the patchset and it looks good to me. I would have made
> the following two minor (really minor) changes.
> 
> Add a missing "in" to the patch message:
> 
> @@ [PATCH 1/4] crypto: qat - expose device state through sysfs for 4xxx
> -allow the change of states even if the device is the down state.
> +allow the change of states even if the device is in the down state.
> 
> Probably add an indication that cfg_services has been really changed to
> the sysfs-driver-qat doc for clarity:
> 
> @@ [PATCH 4/4] crypto: qat - expose device config through sysfs for 4xxx
> diff --git a/Documentation/ABI/testing/sysfs-driver-qat
> b/Documentation/ABI/testing/sysfs-driver-qat
>  +                       # echo dc > /sys/bus/pci/devices/<BDF>/qat/cfg_services
>  +                       # echo up > /sys/bus/pci/devices/<BDF>/qat/state
> ++                       # cat /sys/bus/pci/devices/<BDF>/qat/cfg_services
> ++                       dc
> 
> Anyway, please feel free to use:
> 
> Reviewed-by: Vladis Dronov <vdronov@redhat.com>
Thanks Vladis!
I'm going to rework and re-send.
Also I'm going to update the KernelVersion attribute in the
documentation as this patch didn't make kernel 5.19.

-- 
Giovanni
