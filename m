From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 01/20] staging: ccree: remove spurious blank lines
Date: Thu, 01 Jun 2017 04:20:19 -0700
Message-ID: <1496316019.2618.69.camel@perches.com>
References: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
         <1496314993-30229-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0163.hostedemail.com ([216.40.44.163]:37700 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751609AbdFALUY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2017 07:20:24 -0400
In-Reply-To: <1496314993-30229-2-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2017-06-01 at 14:02 +0300, Gilad Ben-Yossef wrote:
> Remove spurious blanks lines from cc_crypto_ctx.h file

unrelated trivia:

> diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
[]
> @@ -208,7 +204,6 @@ struct drv_ctx_generic {
>  	enum drv_crypto_alg alg;
>  } __attribute__((__may_alias__));

Please try to remove the __may_alias__ attribute one day.
