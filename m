From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [BUILD_FAILURE] linux-next: Tree for May 19 - build fails on
 cryptd_alloc_hash ()
Date: Mon, 19 May 2008 10:26:27 -0700
Message-ID: <20080519102627.997d61ef.randy.dunlap@oracle.com>
References: <20080519174120.2083ea57.sfr@canb.auug.org.au>
	<4831B3F6.5080101@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:13510 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402AbYESRd6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 May 2008 13:33:58 -0400
In-Reply-To: <4831B3F6.5080101@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 19 May 2008 22:38:06 +0530 Kamalesh Babulal wrote:

> Hi,
> 
> The next-20080519 kernel build fails on the x86_64 machine, when compiled 
> with the randconfig.
> 
>   LD      .tmp_vmlinux1
> crypto/built-in.o: In function `cryptd_alloc_hash':
> /root/kernels/linux-2.6.26-rc3/crypto/cryptd.c:485: undefined reference to `crypto_ahash_type'
> make: *** [.tmp_vmlinux1] Error 1

Fixed on Thu May 15:  http://lkml.org/lkml/2008/5/15/433
and Herbert says that he merged it on Fri May 16,
so why did it miss being in linux-next on Mon May 19?

Wrong tree/branch/whatever?

---
~Randy
