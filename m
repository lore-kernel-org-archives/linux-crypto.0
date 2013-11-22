From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH] crypto: s390 - Fix aes-xts parameter corruption
Date: Fri, 22 Nov 2013 14:57:56 +0100
Message-ID: <20131122145756.387d7638@vbox-ubuntu>
References: <1384877567-23593-1-git-send-email-gerald.schaefer@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Harald Freudenberger <freude@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:48871 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3KVN6I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Nov 2013 08:58:08 -0500
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <gerald.schaefer@de.ibm.com>;
	Fri, 22 Nov 2013 13:58:05 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 43EB117D805A
	for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2013 13:57:48 +0000 (GMT)
Received: from d06av08.portsmouth.uk.ibm.com (d06av08.portsmouth.uk.ibm.com [9.149.37.249])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rAMDvor446268458
	for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2013 13:57:50 GMT
Received: from d06av08.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av08.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rAMDw1wp020668
	for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2013 06:58:02 -0700
In-Reply-To: <1384877567-23593-1-git-send-email-gerald.schaefer@de.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 19 Nov 2013 17:12:47 +0100
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> Some s390 crypto algorithms incorrectly use the crypto_tfm structure
> to store private data. As the tfm can be shared among multiple
> threads, this can result in data corruption.
> 
> This patch fixes aes-xts by moving the xts and pcc parameter blocks
> from the tfm onto the stack (48 + 96 bytes).
> 
> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> ---
>  arch/s390/crypto/aes_s390.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)

Herbert, could you please add Cc: stable@vger.kernel.org to this?
