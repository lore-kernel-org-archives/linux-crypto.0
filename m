From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: select on non-existing Kconfig option CRC32C
Date: Wed, 15 Jun 2016 16:41:53 +0200
Message-ID: <20160615144153.GB4700@linux.vnet.ibm.com>
References: <5761275B.4010508@fau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Andreas Ziegler <andreas.ziegler@fau.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33102 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753241AbcFOOmA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 10:42:00 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5FEdQMe005673
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jun 2016 10:41:59 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23jswb9vy8-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jun 2016 10:41:59 -0400
Received: from localhost
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <brueckner@linux.vnet.ibm.com>;
	Wed, 15 Jun 2016 15:41:57 +0100
Content-Disposition: inline
In-Reply-To: <5761275B.4010508@fau.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Andreas,

On Wed, Jun 15, 2016 at 12:00:59PM +0200, Andreas Ziegler wrote:
> 
> your patch "s390/crc32-vx: add crypto API module for optimized CRC-32
> algorithms" showed up in linux-next today (next-20160615) as commit 	364148e0b195.
> 
> The patch defines the Kconfig option CRYPTO_CRC32_S390 which 'select's CRC32C.
> However, this should probably have been CRYPTO_CRC32C, as CRC32C does not exist.

Thanks for informing me.  Actually, the crc32-vx driver requires the
__crc32c_le() function which is available by selecting CONFIG_CRC32. There is
no need for CRYPTO_CRC32C.  So this can be safely removed.

> Should I prepare a trivial patch to fix this up or would you like to do that on
> your side?

Martin have already corrected the patch.

Thanks and kind regards,
  Hendrik
