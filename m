From: "Loc Ho" <lho@amcc.com>
Subject: RE: OpenSSL patch to support Linux CryptoAPI.
Date: Mon, 11 Aug 2008 11:53:41 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D604D29239@SDCEXCHANGE01.ad.amcc.com>
References: <DB599F406D04E34389140B7D99C71B1B05D9E002@SDCEXCHANGE01.ad.amcc.com> <20080808210949.GA6535@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D604D28FD5@SDCEXCHANGE01.ad.amcc.com> <20080809062941.GA25828@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: <linux-crypto@vger.kernel.org>,
	"Shasi Pulijala" <spulijala@amcc.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:18138 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbYHKSxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Aug 2008 14:53:47 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080809062941.GA25828@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

>
>You do not need to pass multiple pointers, but instead a multiple data.
>You can do that via single area provided to the kernel and multiple size fields, where each 
> one corresponds to the size of the contiguous sectors in the provided data.

[Loc Ho]
It sounds like the solution is to format the data (parameter values, src, dst) into a single buffer. This will require memory copy of the source and destination data as follow:
1. User space formating the user space buffer that includes:
	1a) size parameter fields (this is required regardless)
	2b) parameter data such as IV, adata, and etc (this is required regardless)
	3c) copy the source data from application buffer into this single buffer (this is extra memcpy)
2. Kernel operation of the single user buffer (this is required regardless)
3. User space copy the destination data buffer into its appropriate memory pointer
	3a) For hash, it is just the hash
	3b) For crypto, it is the entire buffer (= to source length)
	3c) For aead, it is the entire buffer + aead ICV

As you can see, there is two extra memcpy's. There is noticeable performance on our SoC (AMCC 4xx) which memory copy is performed.

I was thinking. What do you think about passing multiple data pointer using writev (vector write)? And possible a similar idea for AIO.

-Loc


