From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: sha256_ssse3 - fix stack corruption with SSSE3
 and AVX implementations
Date: Wed, 22 May 2013 17:32:04 -0700
Message-ID: <1369269124.27102.356.camel@schen9-DESK>
References: <20130521140941.15997.83258.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Julian Wollrath <jwollrath@web.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51971 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab3EWAcQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 May 2013 20:32:16 -0400
In-Reply-To: <20130521140941.15997.83258.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2013-05-21 at 17:09 +0300, Jussi Kivilinna wrote:
> The _XFER stack element size was set too small, 8 bytes, when it needs to be
> 16 bytes. As _XFER is the last stack element used by these implementations,
> the 16 byte stores with 'movdqa' corrupt the stack where the value of register
> %r12 is temporarily stored. As these implementations align the stack pointer
> to 16 bytes, this corruption did not happen every time.
> 
> Patch corrects this issue.

Thanks for catching and fixing the issue.

Acked-by: Tim Chen <tim.c.chen@linux.intel.com>

Tim
