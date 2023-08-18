Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3E4C71133
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Aug 2023 05:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357957AbjHRFaV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Aug 2023 01:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357651AbjHRF3X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2023 01:29:23 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732143C34;
        Thu, 17 Aug 2023 22:28:49 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qWs2L-005BmE-J9; Fri, 18 Aug 2023 13:28:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Aug 2023 13:28:42 +0800
Date:   Fri, 18 Aug 2023 13:28:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, andriy.shevchenko@intel.com,
        alx.manpages@gmail.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 4/4] crypto: qat - add pm_status debugfs file
Message-ID: <ZN8BipaGe6DOwiVS@gondor.apana.org.au>
References: <20230817143352.132583-1-lucas.segarra.fernandez@intel.com>
 <20230817143352.132583-5-lucas.segarra.fernandez@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817143352.132583-5-lucas.segarra.fernandez@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 17, 2023 at 04:33:17PM +0200, Lucas Segarra Fernandez wrote:
>
> +static struct pm_status_row pm_event_rows[] = {
> +	PM_INFO_REGSET_ENTRY32(event_log[0], EVENT0),
> +	PM_INFO_REGSET_ENTRY32(event_log[1], EVENT1),
> +	PM_INFO_REGSET_ENTRY32(event_log[2], EVENT2),
> +	PM_INFO_REGSET_ENTRY32(event_log[3], EVENT3),
> +	PM_INFO_REGSET_ENTRY32(event_log[4], EVENT4),
> +	PM_INFO_REGSET_ENTRY32(event_log[5], EVENT5),
> +	PM_INFO_REGSET_ENTRY32(event_log[6], EVENT6),
> +	PM_INFO_REGSET_ENTRY32(event_log[7], EVENT7),
> +};
> +
> +static_assert(ARRAY_SIZE_OF_FIELD(struct icp_qat_fw_init_admin_pm_info, event_log) ==
> +	      ARRAY_SIZE(pm_event_rows));

Was all of that churn just for this one line?

How about simply declaring a macro

	#define QAT_NUMBER_OF_PM_EVENTS 8

and then use it for the two arrays:

	static struct pm_status_row pm_event_rows[QAT_NUMBER_OF_PM_EVENTS] = {

	__u32 event_log[QAT_NUMBER_OF_PM_EVENTS];

What am I missing?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
