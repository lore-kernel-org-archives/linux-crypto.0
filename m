From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH v6 0/8] Raid: enable talitos xor offload for improving
 performance
Date: Tue, 7 Aug 2012 03:27:49 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70E108F@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1344247815-1104-1-git-send-email-qiang.liu@freescale.com>
 <20120806203506.bcf31cc63a2d1f55a9695f13@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"vinod.koul@intel.com" <vinod.koul@intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
	"arnd@arndb.de" <arnd@arndb.de>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dan.j.williams@gmail.com" <dan.j.williams@gmail.com>,
	Li Yang-R58472 <r58472@freescale.com>
To: Phillips Kim-R1AAHA <R1AAHA@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:56807
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757182Ab2HGD1x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Aug 2012 23:27:53 -0400
In-Reply-To: <20120806203506.bcf31cc63a2d1f55a9695f13@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: Phillips Kim-R1AAHA
> Sent: Tuesday, August 07, 2012 9:35 AM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; vinod.koul@intel.com;
> dan.j.williams@intel.com; herbert@gondor.hengli.com.au; arnd@arndb.de;
> gregkh@linuxfoundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; dan.j.williams@gmail.com; Li Yang-R58472
> Subject: Re: [PATCH v6 0/8] Raid: enable talitos xor offload for
> improving performance
> 
> On Mon, 6 Aug 2012 18:10:15 +0800
> <qiang.liu@freescale.com> wrote:
> 
> > Changes in v6:
> > 	- swap the order of original patch 3/6 and 4/6;
> > 	- merge Ira's patch to reduce the size of original patch;
> > 	- merge Ira's patch of carma in 8/8;
> > 	- update documents and descriptions according to Ira's advice;
> 
> fwiw, I gave v5 a test-drive, setting up a RAID5 array on ramdisks [1],
> and this patchseries, along with FSL_DMA && NET_DMA set seems to be
> holding water, so this series gets my:
> 
> Tested-by: Kim Phillips <kim.phillips@freescale.com>
Thanks, Kim. I will add this line in v7:)

> 
> Thanks,
> 
> Kim
> 
> [1] mdadm --create --verbose --force /dev/md0 --level=raid5 --raid-
> devices=4 /dev/ram[0123]
