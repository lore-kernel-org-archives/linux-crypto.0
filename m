From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH][RFC] crypto: tcrypt - Ahash tests changed to run in
 parallel.
Date: Sat, 05 Jan 2013 18:25:56 +0200
Message-ID: <20130105182556.87853b23jydihzk0@www.dalek.fi>
References: <1357123173-32534-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:40657 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3AEQ0K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Jan 2013 11:26:10 -0500
In-Reply-To: <1357123173-32534-1-git-send-email-vakul@freescale.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Vakul Garg <vakul@freescale.com>:

> This allows to test & run multiple parallel crypto ahash contexts.
> Each of the test vector under the ahash speed test template is started
> under a separate kthread.

Why you want to do this? Does not this change make tcrypt give  
inconsistent results?
