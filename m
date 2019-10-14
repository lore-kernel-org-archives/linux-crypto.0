Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBEEECE58D
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 08:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6A5D206A3
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 08:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbfJNI6s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 04:58:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:43474 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730354AbfJNI6s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 04:58:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 01:58:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,295,1566889200"; 
   d="scan'208";a="207929957"
Received: from vkuppusa-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.39.77])
  by fmsmga001.fm.intel.com with ESMTP; 14 Oct 2019 01:58:41 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Changbin Du <changbin.du@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-pci@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-fpga@vger.kernel.org,
        linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        Changbin Du <changbin.du@gmail.com>
Subject: Re: [PATCH] kernel-doc: rename the kernel-doc directive 'functions' to 'specific'
In-Reply-To: <20191013055359.23312-1-changbin.du@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20191013055359.23312-1-changbin.du@gmail.com>
Date:   Mon, 14 Oct 2019 11:59:37 +0300
Message-ID: <875zkrd7nq.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 13 Oct 2019, Changbin Du <changbin.du@gmail.com> wrote:
> The 'functions' directive is not only for functions, but also works for
> structs/unions. So the name is misleading. This patch renames it to
> 'specific', so now we have export/internal/specific directives to limit
> the functions/types to be included in documentation. Meanwhile we improved
> the warning message.

Agreed on "functions" being less than perfect. It directly exposes the
idiosyncrasies of scripts/kernel-doc. I'm not sure "specific" is any
better, though.

Perhaps "symbols" would be more self-explanatory. Or, actually make
"functions" only work on functions, and add a separate keyword for other
stuff. *shrug*

Seems like the patch is way too big. I'd probably add "symbols" (or
whatever) as a synonym for "functions" for starters, and convert
documents piecemeal, and finally drop the old one.

The scripts/kernel-doc change should be a patch of its own.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
