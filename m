From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] dmaengine: Add supports for APM X-Gene SoC CRC32C
 accerlerator driver
Date: Mon, 30 Nov 2015 16:50:54 +0800
Message-ID: <20151130085054.GA7928@gondor.apana.org.au>
References: <rsahu@apm.com>
 <1447665169-14003-1-git-send-email-rsahu@apm.com>
 <CAFd313zqimQtG8epeo3U7gzxWRf0hqO4K8hOFy4UK-6pG5GcJg@mail.gmail.com>
 <20151130083950.GA7792@gondor.apana.org.au>
 <CAFd313z2dncWmBQJY48RkReVOhQqLs13UzehwrbizBbputOSEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, Vinod Koul <vinod.koul@intel.com>,
	dan.j.williams@intel.com, dmaengine@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	jcm@redhat.com, patches@apm.com, linux-crypto@vger.kernel.org,
	Kaustubh Gondkar <kgondkar@apm.com>
To: Rameshwar Sahu <rsahu@apm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50677 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbbK3IvR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Nov 2015 03:51:17 -0500
Content-Disposition: inline
In-Reply-To: <CAFd313z2dncWmBQJY48RkReVOhQqLs13UzehwrbizBbputOSEw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 30, 2015 at 02:19:33PM +0530, Rameshwar Sahu wrote:
>
> One of our client is using this layer for offloading the crc32c to our
> dmaengine hw.

Is this going to be merged into the kernel?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
