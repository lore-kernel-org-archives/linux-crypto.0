From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: Re: crypto: nx - Fix reentrancy bugs
Date: Tue, 7 Jul 2015 15:48:37 -0300
Message-ID: <20150707184837.GA9341@bluepex.com>
References: <20150707093025.GA31368@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:37284 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934263AbbGGSso (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 14:48:44 -0400
Received: from /spool/local
	by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Tue, 7 Jul 2015 15:48:42 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.13.184.25])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 7E8B01DC0057
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2015 14:47:38 -0400 (EDT)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t67IlLPw57671824
	for <linux-crypto@vger.kernel.org>; Tue, 7 Jul 2015 15:47:21 -0300
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
	by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t67ImbVB000618
	for <linux-crypto@vger.kernel.org>; Tue, 7 Jul 2015 15:48:38 -0300
Content-Disposition: inline
In-Reply-To: <20150707093025.GA31368@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 07, 2015 at 05:30:25PM +0800, Herbert Xu wrote:
> The crypto API allows a single transform to be used by multiple
> threads simultaneously.  For example, IPsec will use a single tfm
> to process packets for a given SA.  As packets may arrive on
> multiple CPUs that tfm must be reentrant.
> 
> The nx driver does try to deal with this by using a spin lock.
> Unfortunately only the basic AES/CBC/ECB algorithms do this in
> the correct way.
> 
> The symptom of these bugs may range from the generation of incorrect
> output to memory corruption.

Is this related with the issue in CTR ouput test#4 too?

Thanks!
