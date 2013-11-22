From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH] s390/crypto: fix aes ctr concurrency issue
Date: Fri, 22 Nov 2013 14:58:40 +0100
Message-ID: <20131122145840.5013bf02@vbox-ubuntu>
References: <1384856532-17247-1-git-send-email-freude@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Freudenberger <freude@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:40372 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3KVN6u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Nov 2013 08:58:50 -0500
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <gerald.schaefer@de.ibm.com>;
	Fri, 22 Nov 2013 13:58:49 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6580617D8058
	for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2013 13:58:32 +0000 (GMT)
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rAMDwYUY53739700
	for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2013 13:58:34 GMT
Received: from d06av02.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rAMDwj4M004540
	for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2013 06:58:46 -0700
In-Reply-To: <1384856532-17247-1-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 19 Nov 2013 11:22:11 +0100
Harald Freudenberger <freude@linux.vnet.ibm.com> wrote:

> The aes-ctr mode used one preallocated page without any concurrency
> protection. When multiple threads run aes-ctr encryption or decryption
> this could lead to data corruption.
> 
> The patch introduces locking for the preallocated page and
> alternatively allocating and freeing of an temp page in concurrency
> situations.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
> 
> Harald Freudenberger (1):
>   s390/crypto: fix aes ctr concurrency issue
> 
>  arch/s390/crypto/aes_s390.c |   55
> ++++++++++++++++++++++++++++++++---------- 1 files changed, 42
> insertions(+), 13 deletions(-)

Herbert, could you please add Cc: stable@vger.kernel.org to this?
