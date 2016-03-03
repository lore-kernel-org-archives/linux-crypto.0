From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 4/4] crypto: ccp - Add abstraction for device-specific
 calls
Date: Thu, 3 Mar 2016 08:28:36 -0600
Message-ID: <56D84A14.7030205@amd.com>
References: <20160301194831.6788.2154.stgit@taos.amd.com>
 <20160301194925.6788.93319.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0068.outbound.protection.outlook.com ([65.55.169.68]:33852
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752921AbcCCOoA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Mar 2016 09:44:00 -0500
In-Reply-To: <20160301194925.6788.93319.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/01/2016 01:49 PM, Gary R Hook wrote:
> Support for different generations of the coprocessor
> requires that an abstraction layer be implemented for
> interacting with the hardware. This patch splits out
> version-specific functions to a separate file and populates
> the version structure (acting as a driver) with function
> pointers.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/Makefile       |    2 
>  drivers/crypto/ccp/ccp-dev-v3.c   |  534 +++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/ccp-dev.c      |  306 +--------------------
>  drivers/crypto/ccp/ccp-dev.h      |  138 +++++++++-
>  drivers/crypto/ccp/ccp-ops.c      |  381 +-------------------------
>  drivers/crypto/ccp/ccp-pci.c      |   10 -
>  drivers/crypto/ccp/ccp-platform.c |    7 
>  7 files changed, 711 insertions(+), 667 deletions(-)
>  create mode 100644 drivers/crypto/ccp/ccp-dev-v3.c
