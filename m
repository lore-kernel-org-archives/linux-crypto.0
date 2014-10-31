From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam: fix error reporting
Date: Fri, 31 Oct 2014 13:22:09 -0500
Message-ID: <20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
References: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<horia.geanta@freescale.com>, <marex@denx.de>
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0131.outbound.protection.outlook.com ([157.56.110.131]:14656
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756370AbaJaS12 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Oct 2014 14:27:28 -0400
In-Reply-To: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 31 Oct 2014 18:57:33 +0200
Cristian Stoica <cristian.stoica@freescale.com> wrote:

> The error code returned by hardware is four bits wide with an expected
> zero MSB. A hardware error condition where the error code can get between
> 0x8 and 0xf will trigger an out of bound array access on the error
> message table.

If this issue was brought up by h/w, the appropriate new error codes
should be being introduced.

Otherwise, I'm assuming it was brought up by a static code analyser,
which technically could be ignored, but...

> -	/*
> -	 * If there is no further error handling function, just
> -	 * print the error code, error string and exit. Otherwise
> -	 * call the handler function.
> -	 */

why remove the comment?  It's still valid.

> -	if (!status_src[ssrc].report_ssed)
> -		dev_err(jrdev, "%08x: %s: \n", status, status_src[ssrc].error);
> -	else
> +	if (status_src[ssrc].report_ssed)
>  		status_src[ssrc].report_ssed(jrdev, status, error);
> +	else if (error)
> +		dev_err(jrdev, "%d: %s\n", ssrc, error);
> +	else
> +		dev_err(jrdev, "%d: unknown error code\n", ssrc);

This is simpler:

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 6531054..6f4a148 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -224,7 +224,12 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
                { report_cond_code_status, "Condition Code" },
        };
        u32 ssrc = status >> JRSTA_SSRC_SHIFT;
-       const char *error = status_src[ssrc].error;
+       const char *error;
+
+       if (ssrc >= ARRAY_SIZE(status_src)) {
+               dev_err(jrdev, "unknown error status source %d\n", ssrc);
+               return;
+       }
 
        /*
         * If there is no further error handling function, just

Kim
