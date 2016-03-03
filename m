From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 3/4] crypto: ccp - CCP versioning support
Date: Thu, 3 Mar 2016 08:28:04 -0600
Message-ID: <56D849F4.70102@amd.com>
References: <20160301194831.6788.2154.stgit@taos.amd.com>
 <20160301194915.6788.33941.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0091.outbound.protection.outlook.com ([207.46.100.91]:50068
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752921AbcCCOnK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Mar 2016 09:43:10 -0500
In-Reply-To: <20160301194915.6788.33941.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/01/2016 01:49 PM, Gary R Hook wrote:
> Future hardware may introduce new algorithms wherein the
> driver will need to manage resources for different versions
> of the cryptographic coprocessor. This precursor patch
> determines the version of the available device, and marks
> and registers algorithms accordingly. A structure is added
> which manages the version-specific data.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/ccp-crypto-aes.c |   12 ++++++++++-
>  drivers/crypto/ccp/ccp-crypto-sha.c |    9 +++++++-
>  drivers/crypto/ccp/ccp-dev.c        |   27 ++++++++++++++++++++++++
>  drivers/crypto/ccp/ccp-dev.h        |    8 +++++++
>  drivers/crypto/ccp/ccp-pci.c        |    8 ++++++-
>  drivers/crypto/ccp/ccp-platform.c   |   39 +++++++++++++++++++++++++++++++++--
>  include/linux/ccp.h                 |   17 +++++++++++++++
>  7 files changed, 115 insertions(+), 5 deletions(-)
