From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2 0/10] crypto mv_cesa : Add sha1 and hmac(sha1)
	support to the mv_cesa driver
Date: Tue, 13 Apr 2010 16:54:27 +0800
Message-ID: <20100413085427.GA8888@gondor.apana.org.au>
References: <4BBE036B.8010001@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Uri Simchoni <uri@jdland.co.il>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:32984 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752567Ab0DMIyc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 04:54:32 -0400
Content-Disposition: inline
In-Reply-To: <4BBE036B.8010001@jdland.co.il>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 08, 2010 at 07:25:15PM +0300, Uri Simchoni wrote:
> This is a resubmission of a patchset I set a while ago, and that was corrupted by my email client.
> 
> The following patchset adds async hashing (sha1 and hmac-sha1) to the mv_cesa crypto driver. This driver utilizes the Marvell CESA crypto accelerator that exists in some Marvell CPU's (Orion and Kirkwood). The existing driver has AES crypto support.
> 
> Compared to SW hashing on a 1.2GHz Kirkwood, the HW acceleration is about 20% faster, but more importantly, at reduced CPU utilization.
> 
> The patchset is divided as follows:
> - patches 1-4 are bug/warning fixes to the existing driver
> - patches 5-9 refactor the existing driver with no functional change to accommodate the added functionality
> - patch 10 adds the sha1 and hmac-sha1 support.
> 
> The driver requires the sha1 and hmac sw drivers in order to handle some corner cases (i.e. it never falls back on a complete request but sometimes it hashes the last 64 bytes in sw)

All applied to cryptodev.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
