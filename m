From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH v2] staging: ccree: Fix bool comparison
Date: Wed, 18 Oct 2017 13:33:07 +1100
Message-ID: <20171018023307.GD30848@eros>
References: <20171016211708.GM16106@eros>
 <1508292614-15682-1-git-send-email-sunil.m@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org
To: sunil.m@techveda.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48165 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932091AbdJRCdL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2017 22:33:11 -0400
Content-Disposition: inline
In-Reply-To: <1508292614-15682-1-git-send-email-sunil.m@techveda.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 18, 2017 at 07:40:14AM +0530, sunil.m@techveda.org wrote:
> From: Suniel Mahesh <sunil.m@techveda.org>
> 
> Comparision operator "equal to" not required on a variable
> "foo" of type "bool". Bool has only two values, can be used
> directly or with logical not.
> 
> This fixes the following coccinelle warning:
> WARNING: Comparison of bool to 0/1
> 
> Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>

Nice.
