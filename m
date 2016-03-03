From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/4] crypto: ccp - Support for multiple CCPs
Date: Thu, 3 Mar 2016 08:27:28 -0600
Message-ID: <56D849D0.7030101@amd.com>
References: <20160301194831.6788.2154.stgit@taos.amd.com>
 <20160301194904.6788.84406.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0082.outbound.protection.outlook.com ([65.55.169.82]:59778
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752921AbcCCOmz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Mar 2016 09:42:55 -0500
In-Reply-To: <20160301194904.6788.84406.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/01/2016 01:49 PM, Gary R Hook wrote:
> Enable management of >1 CCPs in a system. Each device will
> get a unique identifier, as well as uniquely named
> resources. Treat each CCP as an orthogonal unit and register
>  resources individually.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/ccp-dev.c      |  113 +++++++++++++++++++++++++++++++++----
>  drivers/crypto/ccp/ccp-dev.h      |    9 +++
>  drivers/crypto/ccp/ccp-pci.c      |    7 +-
>  drivers/crypto/ccp/ccp-platform.c |    4 +
>  4 files changed, 114 insertions(+), 19 deletions(-)
