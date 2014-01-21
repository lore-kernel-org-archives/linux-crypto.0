From: Harald Freudenberger <hfreude@linux.vnet.ibm.com>
Subject: Re: [PATCH] crypto: s390 - fix concurrency issue in aes-ctr mode
Date: Tue, 21 Jan 2014 16:04:42 +0100
Message-ID: <1390316682.25689.2.camel@Ubuntu12>
References: <1389884471-24964-1-git-send-email-freude@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39041 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbaAUPEq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jan 2014 10:04:46 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <hfreude@linux.vnet.ibm.com>;
	Tue, 21 Jan 2014 10:04:46 -0500
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 5F12138C8054
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jan 2014 10:04:42 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22034.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s0LF4gGT7078308
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jan 2014 15:04:42 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s0LF4eZG030292
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jan 2014 10:04:42 -0500
In-Reply-To: <1389884471-24964-1-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2014-01-16 at 16:01 +0100, Harald Freudenberger wrote:

> The aes-ctr mode uses one preallocated page without any concurrency
> protection. When multiple threads run aes-ctr encryption or decryption
> this can lead to data corruption.
> 
> The patch introduces locking for the page and a fallback solution with
> slower en/decryption performance in concurrency situations.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
> ---
>  arch/s390/crypto/aes_s390.c |   65 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 46 insertions(+), 19 deletions(-)

Herbert, could you please add Cc: stable@vger.kernel.org to this?

Thanks
